from datetime import date, datetime
from decimal import Decimal
from typing import Literal, Optional
from uuid import UUID

from pydantic import BaseModel, EmailStr, Field


class BaseDBModel(BaseModel):
	id: UUID = Field(..., description="Primary Key")


class OrganizationSchema(BaseDBModel):
	name: str = Field(..., min_length=1, max_length=255)
	domain: Optional[str] = Field(default=None, min_length=1, max_length=255)
	industry: Optional[str] = Field(default=None, min_length=1, max_length=255)


class UserSchema(BaseDBModel):
	org_id: Optional[UUID] = None
	first_name: str = Field(..., min_length=1, max_length=100)
	last_name: str = Field(..., min_length=1, max_length=100)
	email: EmailStr = Field(..., description="Must be a valid email format")
	role: Literal["buyer", "approver", "requester", "reviewer", "admin"] = "buyer"


class CategorySchema(BaseDBModel):
	name: str = Field(..., min_length=1, max_length=255)
	slug: str = Field(..., min_length=1, max_length=255)


class ProductCatalogSchema(BaseDBModel):
	category_id: UUID
	name: str = Field(..., min_length=1, max_length=255)
	sku: str = Field(..., min_length=1, max_length=64)
	unit_of_measure: Literal["each", "pack", "box", "case", "set"] = "each"


class VendorSchema(BaseDBModel):
	org_id: Optional[UUID] = None
	name: str = Field(..., min_length=1, max_length=255)
	contact_email: EmailStr
	reliability_score: Decimal = Field(..., ge=Decimal("0.00"), le=Decimal("1.00"))
	country: str = Field(default="US", min_length=2, max_length=2)


class VendorProductSchema(BaseDBModel):
	vendor_id: UUID
	product_id: UUID
	unit_price: Decimal = Field(..., ge=Decimal("0.00"))
	moq: int = Field(..., gt=0)
	lead_time_days: int = Field(default=0, ge=0)
	in_stock: bool = True
	stock_quantity: Optional[int] = Field(default=None, ge=0)


class PurchaseOrderSchema(BaseDBModel):
	po_number: str = Field(..., min_length=1, max_length=100)
	buyer_id: UUID
	vendor_id: UUID
	status: Literal[
		"pending",
		"approved",
		"rejected",
		"flagged_for_review",
		"cancelled",
	] = "pending"
	total_amount: Decimal = Field(..., ge=Decimal("0.00"))
	required_by_date: Optional[date] = None
	approval_required: bool = False
	approval_reason: Optional[str] = None
	notes: Optional[str] = None
	created_at: datetime = Field(default_factory=datetime.utcnow)
	updated_at: datetime = Field(default_factory=datetime.utcnow)


class POLineItemSchema(BaseDBModel):
	po_id: UUID
	vendor_product_id: UUID
	quantity: int = Field(..., gt=0)
	unit_price: Decimal = Field(..., ge=Decimal("0.00"))
	line_total: Optional[Decimal] = Field(default=None, ge=Decimal("0.00"))


class ReviewQueueSchema(BaseDBModel):
	review_number: str = Field(..., min_length=1, max_length=100)
	po_id: UUID
	assigned_to: Optional[UUID] = None
	reason: str = Field(..., min_length=1)
	urgency: Literal["low", "medium", "high"]
	status: Literal["pending_review", "approved", "rejected", "resolved"] = (
		"pending_review"
	)
	created_at: datetime = Field(default_factory=datetime.utcnow)
	resolved_at: Optional[datetime] = None


class ProductSchema(BaseDBModel):
	name: str = Field(..., min_length=1, max_length=255)
	description: Optional[str] = None
	price: Decimal = Field(..., ge=Decimal("0.00"))


class OrderSchema(BaseDBModel):
	user_id: UUID
	order_number: str = Field(..., min_length=1, max_length=100)
	status: str = Field(..., min_length=1, max_length=50)
	total: Decimal = Field(..., ge=Decimal("0.00"))
	placed_at: datetime = Field(default_factory=datetime.utcnow)


class OrderItemSchema(BaseDBModel):
	order_id: UUID
	product_id: UUID
	quantity: int = Field(..., gt=0)
	unit_price: Decimal = Field(..., ge=Decimal("0.00"))
