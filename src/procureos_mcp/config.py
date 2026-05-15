import os

try:
	from dotenv import load_dotenv

	load_dotenv()
except Exception:
	pass


DB_CONFIG = {
	"host": os.getenv("DB_HOST", "100.72.202.71"),
	"port": int(os.getenv("DB_PORT", "5432")),
	"dbname": os.getenv("DB_NAME", "procureos_db"),
	"user": os.getenv("DB_USER", "kushal"),
	"password": os.getenv("DB_PASSWORD"),
}


def get_db_dsn() -> str:
	password = DB_CONFIG.get("password")
	if not password:
		raise ValueError("DB_PASSWORD is required in environment variables.")
	return (
		"dbname={dbname} user={user} password={password} host={host} port={port}"
	).format(**DB_CONFIG)
