-- ============================================================
-- ProcureOS Seller-Side MCP Database
-- Single-vendor catalog with buyer authorization layer
-- ============================================================

-- Extensions
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- ============================================================
-- 1. BRANDS — real manufacturers whose products we sell
-- ============================================================
CREATE TABLE brands (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(100) NOT NULL UNIQUE,
    country     VARCHAR(60)  NOT NULL,
    website     VARCHAR(255),
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);
COMMENT ON TABLE brands IS 'Consumer electronics manufacturers whose products we distribute.';

-- ============================================================
-- 2. CATEGORIES
-- ============================================================
CREATE TABLE categories (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);
COMMENT ON TABLE categories IS 'Product categories in our catalog.';

-- ============================================================
-- 3. PRODUCT_CATALOG — our inventory with real products
-- ============================================================
CREATE TABLE product_catalog (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sku             VARCHAR(40)    NOT NULL UNIQUE,
    name            VARCHAR(255)   NOT NULL,
    brand_id        UUID           NOT NULL REFERENCES brands(id),
    category_id     UUID           NOT NULL REFERENCES categories(id),
    unit_price      NUMERIC(12,2)  NOT NULL CHECK (unit_price > 0),
    stock_quantity  INTEGER        NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    moq             INTEGER        NOT NULL DEFAULT 1 CHECK (moq >= 1),
    specs           JSONB          NOT NULL DEFAULT '{}',
    is_active       BOOLEAN        NOT NULL DEFAULT true,
    created_at      TIMESTAMPTZ    NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ    NOT NULL DEFAULT now()
);
COMMENT ON TABLE  product_catalog IS 'Our product catalog — every item we sell, with pricing and stock.';
COMMENT ON COLUMN product_catalog.moq IS 'Minimum order quantity per line item.';
COMMENT ON COLUMN product_catalog.specs IS 'Technical specifications as JSON (storage, RAM, screen size, etc.).';

CREATE INDEX idx_products_brand    ON product_catalog(brand_id);
CREATE INDEX idx_products_category ON product_catalog(category_id);
CREATE INDEX idx_products_name_trgm ON product_catalog USING gin (name gin_trgm_ops);
CREATE INDEX idx_products_active   ON product_catalog(is_active) WHERE is_active = true;

-- ============================================================
-- 4. BUYERS — authorized companies that can purchase from us
-- ============================================================
CREATE TABLE buyers (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_name        VARCHAR(200)   NOT NULL UNIQUE,
    industry            VARCHAR(100),
    billing_address     TEXT,
    tax_id              VARCHAR(50),
    status              VARCHAR(20)    NOT NULL DEFAULT 'pending'
                        CHECK (status IN ('active','suspended','pending','revoked')),
    credit_limit        NUMERIC(14,2)  NOT NULL DEFAULT 0 CHECK (credit_limit >= 0),
    net_payment_days    INTEGER        NOT NULL DEFAULT 30 CHECK (net_payment_days >= 0),
    allowed_categories  UUID[]         DEFAULT '{}',
    created_at          TIMESTAMPTZ    NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ    NOT NULL DEFAULT now()
);
COMMENT ON TABLE  buyers IS 'Companies authorized to purchase through our MCP. Status must be active to place orders.';
COMMENT ON COLUMN buyers.credit_limit IS 'Maximum outstanding order value allowed for this buyer.';
COMMENT ON COLUMN buyers.allowed_categories IS 'If non-empty, buyer can only order products from these category IDs. Empty means all categories allowed.';
COMMENT ON COLUMN buyers.net_payment_days IS 'Payment terms — number of days after invoice.';

-- ============================================================
-- 5. BUYER_CONTACTS — people at buyer companies
-- ============================================================
CREATE TABLE buyer_contacts (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    buyer_id    UUID         NOT NULL REFERENCES buyers(id) ON DELETE CASCADE,
    full_name   VARCHAR(150) NOT NULL,
    email       VARCHAR(255) NOT NULL UNIQUE,
    role        VARCHAR(30)  NOT NULL DEFAULT 'buyer'
                CHECK (role IN ('admin','buyer','viewer')),
    is_active   BOOLEAN      NOT NULL DEFAULT true,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);
COMMENT ON TABLE  buyer_contacts IS 'Individual contacts at buyer companies. Role controls what they can do via MCP.';
COMMENT ON COLUMN buyer_contacts.role IS 'admin = manage contacts + place orders, buyer = place orders, viewer = read-only catalog access.';

