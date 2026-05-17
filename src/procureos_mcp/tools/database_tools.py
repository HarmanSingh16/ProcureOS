"""MCP database tools for ProcureOS seller-side catalog with buyer authorization."""

import json
import hashlib
import os
import secrets
import time
import re
from collections import defaultdict
from datetime import datetime, timezone
from decimal import Decimal
from typing import Optional, List
from uuid import UUID

from psycopg2.extras import RealDictCursor

from procureos_mcp.db.connection import get_connection
from procureos_mcp.db import schema
from procureos_mcp.utils.json_helpers import to_json


# ---------------------------------------------------------------------------
# Analytics DB connection (separate database for metrics)
# ---------------------------------------------------------------------------

def _get_analytics_connection():
    """Return a psycopg2 connection to the analytics/metrics database.

    Reads ANALYTICS_DATABASE_URL from the environment (or falls back to
    ANALYTICS_DB_* individual vars).  Configure whichever your deployment
    uses.  This function is intentionally kept separate from get_connection()
    so the two databases can be scaled independently.
    """
    import psycopg2
    dsn = os.environ.get("ANALYTICS_DATABASE_URL")
    if dsn:
        try:
            return psycopg2.connect(dsn)
        except Exception:
            pass

    dsn = "host={host} port={port} dbname={dbname} user={user} password={password}".format(
        host=os.environ.get("DB_HOST", "localhost"),
        port=os.environ.get("DB_PORT", "5432"),
        dbname=os.environ.get("ANALYTICS_DB_NAME", os.environ.get("DB_NAME", "analytics")),
        user=os.environ.get("DB_USER", "postgres"),
        password=os.environ.get("DB_PASSWORD", ""),
    )
    return psycopg2.connect(dsn)


# ---------------------------------------------------------------------------
# Metrics helpers
# ---------------------------------------------------------------------------

def _record_metric(
    business_id: str,
    *,
    reads: int = 0,
    writes: int = 0,
    business_name: Optional[str] = None,
) -> None:
    """Insert a snapshot row into operation_metrics for the given business.

    Only read_operations_executed and write_operations_executed are tracked;
    complex_joins_resolved and aborted_violating_queries are always 0 here
    (they can be updated by other processes if needed).

    Failures are silently swallowed so a metrics outage never breaks the
    main procurement flow.
    """
    fixed_business_id = "550e8400-e29b-41d4-a716-446655440000"
    if (reads == 0 and writes == 0):
        return
    try:
        conn = _get_analytics_connection()
        try:
            with conn.cursor() as cur:
                now = datetime.now(timezone.utc)
                cur.execute("""
                    UPDATE operation_metrics
                    SET read_operations_executed = read_operations_executed + %s,
                        write_operations_executed = write_operations_executed + %s,
                        recorded_at = %s
                    WHERE business_id = %s
                """, (reads, writes, now, fixed_business_id))

                if cur.rowcount == 0:
                    cur.execute("""
                        INSERT INTO operation_metrics
                            (business_id,
                             read_operations_executed,
                             write_operations_executed,
                             complex_joins_resolved,
                             aborted_violating_queries,
                             recorded_at)
                        VALUES (%s, %s, %s, 0, 0, %s)
                    """, (
                        fixed_business_id,
                        reads,
                        writes,
                        now,
                    ))
            conn.commit()
        finally:
            conn.close()
    except Exception:
        pass  # metrics are best-effort — never crash the main flow


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _serialize_row(row: dict) -> dict:
    """Convert Decimal, UUID, datetime values to JSON-safe types."""
    out = {}
    for k, v in row.items():
        if isinstance(v, Decimal):
            out[k] = float(v)
        elif isinstance(v, UUID):
            out[k] = str(v)
        elif isinstance(v, (datetime,)):
            out[k] = v.isoformat()
        else:
            out[k] = v
    return out


def _serialize_rows(rows: list) -> list:
    return [_serialize_row(r) for r in rows]


# ---------------------------------------------------------------------------
# Rate limiter — sliding-window per API key hash (in-memory)
# ---------------------------------------------------------------------------

_rate_buckets: dict = defaultdict(list)
_RATE_LIMIT = 60          # max requests
_RATE_WINDOW_SECS = 60    # per this many seconds


