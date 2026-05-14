-- ============================================================
-- ProcureOS — FINAL COMPREHENSIVE SEED SCRIPT (60 Entries)
-- ============================================================

-- 1. CLEAN SLATE
TRUNCATE TABLE 
    coupon_usages, wishlist_items, order_items, inventory_logs, 
    reviews, notifications, payments, orders, seller_listings, 
    wishlists, product_images, product_variants, products, 
    categories, brands, addresses, coupons, users 
RESTART IDENTITY CASCADE;

-- 2. USERS (30 Buyers, 30 Sellers)
INSERT INTO users (id, first_name, last_name, email, password_hash, phone, role, is_verified)
SELECT 
    uuid_generate_v4(), 
    CASE WHEN i <= 30 THEN 'Buyer_Mgr_' ELSE 'Vendor_Rep_' END || i,
    'Industrial_User',
    'user' || i || '@procure-hub.com',
    '$2b$12$samplehash',
    '+1-800-555-' || LPAD(i::text, 4, '0'),
    CASE WHEN i <= 30 THEN 'buyer' ELSE 'seller' END,
    TRUE
FROM generate_series(1, 60) s(i);

-- 3. ADDRESSES
INSERT INTO addresses (id, user_id, label, street_line1, city, state, postal_code, country, is_default)
SELECT 
    uuid_generate_v4(),
    u.id,
    'Facility A',
    (200 + i) || ' Industrial Parkway',
    'Tech City',
    'TX',
    '77001',
    'USA',
    TRUE
FROM (SELECT id, row_number() over() as i FROM users) u;

-- 4. BRANDS
INSERT INTO brands (id, name, description)
SELECT uuid_generate_v4(), name || ' ' || i, 'Global industrial provider.'
FROM (VALUES ('Siemens'), ('ABB'), ('Rockwell'), ('Schneider'), ('Honeywell'), ('Keyence')) AS t(name), generate_series(1, 10) i;

-- 5. CATEGORIES
INSERT INTO categories (id, name, slug, description)
SELECT uuid_generate_v4(), name || ' ' || i, lower(replace(name, ' ', '-')) || '-' || i, 'Industrial equipment.'
FROM (VALUES ('PLC'), ('Sensor'), ('Valve'), ('Motor'), ('Relay'), ('Panel')) AS t(name), generate_series(1, 10) i;

-- 6. PRODUCTS
INSERT INTO products (id, brand_id, category_id, name, slug, description, base_price)
SELECT 
    uuid_generate_v4(),
    (SELECT id FROM brands OFFSET (i % 60) LIMIT 1),
    (SELECT id FROM categories OFFSET (i % 60) LIMIT 1),
    'Industrial Part #' || i,
    'part-id-' || i,
    'Reliable component for high-performance automation.',
    (random() * 3000 + 150)::numeric(10,2)
FROM generate_series(1, 60) s(i);

-- 7. PRODUCT VARIANTS
INSERT INTO product_variants (id, product_id, sku, price, stock_quantity)
SELECT uuid_generate_v4(), id, 'SKU-PRO-' || i, base_price + 25, 1000
FROM (SELECT id, base_price, row_number() over() as i FROM products) p;

-- 8. ORDERS (Fix: Financials + Order Number)
INSERT INTO orders (id, buyer_id, shipping_address_id, order_number, status, subtotal, shipping_fee, tax, discount_amount, total)
SELECT 
    uuid_generate_v4(),
    (SELECT id FROM users WHERE role = 'buyer' ORDER BY random() LIMIT 1),
    (SELECT id FROM addresses ORDER BY random() LIMIT 1),
    'ORD-IND-' || LPAD(i::text, 6, '0'),
    'pending',
    1500.00, 50.00, 120.00, 0.00, 1670.00
FROM generate_series(1, 60) s(i);

-- 9. PAYMENTS (Fix: gateway_response as TEXT)
INSERT INTO payments (id, order_id, method, status, amount, gateway_ref, gateway_response)
SELECT 
    uuid_generate_v4(), id, 'WIRE_TRANSFER', 'completed', 1670.00, 'TXN-' || i, 'Verified by B2B Gateway'
FROM (SELECT id, row_number() over() as i FROM orders) o;

-- 10. SELLER LISTINGS
INSERT INTO seller_listings (id, seller_id, variant_id, asking_price, quantity_available, status)
SELECT 
    uuid_generate_v4(),
    (SELECT id FROM users WHERE role = 'seller' ORDER BY random() LIMIT 1),
    id, price, stock_quantity, 'active'
FROM product_variants;

-- 11. REVIEWS
INSERT INTO reviews (id, product_id, user_id, rating, title, body)
SELECT 
    uuid_generate_v4(), id, (SELECT id FROM users WHERE role = 'buyer' LIMIT 1), 5, 'Highly Recommend', 'Component works perfectly in our lab.'
FROM products;

-- 12. COUPONS (Fix: Added valid_from AND valid_until)
INSERT INTO coupons (id, code, discount_type, discount_value, min_order_value, valid_from, valid_until, is_active)
SELECT 
    uuid_generate_v4(), 
    'B2B_SAVE_' || i, 
    'percentage', 
    15, 
    2000, 
    CURRENT_TIMESTAMP, 
    CURRENT_TIMESTAMP + INTERVAL '1 year', 
    TRUE
FROM generate_series(1, 60) s(i);

-- 13. NOTIFICATIONS
INSERT INTO notifications (id, user_id, type, title, message)
SELECT uuid_generate_v4(), id, 'LOGISTICS', 'Order Shipped', 'Your parts are on the way.' FROM users;

-- 14. WISHLISTS
INSERT INTO wishlists (id, user_id, name)
SELECT uuid_generate_v4(), id, 'Q3 Expansion Plan' FROM users WHERE role = 'buyer' LIMIT 60;

-- 15. WISHLIST_ITEMS (Fix: 1-to-1 Mapping to prevent duplicates)
INSERT INTO wishlist_items (wishlist_id, variant_id)
SELECT w.id, v.id
FROM (SELECT id, row_number() over() as rn FROM wishlists) w
JOIN (SELECT id, row_number() over() as rn FROM product_variants) v ON w.rn = v.rn;