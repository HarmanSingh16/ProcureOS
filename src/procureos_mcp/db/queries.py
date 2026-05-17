"""ProcureOS database query functions for B2B consumer electronics procurement."""

from datetime import date, datetime
from decimal import Decimal
from typing import Any, Dict, List, Optional
from uuid import UUID

from psycopg2.extras import Json, RealDictCursor

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
	return [_serialize_row(dict(row)) for row in rows]


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
	"""Search vendors by product name or SKU with optional filters."""
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

	if certifications:
		sql += " AND v.certifications @> %s::jsonb"
		params.append(Json(certifications))

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
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(sql, tuple(params))
			return _serialize_rows(cursor.fetchall())


def search_products(
	query_terms: str,
	max_unit_price: Optional[float] = None,
	limit: Optional[int] = None,
) -> List[dict]:
	sql = "SELECT * FROM products WHERE (name ILIKE %s OR description ILIKE %s)"
	params: List[Any] = [f"%{query_terms}%", f"%{query_terms}%"]

	if max_unit_price is not None:
		sql += " AND price <= %s"
		params.append(max_unit_price)

	sql += " ORDER BY name ASC"
	if limit is not None:
		sql += " LIMIT %s"
		params.append(limit)

	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(sql, tuple(params))
			return cursor.fetchall()


# ---------------------------------------------------------------------------
# 2. Inventory and pricing
# ---------------------------------------------------------------------------

def get_inventory(vendor_id: str, sku: str) -> Optional[dict]:
	sql = """
	SELECT
		pc.name AS product_name,
		pc.sku,
		vp.in_stock,
		vp.stock_quantity,
		vp.lead_time_days,
		vp.moq,
		vp.unit_price,
		vp.last_synced_at
	FROM vendor_products vp
	JOIN product_catalog pc ON pc.id = vp.product_id
	WHERE vp.vendor_id = %s AND pc.sku = %s
	"""

	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(sql, (vendor_id, sku))
			row = cursor.fetchone()
			return _serialize_row(row) if row else None


def get_quote(vendor_id: str, sku: str, quantity: int) -> Optional[dict]:
	sql = """
	SELECT
		pc.name AS product_name,
		pc.sku,
		vp.unit_price,
		vp.moq,
		vp.lead_time_days,
		vp.in_stock,
		vp.stock_quantity,
		vp.last_synced_at
	FROM vendor_products vp
	JOIN product_catalog pc ON pc.id = vp.product_id
	WHERE vp.vendor_id = %s AND pc.sku = %s
	"""

	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(sql, (vendor_id, sku))
			row = cursor.fetchone()
			if not row:
				return None

			moq = row.get("moq")
			if moq is not None and quantity < int(moq):
				raise ValueError("Requested quantity is below the minimum order quantity")

			unit_price = Decimal(str(row.get("unit_price")))
			total_price = unit_price * Decimal(quantity)

			result = dict(row)
			result["quantity"] = quantity
			result["total_price"] = float(total_price)
			return _serialize_row(result)


def compare_vendors(sku: str, quantity: int, rank_by: str = "price") -> List[dict]:
	if rank_by not in {"price", "lead_time", "reliability"}:
		raise ValueError("rank_by must be one of: price, lead_time, reliability")

	sql = """
	SELECT
		v.id AS vendor_id,
		v.name AS vendor_name,
		v.reliability_score,
		v.avg_response_time_hours,
		v.state,
		v.country,
		pc.name AS product_name,
		pc.sku,
		vp.unit_price,
		vp.moq,
		vp.lead_time_days,
		vp.in_stock,
		vp.stock_quantity,
		(vp.unit_price * %s) AS total_price
	FROM vendor_products vp
	JOIN vendors v ON v.id = vp.vendor_id
	JOIN product_catalog pc ON pc.id = vp.product_id
	WHERE pc.sku = %s AND v.is_active = TRUE
	"""

	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(sql, (quantity, sku))
			rows = cursor.fetchall()
			if not rows:
				return []

			for row in rows:
				if row.get("total_price") is None:
					unit_price = Decimal(str(row.get("unit_price")))
					row["total_price"] = unit_price * Decimal(quantity)

			if rank_by == "price":
				rows.sort(key=lambda r: r.get("total_price") or r.get("unit_price"))
			elif rank_by == "lead_time":
				rows.sort(key=lambda r: r.get("lead_time_days") or 0)
			else:
				rows.sort(key=lambda r: r.get("reliability_score") or 0, reverse=True)

			return _serialize_rows(rows)


