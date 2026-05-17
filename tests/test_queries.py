"""Tests for ProcureOS query functions using mocked DB connections."""

import pytest
from decimal import Decimal
from datetime import datetime
from uuid import uuid4

from procureos_mcp.db import queries


# ---------------------------------------------------------------------------
# Fake DB helpers
# ---------------------------------------------------------------------------

class FakeCursor:
    """Mimics a psycopg2 RealDictCursor for testing."""

    def __init__(self, rows):
        self._rows = rows

    def execute(self, sql, params=None):
        pass

    def fetchall(self):
        return self._rows

    def fetchone(self):
        return self._rows[0] if self._rows else None

    def close(self):
        pass

    def __enter__(self):
        return self

    def __exit__(self, *args):
        pass


class FakeConn:
    """Mimics a psycopg2 connection for testing."""

    def __init__(self, rows):
        self._rows = rows

    def cursor(self, cursor_factory=None):
        return FakeCursor(self._rows)

    def commit(self):
        pass

    def close(self):
        pass

    def __enter__(self):
        return self

    def __exit__(self, *args):
        pass


# ---------------------------------------------------------------------------
# 1. search_vendors
# ---------------------------------------------------------------------------

def test_search_vendors_returns_results(monkeypatch):
    rows = [
        {
            "vendor_id": uuid4(),
            "vendor_name": "TechSource",
            "contact_email": "info@techsource.com",
            "city": "Austin",
            "state": "TX",
            "country": "US",
            "certifications": ["ISO9001"],
            "reliability_score": Decimal("0.95"),
            "avg_response_time_hours": 12,
            "is_active": True,
            "matched_products": 3,
        },
        {
            "vendor_id": uuid4(),
            "vendor_name": "ChipDirect",
            "contact_email": "sales@chipdirect.com",
            "city": "San Jose",
            "state": "CA",
            "country": "US",
            "certifications": [],
            "reliability_score": Decimal("0.88"),
            "avg_response_time_hours": 24,
            "is_active": True,
            "matched_products": 1,
        },
    ]

    monkeypatch.setattr(queries, "get_connection", lambda: FakeConn(rows))

    results = queries.search_vendors(query="laptop")
    assert isinstance(results, list)
    assert len(results) == 2
    assert results[0]["vendor_name"] == "TechSource"
    # Decimal should be serialized to float
    assert isinstance(results[0]["reliability_score"], float)


def test_search_vendors_empty(monkeypatch):
    monkeypatch.setattr(queries, "get_connection", lambda: FakeConn([]))

    results = queries.search_vendors(query="nonexistent")
    assert results == []


# ---------------------------------------------------------------------------
# 2. get_inventory
# ---------------------------------------------------------------------------

def test_get_inventory_found(monkeypatch):
    row = {
        "product_name": "iPhone 15 Pro",
        "sku": "PHONE-APL-IP15P",
        "in_stock": True,
        "stock_quantity": 250,
        "lead_time_days": 5,
        "moq": 10,
        "unit_price": Decimal("999.99"),
        "last_synced_at": datetime(2025, 1, 15, 12, 0, 0),
    }

    monkeypatch.setattr(queries, "get_connection", lambda: FakeConn([row]))

    result = queries.get_inventory(vendor_id=str(uuid4()), sku="PHONE-APL-IP15P")
    assert isinstance(result, dict)
    assert result["product_name"] == "iPhone 15 Pro"
    assert result["sku"] == "PHONE-APL-IP15P"
    assert isinstance(result["unit_price"], float)
    assert isinstance(result["last_synced_at"], str)


def test_get_inventory_not_found(monkeypatch):
    monkeypatch.setattr(queries, "get_connection", lambda: FakeConn([]))

    result = queries.get_inventory(vendor_id=str(uuid4()), sku="NONEXIST-SKU")
    assert result is None


# ---------------------------------------------------------------------------
# 3. get_quote
# ---------------------------------------------------------------------------

def test_get_quote_valid(monkeypatch):
    row = {
        "product_name": "USB-C Hub",
        "sku": "ACC-USB-HUB7",
        "unit_price": Decimal("45.00"),
        "moq": 5,
        "lead_time_days": 3,
        "in_stock": True,
        "stock_quantity": 500,
        "last_synced_at": datetime(2025, 1, 15),
    }

    monkeypatch.setattr(queries, "get_connection", lambda: FakeConn([row]))

    result = queries.get_quote(vendor_id=str(uuid4()), sku="ACC-USB-HUB7", quantity=10)
    assert isinstance(result, dict)
    assert result["quantity"] == 10
    assert result["total_price"] == 450.0


