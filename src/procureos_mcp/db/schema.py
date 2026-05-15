from psycopg2.extras import RealDictCursor

from procureos_mcp.db.connection import get_connection


def list_tables():
	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(
				"""
				SELECT table_name
				FROM information_schema.tables
				WHERE table_schema = 'public'
				ORDER BY table_name
				"""
			)
			return [row["table_name"] for row in cursor.fetchall()]


def describe_table(table_name: str):
	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(
				"""
				SELECT column_name, data_type, is_nullable, column_default
				FROM information_schema.columns
				WHERE table_schema = 'public' AND table_name = %s
				ORDER BY ordinal_position
				""",
				(table_name,),
			)
			return cursor.fetchall()
