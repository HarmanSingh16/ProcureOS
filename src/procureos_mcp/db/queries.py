"""ProcureOS database query functions for B2B consumer electronics procurement."""

from datetime import datetime, date
from decimal import Decimal
from typing import Any, Dict, List, Optional
from uuid import UUID

import psycopg2.extras
from psycopg2.extras import RealDictCursor

from procureos_mcp.db.connection import get_connection


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _serialize_row(row: dict) -> dict:
    """Convert Decimal, datetime, date, and UUID values to JSON-safe types."""
    out: Dict[str, Any] = {}
    for key, value in row.items():
        if isinstance(value, Decimal):
            out[key] = float(value)
        elif isinstance(value, (datetime, date)):
            out[key] = value.isoformat()
        elif isinstance(value, UUID):
            out[key] = str(value)
        else:
            out[key] = value
    return out


def _serialize_rows(rows: list) -> List[dict]:
    return [_serialize_row(dict(r)) for r in rows]


# ---------------------------------------------------------------------------
# 1. search_vendors
# ---------------------------------------------------------------------------

def search_vendors(
    query: str,
    location_state: Optional[str] = None,
    certifications: Optional[List[str]] = None,
    min_reliability: Optional[float] = None,
    limit: int = 10,
) -> List[dict]:
    """Search vendors by product name or SKU with optional filters.

    Returns vendor info with a count of matched products.
    """
    sql = """
    SELECT
        v.id              AS vendor_id,
        v.name            AS vendor_name,
        v.contact_email,
        v.city,
        v.state,
        v.country,
        v.certifications,
        v.reliability_score,
        v.avg_response_time_hours,
        v.is_active,
        COUNT(DISTINCT pc.id) AS matched_products
    FROM vendors v
    JOIN vendor_products vp ON vp.vendor_id = v.id
    JOIN product_catalog pc ON pc.id = vp.product_id
    WHERE v.is_active = TRUE
      AND (pc.name ILIKE %s OR pc.sku ILIKE %s)
    """
    params: List[Any] = [f"%{query}%", f"%{query}%"]

    if location_state is not None:
        sql += " AND v.state = %s"
        params.append(location_state)

    if certifications is not None and len(certifications) > 0:
        sql += " AND v.certifications @> %s::jsonb"
        params.append(psycopg2.extras.Json(certifications))

    if min_reliability is not None:
        sql += " AND v.reliability_score >= %s"
        params.append(min_reliability)

    sql += """
    GROUP BY v.id, v.name, v.contact_email, v.city, v.state, v.country,
             v.certifications, v.reliability_score, v.avg_response_time_hours, v.is_active
    ORDER BY v.reliability_score DESC
    LIMIT %s
    """
    params.append(limit)

    with get_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(sql, tuple(params))
            return _serialize_rows(cur.fetchall())


# ---------------------------------------------------------------------------
# 2. get_inventory
# ---------------------------------------------------------------------------

def get_inventory(vendor_id: str, sku: str) -> Optional[dict]:
    """Look up a single vendor-product by vendor ID and SKU.

    Returns product_name, sku, in_stock, stock_quantity, lead_time_days,
    moq, unit_price, last_synced_at — or None if not found.
    """
    sql = """
    SELECT
        pc.name            AS product_name,
        pc.sku,
        vp.in_stock,
        vp.stock_quantity,
        vp.lead_time_days,
        vp.moq,
        vp.unit_price,
        vp.last_synced_at
    FROM vendor_products vp
    JOIN product_catalog pc ON pc.id = vp.product_id
    WHERE vp.vendor_id = %s
      AND pc.sku = %s
    """
    with get_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(sql, (vendor_id, sku))
            row = cur.fetchone()
            return _serialize_row(dict(row)) if row else None


# ---------------------------------------------------------------------------
# 3. get_quote
# ---------------------------------------------------------------------------

def get_quote(vendor_id: str, sku: str, quantity: int) -> Optional[dict]:
    """Get a price quote for a given quantity from a specific vendor.

    Raises ValueError if quantity is below the vendor's MOQ.
    Returns None if the vendor doesn't carry the SKU.
    """
    sql = """
    SELECT
        pc.name            AS product_name,
        pc.sku,
        vp.unit_price,
        vp.moq,
        vp.lead_time_days,
        vp.in_stock,
        vp.stock_quantity,
        vp.last_synced_at
    FROM vendor_products vp
    JOIN product_catalog pc ON pc.id = vp.product_id
    WHERE vp.vendor_id = %s
      AND pc.sku = %s
    """
    with get_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(sql, (vendor_id, sku))
            row = cur.fetchone()
            if row is None:
                return None

            row = dict(row)
            if quantity < row["moq"]:
                raise ValueError(
                    f"Requested quantity {quantity} is below the minimum order "
                    f"quantity of {row['moq']} for SKU {sku}."
                )

            total_price = row["unit_price"] * quantity
            result = _serialize_row(row)
            result["quantity"] = quantity
            result["total_price"] = float(total_price)
            return result


