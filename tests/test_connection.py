import sys
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"

if str(SRC) not in sys.path:
	sys.path.insert(0, str(SRC))

from procureos_mcp import config
from procureos_mcp.db import connection


def test_get_db_dsn_requires_password(monkeypatch):
	monkeypatch.setitem(config.DB_CONFIG, "password", None)

	with pytest.raises(ValueError):
		config.get_db_dsn()


def test_get_db_dsn_builds_string(monkeypatch):
	monkeypatch.setitem(config.DB_CONFIG, "host", "db.example.com")
	monkeypatch.setitem(config.DB_CONFIG, "port", 5432)
	monkeypatch.setitem(config.DB_CONFIG, "dbname", "procureos_db")
	monkeypatch.setitem(config.DB_CONFIG, "user", "kushal")
	monkeypatch.setitem(config.DB_CONFIG, "password", "secret")

	dsn = config.get_db_dsn()

	assert "dbname=procureos_db" in dsn
	assert "user=kushal" in dsn
	assert "password=secret" in dsn
	assert "host=db.example.com" in dsn
	assert "port=5432" in dsn


def test_get_connection_uses_dsn(monkeypatch):
	called = {}

	def fake_connect(dsn):
		called["dsn"] = dsn
		return "conn"

	monkeypatch.setattr(connection, "get_db_dsn", lambda: "dsn-string")
	monkeypatch.setattr(connection.psycopg2, "connect", fake_connect)

	result = connection.get_connection()

	assert result == "conn"
	assert called["dsn"] == "dsn-string"
