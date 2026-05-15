# Data normalisation requirements

## ProcureOS — Marketplace MVP

---

## 1. Overview

The normalisation pipeline transforms legacy SQL rows into validated, typed records ready for insertion into PostgreSQL. Every record must conform to the schemas defined below before it touches the database.

---

## 2. Source

| Property       | Value                                           |
| -------------- | ----------------------------------------------- |
| Source         | Legacy SQL database                             |
| Format         | SQL rows (dictionary representation via Python) |
| Sync frequency | Batch execution                                 |
| Output format  | JSON → PostgreSQL upsert                        |

---

## 3. Entities

The pipeline produces four entities: **User**, **Product**, **Order**, and **OrderItem**.

- Orders reference a valid user (`user_id`).
- Order items reference a valid order and product (`order_id`, `product_id`).

---

## 4. User schema

### 4.1 Fields

| Field        | Type           | Required | Notes                        |
| ------------ | -------------- | -------- | ---------------------------- |
| `id`         | `UUID`         | Yes      | Primary key                  |
| `first_name` | `VARCHAR(100)` | Yes      | Must be non-empty            |
| `last_name`  | `VARCHAR(100)` | Yes      | Must be non-empty            |
| `email`      | `VARCHAR(255)` | Yes      | Must be a valid email format |

### 4.2 Validation rules

- `id` must be a valid UUID
- `first_name` and `last_name` must be non-empty strings
- `email` must be a valid email string

---

## 5. Product schema

### 5.1 Fields

| Field         | Type            | Required | Notes              |
| ------------- | --------------- | -------- | ------------------ |
| `id`          | `UUID`          | Yes      | Primary key        |
| `name`        | `VARCHAR(255)`  | Yes      | Must be non-empty  |
| `description` | `TEXT`          | No       | Optional           |
| `price`       | `DECIMAL(10,2)` | Yes      | Must be $\ge 0.00$ |

### 5.2 Validation rules

- `id` must be a valid UUID
- `name` must be non-empty
- `price` must be $\ge 0.00$

---

## 6. Order schema

### 6.1 Fields

| Field          | Type            | Required | Notes                                    |
| -------------- | --------------- | -------- | ---------------------------------------- |
| `id`           | `UUID`          | Yes      | Primary key                              |
| `user_id`      | `UUID`          | Yes      | References `users.id`                    |
| `order_number` | `VARCHAR(100)`  | Yes      | Must be non-empty                        |
| `status`       | `VARCHAR(50)`   | Yes      | e.g., `PENDING`, `SHIPPED`, `COMPLETED`  |
| `total`        | `DECIMAL(10,2)` | Yes      | Must be $\ge 0.00$                       |
| `placed_at`    | `TIMESTAMP`     | Yes      | Defaults to current timestamp if missing |

### 6.2 Validation rules

- `id` and `user_id` must be valid UUIDs
- `order_number` and `status` must be non-empty strings
- `total` must be $\ge 0.00$

---

## 7. Order item schema

### 7.1 Fields

| Field        | Type            | Required | Notes                    |
| ------------ | --------------- | -------- | ------------------------ |
| `id`         | `UUID`          | Yes      | Primary key              |
| `order_id`   | `UUID`          | Yes      | References `orders.id`   |
| `product_id` | `UUID`          | Yes      | References `products.id` |
| `quantity`   | `INTEGER`       | Yes      | Must be > 0              |
| `unit_price` | `DECIMAL(10,2)` | Yes      | Must be $\ge 0.00$       |

### 7.2 Validation rules

- `id`, `order_id`, and `product_id` must be valid UUIDs
- `quantity` must be greater than 0
- `unit_price` must be $\ge 0.00$

---

## 8. Null handling

The pipeline must not halt execution due to individual bad records.

| Scenario                     | Behaviour                                                     |
| ---------------------------- | ------------------------------------------------------------- |
| Non-required field is `NULL` | Validate as `null`/`None` and pass to insertion               |
| Required field is `NULL`     | Log error, quarantine to `failed_records` dict, do not insert |
| UUID is malformed            | Log error, quarantine to `failed_records` dict, do not insert |
| Value violates range checks  | Log error, quarantine to `failed_records` dict, do not insert |

---

## 9. Pipeline steps

``` text
1. Extract      Query batch of rows from legacy SQL database.
2. Map          Align raw row dictionaries to schema field names.
3. Cast         Convert all values to correct types (UUID, DECIMAL, TIMESTAMP).
4. Validate     Enforce UUID formatting and range checks.
5. Quarantine   Catch ValidationError and log bad records.
6. Serialize    Call .model_dump() to generate clean dictionaries.
7. Upsert       INSERT ... ON CONFLICT DO UPDATE into PostgreSQL.
```

---

## 10. Upsert behaviour

On conflict (same `id`), update all fields except the primary key. Do not create duplicate records.

```sql
INSERT INTO users (...)
VALUES (...)
ON CONFLICT (id)
DO UPDATE SET
  first_name = EXCLUDED.first_name,
  last_name = EXCLUDED.last_name,
  email = EXCLUDED.email;
```

---

## 11. Out of scope for MVP

- Pricing history over time
- Inventory tracking
- Payment processing and refunds
- Notification and promotion systems
