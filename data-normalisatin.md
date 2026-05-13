# Data normalisation requirements
## ProcureOS — Thomasnet MVP

---

## 1. Overview

The normalisation pipeline takes raw scraped HTML from Thomasnet and produces clean, typed, validated records ready for insertion into PostgreSQL. Every record must conform to the schemas defined below before it touches the database.

---

## 2. Source

| Property | Value |
|---|---|
| Source | Thomasnet (thomasnet.com) |
| Format | Raw HTML, parsed via BeautifulSoup / Playwright |
| Sync frequency | Every 24 hours (batch) |
| Output format | JSON → PostgreSQL upsert |

---

## 3. Entities

Two entities are produced by the pipeline: **Vendor** and **Product**. Every product must reference a valid vendor.

---

## 4. Vendor schema

### 4.1 Fields

| Field | Type | Required | Source | Notes |
|---|---|---|---|---|
| `vendor_id` | `VARCHAR` | Yes | Generated | Format: `THN_{incremental}` e.g. `THN_001` |
| `name` | `VARCHAR` | Yes | Scraped | Vendor's registered business name |
| `location_city` | `VARCHAR` | No | Scraped | City of primary operations |
| `location_state` | `VARCHAR` | No | Scraped | State / region code e.g. `IL` |
| `certifications` | `TEXT[]` | No | Scraped | Array e.g. `["ISO_9001", "RoHS"]`. Empty array if none |
| `reliability_score` | `DECIMAL(3,2)` | Yes | Derived | Range `0.00–1.00`. Default `0.75` for new vendors |
| `response_time_avg` | `DECIMAL(4,1)` | Yes | Derived | Days to PO confirmation. Default `3.0` for new vendors |
| `single_source_flag` | `BOOLEAN` | Yes | Derived | `true` if only vendor supplying a given SKU |
| `last_synced_at` | `TIMESTAMP` | Yes | Pipeline | UTC timestamp of last successful sync |

### 4.2 Validation rules

- `vendor_id` must be unique across all records
- `name` must not be null or empty string
- `reliability_score` must be between `0.00` and `1.00` inclusive
- `response_time_avg` must be greater than `0`
- `certifications` must be an array — never null, use `[]` if none
- `last_synced_at` must be a valid UTC ISO 8601 timestamp

### 4.3 Example record

```json
{
  "vendor_id": "THN_001",
  "name": "Acme Industrial Supply",
  "location_city": "Chicago",
  "location_state": "IL",
  "certifications": ["ISO_9001"],
  "reliability_score": 0.87,
  "response_time_avg": 2.4,
  "single_source_flag": false,
  "last_synced_at": "2026-05-13T08:00:00Z"
}
```

---

## 5. Product schema

### 5.1 Fields

| Field | Type | Required | Source | Notes |
|---|---|---|---|---|
| `product_id` | `VARCHAR` | Yes | Generated | Format: `{vendor_id}_{SKU}` e.g. `THN_001_BRG-6204` |
| `vendor_id` | `VARCHAR` | Yes | Scraped | Must reference a valid `vendor_id` |
| `sku` | `VARCHAR` | Yes | Scraped | Vendor's own part number |
| `name` | `VARCHAR` | Yes | Scraped | Product display name |
| `category` | `VARCHAR` | No | Scraped | e.g. `bearings`, `fasteners`, `pneumatics` |
| `unit_price` | `DECIMAL(10,2)` | Yes | Scraped | Price per single unit in USD |
| `moq` | `INTEGER` | Yes | Scraped | Minimum order quantity |
| `in_stock` | `BOOLEAN` | Yes | Scraped | Current availability at time of sync |
| `lead_time_days` | `INTEGER` | Yes | Scraped | Estimated days to delivery |
| `last_synced_at` | `TIMESTAMP` | Yes | Pipeline | UTC timestamp of last successful sync |

### 5.2 Validation rules

- `product_id` must be unique across all records
- `vendor_id` must exist in the vendors table
- `sku` must not be null or empty string
- `unit_price` must be greater than `0.00`
- `moq` must be a positive integer greater than `0`
- `in_stock` must be explicitly `true` or `false` — never null
- `lead_time_days` must be a positive integer greater than `0`
- `last_synced_at` must be a valid UTC ISO 8601 timestamp

### 5.3 Example record

```json
{
  "product_id": "THN_001_BRG-6204",
  "vendor_id": "THN_001",
  "sku": "BRG-6204",
  "name": "Deep groove ball bearing",
  "category": "bearings",
  "unit_price": 4.20,
  "moq": 50,
  "in_stock": true,
  "lead_time_days": 7,
  "last_synced_at": "2026-05-13T08:00:00Z"
}
```

---

## 6. Derived fields

Two vendor fields cannot be scraped directly and must be computed by the pipeline.

### 6.1 `reliability_score`

Computed from Thomasnet vendor rating data where available. Formula:

```
reliability_score = (positive_reviews / total_reviews) * timeliness_weight
```

Where `timeliness_weight` is derived from on-time delivery mentions in reviews if parseable. If no review data is available, default to `0.75`.

Update rule: recalculate after every completed PO in the system.

### 6.2 `response_time_avg`

Derived from Thomasnet's stated lead time ranges. Take the midpoint of any stated range:

```
"3–5 days"  →  4.0
"1 week"    →  7.0
"24 hours"  →  1.0
```

If no response time data is available, default to `3.0`.

Update rule: recalculate from actual PO confirmation timestamps after each transaction.

### 6.3 `single_source_flag`

Set at the product level after all vendors for a batch are ingested:

```
single_source_flag = true  if only one vendor carries a given SKU
single_source_flag = false if two or more vendors carry the same SKU
```

This flag is set vendor-wide — if a vendor is the sole source for any of their products, the flag is `true`.

---

## 7. Null handling

The pipeline must never drop a record due to a missing non-required field. Rules:

| Scenario | Behaviour |
|---|---|
| Non-required field missing from scrape | Set to `null` in DB |
| Required field missing from scrape | Log warning, set safe default, do not skip record |
| Record fails validation entirely | Log error, quarantine to `failed_records` table, do not insert |

---

## 8. Pipeline steps

```
1. Scrape       Raw HTML fetched from Thomasnet via Playwright
2. Parse        BeautifulSoup extracts raw field values into dict
3. Map          Rename raw keys to schema field names
4. Cast         Convert all values to correct types (DECIMAL, BOOLEAN, INTEGER)
5. Validate     Check required fields, ranges, and referential integrity
6. Enrich       Compute reliability_score, response_time_avg, single_source_flag
7. Output       Serialise to JSON
8. Upsert       INSERT ... ON CONFLICT DO UPDATE into PostgreSQL
```

---

## 9. Upsert behaviour

On conflict (same `vendor_id` or `product_id`), update all fields except the ID. Do not create duplicate records.

```sql
INSERT INTO vendors (...)
VALUES (...)
ON CONFLICT (vendor_id)
DO UPDATE SET
  name = EXCLUDED.name,
  reliability_score = EXCLUDED.reliability_score,
  last_synced_at = EXCLUDED.last_synced_at;
```

---

## 10. Out of scope for MVP

The following are explicitly deferred post-MVP:

- Multi-sector schema variants
- Price history tracking over time
- Competitor vendor cross-referencing
- Real-time webhook updates from Thomasnet
- Confidence scores on derived fields
