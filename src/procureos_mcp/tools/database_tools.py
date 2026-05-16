import random
import uuid
from datetime import datetime, timezone
from typing import List, Optional

from pydantic import BaseModel, Field, EmailStr

from procureos_mcp import schemas
from procureos_mcp.db.queries import (
	create_order,
	create_order_items,
	get_order_by_number,
	get_order_items_for_order,
	get_orders_by_status,
	get_orders_for_user,
	get_product_by_id,
	get_user_by_email,
	search_products,
)
from procureos_mcp.utils.json_helpers import to_json


class SourcingQuery(BaseModel):
	query_terms: str = Field(
		..., description="Keywords to search in product name or description."
	)
	max_unit_price: Optional[float] = Field(
		default=None, description="Maximum price per unit."
	)


class PurchaseItem(BaseModel):
	product_id: uuid.UUID = Field(..., description="The UUID of the product to buy.")
	quantity: int = Field(..., gt=0, description="Number of units to purchase.")


class DraftPOQuery(BaseModel):
	buyer_email: EmailStr = Field(..., description="Email of the procurement officer.")
	items: List[PurchaseItem] = Field(..., description="List of items and quantities.")


class OrderStatusQuery(BaseModel):
	order_number: str = Field(..., description="The ORD-XXXXXX number to check.")


class ProductLookupQuery(BaseModel):
	product_id: uuid.UUID = Field(..., description="The UUID of the product.")


class OrderStatusListQuery(BaseModel):
	status: str = Field(..., description="Order status like PENDING or SHIPPED.")


class BuyerOrdersQuery(BaseModel):
	buyer_email: EmailStr = Field(..., description="Email of the procurement officer.")


def register_database_tools(mcp):
	@mcp.tool()
	def search_supplier_catalog(query: SourcingQuery) -> str:
		"""Search the B2B catalog for hardware and equipment."""
		try:
			raw_results = search_products(
				query_terms=query.query_terms,
				max_unit_price=query.max_unit_price,
			)

			validated_products = []
			for row in raw_results:
				clean_product = schemas.ProductSchema(**row).model_dump(mode="json")
				validated_products.append(clean_product)

			if not validated_products:
				return to_json(
					{"status": "no_results", "message": "No hardware matched."}
				)
			return to_json({"status": "success", "data": validated_products})
		except Exception as exc:
			return to_json({"error": str(exc)})

	@mcp.tool()
	def draft_purchase_order(query: DraftPOQuery) -> str:
		"""Generates a formal B2B Purchase Order. Automatically calculates totals."""
		try:
			user_row = get_user_by_email(query.buyer_email)
			if not user_row:
				return to_json({"error": "Procurement officer email not found."})

			user = schemas.UserSchema(**user_row)

			total_amount = 0.0
			valid_items = []

			for item in query.items:
				prod_row = get_product_by_id(str(item.product_id))
				if not prod_row:
					return to_json({"error": f"Product {item.product_id} is invalid."})

				prod = schemas.ProductSchema(**prod_row)
				unit_price = float(prod.price)
				total_amount += unit_price * item.quantity

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
			return to_json({"error": str(exc)})

	@mcp.tool()
	def check_po_status(query: OrderStatusQuery) -> str:
		"""Check the status of a purchase order."""
		try:
			row = get_order_by_number(query.order_number)
			if not row:
				return to_json({"error": "Purchase order not found."})

			clean_order = schemas.OrderSchema(**row).model_dump(mode="json")
			return to_json({"status": "success", "data": clean_order})
		except Exception as exc:
			return to_json({"error": str(exc)})

	@mcp.tool()
	def get_product_details(query: ProductLookupQuery) -> str:
		"""Get a product record by ID."""
		try:
			row = get_product_by_id(str(query.product_id))
			if not row:
				return to_json({"error": "Product not found."})

			clean_product = schemas.ProductSchema(**row).model_dump(mode="json")
			return to_json({"status": "success", "data": clean_product})
		except Exception as exc:
			return to_json({"error": str(exc)})

	@mcp.tool()
	def list_purchase_orders_by_status(query: OrderStatusListQuery) -> str:
		"""List purchase orders by status."""
		try:
			rows = get_orders_by_status(query.status)
			orders = [schemas.OrderSchema(**row).model_dump(mode="json") for row in rows]

			if not orders:
				return to_json({"status": "no_results", "message": "No orders found."})
			return to_json({"status": "success", "data": orders})
		except Exception as exc:
			return to_json({"error": str(exc)})

	@mcp.tool()
	def list_purchase_orders_for_buyer(query: BuyerOrdersQuery) -> str:
		"""List purchase orders for a procurement officer."""
		try:
			user_row = get_user_by_email(query.buyer_email)
			if not user_row:
				return to_json({"error": "Procurement officer email not found."})

			user = schemas.UserSchema(**user_row)
			rows = get_orders_for_user(str(user.id))
			orders = [schemas.OrderSchema(**row).model_dump(mode="json") for row in rows]

			if not orders:
				return to_json({"status": "no_results", "message": "No orders found."})
			return to_json({"status": "success", "data": orders})
		except Exception as exc:
			return to_json({"error": str(exc)})

	@mcp.tool()
	def get_purchase_order_details(query: OrderStatusQuery) -> str:
		"""Fetch a purchase order with line items."""
		try:
			row = get_order_by_number(query.order_number)
			if not row:
				return to_json({"error": "Purchase order not found."})

			order = schemas.OrderSchema(**row).model_dump(mode="json")
			item_rows = get_order_items_for_order(str(order["id"]))
			items = []
			for item_row in item_rows:
				base_item = schemas.OrderItemSchema(**item_row).model_dump(mode="json")
				base_item["product_name"] = item_row.get("product_name")
				base_item["product_description"] = item_row.get("product_description")
				items.append(base_item)

			return to_json({"status": "success", "order": order, "items": items})
		except Exception as exc:
			return to_json({"error": str(exc)})
