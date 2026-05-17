"""Tests for all Pydantic schemas defined in schemas.py."""

import pytest
from pydantic import ValidationError
from uuid import uuid4
from decimal import Decimal
from datetime import datetime, date
from schemas import (
    OrganizationSchema,
    UserSchema,
    CategorySchema,
    ProductCatalogSchema,
    VendorSchema,
    VendorProductSchema,
    PurchaseOrderSchema,
    POLineItemSchema,
    ReviewQueueSchema,
)


# ---------------------------------------------------------------------------
# OrganizationSchema
# ---------------------------------------------------------------------------

def test_organization_valid():
    org = OrganizationSchema(id=uuid4(), name="TechMart", domain="techmart.com", industry="Electronics")
    assert org.name == "TechMart"


def test_organization_empty_name_rejected():
    with pytest.raises(ValidationError):
        OrganizationSchema(id=uuid4(), name="", domain="x.com", industry="Electronics")


# ---------------------------------------------------------------------------
# UserSchema
# ---------------------------------------------------------------------------

def test_user_valid():
    u = UserSchema(
        id=uuid4(), org_id=uuid4(), first_name="John", last_name="Doe",
        email="john@example.com", role="buyer",
    )
    assert u.role == "buyer"


def test_user_invalid_role():
    with pytest.raises(ValidationError):
        UserSchema(
            id=uuid4(), org_id=uuid4(), first_name="John", last_name="Doe",
            email="john@example.com", role="superadmin",
        )


def test_user_invalid_email():
    with pytest.raises(ValidationError):
        UserSchema(
            id=uuid4(), org_id=uuid4(), first_name="John", last_name="Doe",
            email="not-an-email", role="buyer",
        )


# ---------------------------------------------------------------------------
# CategorySchema
# ---------------------------------------------------------------------------

def test_category_valid():
    c = CategorySchema(id=uuid4(), name="Smartphones", slug="smartphones")
    assert c.slug == "smartphones"


# ---------------------------------------------------------------------------
# ProductCatalogSchema
# ---------------------------------------------------------------------------

def test_product_valid():
    p = ProductCatalogSchema(id=uuid4(), category_id=uuid4(), name="iPhone 15", sku="PHONE-APL-IP15")
    assert p.unit_of_measure == "each"


def test_product_invalid_uom():
    with pytest.raises(ValidationError):
        ProductCatalogSchema(
            id=uuid4(), category_id=uuid4(), name="iPhone", sku="X",
            unit_of_measure="gallon",
        )


# ---------------------------------------------------------------------------
# VendorSchema
# ---------------------------------------------------------------------------

def test_vendor_valid():
    v = VendorSchema(
        id=uuid4(), org_id=uuid4(), name="TechSource",
        contact_email="info@techsource.com",
        reliability_score=Decimal("0.95"),
    )
    assert v.country == "US"


def test_vendor_reliability_out_of_range():
    with pytest.raises(ValidationError):
        VendorSchema(
            id=uuid4(), org_id=uuid4(), name="X",
            contact_email="x@x.com",
            reliability_score=Decimal("1.5"),
        )


# ---------------------------------------------------------------------------
# VendorProductSchema
# ---------------------------------------------------------------------------

def test_vendor_product_valid():
    vp = VendorProductSchema(
        id=uuid4(), vendor_id=uuid4(), product_id=uuid4(),
        unit_price=Decimal("899.99"), moq=5, lead_time_days=7,
    )
    assert vp.in_stock is True


def test_vendor_product_negative_price():
    with pytest.raises(ValidationError):
        VendorProductSchema(
            id=uuid4(), vendor_id=uuid4(), product_id=uuid4(),
            unit_price=Decimal("-1"), moq=1,
        )


def test_vendor_product_zero_moq():
    with pytest.raises(ValidationError):
        VendorProductSchema(
            id=uuid4(), vendor_id=uuid4(), product_id=uuid4(),
            unit_price=Decimal("10"), moq=0,
        )


# ---------------------------------------------------------------------------
# PurchaseOrderSchema
# ---------------------------------------------------------------------------

def test_po_valid():
    po = PurchaseOrderSchema(
        id=uuid4(), po_number="PO-20250101-000001",
        buyer_id=uuid4(), vendor_id=uuid4(), status="pending",
        total_amount=Decimal("5000"),
    )
    assert po.approval_required is False


def test_po_invalid_status():
    with pytest.raises(ValidationError):
        PurchaseOrderSchema(
            id=uuid4(), po_number="PO-1", buyer_id=uuid4(),
            vendor_id=uuid4(), status="unknown",
        )


def test_po_negative_total():
    with pytest.raises(ValidationError):
        PurchaseOrderSchema(
            id=uuid4(), po_number="PO-1", buyer_id=uuid4(),
            vendor_id=uuid4(), total_amount=Decimal("-100"),
        )


# ---------------------------------------------------------------------------
# POLineItemSchema
# ---------------------------------------------------------------------------

def test_line_item_valid():
    li = POLineItemSchema(
        id=uuid4(), po_id=uuid4(), vendor_product_id=uuid4(),
        quantity=10, unit_price=Decimal("50"), line_total=Decimal("500"),
    )
    assert li.quantity == 10


def test_line_item_without_line_total():
    """line_total is DB-generated (output-only), so it should be optional for input."""
    li = POLineItemSchema(
        id=uuid4(), po_id=uuid4(), vendor_product_id=uuid4(),
        quantity=10, unit_price=Decimal("50"),
    )
    assert li.line_total is None


def test_line_item_zero_quantity():
    with pytest.raises(ValidationError):
        POLineItemSchema(
            id=uuid4(), po_id=uuid4(), vendor_product_id=uuid4(),
            quantity=0, unit_price=Decimal("50"), line_total=Decimal("0"),
        )


# ---------------------------------------------------------------------------
# ReviewQueueSchema
# ---------------------------------------------------------------------------

def test_review_valid():
    r = ReviewQueueSchema(
        id=uuid4(), review_number="REV-20250101-000001",
        po_id=uuid4(), reason="Over threshold", urgency="high",
    )
    assert r.status == "pending_review"


def test_review_invalid_urgency():
    with pytest.raises(ValidationError):
        ReviewQueueSchema(
            id=uuid4(), review_number="REV-1", po_id=uuid4(),
            reason="test", urgency="critical",
        )


def test_review_invalid_status():
    with pytest.raises(ValidationError):
        ReviewQueueSchema(
            id=uuid4(), review_number="REV-1", po_id=uuid4(),
            reason="test", urgency="low", status="done",
        )
