"""Configuration loading for the ProcureOS MCP server."""

import os

from dotenv import load_dotenv

load_dotenv()


def get_required_env(name: str) -> str:
    """Return a required environment variable or fail with a clear error."""
    value = os.getenv(name)
    if not value:
        raise RuntimeError(f"Missing required environment variable: {name}")
    return value


DB_CONFIG = {
    "host": get_required_env("DB_HOST"),
    "port": int(os.getenv("DB_PORT", "5432")),
    "database": get_required_env("DB_NAME"),
    "user": get_required_env("DB_USER"),
    "password": get_required_env("DB_PASSWORD"),
}