CREATE INDEX idx_contacts_buyer ON buyer_contacts(buyer_id);

-- ============================================================
-- 6. API_KEYS — MCP authorization tokens
-- ============================================================
CREATE TABLE api_keys (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contact_id      UUID         NOT NULL REFERENCES buyer_contacts(id) ON DELETE CASCADE,
    key_hash        VARCHAR(128) NOT NULL UNIQUE,
    key_prefix      VARCHAR(12)  NOT NULL,
    label           VARCHAR(100),
    scopes          TEXT[]       NOT NULL DEFAULT '{catalog:read}',
    is_active       BOOLEAN      NOT NULL DEFAULT true,
    expires_at      TIMESTAMPTZ,
    last_used_at    TIMESTAMPTZ,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT now()
);
COMMENT ON TABLE  api_keys IS 'Hashed API keys for MCP authentication. Each key is tied to a buyer_contact.';
COMMENT ON COLUMN api_keys.key_hash IS 'SHA-256 hash of the raw API key. Raw key is shown once at creation.';
COMMENT ON COLUMN api_keys.key_prefix IS 'First 8 chars of the raw key, for identification in logs.';
COMMENT ON COLUMN api_keys.scopes IS 'Permissions: catalog:read, catalog:search, orders:create, orders:read, orders:cancel.';

CREATE INDEX idx_apikeys_contact ON api_keys(contact_id);

-- ============================================================
-- 7. ORDERS — purchase orders placed by buyers
-- ============================================================
CREATE TABLE orders (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number    VARCHAR(30)    NOT NULL UNIQUE,
    buyer_id        UUID           NOT NULL REFERENCES buyers(id),
    contact_id      UUID           NOT NULL REFERENCES buyer_contacts(id),
    status          VARCHAR(20)    NOT NULL DEFAULT 'pending'
                    CHECK (status IN ('pending','confirmed','processing','shipped','delivered','cancelled')),
    total_amount    NUMERIC(14,2)  NOT NULL DEFAULT 0 CHECK (total_amount >= 0),
    notes           TEXT,
    shipping_address TEXT,
    created_at      TIMESTAMPTZ    NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ    NOT NULL DEFAULT now()
);
COMMENT ON TABLE orders IS 'Purchase orders placed by authorized buyers through MCP.';

CREATE INDEX idx_orders_buyer   ON orders(buyer_id);
CREATE INDEX idx_orders_contact ON orders(contact_id);
CREATE INDEX idx_orders_status  ON orders(status);

-- ============================================================
-- 8. ORDER_ITEMS — line items in each order
-- ============================================================
CREATE TABLE order_items (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id    UUID          NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id  UUID          NOT NULL REFERENCES product_catalog(id),
    quantity    INTEGER       NOT NULL CHECK (quantity > 0),
    unit_price  NUMERIC(12,2) NOT NULL CHECK (unit_price > 0),
    line_total  NUMERIC(14,2) NOT NULL GENERATED ALWAYS AS (quantity * unit_price) STORED,
    created_at  TIMESTAMPTZ   NOT NULL DEFAULT now()
);
COMMENT ON TABLE order_items IS 'Individual line items within an order. line_total is auto-computed.';

CREATE INDEX idx_order_items_order   ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);

-- ============================================================
-- 9. AUDIT_LOG — compliance trail for all MCP actions
-- ============================================================
CREATE TABLE audit_log (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    contact_id  UUID         REFERENCES buyer_contacts(id),
    buyer_id    UUID         REFERENCES buyers(id),
    action      VARCHAR(50)  NOT NULL,
    resource    VARCHAR(50)  NOT NULL,
    resource_id UUID,
    details     JSONB        DEFAULT '{}',
    ip_address  INET,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);
COMMENT ON TABLE  audit_log IS 'Immutable audit trail of all MCP actions for compliance and debugging.';
COMMENT ON COLUMN audit_log.action IS 'e.g. catalog:search, order:create, order:cancel, auth:login, auth:denied.';

CREATE INDEX idx_audit_contact ON audit_log(contact_id);
CREATE INDEX idx_audit_buyer   ON audit_log(buyer_id);
CREATE INDEX idx_audit_action  ON audit_log(action);
CREATE INDEX idx_audit_created ON audit_log(created_at);

