-- ============================================================
-- Fix 1: ADDRESSES — drop extra columns
-- ============================================================
ALTER TABLE addresses
    DROP COLUMN IF EXISTS created_at,
    DROP COLUMN IF EXISTS updated_at;

-- ============================================================
-- Fix 2: PAYMENTS — drop extra column + fix gateway_response type
-- ============================================================
ALTER TABLE payments
    DROP COLUMN IF EXISTS updated_at;

-- Change gateway_response from JSONB to TEXT (schema says "string")
ALTER TABLE payments
    ALTER COLUMN gateway_response TYPE TEXT
    USING gateway_response::TEXT;

-- ============================================================
-- Fix 3: SELLER_LISTINGS — drop extra column
-- ============================================================
ALTER TABLE seller_listings
    DROP COLUMN IF EXISTS updated_at;