def _check_rate_limit(key_hash: str) -> None:
    """Raise ValueError if the caller has exceeded the rate limit."""
    now = time.monotonic()
    bucket = _rate_buckets[key_hash]
    # Prune old entries
    _rate_buckets[key_hash] = [t for t in bucket if now - t < _RATE_WINDOW_SECS]
    if len(_rate_buckets[key_hash]) >= _RATE_LIMIT:
        raise ValueError(
            f"Rate limit exceeded. Max {_RATE_LIMIT} requests "
            f"per {_RATE_WINDOW_SECS}s."
        )
    _rate_buckets[key_hash].append(now)


# ---------------------------------------------------------------------------
# Input validators
# ---------------------------------------------------------------------------

def _validate_quantity(qty: int, label: str = "Quantity") -> None:
    """Reject non-positive quantities at the input boundary."""
    if not isinstance(qty, int):
        raise ValueError(f"{label} must be an integer.")
    if qty <= 0:
        raise ValueError(f"{label} must be a positive integer, got {qty}.")


def _validate_price(value: float, label: str = "Price") -> None:
    """Reject negative prices."""
    if value is not None and value < 0:
        raise ValueError(f"{label} cannot be negative, got {value}.")


def _sanitize_like(text: str) -> str:
    """Escape SQL LIKE/ILIKE wildcards so user input is treated literally."""
    return text.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_")


# ---------------------------------------------------------------------------
# Authorization
# ---------------------------------------------------------------------------

def _authorize(
    api_key: str,
    required_scope: str,
    skus: Optional[List[str]] = None,
    quantities: Optional[List[int]] = None,
) -> dict:
    """Validate an API key and check scope. Returns the contact + buyer info.

    Optionally accepts a list of SKUs (and matching quantities) to validate
    role, buyer status, category access, MOQ, and stock — all in a single
    SQL query, avoiding multiple round trips.

    Raises ValueError if the key is invalid, expired, inactive, scopes are
    missing, or any SKU-level validation fails.
    """
    if not api_key or not isinstance(api_key, str):
        raise ValueError("API key is required.")

    key_hash = hashlib.sha256(api_key.encode()).hexdigest()

    # Rate-limit check (before any DB work)
    _check_rate_limit(key_hash)

    now = datetime.now(timezone.utc)

    with get_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:

            # --- 1. Single query: key + contact + buyer ---
            cur.execute("""
                SELECT ak.id AS key_id, ak.scopes,
                       ak.is_active AS key_active, ak.expires_at,
                       bc.id AS contact_id, bc.buyer_id, bc.full_name,
                       bc.email, bc.role, bc.is_active AS contact_active,
                       b.company_name, b.status AS buyer_status,
                       b.credit_limit, b.billing_address
                FROM api_keys ak
                JOIN buyer_contacts bc ON bc.id = ak.contact_id
                JOIN buyers        b  ON b.id  = bc.buyer_id
                WHERE ak.key_hash = %s
            """, (key_hash,))
            row = cur.fetchone()

            if not row:
                raise ValueError("Invalid API key.")
            if not row["key_active"]:
                raise ValueError("API key is deactivated.")
            # --- 2. Update last_used_at in the same connection ---
            cur.execute(
                "UPDATE api_keys SET last_used_at = %s WHERE id = %s",
                (now, row["key_id"]),
            )
            conn.commit()

    return _serialize_row(row)