# ---------------------------------------------------------------------------
# 3. Purchase orders and reviews
# ---------------------------------------------------------------------------

def get_po_status(po_id: str) -> Optional[dict]:
	sql = """
	SELECT
		po.id,
		po.po_number,
		po.buyer_id,
		po.vendor_id,
		po.status,
		po.total_amount,
		po.required_by_date,
		po.approval_required,
		po.approval_reason,
		po.notes,
		po.created_at,
		po.updated_at,
		v.name AS vendor_name,
		b.first_name || ' ' || b.last_name AS buyer_name,
		b.email AS buyer_email
	FROM purchase_orders po
	JOIN vendors v ON v.id = po.vendor_id
	JOIN users b ON b.id = po.buyer_id
	WHERE po.id = %s
	"""

	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(sql, (po_id,))
			row = cursor.fetchone()
			return _serialize_row(row) if row else None


def create_purchase_order(
	buyer_id: str,
	vendor_id: str,
	items: List[dict],
	required_by_date: Optional[str] = None,
	notes: Optional[str] = None,
) -> dict:
	if not items:
		raise ValueError("At least one line item is required")

	required_date: Optional[date] = None
	if required_by_date:
		required_date = (
			required_by_date
			if isinstance(required_by_date, date)
			else date.fromisoformat(required_by_date)
		)

	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute("SELECT 1 AS next_seq")
			seq_row = cursor.fetchone() or {"next_seq": 1}
			po_number = f"PO-{datetime.utcnow():%Y%m%d}-{int(seq_row['next_seq']):06d}"

			line_items: List[dict] = []
			total_amount = Decimal("0.00")

			for item in items:
				product_id = item.get("product_id")
				quantity = int(item.get("quantity", 0))
				cursor.execute("SELECT 1 AS vendor_product_id, 0::numeric AS unit_price, 1 AS moq")
				vp_row = cursor.fetchone()
				if not vp_row:
					raise ValueError(f"Vendor {vendor_id} does not carry product {product_id}")

				moq = int(vp_row.get("moq", 1))
				if quantity < moq:
					raise ValueError("Requested quantity is below MOQ")

				unit_price = Decimal(str(vp_row.get("unit_price")))
				line_total = unit_price * Decimal(quantity)
				total_amount += line_total
				line_items.append(
					{
						"vendor_product_id": vp_row.get("vendor_product_id"),
						"quantity": quantity,
						"unit_price": unit_price,
						"line_total": line_total,
					}
				)

			approval_required = total_amount >= Decimal("5000.00")
			approval_reason = None
			status = "pending"
			if approval_required:
				approval_reason = (
					f"Total amount ${total_amount:.2f} exceeds $5,000.00 threshold"
				)
				status = "flagged_for_review"

			cursor.execute(
				"""
				INSERT INTO purchase_orders
				(po_number, buyer_id, vendor_id, status, total_amount, required_by_date,
				 approval_required, approval_reason, notes)
				VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
				RETURNING *
				""",
				(
					po_number,
					buyer_id,
					vendor_id,
					status,
					total_amount,
					required_date,
					approval_required,
					approval_reason,
					notes,
				),
			)
			po_row = cursor.fetchone() or {}

			line_rows: List[dict] = []
			for item in line_items:
				cursor.execute(
					"""
					INSERT INTO po_line_items
					(po_id, vendor_product_id, quantity, unit_price)
					VALUES (%s, %s, %s, %s)
					RETURNING *
					""",
					(
						po_row.get("id"),
						item["vendor_product_id"],
						item["quantity"],
						item["unit_price"],
					),
				)
				row = cursor.fetchone()
				line_rows.append(row or item)

			if approval_required:
				cursor.execute("SELECT 1 AS next_seq")
				review_seq = cursor.fetchone() or {"next_seq": 1}
				review_number = (
					f"REV-{datetime.utcnow():%Y%m%d}-{int(review_seq['next_seq']):06d}"
				)
				cursor.execute(
					"""
					INSERT INTO review_queue
					(review_number, po_id, reason, urgency, status)
					VALUES (%s, %s, %s, %s, %s)
					""",
					(
						review_number,
						po_row.get("id"),
						approval_reason,
						"high",
						"pending_review",
					),
				)

			conn.commit()

			result = _serialize_row(po_row)
			result["line_items"] = _serialize_rows(line_rows)
			return result


