from datetime import datetime
from decimal import Decimal
from typing import Optional
from uuid import UUID

from pydantic import BaseModel, EmailStr, Field


class BaseDBModel(BaseModel):
	id: UUID = Field(..., description="Primary Key")


class UserSchema(BaseDBModel):
	first_name: str = Field(..., min_length=1, max_length=100)
	last_name: str = Field(..., min_length=1, max_length=100)
	email: EmailStr = Field(..., description="Must be a valid email format")


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