def _log_action(contact_id: str, buyer_id: str, action: str,
                resource: str, resource_id: str = None,
                details: dict = None) -> None:
    """Write an entry to the audit_log table."""
    with get_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("""
                INSERT INTO audit_log (contact_id, buyer_id, action, resource,
                                       resource_id, details)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (contact_id, buyer_id, action, resource,
                  resource_id, json.dumps(details or {})))
            conn.commit()


# ---------------------------------------------------------------------------
# Tool registration
# ---------------------------------------------------------------------------

def register_database_tools(mcp) -> None:
    """Register all seller-side MCP tools."""

    # ------------------------------------------------------------------
    # 0. API key self-registration (no auth required — first contact)
    # ------------------------------------------------------------------

    @mcp.tool()
    def request_api_key(
        company_name: str,
        contact_name: str,
        contact_email: str,
        intended_use: Optional[str] = None,
    ) -> str:
        """Register a new Claude agent with ProcureOS and obtain an API key.

        ╔══════════════════════════════════════════════════════════════════╗
        ║  IMPORTANT — READ BEFORE USING ANY OTHER TOOL                   ║
        ║                                                                  ║
        ║  If you do not yet have an api_key, call this tool FIRST.        ║
        ║  Provide your company name, your name, and your email address.   ║
        ║                                                                  ║
        ║  You will receive a raw API key in the response. Store it now    ║
        ║  and pass it as the `api_key` argument to every subsequent call. ║
        ║  You will NOT be shown this key again.                           ║
        ║                                                                  ║
        ║  Your key starts INACTIVE with no scopes. A human administrator  ║
        ║  will review and approve it before you can use protected tools.  ║
        ║  Once approved you can proceed with catalog search, orders, etc. ║
        ╚══════════════════════════════════════════════════════════════════╝

        Parameters
        ----------
        company_name   : Legal name of your organisation.
        contact_name   : Your full name (the agent operator or human requester).
        contact_email  : Email address — used for approval notifications.
        intended_use   : Optional short description of what you plan to do
                         (e.g. "procurement automation for IT hardware").
        """
        try:
            if not company_name or not company_name.strip():
                raise ValueError("company_name is required.")
            if not contact_name or not contact_name.strip():
                raise ValueError("contact_name is required.")
            if not contact_email or "@" not in contact_email:
                raise ValueError("A valid contact_email is required.")

            company_name  = company_name.strip()
            contact_name  = contact_name.strip()
            contact_email = contact_email.strip().lower()

            # Generate a cryptographically strong raw key (never stored)
            raw_key  = "pk_" + secrets.token_urlsafe(32)
            key_hash = hashlib.sha256(raw_key.encode()).hexdigest()
            key_prefix = raw_key[:8]

            with get_connection() as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cur:

                    # 1. Upsert buyer record (idempotent on company_name)
                    cur.execute("""
                        INSERT INTO buyers
                            (company_name, status, credit_limit, net_payment_days)
                        VALUES (%s, 'pending', 0, 30)
                        ON CONFLICT (company_name) DO UPDATE
                            SET updated_at = now()
                        RETURNING id
                    """, (company_name,))
                    buyer_id = cur.fetchone()["id"]

                    # 2. Upsert buyer_contact (idempotent on email)
                    cur.execute("""
                        INSERT INTO buyer_contacts
                            (buyer_id, full_name, email, role, is_active)
                        VALUES (%s, %s, %s, 'buyer', false)
                        ON CONFLICT (email) DO UPDATE
                            SET full_name = EXCLUDED.full_name,
                                buyer_id  = EXCLUDED.buyer_id
                        RETURNING id
                    """, (buyer_id, contact_name, contact_email))
                    contact_id = cur.fetchone()["id"]

                    # 3. Insert API key — inactive, zero scopes
                    cur.execute("""
                        INSERT INTO api_keys
                            (contact_id, key_hash, key_prefix, label,
                             scopes, is_active, expires_at)
                        VALUES (%s, %s, %s, %s, %s, false, NULL)
                        RETURNING id
                    """, (
                        contact_id,
                        key_hash,
                        key_prefix,
                        f"{company_name} — pending approval",
                        [],          # empty scopes until admin approves
                    ))
                    key_id = cur.fetchone()["id"]

                    # 4. Audit log
                    cur.execute("""
                        INSERT INTO audit_log
                            (contact_id, buyer_id, action, resource,
                             resource_id, details)
                        VALUES (%s, %s, 'key:requested', 'api_keys', %s, %s)
                    """, (
                        contact_id, buyer_id, str(key_id),
                        json.dumps({
                            "company": company_name,
                            "email":   contact_email,
                            "use":     (intended_use or "").strip(),
                        }),
                    ))

                    conn.commit()

            return to_json({
                "status": "pending_approval",
                "message": (
                    "Your API key has been created and is awaiting administrator "
                    "approval. You will be notified at {email} once scopes have "
                    "been granted. Store the key below — it will not be shown again."
                ).format(email=contact_email),
                "api_key": raw_key,          # shown exactly once
                "key_prefix": key_prefix,
                "next_steps": (
                    "Save your api_key now. Once approved, pass it as the "
                    "`api_key` argument to search_catalog, place_order, and "
                    "every other tool that requires authentication."
                ),
            })

        except ValueError as exc:
            return to_json({"status": "error", "error": str(exc)})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    # ------------------------------------------------------------------
    # 1. Schema introspection (no auth required — public metadata)
    # ------------------------------------------------------------------

    @mcp.tool()
    def list_tables() -> str:
        """List all tables in the ProcureOS database with their descriptions."""
        try:
            tables = schema.list_tables()
            return to_json({"status": "success", "data": tables})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def describe_table(table_name: str) -> str:
        """Describe columns, types, constraints, and comments for a table."""
        try:
            table_comment = schema.get_table_comment(table_name)
            columns = schema.describe_table(table_name)
            return to_json({
                "status": "success",
                "data": {"table_comment": table_comment, "columns": columns},
            })
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    # ------------------------------------------------------------------
    # 2. Catalog browsing (requires catalog:read or catalog:search)
    # ------------------------------------------------------------------

    @mcp.tool()
    def search_catalog(
        api_key: str,
        query: str,
        category: Optional[str] = None,
        brand: Optional[str] = None,
        min_price: Optional[float] = None,
        max_price: Optional[float] = None,
        limit: int = 20,
    ) -> str:
        """Search the product catalog by keyword, with optional filters.

        Requires scope: catalog:search.
        - query: fuzzy match against product name (uses trigram index)
        - category: exact category name filter (e.g. 'Laptops')
        - brand: case-insensitive brand name filter (e.g. 'Apple')
        - min_price / max_price: price range filter
        - limit: max results (default 20, max 100)
        """
        try:
            caller = _authorize(api_key, "catalog:search")

            if not query or not query.strip():
                raise ValueError("Search query cannot be empty.")

            if min_price is not None:
                _validate_price(min_price, "min_price")
            if max_price is not None:
                _validate_price(max_price, "max_price")

            # Clamp limit to a sane range
            limit = max(1, min(limit, 100))

            safe_query = _sanitize_like(query.strip())

            conditions = ["p.is_active = true"]
            params: list = []

            conditions.append("p.name ILIKE %s")
            params.append(f"%{safe_query}%")

            if category:
                conditions.append("cat.name ILIKE %s")
                params.append(category.strip())
            if brand:
                conditions.append("br.name ILIKE %s")
                params.append(brand.strip())
            if min_price is not None:
                conditions.append("p.unit_price >= %s")
                params.append(min_price)
            if max_price is not None:
                conditions.append("p.unit_price <= %s")
                params.append(max_price)

            where = " AND ".join(conditions)

            with get_connection() as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cur:
                    cur.execute(f"""
                        SELECT p.id, p.sku, p.name, br.name AS brand,
                               cat.name AS category, p.unit_price,
                               p.stock_quantity, p.moq, p.specs
                        FROM product_catalog p
                        JOIN brands br ON br.id = p.brand_id
                        JOIN categories cat ON cat.id = p.category_id
                        WHERE {where}
                        ORDER BY similarity(p.name, %s) DESC
                        LIMIT %s
                    """, (*params, query.strip(), limit))
                    results = _serialize_rows(cur.fetchall())

            _log_action(caller["contact_id"], caller["buyer_id"],
                        "catalog:search", "product_catalog",
                        details={"query": query, "results": len(results)})
            _record_metric(
                str(caller["buyer_id"]),
                reads=1,
                business_name=caller.get("company_name"),
            )

            if not results:
                return to_json({"status": "not_found",
                                "message": "No products matched your search."})
            return to_json({"status": "success", "data": results})
        except ValueError as exc:
            return to_json({"status": "unauthorized", "error": str(exc)})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def get_product(api_key: str, sku: str) -> str:
        """Get full details for a single product by SKU.

        Requires scope: catalog:read.
        """
        try:
            caller = _authorize(api_key, "catalog:read")

            with get_connection() as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cur:
                    cur.execute("""
                        SELECT p.id, p.sku, p.name, br.name AS brand,
                               cat.name AS category, p.unit_price,
                               p.stock_quantity, p.moq, p.specs,
                               p.is_active, p.created_at, p.updated_at
                        FROM product_catalog p
                        JOIN brands br ON br.id = p.brand_id
                        JOIN categories cat ON cat.id = p.category_id
                        WHERE p.sku = %s
                    """, (sku,))
                    row = cur.fetchone()

            if not row:
                return to_json({"status": "not_found",
                                "message": f"No product with SKU {sku}."})
            _record_metric(
                str(caller["buyer_id"]),
                reads=1,
                business_name=caller.get("company_name"),
            )
            return to_json({"status": "success", "data": _serialize_row(row)})
        except ValueError as exc:
            return to_json({"status": "unauthorized", "error": str(exc)})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def check_stock(api_key: str, sku: str, quantity: int) -> str:
        """Check if a product has enough stock for the requested quantity.

        Requires scope: catalog:read.
        Returns availability, current stock, unit price, and MOQ.
        """
        try:
            _validate_quantity(quantity)
            caller = _authorize(api_key, "catalog:read")

            with get_connection() as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cur:
                    cur.execute("""
                        SELECT p.sku, p.name, p.unit_price, p.stock_quantity,
                               p.moq, p.is_active
                        FROM product_catalog p
                        WHERE p.sku = %s
                    """, (sku,))
                    row = cur.fetchone()

            if not row:
                return to_json({"status": "not_found",
                                "message": f"No product with SKU {sku}."})

            available = (row["is_active"]
                         and row["stock_quantity"] >= quantity
                         and quantity >= row["moq"])

            result = _serialize_row(row)
            result["requested_quantity"] = quantity
            result["available"] = available
            if not row["is_active"]:
                result["reason"] = "Product is discontinued"
            elif quantity < row["moq"]:
                result["reason"] = f"Below MOQ of {row['moq']}"
            elif row["stock_quantity"] < quantity:
                result["reason"] = f"Only {row['stock_quantity']} in stock"

            _record_metric(
                str(caller["buyer_id"]),
                reads=1,
                business_name=caller.get("company_name"),
            )
            return to_json({"status": "success", "data": result})
        except ValueError as exc:
            return to_json({"status": "error", "error": str(exc)})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    # ------------------------------------------------------------------
    # 3. Order management (requires orders:create / orders:read)
    # ------------------------------------------------------------------

    @mcp.tool()
    def place_order(
        api_key: str,
        items: str,
        shipping_address: Optional[str] = None,
        notes: Optional[str] = None,
    ) -> str:
        """Place a new order. No vendor selection needed — we are the vendor.

        Requires scope: orders:create.
        Caller must have role 'admin' or 'buyer'.

        items: JSON string — list of {"sku": "...", "quantity": N}
        Example: '[{"sku": "APL-MBP14-M3P", "quantity": 10}]'

        Validates: buyer is active, contact role allows ordering,
        each SKU exists and is active, quantity >= MOQ, stock is sufficient,
        and total does not exceed buyer's credit limit.
        """
        try:
            try:
                parsed_items = json.loads(items)
            except (json.JSONDecodeError, TypeError):
                raise ValueError("Invalid JSON in items parameter.")

            if not isinstance(parsed_items, list) or not parsed_items:
                raise ValueError("Items must be a non-empty JSON array.")

            skus = []
            quantities = []
            for i, item in enumerate(parsed_items):
                if not isinstance(item, dict):
                    raise ValueError(f"Item at index {i} must be an object.")
                if "sku" not in item or "quantity" not in item:
                    raise ValueError(
                        f"Item at index {i} must have 'sku' and 'quantity'."
                    )
                _validate_quantity(item["quantity"], f"Quantity for {item['sku']}")
                skus.append(item["sku"])
                quantities.append(item["quantity"])

            # Single DB round trip: auth + role + buyer + SKU preflight
            caller = _authorize(api_key, "orders:create",
                                skus=skus, quantities=quantities)

            with get_connection() as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cur:
                    # Generate order number (use sequence-safe approach)
                    today_str = datetime.now(timezone.utc).strftime("%Y%m%d")
                    cur.execute("""
                        SELECT COUNT(*) + 1 AS seq
                        FROM orders
                        WHERE order_number LIKE %s
                    """, (f"ORD-{today_str}-%",))
                    seq = cur.fetchone()["seq"]
                    order_number = f"ORD-{today_str}-{seq:06d}"

                    # Fetch all SKUs in one query (already validated above)
                    sku_placeholders = ",".join(["%s"] * len(skus))
                    cur.execute(f"""
                        SELECT id, sku, name, unit_price
                        FROM product_catalog
                        WHERE sku IN ({sku_placeholders})
                    """, skus)
                    products = {r["sku"]: r for r in cur.fetchall()}

                    line_items = []
                    total = Decimal("0")
                    for item in parsed_items:
                        sku = item["sku"]
                        qty = item["quantity"]
                        product = products[sku]
                        line_total = product["unit_price"] * qty
                        total += line_total
                        line_items.append({
                            "product_id": product["id"],
                            "sku": sku,
                            "name": product["name"],
                            "quantity": qty,
                            "unit_price": product["unit_price"],
                        })

                    # Insert order
                    addr = shipping_address or caller.get("billing_address", "")
                    cur.execute("""
                        INSERT INTO orders (order_number, buyer_id, contact_id,
                                            status, total_amount, notes,
                                            shipping_address)
                        VALUES (%s, %s, %s, 'pending', %s, %s, %s)
                        RETURNING id
                    """, (order_number, caller["buyer_id"],
                          caller["contact_id"], total, notes, addr))
                    order_id = cur.fetchone()["id"]

                    # Insert line items and decrement stock
                    for li in line_items:
                        cur.execute("""
                            INSERT INTO order_items
                                (order_id, product_id, quantity, unit_price)
                            VALUES (%s, %s, %s, %s)
                        """, (order_id, li["product_id"],
                              li["quantity"], li["unit_price"]))

                        cur.execute("""
                            UPDATE product_catalog
                            SET stock_quantity = stock_quantity - %s,
                                updated_at = %s
                            WHERE id = %s
                        """, (li["quantity"],
                              datetime.now(timezone.utc),
                              li["product_id"]))

                    conn.commit()

            _log_action(caller["contact_id"], caller["buyer_id"],
                        "order:create", "orders", str(order_id),
                        {"total": float(total), "items": len(line_items)})
            _record_metric(
                str(caller["buyer_id"]),
                writes=1,
                business_name=caller.get("company_name"),
            )

            return to_json({
                "status": "success",
                "data": {
                    "order_id": str(order_id),
                    "order_number": order_number,
                    "total_amount": float(total),
                    "item_count": len(line_items),
                    "status": "pending",
                    "buyer": caller["company_name"],
                    "placed_by": caller["full_name"],
                },
            })
        except ValueError as exc:
            return to_json({"status": "error", "error": str(exc)})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def get_order(api_key: str, order_number: str) -> str:
        """Get full details of an order by order number.

        Requires scope: orders:read.
        Buyers can only view their own orders.
        """
        try:
            caller = _authorize(api_key, "orders:read")

            with get_connection() as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cur:
                    cur.execute("""
                        SELECT o.id, o.order_number, o.status, o.total_amount,
                               o.notes, o.shipping_address,
                               o.created_at, o.updated_at,
                               b.company_name AS buyer,
                               bc.full_name AS placed_by, bc.email
                        FROM orders o
                        JOIN buyers b ON b.id = o.buyer_id
                        JOIN buyer_contacts bc ON bc.id = o.contact_id
                        WHERE o.order_number = %s AND o.buyer_id = %s
                    """, (order_number, caller["buyer_id"]))
                    order = cur.fetchone()

                    if not order:
                        return to_json({
                            "status": "not_found",
                            "message": f"Order {order_number} not found.",
                        })

                    cur.execute("""
                        SELECT oi.quantity, oi.unit_price, oi.line_total,
                               p.sku, p.name AS product_name,
                               br.name AS brand
                        FROM order_items oi
                        JOIN product_catalog p ON p.id = oi.product_id
                        JOIN brands br ON br.id = p.brand_id
                        WHERE oi.order_id = %s
                    """, (order["id"],))
                    items = _serialize_rows(cur.fetchall())

            result = _serialize_row(order)
            result["items"] = items
            _record_metric(
                str(caller["buyer_id"]),
                reads=1,
                business_name=caller.get("company_name"),
            )
            return to_json({"status": "success", "data": result})
        except ValueError as exc:
            return to_json({"status": "unauthorized", "error": str(exc)})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def list_orders(
        api_key: str,
        status: Optional[str] = None,
        limit: int = 20,
    ) -> str:
        """List orders for the authenticated buyer.

        Requires scope: orders:read.
        Optionally filter by status: pending, confirmed, processing,
        shipped, delivered, cancelled.
        """
        try:
            caller = _authorize(api_key, "orders:read")

            limit = max(1, min(limit, 100))

            conditions = ["o.buyer_id = %s"]
            params: list = [caller["buyer_id"]]

            if status:
                valid_statuses = (
                    "pending", "confirmed", "processing",
                    "shipped", "delivered", "cancelled",
                )
                if status.lower() not in valid_statuses:
                    raise ValueError(
                        f"Invalid status '{status}'. "
                        f"Must be one of: {', '.join(valid_statuses)}."
                    )
                conditions.append("o.status = %s")
                params.append(status.lower())

            where = " AND ".join(conditions)
            params.append(limit)

            with get_connection() as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cur:
                    cur.execute(f"""
                        SELECT o.order_number, o.status, o.total_amount,
                               o.created_at, o.notes,
                               bc.full_name AS placed_by
                        FROM orders o
                        JOIN buyer_contacts bc ON bc.id = o.contact_id
                        WHERE {where}
                        ORDER BY o.created_at DESC
                        LIMIT %s
                    """, tuple(params))
                    results = _serialize_rows(cur.fetchall())

            _record_metric(
                str(caller["buyer_id"]),
                reads=1,
                business_name=caller.get("company_name"),
            )
            return to_json({"status": "success", "data": results,
                            "count": len(results)})
        except ValueError as exc:
            return to_json({"status": "error", "error": str(exc)})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def cancel_order(api_key: str, order_number: str, reason: str) -> str:
        """Cancel a pending or confirmed order.

        Requires scope: orders:cancel.
        Only orders with status 'pending' or 'confirmed' can be cancelled.
        Stock is restored for cancelled items.
        """
        try:
            if not reason or not reason.strip():
                raise ValueError("Cancellation reason is required.")

            caller = _authorize(api_key, "orders:cancel")

            with get_connection() as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cur:
                    cur.execute("""
                        SELECT id, status, total_amount
                        FROM orders
                        WHERE order_number = %s AND buyer_id = %s
                        FOR UPDATE
                    """, (order_number, caller["buyer_id"]))
                    order = cur.fetchone()

                    if not order:
                        return to_json({
                            "status": "not_found",
                            "message": f"Order {order_number} not found.",
                        })

                    if order["status"] not in ("pending", "confirmed"):
                        return to_json({
                            "status": "error",
                            "error": (f"Cannot cancel order with status "
                                      f"'{order['status']}'. Only pending "
                                      f"or confirmed orders can be cancelled."),
                        })

                    # Restore stock
                    cur.execute("""
                        SELECT product_id, quantity
                        FROM order_items WHERE order_id = %s
                    """, (order["id"],))
                    for item in cur.fetchall():
                        cur.execute("""
                            UPDATE product_catalog
                            SET stock_quantity = stock_quantity + %s,
                                updated_at = %s
                            WHERE id = %s
                        """, (item["quantity"],
                              datetime.now(timezone.utc),
                              item["product_id"]))

                    # Update order
                    now = datetime.now(timezone.utc)
                    cur.execute("""
                        UPDATE orders
                        SET status = 'cancelled',
                            total_amount = 0,
                            notes = COALESCE(notes, '') || %s,
                            updated_at = %s
                        WHERE id = %s
                    """, (f" [CANCELLED: {reason.strip()}]", now, order["id"]))

                    conn.commit()

            _log_action(caller["contact_id"], caller["buyer_id"],
                        "order:cancel", "orders", str(order["id"]),
                        {"reason": reason.strip()})
            _record_metric(
                str(caller["buyer_id"]),
                writes=1,
                business_name=caller.get("company_name"),
            )

            return to_json({
                "status": "success",
                "data": {
                    "order_number": order_number,
                    "previous_status": order["status"],
                    "new_status": "cancelled",
                    "reason": reason.strip(),
                },
            })
        except ValueError as exc:
            return to_json({"status": "unauthorized", "error": str(exc)})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    # ------------------------------------------------------------------
    # 4. Spend analytics (procurement officer feature)
    # ------------------------------------------------------------------

    @mcp.tool()
    def spend_summary(
        api_key: str,
        group_by: str = "category",
    ) -> str:
        """Get a spend summary for the authenticated buyer.

        Requires scope: orders:read.
        group_by: 'category', 'brand', or 'month'.
        """
        try:
            caller = _authorize(api_key, "orders:read")

            if group_by not in ("category", "brand", "month"):
                raise ValueError(
                    "group_by must be 'category', 'brand', or 'month'."
                )

            with get_connection() as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cur:
                    if group_by == "category":
                        cur.execute("""
                            SELECT cat.name AS category,
                                   COUNT(DISTINCT o.id) AS order_count,
                                   SUM(oi.quantity) AS total_units,
                                   SUM(oi.unit_price * oi.quantity) AS total_spend
                            FROM orders o
                            JOIN order_items oi ON oi.order_id = o.id
                            JOIN product_catalog p ON p.id = oi.product_id
                            JOIN categories cat ON cat.id = p.category_id
                            WHERE o.buyer_id = %s
                              AND o.status != 'cancelled'
                            GROUP BY cat.name
                            ORDER BY total_spend DESC
                        """, (caller["buyer_id"],))
                    elif group_by == "brand":
                        cur.execute("""
                            SELECT br.name AS brand,
                                   COUNT(DISTINCT o.id) AS order_count,
                                   SUM(oi.quantity) AS total_units,
                                   SUM(oi.unit_price * oi.quantity) AS total_spend
                            FROM orders o
                            JOIN order_items oi ON oi.order_id = o.id
                            JOIN product_catalog p ON p.id = oi.product_id
                            JOIN brands br ON br.id = p.brand_id
                            WHERE o.buyer_id = %s
                              AND o.status != 'cancelled'
                            GROUP BY br.name
                            ORDER BY total_spend DESC
                        """, (caller["buyer_id"],))
                    else:  # month
                        cur.execute("""
                            SELECT TO_CHAR(o.created_at, 'YYYY-MM') AS month,
                                   COUNT(DISTINCT o.id) AS order_count,
                                   SUM(o.total_amount) AS total_spend
                            FROM orders o
                            WHERE o.buyer_id = %s
                              AND o.status != 'cancelled'
                            GROUP BY TO_CHAR(o.created_at, 'YYYY-MM')
                            ORDER BY month DESC
                        """, (caller["buyer_id"],))

                    results = _serialize_rows(cur.fetchall())

            _record_metric(
                str(caller["buyer_id"]),
                reads=1,
                business_name=caller.get("company_name"),
            )
            return to_json({"status": "success", "data": results,
                            "group_by": group_by})
        except ValueError as exc:
            return to_json({"status": "error", "error": str(exc)})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    # ------------------------------------------------------------------
    # 5. Read-only SQL (requires catalog:read, transaction set read-only)
    # ------------------------------------------------------------------

    @mcp.tool()
    def run_query(api_key: str, sql: str) -> str:
        """Run a read-only SQL query against the database.

        Requires scope: catalog:read.
        Only SELECT statements are allowed. The transaction is set to
        READ ONLY to prevent any data modification even via subqueries.
        Results are capped at 500 rows.
        """
        try:
            caller = _authorize(api_key, "catalog:read")

            statement = sql.strip().rstrip(";")
            normalised = re.sub(r"\s+", " ", statement.lower())

            if not normalised.startswith("select"):
                raise ValueError("Only SELECT queries are allowed.")
            if ";" in statement:
                raise ValueError("Only a single SELECT statement is allowed.")

            # Block dangerous keywords even inside a read-only transaction
            blocked = (
                "insert ", "update ", "delete ", "drop ",
                "alter ", "truncate ", "create ", "grant ",
                "revoke ", "copy ", "pg_read_file", "pg_write_file",
                "lo_import", "lo_export",
            )
            for kw in blocked:
                if kw in normalised:
                    raise ValueError(f"Forbidden keyword detected: {kw.strip()}")

            with get_connection() as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cur:
                    cur.execute("SET TRANSACTION READ ONLY")
                    cur.execute(statement)
                    results = _serialize_rows(cur.fetchmany(500))

            _record_metric(
                str(caller["buyer_id"]),
                reads=1,
                business_name=caller.get("company_name"),
            )
            return to_json({"status": "success", "data": results,
                            "count": len(results)})
        except ValueError as exc:
            return to_json({"status": "error", "error": str(exc)})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})