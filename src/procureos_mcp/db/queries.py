from typing import List, Optional

from psycopg2.extras import RealDictCursor

from procureos_mcp.db.connection import get_connection


def search_products(query_terms: str, max_unit_price: Optional[float], limit: int = 10):
	sql = "SELECT * FROM products WHERE (name ILIKE %s OR description ILIKE %s)"
	params: List[object] = [f"%{query_terms}%", f"%{query_terms}%"]

	if max_unit_price is not None:
		sql += " AND price <= %s"
		params.append(max_unit_price)

	sql += " ORDER BY name ASC LIMIT %s"
	params.append(limit)

	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(sql, tuple(params))
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


def get_orders_for_user(user_id: str, limit: int = 20):
	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(
				"""
				SELECT *
				FROM orders
				WHERE user_id = %s
				ORDER BY placed_at DESC
				LIMIT %s
				""",
				(user_id, limit),
			)
			return cursor.fetchall()


def get_order_items(order_id: str):
	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(
				"""
				SELECT
					oi.*,
					p.name AS product_name,
					p.description AS product_description,
					p.price AS current_product_price
				FROM order_items oi
				JOIN products p ON p.id = oi.product_id
				WHERE oi.order_id = %s
				ORDER BY p.name ASC
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
			cursor.execute(statement, tuple(params or []))
			return cursor.fetchall()
