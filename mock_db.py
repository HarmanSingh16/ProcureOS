# Simulating the output of: SELECT * FROM users;
mock_sql_users = [
    # 1. PERFECT RECORD
    {
        "id": "111e4567-e89b-12d3-a456-426614174000",
        "first_name": "Ava",
        "last_name": "Ng",
        "email": "ava.ng@example.com"
    },
    # 2. DIRTY RECORD (Should be quarantined)
    {
        "id": "not-a-real-uuid-1234",  # ERROR: Invalid UUID format
        "first_name": "",
        "last_name": "Kim",
        "email": "not-an-email"
    }
]

# Simulating the output of: SELECT * FROM products;
mock_sql_products = [
    # 1. PERFECT RECORD
    {
        "id": "123e4567-e89b-12d3-a456-426614174000",
        "name": "Sony Alpha A7 IV",
        "description": "Full-frame mirrorless interchangeable lens camera.",
        "price": 2499.00
    },
    # 2. DIRTY RECORD (Should be quarantined)
    {
        "id": "222e4567-e89b-12d3-a456-426614174000",
        "name": "",
        "description": None,
        "price": -50.00
    }
]

# Simulating the output of: SELECT * FROM orders;
mock_sql_orders = [
    # 1. PERFECT RECORD
    {
        "id": "333e4567-e89b-12d3-a456-426614174000",
        "user_id": "111e4567-e89b-12d3-a456-426614174000",
        "order_number": "ORD-1001",
        "status": "PENDING",
        "total": 2499.00,
        "placed_at": "2026-05-15T10:00:00Z"
    },
    # 2. DIRTY RECORD (Should be quarantined)
    {
        "id": "333e4567-e89b-12d3-a456-426614174001",
        "user_id": "not-a-real-uuid-0000",
        "order_number": "",
        "status": "",
        "total": -1,
        "placed_at": "not-a-date"
    }
]

# Simulating the output of: SELECT * FROM order_items;
mock_sql_order_items = [
    # 1. PERFECT RECORD
    {
        "id": "444e4567-e89b-12d3-a456-426614174000",
        "order_id": "333e4567-e89b-12d3-a456-426614174000",
        "product_id": "123e4567-e89b-12d3-a456-426614174000",
        "quantity": 1,
        "unit_price": 2499.00
    },
    # 2. DIRTY RECORD (Should be quarantined)
    {
        "id": "444e4567-e89b-12d3-a456-426614174001",
        "order_id": "333e4567-e89b-12d3-a456-426614174000",
        "product_id": "bad-uuid",
        "quantity": 0,
        "unit_price": -10
    }
]