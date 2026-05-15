"""MCP database tool registration."""

import random
import uuid
from datetime import datetime, timezone
from decimal import Decimal
from typing import List, Optional

from pydantic import BaseModel, Field, EmailStr

import schemas
from procureos_mcp.db.queries import (
    create_order,
    create_order_items,
    get_order_by_number,
    get_product_by_id,
    get_user_by_email,
    search_products,
)
from procureos_mcp.db.schema import describe_table, list_tables
from procureos_mcp.utils.json_helpers import to_json


class SourcingQuery(BaseModel):
    query_terms: str = Field(
        ..., description="Keywords to search in product name or description."
    )
    max_unit_price: Optional[float] = Field(
        default=None, description="Maximum price per unit."
    )
    limit: int = Field(default=10, ge=1, le=50, description="Maximum number of products to return.")


class PurchaseItem(BaseModel):
    product_id: uuid.UUID = Field(..., description="The UUID of the product to buy.")
    quantity: int = Field(..., gt=0, description="Number of units to purchase.")


class DraftPOQuery(BaseModel):
    buyer_email: EmailStr = Field(..., description="Email of the procurement officer.")
    items: List[PurchaseItem] = Field(..., description="List of items and quantities.")


class OrderStatusQuery(BaseModel):
    order_number: str = Field(..., description="The ORD-XXXXXX number to check.")


def register_database_tools(mcp) -> None:
    @mcp.tool()
    def list_database_tables() -> str:
        """List public database tables visible to the MCP server."""
        try:
            return to_json({"status": "success", "data": list_tables()})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def describe_database_table(table_name: str) -> str:
        """Describe columns for a public database table."""
        try:
            return to_json({"status": "success", "data": describe_table(table_name)})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def search_supplier_catalog(query: SourcingQuery) -> str:
        """Search the B2B catalog for hardware and equipment."""
        try:
            raw_results = search_products(
                query_terms=query.query_terms,
                max_unit_price=query.max_unit_price,
                limit=query.limit,
            )

            validated_products = []
            for row in raw_results:
                clean_product = schemas.ProductSchema(**row).model_dump(mode="json")
                validated_products.append(clean_product)

            if not validated_products:
                return to_json(
                    {"status": "not_found", "message": "No hardware matched."}
                )
            return to_json({"status": "success", "data": validated_products})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def draft_purchase_order(query: DraftPOQuery) -> str:
        """Generates a formal B2B Purchase Order. Automatically calculates totals."""
        try:
            user_row = get_user_by_email(str(query.buyer_email))
            if not user_row:
                return to_json({"status": "error", "error": "Procurement officer email not found."})

            user = schemas.UserSchema(**user_row)

            total_amount = Decimal("0.00")
            valid_items = []

            for item in query.items:
                prod_row = get_product_by_id(str(item.product_id))
                if not prod_row:
                    return to_json({"status": "error", "error": f"Product {item.product_id} is invalid."})

                prod = schemas.ProductSchema(**prod_row)
                total_amount += prod.price * item.quantity

                valid_items.append(
                    {
                        "product_id": prod.id,
                        "quantity": item.quantity,
                        "unit_price": prod.price,
                    }
                )

            new_order = schemas.OrderSchema(
                id=uuid.uuid4(),
                user_id=user.id,
                order_number=f"ORD-{random.randint(100000, 999999)}",
                status="PENDING",
                total=total_amount,
                placed_at=datetime.now(timezone.utc),
            )

            create_order(new_order.model_dump())

            order_items = []
            for item in valid_items:
                new_item = schemas.OrderItemSchema(
                    id=uuid.uuid4(),
                    order_id=new_order.id,
                    product_id=item["product_id"],
                    quantity=item["quantity"],
                    unit_price=item["unit_price"],
                )
                order_items.append(new_item.model_dump())

            create_order_items(order_items)

            return to_json(
                {
                    "status": "success",
                    "message": "Purchase Order Drafted.",
                    "order_details": new_order.model_dump(mode="json"),
                }
            )
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def check_po_status(query: OrderStatusQuery) -> str:
        """Check the status of a purchase order."""
        try:
            row = get_order_by_number(query.order_number)
            if not row:
                return to_json({"status": "not_found", "message": "Purchase order not found."})

            clean_order = schemas.OrderSchema(**row).model_dump(mode="json")
            return to_json({"status": "success", "data": clean_order})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})