# ---------------------------------------------------------------------------
# 4. compare_vendors
# ---------------------------------------------------------------------------

def compare_vendors(
    sku: str,
    quantity: int,
    rank_by: str = "price",
) -> List[dict]:
    """Compare all vendors carrying a SKU, ranked by price, lead_time, or reliability."""
    order_clause_map = {
        "price": "vp.unit_price ASC",
        "lead_time": "vp.lead_time_days ASC",
        "reliability": "v.reliability_score DESC",
    }
    order_clause = order_clause_map.get(rank_by)
    if order_clause is None:
        raise ValueError(
            f"Invalid rank_by value '{rank_by}'. "
            f"Must be one of: price, lead_time, reliability."
        )

    sql = f"""
    SELECT
        v.id                    AS vendor_id,
        v.name                  AS vendor_name,
        v.reliability_score,
        v.avg_response_time_hours,
        v.state,
        v.country,
        pc.name                 AS product_name,
        pc.sku,
        vp.unit_price,
        vp.moq,
        vp.lead_time_days,
        vp.in_stock,
        vp.stock_quantity,
        (vp.unit_price * %s)    AS total_price
    FROM vendor_products vp
    JOIN product_catalog pc ON pc.id = vp.product_id
    JOIN vendors v          ON v.id  = vp.vendor_id
    WHERE pc.sku = %s
      AND v.is_active = TRUE
    ORDER BY {order_clause}
    """
    with get_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(sql, (quantity, sku))
            return _serialize_rows(cur.fetchall())


# ---------------------------------------------------------------------------
# 5. create_purchase_order
# ---------------------------------------------------------------------------

def create_purchase_order(
    buyer_id: str,
    vendor_id: str,
    items: List[Dict[str, Any]],
    required_by_date: Optional[str] = None,
    notes: Optional[str] = None,
) -> dict:
    """Create a purchase order with line items.

    Parameters
    ----------
    items : list of {"product_id": str, "quantity": int}
    required_by_date : ISO date string (YYYY-MM-DD) or None
    notes : optional free-text notes

    Returns the created PO as a dict.  Orders >= $5 000 are auto-flagged.
    """
    with get_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Generate PO number: PO-YYYYMMDD-NNNNNN
            today_str = datetime.utcnow().strftime("%Y%m%d")
            cur.execute(
                """
                SELECT COALESCE(
                    MAX(CAST(SUBSTRING(po_number FROM '[0-9]{6}$') AS INTEGER)),
                    0
                ) + 1 AS next_seq
                FROM purchase_orders
                WHERE po_number LIKE %s
                """,
                (f"PO-{today_str}-%",),
            )
            next_seq = cur.fetchone()["next_seq"]
            po_number = f"PO-{today_str}-{next_seq:06d}"

            # Resolve vendor_products and compute totals
            line_items_data: List[Dict[str, Any]] = []
            total_amount = Decimal("0")

            for item in items:
                cur.execute(
                    """
                    SELECT vp.id AS vendor_product_id, vp.unit_price
                    FROM vendor_products vp
                    WHERE vp.vendor_id  = %s
                      AND vp.product_id = %s
                    """,
                    (vendor_id, item["product_id"]),
                )
                vp_row = cur.fetchone()
                if vp_row is None:
                    raise ValueError(
                        f"Vendor {vendor_id} does not carry product {item['product_id']}."
                    )

                qty = item["quantity"]
                unit_price = vp_row["unit_price"]
                line_total = unit_price * qty
                total_amount += line_total

                line_items_data.append({
                    "vendor_product_id": vp_row["vendor_product_id"],
                    "quantity": qty,
                    "unit_price": unit_price,
                })

            # Determine approval status
            approval_required = total_amount >= Decimal("5000")
            status = "flagged_for_review" if approval_required else "pending"
            approval_reason = (
                f"Total amount ${total_amount:.2f} exceeds $5,000.00 threshold"
                if approval_required
                else None
            )

            # Insert purchase order
            cur.execute(
                """
                INSERT INTO purchase_orders
                    (po_number, buyer_id, vendor_id, status, total_amount,
                     required_by_date, approval_required, approval_reason, notes)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                RETURNING *
                """,
                (
                    po_number,
                    buyer_id,
                    vendor_id,
                    status,
                    total_amount,
                    required_by_date,
                    approval_required,
                    approval_reason,
                    notes,
                ),
            )
            po_row = _serialize_row(dict(cur.fetchone()))

            # Insert line items
            created_lines = []
            for ld in line_items_data:
                cur.execute(
                    """
                    INSERT INTO po_line_items
                        (po_id, vendor_product_id, quantity, unit_price)
                    VALUES (%s, %s, %s, %s)
                    RETURNING *
                    """,
                    (
                        po_row["id"],
                        str(ld["vendor_product_id"]),
                        ld["quantity"],
                        ld["unit_price"],
                    ),
                )
                created_lines.append(_serialize_row(dict(cur.fetchone())))

            # If flagged, auto-create a review queue entry
            if approval_required:
                rev_today = datetime.utcnow().strftime("%Y%m%d")
                cur.execute(
                    """
                    SELECT COALESCE(
                        MAX(CAST(SUBSTRING(review_number FROM '[0-9]{6}$') AS INTEGER)),
                        0
                    ) + 1 AS next_seq
                    FROM review_queue
                    WHERE review_number LIKE %s
                    """,
                    (f"REV-{rev_today}-%",),
                )
                rev_seq = cur.fetchone()["next_seq"]
                review_number = f"REV-{rev_today}-{rev_seq:06d}"

                cur.execute(
                    """
                    INSERT INTO review_queue
                        (review_number, po_id, reason, urgency, status)
                    VALUES (%s, %s, %s, %s, 'pending_review')
                    """,
                    (
                        review_number,
                        po_row["id"],
                        approval_reason,
                        "high" if total_amount >= Decimal("25000") else "medium",
                    ),
                )

        conn.commit()

    po_row["line_items"] = created_lines
    return po_row


