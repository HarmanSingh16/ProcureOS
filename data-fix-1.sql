-- ============================================================
-- ProcureOS: Integrated Schema & Seed Data Script
-- Includes:
-- 1. Core Schema Creation
-- 2. Schema Fixes (Data Type Changes & Column Cleanup)
-- 3. Comprehensive Industrial B2B Seed Data (60 Entries)
-- ============================================================

-- EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- 1. SCHEMA DEFINITION
-- ============================================================================

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(50) NOT NULL DEFAULT 'buyer',
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE addresses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    label VARCHAR(255),
    street_line1 VARCHAR(255) NOT NULL,
    street_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE
);

CREATE TABLE brands (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL UNIQUE,
    logo_url TEXT,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    parent_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    image_url TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
    brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE RESTRICT,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    base_price DECIMAL(12, 2) NOT NULL,
    condition VARCHAR(50) DEFAULT 'new',
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    sku VARCHAR(100) NOT NULL UNIQUE,
    attributes JSONB,
    price DECIMAL(12, 2) NOT NULL,
    stock_quantity INTEGER NOT NULL DEFAULT 0,
    reserved_quantity INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product_images (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    url TEXT NOT NULL,
    alt_text VARCHAR(255),
    sort_order INTEGER NOT NULL DEFAULT 0,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE inventory_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    change_type VARCHAR(50) NOT NULL,
    quantity_delta INTEGER NOT NULL,
    quantity_after INTEGER NOT NULL,
    reference_id VARCHAR(255),
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    buyer_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    shipping_address_id UUID NOT NULL REFERENCES addresses(id) ON DELETE RESTRICT,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    subtotal DECIMAL(12, 2) NOT NULL,
    shipping_fee DECIMAL(12, 2) DEFAULT 0,
    tax DECIMAL(12, 2) DEFAULT 0,
    discount_amount DECIMAL(12, 2) DEFAULT 0,
    total DECIMAL(12, 2) NOT NULL,
    placed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(12, 2) NOT NULL,
    total_price DECIMAL(12, 2) NOT NULL,
    snapshot JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE RESTRICT,
    method VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    amount DECIMAL(12, 2) NOT NULL,
    gateway_ref VARCHAR(255),
    gateway_response TEXT, -- Fixed as TEXT per Schema-Fix1
    initiated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP
);

CREATE TABLE seller_listings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    seller_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE RESTRICT,
    asking_price DECIMAL(12, 2) NOT NULL,
    quantity_available INTEGER NOT NULL,
    condition VARCHAR(50),
    description TEXT,
    status VARCHAR(50) NOT NULL DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP
);

CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    order_item_id UUID REFERENCES order_items(id) ON DELETE SET NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(255),
    body TEXT,
    is_verified_purchase BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE wishlists (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE wishlist_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    wishlist_id UUID NOT NULL REFERENCES wishlists(id) ON DELETE CASCADE,
    variant_id UUID NOT NULL REFERENCES product_variants(id) ON DELETE CASCADE,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(wishlist_id, variant_id)
);

