from pydantic import BaseModel, Field, EmailStr
from typing import Optional
from decimal import Decimal
from datetime import datetime, date, timezone
from uuid import UUID


class BaseDBModel(BaseModel):
    id: UUID = Field(..., description="Primary Key")


class OrganizationSchema(BaseDBModel):
    name: str = Field(..., min_length=1, max_length=255)
    domain: str = Field(..., min_length=1, max_length=255)
    industry: str = Field(..., min_length=1, max_length=100)
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


class UserSchema(BaseDBModel):
    org_id: UUID
    first_name: str = Field(..., min_length=1, max_length=100)
    last_name: str = Field(..., min_length=1, max_length=100)
    email: EmailStr
    role: str = Field(..., pattern=r'^(admin|buyer|approver|viewer)$')
    is_active: bool = Field(default=True)
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


class CategorySchema(BaseDBModel):
    name: str = Field(..., min_length=1, max_length=100)
    slug: str = Field(..., min_length=1, max_length=100)
    description: Optional[str] = None


class ProductCatalogSchema(BaseDBModel):
    category_id: UUID
    name: str = Field(..., min_length=1, max_length=255)
    sku: str = Field(..., min_length=1, max_length=100)
    description: Optional[str] = None
    unit_of_measure: str = Field(default='each', pattern=r'^(each|box|carton|pallet|pack)$')


class VendorSchema(BaseDBModel):
    org_id: UUID
    name: str = Field(..., min_length=1, max_length=255)
    contact_email: EmailStr
    city: Optional[str] = Field(default=None, max_length=100)
    state: Optional[str] = Field(default=None, max_length=50)
    country: str = Field(default='US', max_length=100)
    certifications: list[str] = Field(default_factory=list)
    reliability_score: Decimal = Field(default=Decimal("0.00"), ge=Decimal("0"), le=Decimal("1"))
    avg_response_time_hours: int = Field(default=24, ge=0)
    is_active: bool = Field(default=True)
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


class VendorProductSchema(BaseDBModel):
    vendor_id: UUID
    product_id: UUID
    unit_price: Decimal = Field(..., ge=Decimal("0"))
    moq: int = Field(default=1, ge=1)
    lead_time_days: int = Field(default=7, ge=0)
    in_stock: bool = Field(default=True)
    stock_quantity: int = Field(default=0, ge=0)
    last_synced_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


class PurchaseOrderSchema(BaseDBModel):
    po_number: str = Field(..., min_length=1, max_length=50)
    buyer_id: UUID
    vendor_id: UUID
    status: str = Field(default='draft', pattern=r'^(draft|pending|confirmed|flagged_for_review|approved|rejected|cancelled|shipped|completed)$')
    total_amount: Decimal = Field(default=Decimal("0"), ge=Decimal("0"))
    required_by_date: Optional[date] = None
    approval_required: bool = Field(default=False)
    approval_reason: Optional[str] = None
    approved_by: Optional[str] = None
    notes: Optional[str] = None
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    updated_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


class POLineItemSchema(BaseDBModel):
    po_id: UUID
    vendor_product_id: UUID
    quantity: int = Field(..., gt=0)
    unit_price: Decimal = Field(..., ge=Decimal("0"))
    # line_total is a DB-generated column (GENERATED ALWAYS AS quantity * unit_price STORED).
    # It is output-only — never provided on INSERT. Optional for input validation use cases.
    line_total: Optional[Decimal] = Field(default=None, ge=Decimal("0"))


class ReviewQueueSchema(BaseDBModel):
    review_number: str = Field(..., min_length=1, max_length=50)
    po_id: UUID
    assigned_to: Optional[UUID] = None
    reason: str = Field(..., min_length=1)
    urgency: str = Field(..., pattern=r'^(low|medium|high)$')
    status: str = Field(default='pending_review', pattern=r'^(pending_review|under_review|approved|rejected)$')
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))
    resolved_at: Optional[datetime] = None