# ---------------------------------------------------------------------------
# 6. get_po_status
# ---------------------------------------------------------------------------

def get_po_status(po_id: str) -> Optional[dict]:
    """Return full PO record joined with vendor and buyer names."""
    sql = """
    SELECT
        po.*,
        v.name  AS vendor_name,
        u.first_name || ' ' || u.last_name AS buyer_name,
        u.email AS buyer_email
    FROM purchase_orders po
    JOIN vendors v ON v.id = po.vendor_id
    JOIN users   u ON u.id = po.buyer_id
    WHERE po.id = %s
    """
    with get_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(sql, (po_id,))
            row = cur.fetchone()
            return _serialize_row(dict(row)) if row else None


# ---------------------------------------------------------------------------
# 7. create_review
# ---------------------------------------------------------------------------

def create_review(
    po_id: str,
    reason: str,
    urgency: str,
    assigned_to: Optional[str] = None,
) -> dict:
    """Create a review queue entry for a PO and flag the PO for review.

    Returns the created review dict.
    """
    with get_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Generate review number: REV-YYYYMMDD-NNNNNN
            today_str = datetime.utcnow().strftime("%Y%m%d")
            cur.execute(
                """
                SELECT COALESCE(
                    MAX(CAST(SUBSTRING(review_number FROM '[0-9]{6}$') AS INTEGER)),
                    0
                ) + 1 AS next_seq
                FROM review_queue
                WHERE review_number LIKE %s
                """,
                (f"REV-{today_str}-%",),
            )
            next_seq = cur.fetchone()["next_seq"]
            review_number = f"REV-{today_str}-{next_seq:06d}"

            # Insert review queue entry
            cur.execute(
                """
                INSERT INTO review_queue
                    (review_number, po_id, assigned_to, reason, urgency)
                VALUES (%s, %s, %s, %s, %s)
                RETURNING *
                """,
                (review_number, po_id, assigned_to, reason, urgency),
            )
            review_row = _serialize_row(dict(cur.fetchone()))

            # Flag the purchase order
            cur.execute(
                """
                UPDATE purchase_orders
                SET status = 'flagged_for_review', updated_at = NOW()
                WHERE id = %s
                """,
                (po_id,),
            )

        conn.commit()

    return review_row


# ---------------------------------------------------------------------------
# 8. run_readonly_query
# ---------------------------------------------------------------------------

def run_readonly_query(sql: str, params: Optional[List] = None) -> List[dict]:
    """Execute a single read-only SELECT statement.

    Guards against non-SELECT queries and multi-statement injection.
    """
    statement = sql.strip()
    if not statement.lower().startswith("select"):
        raise ValueError("Only SELECT queries are allowed.")
    if ";" in statement.rstrip(";"):
        raise ValueError("Only a single SELECT statement is allowed.")

    with get_connection() as conn:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute(statement, tuple(params or []))
            return _serialize_rows(cur.fetchall())