def test_get_quote_below_moq(monkeypatch):
    row = {
        "product_name": "USB-C Hub",
        "sku": "ACC-USB-HUB7",
        "unit_price": Decimal("45.00"),
        "moq": 10,
        "lead_time_days": 3,
        "in_stock": True,
        "stock_quantity": 500,
        "last_synced_at": datetime(2025, 1, 15),
    }

    monkeypatch.setattr(queries, "get_connection", lambda: FakeConn([row]))

    with pytest.raises(ValueError, match="below the minimum order quantity"):
        queries.get_quote(vendor_id=str(uuid4()), sku="ACC-USB-HUB7", quantity=5)


def test_get_quote_not_found(monkeypatch):
    monkeypatch.setattr(queries, "get_connection", lambda: FakeConn([]))

    result = queries.get_quote(vendor_id=str(uuid4()), sku="NONEXIST", quantity=10)
    assert result is None


# ---------------------------------------------------------------------------
# 4. compare_vendors
# ---------------------------------------------------------------------------

def test_compare_vendors_by_price(monkeypatch):
    rows = [
        {
            "vendor_id": uuid4(),
            "vendor_name": "BudgetTech",
            "reliability_score": Decimal("0.85"),
            "avg_response_time_hours": 48,
            "state": "TX",
            "country": "US",
            "product_name": "Laptop Stand",
            "sku": "ACC-STAND-01",
            "unit_price": Decimal("29.99"),
            "moq": 5,
            "lead_time_days": 7,
            "in_stock": True,
            "stock_quantity": 200,
            "total_price": Decimal("299.90"),
        },
        {
            "vendor_id": uuid4(),
            "vendor_name": "PremiumSupply",
            "reliability_score": Decimal("0.98"),
            "avg_response_time_hours": 4,
            "state": "CA",
            "country": "US",
            "product_name": "Laptop Stand",
            "sku": "ACC-STAND-01",
            "unit_price": Decimal("39.99"),
            "moq": 1,
            "lead_time_days": 2,
            "in_stock": True,
            "stock_quantity": 50,
            "total_price": Decimal("399.90"),
        },
    ]

    monkeypatch.setattr(queries, "get_connection", lambda: FakeConn(rows))

    results = queries.compare_vendors(sku="ACC-STAND-01", quantity=10, rank_by="price")
    assert isinstance(results, list)
    assert len(results) == 2
    # Prices should be serialized to float
    assert isinstance(results[0]["unit_price"], float)


# ---------------------------------------------------------------------------
# 5. get_po_status
# ---------------------------------------------------------------------------

def test_get_po_status_found(monkeypatch):
    po_row = {
        "id": uuid4(),
        "po_number": "PO-20250115-000001",
        "buyer_id": uuid4(),
        "vendor_id": uuid4(),
        "status": "pending",
        "total_amount": Decimal("4500.00"),
        "required_by_date": None,
        "approval_required": False,
        "approval_reason": None,
        "notes": None,
        "created_at": datetime(2025, 1, 15, 10, 0, 0),
        "updated_at": datetime(2025, 1, 15, 10, 0, 0),
        "vendor_name": "TechSource",
        "buyer_name": "John Doe",
        "buyer_email": "john@example.com",
    }

    monkeypatch.setattr(queries, "get_connection", lambda: FakeConn([po_row]))

    result = queries.get_po_status(po_id=str(uuid4()))
    assert isinstance(result, dict)
    assert result["po_number"] == "PO-20250115-000001"
    assert result["vendor_name"] == "TechSource"
    assert isinstance(result["total_amount"], float)


def test_get_po_status_not_found(monkeypatch):
    monkeypatch.setattr(queries, "get_connection", lambda: FakeConn([]))

    result = queries.get_po_status(po_id=str(uuid4()))
    assert result is None


# ---------------------------------------------------------------------------
# 6. run_readonly_query
# ---------------------------------------------------------------------------

def test_run_readonly_query_select(monkeypatch):
    rows = [
        {"id": uuid4(), "name": "TestVendor"},
    ]

    monkeypatch.setattr(queries, "get_connection", lambda: FakeConn(rows))

    results = queries.run_readonly_query("SELECT * FROM vendors LIMIT 1")
    assert isinstance(results, list)
    assert len(results) == 1
    assert results[0]["name"] == "TestVendor"


def test_run_readonly_query_rejects_insert():
    with pytest.raises(ValueError, match="Only SELECT queries are allowed"):
        queries.run_readonly_query("INSERT INTO vendors (name) VALUES ('hack')")