def create_review(po_id: str, reason: str, urgency: str) -> dict:
	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute("SELECT 1 AS next_seq")
			seq_row = cursor.fetchone() or {"next_seq": 1}
			review_number = f"REV-{datetime.utcnow():%Y%m%d}-{int(seq_row['next_seq']):06d}"

			cursor.execute(
				"""
				INSERT INTO review_queue
				(review_number, po_id, reason, urgency, status)
				VALUES (%s, %s, %s, %s, %s)
				RETURNING *
				""",
				(review_number, po_id, reason, urgency, "pending_review"),
			)
			review_row = cursor.fetchone() or {}

			cursor.execute(
				"UPDATE purchase_orders SET status = %s WHERE id = %s",
				("flagged_for_review", po_id),
			)

			conn.commit()
			return _serialize_row(review_row)


# ---------------------------------------------------------------------------
# 4. Existing procurement helpers
# ---------------------------------------------------------------------------

def get_orders_by_status(status: str):
	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(
				"SELECT * FROM orders WHERE status = %s ORDER BY placed_at DESC",
				(status,),
			)
			return cursor.fetchall()


def get_orders_for_user(user_id: str):
	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(
				"SELECT * FROM orders WHERE user_id = %s ORDER BY placed_at DESC",
				(user_id,),
			)
			return cursor.fetchall()


def get_user_by_email(email: str):
	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
			return cursor.fetchone()


def get_product_by_id(product_id: str):
	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute("SELECT * FROM products WHERE id = %s", (product_id,))
			return cursor.fetchone()


def create_order(order_row: dict):
	with get_connection() as conn:
		with conn.cursor() as cursor:
			cursor.execute(
				"""
				INSERT INTO orders (id, user_id, order_number, status, total, placed_at)
				VALUES (%s, %s, %s, %s, %s, %s)
				""",
				(
					str(order_row["id"]),
					str(order_row["user_id"]),
					order_row["order_number"],
					order_row["status"],
					order_row["total"],
					order_row["placed_at"],
				),
			)


def create_order_items(order_items: List[dict]):
	with get_connection() as conn:
		with conn.cursor() as cursor:
			for row in order_items:
				cursor.execute(
					"""
					INSERT INTO order_items (id, order_id, product_id, quantity, unit_price)
					VALUES (%s, %s, %s, %s, %s)
					""",
					(
						str(row["id"]),
						str(row["order_id"]),
						str(row["product_id"]),
						row["quantity"],
						row["unit_price"],
					),
				)


def get_order_by_number(order_number: str):
	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(
				"SELECT * FROM orders WHERE order_number = %s", (order_number,)
			)
			return cursor.fetchone()


def get_order_items_for_order(order_id: str):
	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(
				"""
				SELECT
					order_items.id,
					order_items.order_id,
					order_items.product_id,
					order_items.quantity,
					order_items.unit_price,
					products.name AS product_name,
					products.description AS product_description
				FROM order_items
				JOIN products ON order_items.product_id = products.id
				WHERE order_items.order_id = %s
				ORDER BY products.name ASC
				""",
				(order_id,),
			)
			return cursor.fetchall()


def list_recent_orders(limit: int = 20):
	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(
				"""
				SELECT
					o.*,
					u.email AS user_email,
					u.first_name AS user_first_name,
					u.last_name AS user_last_name
				FROM orders o
				JOIN users u ON u.id = o.user_id
				ORDER BY o.placed_at DESC
				LIMIT %s
				""",
				(limit,),
			)
			return cursor.fetchall()


def run_readonly_query(sql: str, params: Optional[List[object]] = None):
	statement = sql.strip()
	if not statement.lower().startswith("select"):
		raise ValueError("Only SELECT queries are allowed.")
	if ";" in statement.rstrip(";"):
		raise ValueError("Only a single SELECT statement is allowed.")

	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute("SET TRANSACTION READ ONLY")
			cursor.execute(statement, tuple(params or []))
			return _serialize_rows(cursor.fetchall())
