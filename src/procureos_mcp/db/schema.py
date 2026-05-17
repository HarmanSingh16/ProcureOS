from typing import Optional

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
	"""Return rich column metadata including comments, CHECK constraints, and FK targets.

	Each row in the result contains:
	  - column_name, data_type, is_nullable, column_default  (from information_schema)
	  - comment        (from pg_description via pg_attribute + pg_class)
	  - check_constraint  (CHECK expression from pg_constraint, excluding NOT NULL)
	  - foreign_key    (FK target as 'table.column', from information_schema FK views)
	"""
	sql = """
	SELECT
		c.column_name,
		c.data_type,
		c.is_nullable,
		c.column_default,
		pgd.description                                          AS comment,
		cc.check_clause                                          AS check_constraint,
		CASE
			WHEN fk_ccu.table_name IS NOT NULL
			THEN fk_ccu.table_name || '.' || fk_ccu.column_name
		END                                                      AS foreign_key
	FROM information_schema.columns c

	-- Column comments from pg_description
	LEFT JOIN pg_catalog.pg_class     pcls ON pcls.relname = c.table_name
	LEFT JOIN pg_catalog.pg_namespace pns  ON pns.oid = pcls.relnamespace
	                                       AND pns.nspname = c.table_schema
	LEFT JOIN pg_catalog.pg_attribute pa   ON pa.attrelid = pcls.oid
	                                       AND pa.attname  = c.column_name
	LEFT JOIN pg_catalog.pg_description pgd ON pgd.objoid    = pcls.oid
	                                        AND pgd.objsubid  = pa.attnum

	-- CHECK constraints (exclude NOT NULL which pg stores as CHECK too)
	LEFT JOIN LATERAL (
		SELECT pg_get_constraintdef(con.oid, true) AS check_clause
		FROM pg_catalog.pg_constraint con
		WHERE con.conrelid = pcls.oid
		  AND con.contype = 'c'
		  AND pa.attnum = ANY(con.conkey)
		  AND array_length(con.conkey, 1) = 1
		LIMIT 1
	) cc ON true

	-- Foreign key target
	LEFT JOIN information_schema.key_column_usage fk_kcu
		ON  fk_kcu.table_schema = c.table_schema
		AND fk_kcu.table_name   = c.table_name
		AND fk_kcu.column_name  = c.column_name
	LEFT JOIN information_schema.table_constraints fk_tc
		ON  fk_tc.constraint_name   = fk_kcu.constraint_name
		AND fk_tc.table_schema      = fk_kcu.table_schema
		AND fk_tc.constraint_type   = 'FOREIGN KEY'
	LEFT JOIN information_schema.constraint_column_usage fk_ccu
		ON  fk_ccu.constraint_name  = fk_tc.constraint_name
		AND fk_ccu.table_schema     = fk_tc.table_schema

	WHERE c.table_schema = 'public'
	  AND c.table_name   = %s
	  AND pns.nspname    = 'public'
	ORDER BY c.ordinal_position
	"""

	with get_connection() as conn:
		with conn.cursor(cursor_factory=RealDictCursor) as cursor:
			cursor.execute(sql, (table_name,))
			return [dict(row) for row in cursor.fetchall()]


def get_table_comment(table_name: str) -> Optional[str]:
	"""Return the table-level COMMENT for a public table, or None if not set."""
	sql = """
	SELECT obj_description(c.oid)
	FROM pg_class c
	JOIN pg_namespace n ON n.oid = c.relnamespace
	WHERE c.relname = %s AND n.nspname = 'public'
	"""
	with get_connection() as conn:
		with conn.cursor() as cursor:
			cursor.execute(sql, (table_name,))
			row = cursor.fetchone()
			return row[0] if row else None


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
				"table_comment": get_table_comment(table_name),
				"columns": describe_table(table_name),
			}
			for table_name in tables
		],
		"relationships": get_relationships(),
	}
