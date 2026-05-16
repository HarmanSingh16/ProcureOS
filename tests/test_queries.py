import datetime as dt
import uuid

from procureos_mcp.db import queries


def test_search_products_builds_results(monkeypatch):
	expected = [
		{"id": uuid.uuid4(), "name": "Widget", "description": "A", "price": 10.0},
		{"id": uuid.uuid4(), "name": "Gadget", "description": "B", "price": 20.0},
	]

	class FakeCursor:
		def execute(self, sql, params):
			self.sql = sql
			self.params = params

		def fetchall(self):
			return expected

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	class FakeConn:
		def cursor(self, cursor_factory=None):
			return FakeCursor()

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	monkeypatch.setattr(queries, "get_connection", lambda: FakeConn())

	rows = queries.search_products("widget", max_unit_price=25.0)
	assert rows == expected


def test_get_user_by_email(monkeypatch):
	expected = {
		"id": uuid.uuid4(),
		"first_name": "Ava",
		"last_name": "Ng",
		"email": "ava@x.com",
	}

	class FakeCursor:
		def execute(self, sql, params):
			self.sql = sql
			self.params = params

		def fetchone(self):
			return expected

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	class FakeConn:
		def cursor(self, cursor_factory=None):
			return FakeCursor()

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	monkeypatch.setattr(queries, "get_connection", lambda: FakeConn())

	row = queries.get_user_by_email("ava@x.com")
	assert row == expected


def test_get_product_by_id(monkeypatch):
	expected = {
		"id": uuid.uuid4(),
		"name": "Camera",
		"description": None,
		"price": 100.0,
	}

	class FakeCursor:
		def execute(self, sql, params):
			self.sql = sql
			self.params = params

		def fetchone(self):
			return expected

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	class FakeConn:
		def cursor(self, cursor_factory=None):
			return FakeCursor()

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	monkeypatch.setattr(queries, "get_connection", lambda: FakeConn())

	row = queries.get_product_by_id(str(expected["id"]))
	assert row == expected


def test_create_order_executes_insert(monkeypatch):
	order = {
		"id": uuid.uuid4(),
		"user_id": uuid.uuid4(),
		"order_number": "ORD-123456",
		"status": "PENDING",
		"total": 12.5,
		"placed_at": dt.datetime.now(dt.timezone.utc),
	}

	executed = {}

	class FakeCursor:
		def execute(self, sql, params):
			executed["sql"] = sql
			executed["params"] = params

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	class FakeConn:
		def cursor(self):
			return FakeCursor()

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	monkeypatch.setattr(queries, "get_connection", lambda: FakeConn())

	queries.create_order(order)
	assert "INSERT INTO orders" in executed["sql"]
	assert executed["params"][0] == str(order["id"])


def test_create_order_items_executes_inserts(monkeypatch):
	items = [
		{
			"id": uuid.uuid4(),
			"order_id": uuid.uuid4(),
			"product_id": uuid.uuid4(),
			"quantity": 2,
			"unit_price": 10.0,
		},
		{
			"id": uuid.uuid4(),
			"order_id": uuid.uuid4(),
			"product_id": uuid.uuid4(),
			"quantity": 1,
			"unit_price": 5.0,
		},
	]

	calls = []

	class FakeCursor:
		def execute(self, sql, params):
			calls.append((sql, params))

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	class FakeConn:
		def cursor(self):
			return FakeCursor()

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	monkeypatch.setattr(queries, "get_connection", lambda: FakeConn())

	queries.create_order_items(items)
	assert len(calls) == 2
	assert "INSERT INTO order_items" in calls[0][0]


def test_get_order_by_number(monkeypatch):
	expected = {"id": uuid.uuid4(), "order_number": "ORD-123456", "status": "PENDING"}

	class FakeCursor:
		def execute(self, sql, params):
			self.sql = sql
			self.params = params

		def fetchone(self):
			return expected

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	class FakeConn:
		def cursor(self, cursor_factory=None):
			return FakeCursor()

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	monkeypatch.setattr(queries, "get_connection", lambda: FakeConn())

	row = queries.get_order_by_number("ORD-123456")
	assert row == expected


def test_get_orders_by_status(monkeypatch):
	expected = [
		{"id": uuid.uuid4(), "status": "PENDING", "order_number": "ORD-1"},
		{"id": uuid.uuid4(), "status": "PENDING", "order_number": "ORD-2"},
	]

	class FakeCursor:
		def execute(self, sql, params):
			self.sql = sql
			self.params = params

		def fetchall(self):
			return expected

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	class FakeConn:
		def cursor(self, cursor_factory=None):
			return FakeCursor()

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	monkeypatch.setattr(queries, "get_connection", lambda: FakeConn())

	rows = queries.get_orders_by_status("PENDING")
	assert rows == expected


def test_get_orders_for_user(monkeypatch):
	expected = [
		{"id": uuid.uuid4(), "user_id": uuid.uuid4(), "order_number": "ORD-1"},
	]

	class FakeCursor:
		def execute(self, sql, params):
			self.sql = sql
			self.params = params

		def fetchall(self):
			return expected

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	class FakeConn:
		def cursor(self, cursor_factory=None):
			return FakeCursor()

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	monkeypatch.setattr(queries, "get_connection", lambda: FakeConn())

	rows = queries.get_orders_for_user(str(expected[0]["user_id"]))
	assert rows == expected


def test_get_order_items_for_order(monkeypatch):
	expected = [
		{
			"id": uuid.uuid4(),
			"order_id": uuid.uuid4(),
			"product_id": uuid.uuid4(),
			"quantity": 2,
			"unit_price": 10.0,
			"product_name": "Widget",
			"product_description": "A",
		},
	]

	class FakeCursor:
		def execute(self, sql, params):
			self.sql = sql
			self.params = params

		def fetchall(self):
			return expected

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	class FakeConn:
		def cursor(self, cursor_factory=None):
			return FakeCursor()

		def __enter__(self):
			return self

		def __exit__(self, *args):
			return False

	monkeypatch.setattr(queries, "get_connection", lambda: FakeConn())

	rows = queries.get_order_items_for_order(str(expected[0]["order_id"]))
	assert rows == expected
