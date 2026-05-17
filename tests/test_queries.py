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


def test_run_readonly_query_rejects_multi_statement():
    with pytest.raises(ValueError, match="Only a single SELECT statement is allowed"):
        queries.run_readonly_query("SELECT 1; DROP TABLE vendors")


def test_run_readonly_query_sets_read_only(monkeypatch):
    """Verify that SET TRANSACTION READ ONLY is issued before the user query."""
    executed_statements = []

    class TrackingCursor(FakeCursor):
        def execute(self, sql, params=None):
            executed_statements.append(sql)

    class TrackingConn(FakeConn):
        def cursor(self, cursor_factory=None):
            return TrackingCursor([{"id": uuid4(), "x": 1}])

    monkeypatch.setattr(queries, "get_connection", lambda: TrackingConn([]))

    queries.run_readonly_query("SELECT * FROM vendors")
    assert len(executed_statements) == 2
    assert executed_statements[0] == "SET TRANSACTION READ ONLY"
    assert "SELECT * FROM vendors" in executed_statements[1]


# ---------------------------------------------------------------------------
# 7. create_purchase_order
# ---------------------------------------------------------------------------

class MultiStepCursor:
    """Fake cursor that returns different results for sequential execute() calls.

    Accepts a list of result-rows; each call to execute() advances to the
    next set, and fetchone()/fetchall() return from that set.
    """

    def __init__(self, step_results: list):
        self._steps = step_results
        self._index = -1
        self._current = []

    def execute(self, sql, params=None):
        self._index += 1
        if self._index < len(self._steps):
            self._current = self._steps[self._index]
        else:
            self._current = []

    def fetchone(self):
        return self._current[0] if self._current else None

    def fetchall(self):
        return self._current

    def close(self):
        pass

    def __enter__(self):
        return self

    def __exit__(self, *args):
        pass


class MultiStepConn:
    """Fake connection that uses a MultiStepCursor."""

    def __init__(self, step_results: list):
        self._step_results = step_results
        self.committed = False

    def cursor(self, cursor_factory=None):
        return MultiStepCursor(self._step_results)

    def commit(self):
        self.committed = True

    def close(self):
        pass

    def __enter__(self):
        return self

    def __exit__(self, *args):
        pass


def test_create_purchase_order_below_threshold(monkeypatch):
    """PO under $5,000 should be 'pending' and not auto-flagged."""
    vendor_id = str(uuid4())
    buyer_id = str(uuid4())
    product_id = str(uuid4())
    vp_id = uuid4()
    po_id = uuid4()

    # Step sequence for create_purchase_order:
    # 1. SELECT next_seq for PO number
    # 2. SELECT vendor_product (for each item — 1 item here)
    # 3. INSERT purchase_order RETURNING *
    # 4. INSERT po_line_item RETURNING *
    step_results = [
        # 1. next PO sequence
        [{"next_seq": 1}],
        # 2. vendor_product lookup
        [{"vendor_product_id": vp_id, "unit_price": Decimal("100.00"), "moq": 1}],
        # 3. INSERT PO RETURNING *
        [{
            "id": po_id,
            "po_number": "PO-20250115-000001",
            "buyer_id": uuid4(),
            "vendor_id": uuid4(),
            "status": "pending",
            "total_amount": Decimal("1000.00"),
            "required_by_date": None,
            "approval_required": False,
            "approval_reason": None,
            "notes": None,
            "created_at": datetime(2025, 1, 15),
            "updated_at": datetime(2025, 1, 15),
        }],
        # 4. INSERT line item RETURNING *
        [{
            "id": uuid4(),
            "po_id": po_id,
            "vendor_product_id": vp_id,
            "quantity": 10,
            "unit_price": Decimal("100.00"),
            "line_total": Decimal("1000.00"),
        }],
    ]

    monkeypatch.setattr(queries, "get_connection", lambda: MultiStepConn(step_results))

    result = queries.create_purchase_order(
        buyer_id=buyer_id,
        vendor_id=vendor_id,
        items=[{"product_id": product_id, "quantity": 10}],
    )
    assert result["status"] == "pending"
    assert "line_items" in result
    assert len(result["line_items"]) == 1


