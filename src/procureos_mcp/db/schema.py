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


def list_columns(table_name: str):
	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(
				"""
				SELECT column_name
				FROM information_schema.columns
				WHERE table_schema = 'public' AND table_name = %s
				ORDER BY ordinal_position
				""",
				(table_name,),
			)
			return [row["column_name"] for row in cursor.fetchall()]


def get_relationships():
	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(
				"""
				SELECT
					tc.constraint_name,
					tc.table_name,
					kcu.column_name,
					ccu.table_name AS foreign_table_name,
					ccu.column_name AS foreign_column_name
				FROM information_schema.table_constraints AS tc
				JOIN information_schema.key_column_usage AS kcu
					ON tc.constraint_name = kcu.constraint_name
					AND tc.table_schema = kcu.table_schema
				JOIN information_schema.constraint_column_usage AS ccu
					ON ccu.constraint_name = tc.constraint_name
					AND ccu.table_schema = tc.table_schema
				WHERE tc.constraint_type = 'FOREIGN KEY'
					AND tc.table_schema = 'public'
				ORDER BY tc.table_name, kcu.column_name
				"""
			)
			return cursor.fetchall()


def get_database_schema():
	tables = list_tables()
	return {
		"tables": [
			{
				"table_name": table_name,
				"columns": describe_table(table_name),
			}
			for table_name in tables
		],
		"relationships": get_relationships(),
	}
