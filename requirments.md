# Data Normalisation Requirements

## Electronics Marketplace Database Migration

---

## 1. Overview

The normalisation pipeline acts as an ETL (Extract, Transform, Load) bridge between a legacy/staging SQL database and the strict, production-ready PostgreSQL database. Every record must conform to the strict type requirements (UUIDs, Enums, JSON) defined below before insertion.

---

## 2. Source

| Property       | Value                                           |
| -------------- | ----------------------------------------------- |
| Source         | Staging SQL Database                            |
| Format         | SQL Rows (Dictionary representation via Python) |
| Sync frequency | Batch execution                                 |
| Output format  | PostgreSQL Upsert (`ON CONFLICT DO UPDATE`)     |

---

## 3. Global Validation Rules

Unlike web string parsing, this pipeline enforces strict structural integrity across 18 related tables.

* **Primary/Foreign Keys:** All `id` fields must strictly validate as 36-character UUIDv4 strings. Integers or malformed strings must trigger a quarantine.
* **Status/Condition Fields:** Must strictly map to predefined Enums (e.g., `NEW`, `USED`, `REFURBISHED`). Unrecognized strings must trigger a quarantine.
* **Financials:** All monetary values (`base_price`, `price`) must be parsed as `DECIMAL` types to prevent floating-point inaccuracies. Must be $\ge 0.00$.
* **Flexible Data (JSON):** Fields like `attributes` (in variants) or `metadata` (in notifications) must successfully parse as valid JSON objects (Python dictionaries).

---

## 4. Core Catalog Schemas (Phase 1 MVP)

While the database contains 18 tables, Phase 1 focuses on the core product catalog entities. Every product variant must reference a valid product, category, and brand.

### 4.1 `PRODUCTS` Table

| Field         | Type           | Required | Notes                                                  |
| ------------- | -------------- | -------- | ------------------------------------------------------ |
| `id`          | `UUID`         | Yes      | Primary Key                                            |
| `category_id` | `UUID`         | Yes      | Foreign Key to `CATEGORIES`                            |
| `brand_id`    | `UUID`         | Yes      | Foreign Key to `BRANDS`                                |
| `name`        | `VARCHAR`      | Yes      | Display name of the product                            |
| `slug`        | `VARCHAR`      | Yes      | Unique URL identifier (no spaces)                      |
| `description` | `TEXT`         | No       | HTML/Markdown description                              |
| `base_price`  | `DECIMAL(10,2)`| Yes      | Starting price. Must be $\ge 0.00$                     |
| `condition`   | `ENUM`         | Yes      | Allowed: `NEW`, `REFURBISHED`, `USED`                  |
| `is_active`   | `BOOLEAN`      | Yes      | Default: `true`                                        |
| `is_featured` | `BOOLEAN`      | Yes      | Default: `false`                                       |
| `created_at`  | `TIMESTAMP`    | Yes      | ISO 8601 UTC timestamp                                 |

### 4.2 `PRODUCT_VARIANTS` Table

| Field               | Type           | Required | Notes                                                  |
| ------------------- | -------------- | -------- | ------------------------------------------------------ |
| `id`                | `UUID`         | Yes      | Primary Key                                            |
| `product_id`        | `UUID`         | Yes      | Foreign Key to `PRODUCTS`                              |
| `sku`               | `VARCHAR`      | Yes      | Unique stock keeping unit                              |
| `attributes`        | `JSONB`        | No       | e.g., `{"color": "black", "storage": "256GB"}`         |
| `price`             | `DECIMAL(10,2)`| Yes      | Variant specific price. Must be $\ge 0.00$             |
| `stock_quantity`    | `INTEGER`      | Yes      | Total physical stock. Must be $\ge 0$                  |
| `reserved_quantity` | `INTEGER`      | Yes      | Stock held in active carts. Must be $\ge 0$            |
| `is_active`         | `BOOLEAN`      | Yes      | Default: `true`                                        |

---

## 5. Null Handling & Quarantine Protocol

The pipeline must not halt execution due to individual bad records.

| Scenario                               | Behaviour                                                      |
| -------------------------------------- | -------------------------------------------------------------- |
| Non-required field is `NULL`           | Validate as `null`/`None` and pass to insertion                |
| Required field is `NULL`               | Log error, quarantine to `failed_records` dict, do not insert  |
| UUID is malformed                      | Log error, quarantine to `failed_records` dict, do not insert  |
| Value violates Enum/Range checks       | Log error, quarantine to `failed_records` dict, do not insert  |

---

## 6. Pipeline Execution Flow

```text
1. Extract      Query batch of rows from staging SQL database.
2. Load Schema  Map raw row dictionaries to corresponding Pydantic `BaseModel`.
3. Validate     Enforce UUID formatting, Enum constraints, decimal bounds.
4. Quarantine   Catch `ValidationError`. Append row and error trace to failed list.
5. Serialize    Call `.model_dump()` on valid records to generate clean dictionaries.
6. Upsert       Execute `INSERT ... ON CONFLICT DO UPDATE` into target PostgreSQL.
