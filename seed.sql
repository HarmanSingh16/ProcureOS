-- Seed data for ProcureOS demo schema
-- Requires PostgreSQL

-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Clean tables before reseeding
TRUNCATE TABLE order_items, orders, products, users RESTART IDENTITY CASCADE;

-- 1,000 users
INSERT INTO users (id, first_name, last_name, email)
SELECT
    gen_random_uuid(),
    format('First%04s', gs),
    format('Last%04s', gs),
    format('user%04s@example.com', gs)
FROM generate_series(1, 1000) AS gs;

-- 1,000 products (electronics)
INSERT INTO products (id, name, description, price)
SELECT
    gen_random_uuid(),
    format('%s %s',
        (ARRAY['Nova','Apex','Volt','Pulse','Orbit','Vertex','Helix','Nexus','Echo','Flux','Spark','Ion','Quantum','Zenith','Prism','Aurora','Summit','Vector','Vantage','Lumen'])[1 + (random() * 19)::int],
        (ARRAY['Laptop','Smartphone','Tablet','Smartwatch','Headphones','Earbuds','Bluetooth Speaker','Monitor','Keyboard','Mouse','Docking Station','Router','Webcam','External SSD','Power Bank','Projector','Camera','Drone','VR Headset','Gaming Console'])[1 + (random() * 19)::int]
    ),
    format('Electronics item with %s and %s.',
        (ARRAY['Wi-Fi 6','Bluetooth 5.3','USB-C','OLED display','120Hz refresh','active noise cancellation','fast charging','4K video','AI features','long battery life'])[1 + (random() * 9)::int],
        (ARRAY['compact design','durable build','energy efficiency','smart controls','multi-device support','low latency','cloud sync','voice assistant','advanced security','portable form factor'])[1 + (random() * 9)::int]
    ),
    round((random() * 1900 + 49)::numeric, 2)
FROM generate_series(1, 1000) AS gs;

-- 1,000 orders, each tied to a random user
INSERT INTO orders (id, user_id, order_number, status, total, placed_at)
SELECT
    gen_random_uuid(),
    (SELECT id FROM users ORDER BY random() LIMIT 1),
    format('ORD-%06s', gs),
    (ARRAY['PENDING','SHIPPED','COMPLETED'])[1 + (random() * 2)::int],
    round((random() * 5000 + 50)::numeric, 2),
    NOW() - (random() * INTERVAL '90 days')
FROM generate_series(1, 1000) AS gs;

-- 1,000 order items, each tied to a random order and product
INSERT INTO order_items (id, order_id, product_id, quantity, unit_price)
SELECT
    gen_random_uuid(),
    o.id,
    p.id,
    1 + (random() * 9)::int,
    round((random() * 500 + 5)::numeric, 2)
FROM generate_series(1, 1000) AS gs
CROSS JOIN LATERAL (SELECT id FROM orders ORDER BY random() LIMIT 1) AS o
CROSS JOIN LATERAL (SELECT id FROM products ORDER BY random() LIMIT 1) AS p;
