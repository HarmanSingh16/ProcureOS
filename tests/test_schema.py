import pytest

from pydantic import ValidationError
from procureos_mcp.schemas import OrderSchema


def test_order_schema_rejects_bad_data():
    bad_order_data = {
        "id": "bad-uuid",
        "user_id": "not-a-uuid",
        "order_number": "",
        "status": "",
        "total": -1,
        "placed_at": "today",
    }

    with pytest.raises(ValidationError):
        OrderSchema(**bad_order_data)