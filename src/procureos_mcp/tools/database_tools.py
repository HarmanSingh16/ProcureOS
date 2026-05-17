"""MCP database tool registration for ProcureOS B2B procurement."""

import json

from procureos_mcp.db import queries
from procureos_mcp.db import schema
from procureos_mcp.utils.json_helpers import to_json


def register_database_tools(mcp) -> None:
    """Register all database-related MCP tools on the given server instance."""

    @mcp.tool()
    def list_database_tables() -> str:
        """List all public database tables in the ProcureOS procurement database.

        Returns the table names for organizations, users, categories, products,
        vendors, vendor_products, purchase_orders, po_line_items, and review_queue.
        """
        try:
            tables = schema.list_tables()
            return to_json({"status": "success", "data": tables})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def describe_database_table(table_name: str) -> str:
        """Describe the columns and metadata of a specific database table.

        Returns the table comment (purpose description) along with detailed
        column information including data types, nullability, defaults,
        comments, CHECK constraints, and foreign key references.
        """
        try:
            table_comment = schema.get_table_comment(table_name)
            columns = schema.describe_table(table_name)
            return to_json({
                "status": "success",
                "data": {
                    "table_comment": table_comment,
                    "columns": columns,
                },
            })
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def search_vendors(
        query: str,
        location_state: str = None,
        certifications: str = None,
        min_reliability: float = None,
        limit: int = 10,
    ) -> str:
        """Search for active vendors that carry products matching a keyword query.

        Optionally filter by US state, required certifications (comma-separated,
        e.g. 'ISO9001,EPEAT'), and minimum reliability score (0.0 to 1.0).
        Returns vendor details with a count of matched products.
        """
        try:
            cert_list = None
            if certifications:
                cert_list = [c.strip() for c in certifications.split(",") if c.strip()]

            results = queries.search_vendors(
                query=query,
                location_state=location_state,
                certifications=cert_list,
                min_reliability=min_reliability,
                limit=limit,
            )

            if not results:
                return to_json({"status": "not_found", "message": "No vendors matched the search criteria."})
            return to_json({"status": "success", "data": results})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def get_inventory(vendor_id: str, sku: str) -> str:
        """Check a specific vendor's inventory for a product by SKU.

        Returns stock availability, quantity on hand, lead time, minimum order
        quantity, and current unit price. Returns not_found if the vendor does
        not carry the SKU.
        """
        try:
            result = queries.get_inventory(vendor_id=vendor_id, sku=sku)
            if result is None:
                return to_json({
                    "status": "not_found",
                    "message": f"Vendor {vendor_id} does not carry SKU {sku}.",
                })
            return to_json({"status": "success", "data": result})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def get_quote(vendor_id: str, sku: str, quantity: int) -> str:
        """Get a price quote from a vendor for a specific quantity of a product.

        Calculates the total price based on the vendor's unit price and the
        requested quantity. Returns an error if the quantity is below the
        vendor's minimum order quantity (MOQ).
        """
        try:
            result = queries.get_quote(vendor_id=vendor_id, sku=sku, quantity=quantity)
            if result is None:
                return to_json({
                    "status": "not_found",
                    "message": f"Vendor {vendor_id} does not carry SKU {sku}.",
                })
            return to_json({"status": "success", "data": result})
        except ValueError as exc:
            return to_json({"status": "error", "error": str(exc)})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def compare_vendors(sku: str, quantity: int, rank_by: str = "price") -> str:
        """Compare all active vendors carrying a specific SKU.

        Ranks vendors by 'price' (lowest first), 'lead_time' (fastest first),
        or 'reliability' (highest score first). Shows unit price, total price,
        MOQ, lead time, and stock availability for each vendor.
        """
        try:
            results = queries.compare_vendors(sku=sku, quantity=quantity, rank_by=rank_by)
            if not results:
                return to_json({"status": "not_found", "message": f"No vendors found carrying SKU {sku}."})
            return to_json({"status": "success", "data": results})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def create_purchase_order(
        buyer_id: str,
        vendor_id: str,
        items: str,
        required_by_date: str = None,
        notes: str = None,
    ) -> str:
        """Create a new purchase order with line items.

        The 'items' parameter is a JSON string containing a list of objects,
        each with 'product_id' (UUID string) and 'quantity' (int). Example:
        '[{"product_id": "abc-123", "quantity": 10}]'

        Orders totaling >= $5,000 are automatically flagged for review.
        """
        try:
            parsed_items = json.loads(items)
            result = queries.create_purchase_order(
                buyer_id=buyer_id,
                vendor_id=vendor_id,
                items=parsed_items,
                required_by_date=required_by_date,
                notes=notes,
            )
            return to_json({"status": "success", "data": result})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def get_po_status(po_id: str) -> str:
        """Check the status of a purchase order by its UUID.

        Returns full PO details including status, total amount, vendor name,
        buyer name, approval status, and timestamps. Returns not_found if the
        PO ID does not exist.
        """
        try:
            result = queries.get_po_status(po_id=po_id)
            if result is None:
                return to_json({
                    "status": "not_found",
                    "message": f"Purchase order {po_id} not found.",
                })
            return to_json({"status": "success", "data": result})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})

    @mcp.tool()
    def flag_for_review(po_id: str, reason: str, urgency: str) -> str:
        """Flag a purchase order for manual review.

        Creates a review queue entry and updates the PO status to
        'flagged_for_review'. Urgency must be 'low', 'medium', or 'high'.
        """
        try:
            result = queries.create_review(po_id=po_id, reason=reason, urgency=urgency)
            return to_json({"status": "success", "data": result})
        except Exception as exc:
            return to_json({"status": "error", "error": str(exc)})