CREATE TABLE coupons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(50) NOT NULL UNIQUE,
    discount_type VARCHAR(50) NOT NULL,
    discount_value DECIMAL(12, 2) NOT NULL,
    min_order_value DECIMAL(12, 2) DEFAULT 0,
    max_uses INTEGER,
    used_count INTEGER DEFAULT 0,
    valid_from TIMESTAMP NOT NULL,
    valid_until TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE coupon_usages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    coupon_id UUID NOT NULL REFERENCES coupons(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    metadata JSONB,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 2. SEED DATA (Industrial B2B Theme)
-- ============================================================================

-- 2.1 USERS (30 Buyers, 30 Sellers)
INSERT INTO users (id, first_name, last_name, email, password_hash, phone, role, is_verified)
SELECT 
    uuid_generate_v4(), 
    CASE WHEN i <= 30 THEN 'Buyer_Mgr_' ELSE 'Vendor_Rep_' END || i,
    'Industrial_User',
    'user' || i || '@procure-hub.io',
    '$2b$12$samplehash',
    '+1-800-555-' || LPAD(i::text, 4, '0'),
    CASE WHEN i <= 30 THEN 'buyer' ELSE 'seller' END,
    TRUE
FROM generate_series(1, 60) s(i);

-- 2.2 ADDRESSES
INSERT INTO addresses (id, user_id, label, street_line1, city, state, postal_code, country, is_default)
SELECT 
    uuid_generate_v4(),
    u.id,
    'HQ Warehouse',
    (200 + i) || ' Industrial Parkway',
    'Tech City',
    'TX',
    '77001',
    'USA',
    TRUE
FROM (SELECT id, row_number() over() as i FROM users) u;

-- 2.3 BRANDS
INSERT INTO brands (id, name, description)
SELECT uuid_generate_v4(), name || ' ' || i, 'Global industrial provider.'
FROM (VALUES ('Siemens'), ('ABB'), ('Rockwell'), ('Schneider'), ('Honeywell'), ('Keyence')) AS t(name), generate_series(1, 10) i;

-- 2.4 CATEGORIES
INSERT INTO categories (id, name, slug, description)
SELECT uuid_generate_v4(), name || ' ' || i, lower(replace(name, ' ', '-')) || '-' || i, 'Industrial equipment.'
FROM (VALUES ('PLC'), ('Sensor'), ('Valve'), ('Motor'), ('Relay'), ('Panel')) AS t(name), generate_series(1, 10) i;

-- 2.5 PRODUCTS
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

-- 2.6 PRODUCT VARIANTS
INSERT INTO product_variants (id, product_id, sku, price, stock_quantity)
SELECT uuid_generate_v4(), id, 'SKU-PRO-' || i, base_price + 25, 1000
FROM (SELECT id, base_price, row_number() over() as i FROM products) p;

-- 2.7 ORDERS
INSERT INTO orders (id, buyer_id, shipping_address_id, order_number, status, subtotal, shipping_fee, tax, discount_amount, total)
SELECT 
    uuid_generate_v4(),
    (SELECT id FROM users WHERE role = 'buyer' ORDER BY random() LIMIT 1),
    (SELECT id FROM addresses ORDER BY random() LIMIT 1),
    'ORD-IND-' || LPAD(i::text, 6, '0'),
    'pending',
    1500.00, 50.00, 120.00, 0.00, 1670.00
FROM generate_series(1, 60) s(i);

-- 2.8 ORDER ITEMS
INSERT INTO order_items (id, order_id, variant_id, quantity, unit_price, total_price)
SELECT 
    uuid_generate_v4(),
    ord.id,
    var.id,
    1,
    1500.00,
    1500.00
FROM (SELECT id, row_number() OVER (ORDER BY id) as rn FROM orders) ord
JOIN (SELECT id, row_number() OVER (ORDER BY id) as rn FROM product_variants) var ON ord.rn = var.rn;

-- 2.9 PAYMENTS
INSERT INTO payments (id, order_id, method, status, amount, gateway_ref, gateway_response)
SELECT 
    uuid_generate_v4(), id, 'WIRE_TRANSFER', 'completed', 1670.00, 'TXN-' || i, 'Verified by B2B Gateway'
FROM (SELECT id, row_number() over() as i FROM orders) o;

-- 2.10 SELLER LISTINGS
INSERT INTO seller_listings (id, seller_id, variant_id, asking_price, quantity_available, status)
SELECT 
    uuid_generate_v4(),
    (SELECT id FROM users WHERE role = 'seller' ORDER BY random() LIMIT 1),
    id, price, stock_quantity, 'active'
FROM product_variants;

-- 2.11 REVIEWS
INSERT INTO reviews (id, product_id, user_id, rating, title, body)
SELECT 
    uuid_generate_v4(), id, (SELECT id FROM users WHERE role = 'buyer' LIMIT 1), 5, 'Highly Recommend', 'Component works perfectly in our lab.'
FROM products;

-- 2.12 COUPONS
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

-- 2.13 NOTIFICATIONS
INSERT INTO notifications (id, user_id, type, title, message)
SELECT uuid_generate_v4(), id, 'LOGISTICS', 'Order Shipped', 'Your parts are on the way.' FROM users;

-- 2.14 WISHLISTS
INSERT INTO wishlists (id, user_id, name)
SELECT uuid_generate_v4(), id, 'Primary Project List' FROM users WHERE role = 'buyer' LIMIT 30
UNION ALL
SELECT uuid_generate_v4(), id, 'Secondary Procurement List' FROM users WHERE role = 'buyer' LIMIT 30;

-- 2.15 WISHLIST_ITEMS
INSERT INTO wishlist_items (wishlist_id, variant_id)
SELECT w.id, v.id
FROM (SELECT id, row_number() over() as rn FROM wishlists) w
JOIN (SELECT id, row_number() over() as rn FROM product_variants) v ON w.rn = v.rn;
