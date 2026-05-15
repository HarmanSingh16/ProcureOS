import psycopg2

from procureos_mcp.config import get_db_dsn


def get_connection():
	return psycopg2.connect(get_db_dsn())
