from pydantic import BaseModel, Field, EmailStr
from typing import Optional, Dict, Any, List
from decimal import Decimal
from datetime import datetime
from uuid import UUID
from enum import Enum

# ENUMS
class UserRole(str, Enum):
    BUYER = "BUYER"
    SELLER = "SELLER"
    ADMIN = "ADMIN"

class ItemCondition(str, Enum):
    NEW = "NEW"
    REFURBISHED = "REFURBISHED"
    USED = "USED"

class InventoryChangeType(str, Enum):
    RESTOCK = "RESTOCK"
    SALE = "SALE"
    RETURN = "RETURN"
    ADJUSTMENT = "ADJUSTMENT"

class OrderStatus(str, Enum):
    PENDING = "PENDING"
    PAID = "PAID"
    SHIPPED = "SHIPPED"
    DELIVERED = "DELIVERED"
    CANCELLED = "CANCELLED"

class ListingStatus(str, Enum):
    ACTIVE = "ACTIVE"
    PAUSED = "PAUSED"
    SOLD_OUT = "SOLD_OUT"

class PaymentMethod(str, Enum):
    CREDIT_CARD = "CREDIT_CARD"
    PAYPAL = "PAYPAL"
    STRIPE = "STRIPE"

class PaymentStatus(str, Enum):
    PENDING = "PENDING"
    SUCCESS = "SUCCESS"
    FAILED = "FAILED"
    REFUNDED = "REFUNDED"

class DiscountType(str, Enum):
    PERCENTAGE = "PERCENTAGE"
    FIXED_AMOUNT = "FIXED_AMOUNT"

class NotificationType(str, Enum):
    ORDER_UPDATE = "ORDER_UPDATE"
    PROMO = "PROMO"
    SYSTEM = "SYSTEM"


# --- THE BASE MODEL (Inheritance to avoid redundant code) ---
class BaseDBModel(BaseModel):
    id: UUID = Field(..., description="Primary Key")

class UserSchema(BaseDBModel):
    first_name: str = Field(..., min_length=1)
    last_name: str = Field(..., min_length=1)
    email: EmailStr = Field(..., description="Must be a valid email format")
    password_hash: str = Field(...)
    phone: Optional[str] = None
    role: UserRole
    is_verified: bool = False
    is_active: bool = True
    created_at: datetime
    updated_at: datetime

class AddressSchema(BaseDBModel):
    user_id: UUID
    label: str = Field(..., description="e.g., Home, Office")
    street_line1: str = Field(..., min_length=1)
    street_line2: Optional[str] = None
    city: str = Field(..., min_length=1)
    state: str = Field(..., min_length=1)
    postal_code: str = Field(..., min_length=1)
    country: str = Field(..., min_length=1)
    is_default: bool = False

class CategorySchema(BaseDBModel):
    parent_id: Optional[UUID] = None
    name: str = Field(..., min_length=1)
    slug: str = Field(..., min_length=1)
    description: Optional[str] = None
    image_url: Optional[str] = None
    is_active: bool = True

class BrandSchema(BaseDBModel):
    name: str = Field(..., min_length=1)
    logo_url: Optional[str] = None
    description: Optional[str] = None
    is_active: bool = True

class ProductSchema(BaseDBModel):
    category_id: UUID
    brand_id: UUID
    name: str = Field(..., min_length=1)
    slug: str = Field(..., min_length=1)
    description: Optional[str] = None
    base_price: Decimal = Field(..., ge=Decimal("0.00"))
    condition: ItemCondition
    is_active: bool = True
    is_featured: bool = False
    created_at: datetime

class ProductVariantSchema(BaseDBModel):
    product_id: UUID
    sku: str = Field(..., min_length=1)
    attributes: Dict[str, Any] = Field(default_factory=dict)
    price: Decimal = Field(..., ge=Decimal("0.00"))
    stock_quantity: int = Field(..., ge=0)
    reserved_quantity: int = Field(..., ge=0)
    is_active: bool = True

class ProductImageSchema(BaseDBModel):
    product_id: UUID
    url: str = Field(...)
    alt_text: Optional[str] = None
    sort_order: int = 0
    is_primary: bool = False

class InventoryLogSchema(BaseDBModel):
    variant_id: UUID
    change_type: InventoryChangeType
    quantity_delta: int
    quantity_after: int = Field(..., ge=0)
    reference_id: Optional[str] = None
    note: Optional[str] = None
    created_at: datetime

class SellerListingSchema(BaseDBModel):
    seller_id: UUID
    variant_id: UUID
    asking_price: Decimal = Field(..., ge=Decimal("0.00"))
    quantity_available: int = Field(..., ge=0)
    condition: ItemCondition
    description: Optional[str] = None
    status: ListingStatus
    created_at: datetime
    expires_at: Optional[datetime] = None

class OrderSchema(BaseDBModel):
    buyer_id: UUID
    shipping_address_id: UUID
    order_number: str = Field(...)
    status: OrderStatus
    subtotal: Decimal = Field(..., ge=Decimal("0.00"))
    shipping_fee: Decimal = Field(..., ge=Decimal("0.00"))
    tax: Decimal = Field(..., ge=Decimal("0.00"))
    discount_amount: Decimal = Field(default=Decimal("0.00"), ge=Decimal("0.00"))
    total: Decimal = Field(..., ge=Decimal("0.00"))
    placed_at: datetime
    updated_at: datetime

class OrderItemSchema(BaseDBModel):
    order_id: UUID
    variant_id: UUID
    quantity: int = Field(..., gt=0)
    unit_price: Decimal = Field(..., ge=Decimal("0.00"))
    total_price: Decimal = Field(..., ge=Decimal("0.00"))
    snapshot: Dict[str, Any] = Field(default_factory=dict, description="Frozen snapshot of variant data at time of purchase")

class PaymentSchema(BaseDBModel):
    order_id: UUID
    method: PaymentMethod
    status: PaymentStatus
    amount: Decimal = Field(..., gt=Decimal("0.00"))
    gateway_ref: Optional[str] = None
    gateway_response: Optional[str] = None
    initiated_at: datetime
    completed_at: Optional[datetime] = None

class ReviewSchema(BaseDBModel):
    product_id: UUID
    user_id: UUID
    order_item_id: Optional[UUID] = None
    rating: int = Field(..., ge=1, le=5)
    title: str = Field(...)
    body: str = Field(...)
    is_verified_purchase: bool = False
    created_at: datetime

class WishlistSchema(BaseDBModel):
    user_id: UUID
    name: str = Field(...)
    is_public: bool = False
    created_at: datetime

class WishlistItemSchema(BaseDBModel):
    wishlist_id: UUID
    variant_id: UUID
    added_at: datetime

class CouponSchema(BaseDBModel):
    code: str = Field(..., min_length=3)
    discount_type: DiscountType
    discount_value: Decimal = Field(..., gt=Decimal("0.00"))
    min_order_value: Decimal = Field(default=Decimal("0.00"))
    max_uses: Optional[int] = None
    used_count: int = 0
    valid_from: datetime
    valid_until: Optional[datetime] = None
    is_active: bool = True

class CouponUsageSchema(BaseDBModel):
    coupon_id: UUID
    user_id: UUID
    order_id: UUID
    used_at: datetime

class NotificationSchema(BaseDBModel):
    user_id: UUID
    type: NotificationType
    title: str = Field(...)
    message: str = Field(...)
    metadata: Dict[str, Any] = Field(default_factory=dict)
    is_read: bool = False
    created_at: datetime