from schemas import OrderSchema
from pydantic import ValidationError

# A dictionary mimicking raw, messy order data
bad_order_data = {
    "id": "bad-uuid",
    "user_id": "not-a-uuid",
    "order_number": "",
    "status": "",
    "total": -1,
    "placed_at": "today"
}

print("Attempting to validate bad data...\n")

try:
    # The ** unpacks the dictionary into the Pydantic model
    order = OrderSchema(**bad_order_data)
    print("Success! Data is valid.")

except ValidationError as e:
    print("🚨 VALIDATION FAILED! Pydantic caught the errors:\n")
    # Pydantic generates a detailed, machine-readable JSON error report
    print(e.json(indent=2))