-- =============================================================================
-- ProcureOS – B2B Consumer Electronics Procurement Database
-- DDL / Schema creation script
-- =============================================================================

-- Drop all existing tables in reverse-dependency order
DROP TABLE IF EXISTS review_queue    CASCADE;
DROP TABLE IF EXISTS po_line_items   CASCADE;
DROP TABLE IF EXISTS purchase_orders CASCADE;
DROP TABLE IF EXISTS vendor_products CASCADE;
DROP TABLE IF EXISTS vendors         CASCADE;
DROP TABLE IF EXISTS product_catalog CASCADE;
DROP TABLE IF EXISTS categories      CASCADE;
DROP TABLE IF EXISTS users           CASCADE;
DROP TABLE IF EXISTS organizations   CASCADE;

-- Required extensions
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- =============================================================================
-- 1. organizations
-- =============================================================================
CREATE TABLE organizations (
    id         UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    name       VARCHAR(255)  NOT NULL,
    domain     VARCHAR(255)  UNIQUE NOT NULL,
    industry   VARCHAR(100)  NOT NULL,
    created_at TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE  organizations          IS 'B2B tenant organization. All users and vendors belong to exactly one organization.';
COMMENT ON COLUMN organizations.name     IS 'Legal company name.';
COMMENT ON COLUMN organizations.domain   IS 'Primary email domain used to auto-associate users, e.g. techmart-global.com.';
COMMENT ON COLUMN organizations.industry IS 'Industry vertical: Consumer Electronics, IT & Enterprise, Retail Electronics, etc.';

-- =============================================================================
-- 2. users
-- =============================================================================
CREATE TABLE users (
    id         UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id     UUID          NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    first_name VARCHAR(100)  NOT NULL,
    last_name  VARCHAR(100)  NOT NULL,
    email      VARCHAR(255)  UNIQUE NOT NULL,
    role       VARCHAR(50)   NOT NULL CHECK (role IN ('admin', 'buyer', 'approver', 'viewer')),
    is_active  BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_users_org_id ON users(org_id);
CREATE INDEX idx_users_email  ON users(email);

COMMENT ON TABLE  users           IS 'Procurement platform users. Each user belongs to one organization and has a role determining their permissions.';
COMMENT ON COLUMN users.org_id    IS 'FK to organizations. Scopes all user actions to their tenant.';
COMMENT ON COLUMN users.role      IS 'Permission level: admin (full access), buyer (create POs), approver (review flagged POs), viewer (read-only).';
COMMENT ON COLUMN users.is_active IS 'Soft-delete flag. Inactive users cannot log in or be assigned POs.';

-- =============================================================================
-- 3. categories
-- =============================================================================
CREATE TABLE categories (
    id          UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(100)  NOT NULL,
    slug        VARCHAR(100)  UNIQUE NOT NULL,
    description TEXT
);

COMMENT ON TABLE  categories      IS 'Consumer electronics product categories for organizing the catalog. Used by AI agent to browse products by domain.';
COMMENT ON COLUMN categories.slug IS 'URL-safe unique identifier for the category, e.g. smartphones, laptops, televisions, tablets.';

-- =============================================================================
-- 4. product_catalog
-- =============================================================================
CREATE TABLE product_catalog (
    id              UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id     UUID          NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
    name            VARCHAR(255)  NOT NULL,
    sku             VARCHAR(100)  UNIQUE NOT NULL,
    description     TEXT,
    unit_of_measure VARCHAR(50)   NOT NULL DEFAULT 'each'
                        CHECK (unit_of_measure IN ('each', 'box', 'carton', 'pallet', 'pack'))
);

CREATE INDEX idx_product_catalog_category_id ON product_catalog(category_id);
CREATE INDEX idx_product_catalog_sku         ON product_catalog(sku);
CREATE INDEX idx_product_catalog_name_trgm   ON product_catalog USING gin (name gin_trgm_ops);

COMMENT ON TABLE  product_catalog                 IS 'Master product definitions independent of any vendor. Each product has a unique global SKU. Vendor-specific pricing and stock are in vendor_products.';
COMMENT ON COLUMN product_catalog.sku             IS 'Globally unique stock-keeping unit code, e.g. PHONE-SAM-S24U-256, LAPTOP-DELL-XPS15, TV-LG-OLED-65C4. Used as the primary lookup key by AI agent tools.';
COMMENT ON COLUMN product_catalog.unit_of_measure IS 'How this product is sold: each, box, carton, pallet, or pack.';

-- =============================================================================
-- 5. vendors
-- =============================================================================
CREATE TABLE vendors (
    id                     UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    org_id                 UUID          NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    name                   VARCHAR(255)  NOT NULL,
    contact_email          VARCHAR(255)  NOT NULL,
    city                   VARCHAR(100),
    state                  VARCHAR(50),
    country                VARCHAR(100)  NOT NULL DEFAULT 'US',
    certifications         JSONB         NOT NULL DEFAULT '[]'::jsonb,
    reliability_score      NUMERIC(3,2)  NOT NULL DEFAULT 0.00
                              CHECK (reliability_score >= 0 AND reliability_score <= 1),
    avg_response_time_hours INTEGER      NOT NULL DEFAULT 24,
    is_active              BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at             TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_vendors_org_id         ON vendors(org_id);
CREATE INDEX idx_vendors_state          ON vendors(state);
CREATE INDEX idx_vendors_reliability    ON vendors(reliability_score DESC);
CREATE INDEX idx_vendors_certifications ON vendors USING gin (certifications);

COMMENT ON TABLE  vendors                         IS 'Consumer electronics supplier companies (distributors, wholesalers). Each vendor belongs to one organization and has a reliability score based on historical performance.';
COMMENT ON COLUMN vendors.certifications          IS 'JSONB array of certification codes, e.g. ["ISO_9001", "AS9100", "IATF_16949"]. Filter with @> operator.';
COMMENT ON COLUMN vendors.reliability_score       IS 'Historical reliability from 0.00 (worst) to 1.00 (best). Based on on-time delivery and quality metrics.';
COMMENT ON COLUMN vendors.avg_response_time_hours IS 'Average hours the vendor takes to respond to quote requests.';
COMMENT ON COLUMN vendors.state                   IS 'US state code (e.g. IL, CA, TX). Used for location-based vendor filtering.';

-- =============================================================================
-- 6. vendor_products
-- =============================================================================
CREATE TABLE vendor_products (
    id             UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    vendor_id      UUID          NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,
    product_id     UUID          NOT NULL REFERENCES product_catalog(id) ON DELETE CASCADE,
    unit_price     NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
    moq            INTEGER       NOT NULL DEFAULT 1   CHECK (moq >= 1),
    lead_time_days INTEGER       NOT NULL DEFAULT 7   CHECK (lead_time_days >= 0),
    in_stock       BOOLEAN       NOT NULL DEFAULT TRUE,
    stock_quantity INTEGER       NOT NULL DEFAULT 0   CHECK (stock_quantity >= 0),
    last_synced_at TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    UNIQUE (vendor_id, product_id)
);

CREATE INDEX idx_vendor_products_product_id ON vendor_products(product_id);
CREATE INDEX idx_vendor_products_vendor_id  ON vendor_products(vendor_id);

COMMENT ON TABLE  vendor_products                IS 'Junction table: one row per vendor-product combination. Holds vendor-specific pricing, MOQ, lead time, and current stock. This is the core table for inventory and quote lookups.';
COMMENT ON COLUMN vendor_products.unit_price     IS 'Current price per unit from this vendor. Used by get_quote and compare_vendors tools.';
COMMENT ON COLUMN vendor_products.moq            IS 'Minimum order quantity. Orders below this amount are rejected.';
COMMENT ON COLUMN vendor_products.lead_time_days IS 'Estimated business days from order to delivery.';
COMMENT ON COLUMN vendor_products.last_synced_at IS 'When pricing/stock was last refreshed. Data older than 15 minutes may be considered stale.';

-- =============================================================================
-- 7. purchase_orders
-- =============================================================================
CREATE TABLE purchase_orders (
    id                UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    po_number         VARCHAR(50)   UNIQUE NOT NULL,
    buyer_id          UUID          NOT NULL REFERENCES users(id)   ON DELETE RESTRICT,
    vendor_id         UUID          NOT NULL REFERENCES vendors(id) ON DELETE RESTRICT,
    status            VARCHAR(30)   NOT NULL DEFAULT 'draft'
                          CHECK (status IN ('draft','pending','confirmed','flagged_for_review',
                                            'approved','rejected','cancelled','shipped','completed')),
    total_amount      NUMERIC(14,2) NOT NULL DEFAULT 0 CHECK (total_amount >= 0),
    required_by_date  DATE,
    approval_required BOOLEAN       NOT NULL DEFAULT FALSE,
    approval_reason   TEXT,
    approved_by       VARCHAR(255),
    notes             TEXT,
    created_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_purchase_orders_buyer_id  ON purchase_orders(buyer_id);
CREATE INDEX idx_purchase_orders_vendor_id ON purchase_orders(vendor_id);
CREATE INDEX idx_purchase_orders_status    ON purchase_orders(status);
CREATE INDEX idx_purchase_orders_po_number ON purchase_orders(po_number);

COMMENT ON TABLE  purchase_orders                   IS 'Purchase orders created by buyers. Status transitions: draft -> pending -> confirmed/flagged_for_review -> approved/rejected -> shipped -> completed. Orders >= 5000 are auto-flagged for human review.';
COMMENT ON COLUMN purchase_orders.po_number         IS 'Human-readable PO identifier, format: PO-YYYYMMDD-NNNNNN.';
COMMENT ON COLUMN purchase_orders.status            IS 'Current PO lifecycle state. Valid values: draft, pending, confirmed, flagged_for_review, approved, rejected, cancelled, shipped, completed.';
COMMENT ON COLUMN purchase_orders.approval_required IS 'TRUE if total_amount >= 5000. Triggers automatic escalation to review_queue.';
COMMENT ON COLUMN purchase_orders.approved_by       IS 'Email or name of the human approver who resolved the review. NULL if not yet reviewed.';

-- =============================================================================
-- 8. po_line_items
-- =============================================================================
CREATE TABLE po_line_items (
    id                UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
    po_id             UUID          NOT NULL REFERENCES purchase_orders(id) ON DELETE CASCADE,
    vendor_product_id UUID          NOT NULL REFERENCES vendor_products(id) ON DELETE RESTRICT,
    quantity          INTEGER       NOT NULL CHECK (quantity > 0),
    unit_price        NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
    line_total        NUMERIC(14,2) NOT NULL GENERATED ALWAYS AS (quantity * unit_price) STORED
);

CREATE INDEX idx_po_line_items_po_id ON po_line_items(po_id);

COMMENT ON TABLE  po_line_items            IS 'Individual line items within a purchase order. Each row is one product at a specific quantity and price snapshot.';
COMMENT ON COLUMN po_line_items.unit_price IS 'Price per unit at the time the PO was created. Snapshot -- does not change if vendor updates pricing later.';
COMMENT ON COLUMN po_line_items.line_total IS 'Auto-computed: quantity * unit_price. Generated column, do not insert directly.';

-- =============================================================================
-- 9. review_queue
-- =============================================================================
CREATE TABLE review_queue (
    id            UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    review_number VARCHAR(50)  UNIQUE NOT NULL,
    po_id         UUID         NOT NULL REFERENCES purchase_orders(id) ON DELETE CASCADE,
    assigned_to   UUID         REFERENCES users(id) ON DELETE SET NULL,
    reason        TEXT         NOT NULL,
    urgency       VARCHAR(10)  NOT NULL CHECK (urgency IN ('low', 'medium', 'high')),
    status        VARCHAR(30)  NOT NULL DEFAULT 'pending_review'
                      CHECK (status IN ('pending_review', 'under_review', 'approved', 'rejected')),
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    resolved_at   TIMESTAMPTZ
);

CREATE INDEX idx_review_queue_po_id  ON review_queue(po_id);
CREATE INDEX idx_review_queue_status ON review_queue(status);

COMMENT ON TABLE  review_queue               IS 'Human approval queue for flagged purchase orders. POs with total >= 5000 are auto-escalated here. Approvers resolve items by setting status to approved or rejected.';
COMMENT ON COLUMN review_queue.review_number IS 'Human-readable review identifier, format: REV-YYYYMMDD-NNNNNN.';
COMMENT ON COLUMN review_queue.urgency       IS 'Escalation priority: low (routine), medium (time-sensitive), high (blocking production).';
COMMENT ON COLUMN review_queue.assigned_to   IS 'UUID of the user (with role=approver) assigned to review this item. NULL if unassigned.';
COMMENT ON COLUMN review_queue.resolved_at   IS 'Timestamp when the review was completed. NULL while pending.';