def test_create_purchase_order_auto_flags_above_threshold(monkeypatch):
    """PO >= $5,000 should be 'flagged_for_review' with a review queue entry."""
    vendor_id = str(uuid4())
    buyer_id = str(uuid4())
    product_id = str(uuid4())
    vp_id = uuid4()
    po_id = uuid4()

    # Steps: PO seq, vendor_product, INSERT PO, INSERT line_item,
    #         review seq, INSERT review_queue
    step_results = [
        [{"next_seq": 1}],
        [{"vendor_product_id": vp_id, "unit_price": Decimal("500.00"), "moq": 1}],
        [{
            "id": po_id,
            "po_number": "PO-20250115-000001",
            "buyer_id": uuid4(),
            "vendor_id": uuid4(),
            "status": "flagged_for_review",
            "total_amount": Decimal("5000.00"),
            "required_by_date": None,
            "approval_required": True,
            "approval_reason": "Total amount $5000.00 exceeds $5,000.00 threshold",
            "notes": None,
            "created_at": datetime(2025, 1, 15),
            "updated_at": datetime(2025, 1, 15),
        }],
        [{
            "id": uuid4(),
            "po_id": po_id,
            "vendor_product_id": vp_id,
            "quantity": 10,
            "unit_price": Decimal("500.00"),
            "line_total": Decimal("5000.00"),
        }],
        # review seq
        [{"next_seq": 1}],
        # INSERT review_queue (no RETURNING, returns nothing)
        [],
    ]

    monkeypatch.setattr(queries, "get_connection", lambda: MultiStepConn(step_results))

    result = queries.create_purchase_order(
        buyer_id=buyer_id,
        vendor_id=vendor_id,
        items=[{"product_id": product_id, "quantity": 10}],
    )
    assert result["status"] == "flagged_for_review"
    assert result["approval_required"] is True


def test_create_purchase_order_vendor_not_carrying_product(monkeypatch):
    """Should raise ValueError when vendor doesn't carry the requested product."""
    vendor_id = str(uuid4())
    buyer_id = str(uuid4())
    product_id = str(uuid4())

    step_results = [
        # 1. next PO sequence
        [{"next_seq": 1}],
        # 2. vendor_product lookup — not found
        [],
    ]

    monkeypatch.setattr(queries, "get_connection", lambda: MultiStepConn(step_results))

    with pytest.raises(ValueError, match="does not carry product"):
        queries.create_purchase_order(
            buyer_id=buyer_id,
            vendor_id=vendor_id,
            items=[{"product_id": product_id, "quantity": 5}],
        )


def test_create_purchase_order_below_moq(monkeypatch):
    """Should raise ValueError when quantity is below MOQ."""
    vendor_id = str(uuid4())
    buyer_id = str(uuid4())
    product_id = str(uuid4())
    vp_id = uuid4()

    step_results = [
        [{"next_seq": 1}],
        [{"vendor_product_id": vp_id, "unit_price": Decimal("100.00"), "moq": 10}],
    ]

    monkeypatch.setattr(queries, "get_connection", lambda: MultiStepConn(step_results))

    with pytest.raises(ValueError, match="below MOQ"):
        queries.create_purchase_order(
            buyer_id=buyer_id,
            vendor_id=vendor_id,
            items=[{"product_id": product_id, "quantity": 3}],
        )


# ---------------------------------------------------------------------------
# 8. create_review
# ---------------------------------------------------------------------------

def test_create_review(monkeypatch):
    """Should create a review queue entry and flag the PO."""
    po_id = str(uuid4())
    review_id = uuid4()

    step_results = [
        # 1. next review sequence
        [{"next_seq": 1}],
        # 2. INSERT review RETURNING *
        [{
            "id": review_id,
            "review_number": "REV-20250115-000001",
            "po_id": uuid4(),
            "assigned_to": None,
            "reason": "Over threshold",
            "urgency": "high",
            "status": "pending_review",
            "created_at": datetime(2025, 1, 15),
            "resolved_at": None,
        }],
        # 3. UPDATE purchase_orders SET status (no return needed)
        [],
    ]

    monkeypatch.setattr(queries, "get_connection", lambda: MultiStepConn(step_results))

    result = queries.create_review(
        po_id=po_id,
        reason="Over threshold",
        urgency="high",
    )
    assert result["review_number"] == "REV-20250115-000001"
    assert result["urgency"] == "high"
    assert result["status"] == "pending_review"
