# Data Normalisation Requirements

## Marketplace Database Migration

---

## 1. Overview

The normalisation pipeline acts as an ETL (Extract, Transform, Load) bridge between a legacy/staging SQL database and the production PostgreSQL database. Every record must conform to the strict type requirements (UUIDs, email formats, numeric bounds) defined below before insertion.

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

- **Primary/Foreign Keys:** All `id` fields must strictly validate as UUID strings. Malformed values must trigger a quarantine.
- **Email Fields:** `email` must pass email formatting validation.
- **Financials:** All monetary values (`price`, `total`, `unit_price`) must be parsed as `DECIMAL` types and be $\ge 0.00$.
- **Counts:** `quantity` must be a positive integer (> 0).

---

## 4. Core Schemas

### 4.1 `USERS` Table

| Field        | Type           | Required | Notes              |
| ------------ | -------------- | -------- | ------------------ |
| `id`         | `UUID`         | Yes      | Primary Key        |
| `first_name` | `VARCHAR(100)` | Yes      | Non-empty          |
| `last_name`  | `VARCHAR(100)` | Yes      | Non-empty          |
| `email`      | `VARCHAR(255)` | Yes      | Valid email format |

### 4.2 `PRODUCTS` Table

| Field         | Type            | Required | Notes              |
| ------------- | --------------- | -------- | ------------------ |
| `id`          | `UUID`          | Yes      | Primary Key        |
| `name`        | `VARCHAR(255)`  | Yes      | Non-empty          |
| `description` | `TEXT`          | No       | Optional           |
| `price`       | `DECIMAL(10,2)` | Yes      | Must be $\ge 0.00$ |

### 4.3 `ORDERS` Table

| Field          | Type            | Required | Notes                                    |
| -------------- | --------------- | -------- | ---------------------------------------- |
| `id`           | `UUID`          | Yes      | Primary Key                              |
| `user_id`      | `UUID`          | Yes      | Foreign Key to `USERS`                   |
| `order_number` | `VARCHAR(100)`  | Yes      | Non-empty                                |
| `status`       | `VARCHAR(50)`   | Yes      | e.g., `PENDING`, `SHIPPED`, `COMPLETED`  |
| `total`        | `DECIMAL(10,2)` | Yes      | Must be $\ge 0.00$                       |
| `placed_at`    | `TIMESTAMP`     | Yes      | Defaults to current timestamp if missing |

### 4.4 `ORDER_ITEMS` Table

| Field        | Type            | Required | Notes                     |
| ------------ | --------------- | -------- | ------------------------- |
| `id`         | `UUID`          | Yes      | Primary Key               |
| `order_id`   | `UUID`          | Yes      | Foreign Key to `ORDERS`   |
| `product_id` | `UUID`          | Yes      | Foreign Key to `PRODUCTS` |
| `quantity`   | `INTEGER`       | Yes      | Must be > 0               |
| `unit_price` | `DECIMAL(10,2)` | Yes      | Must be $\ge 0.00$        |

---

## 5. Null Handling & Quarantine Protocol

The pipeline must not halt execution due to individual bad records.

| Scenario                     | Behaviour                                                     |
| ---------------------------- | ------------------------------------------------------------- |
| Non-required field is `NULL` | Validate as `null`/`None` and pass to insertion               |
| Required field is `NULL`     | Log error, quarantine to `failed_records` dict, do not insert |
| UUID is malformed            | Log error, quarantine to `failed_records` dict, do not insert |
| Value violates range checks  | Log error, quarantine to `failed_records` dict, do not insert |

---

## 6. Pipeline Execution Flow

```text
1. Extract      Query batch of rows from staging SQL database.
2. Load Schema  Map raw row dictionaries to corresponding Pydantic BaseModel.
3. Validate     Enforce UUID formatting and numeric bounds.
4. Quarantine   Catch ValidationError. Append row and error trace to failed list.
5. Serialize    Call .model_dump() on valid records to generate clean dictionaries.
6. Upsert       Execute INSERT ... ON CONFLICT DO UPDATE into target PostgreSQL.
```
