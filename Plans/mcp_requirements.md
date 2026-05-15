# MCP server requirements
## ProcureOS — Thomasnet MVP

---

## 1. Overview

The MCP (Model Context Protocol) server is the interface layer between the AI agent and the ProcureOS backend. It exposes a defined set of tools the agent can call to discover vendors, check inventory, get quotes, compare options, execute purchase orders, and analyse procurement data.

The MCP server does not scrape, clean, or normalise data. It does not make procurement decisions. It receives structured tool calls from the agent, executes the correct backend operation, and returns structured responses. That is its entire job.

---

## 2. Where it starts

### 2.1 Trigger

The MCP server starts when an AI agent connects to it and begins a procurement workflow. The agent reads the tool definitions exposed by the server and decides which tools to call based on its task.

The server is always-on — it does not start per request. It runs as a persistent Node.js process waiting for incoming tool calls.

### 2.2 Dependencies the MCP server requires to be running

Before the MCP server can function, the following must be available:

| Dependency | Purpose | Required for |
|---|---|---|
| PostgreSQL | Normalized vendor and product data | All tools except `create_po` live path |
| Redis | Live fetch cache (quotes) | `get_quote`, `get_inventory` |
| Thomasnet (live) | Real-time inventory and quote confirmation | `get_quote` (cache miss), `create_po` |

The MCP server does not manage these dependencies. It assumes they are running and reachable.

### 2.3 What the MCP server reads from PostgreSQL

The server queries two tables exclusively:

- `vendors` — for vendor discovery, profiles, reliability scores
- `products` — for inventory, pricing, lead times, MOQ

It never writes to PostgreSQL directly. The only write operation in the system is `create_po`, which writes to a separate `purchase_orders` table.

---

## 3. Tech stack

| Component | Technology | Reason |
|---|---|---|
| Language | TypeScript | Anthropic MCP SDK is TypeScript native |
| Runtime | Node.js 20+ | Required by MCP SDK |
| MCP SDK | `@anthropic-ai/mcp` | Official SDK, handles protocol, tool registration, transport |
| Database client | `pg` (node-postgres) | PostgreSQL queries |
| Cache client | `ioredis` | Redis cache for live fetch results |
| HTTP client | `axios` | Live fetch calls to Thomasnet where needed |
| Validation | `zod` | Input schema validation on every tool call |

---

## 4. Tools

The MCP server exposes exactly 7 tools for MVP. No more, no less.

---

### Tool 1 — `search_vendors`

**Purpose:** Find vendors that supply a given product or category. Entry point for most procurement workflows.

**When the agent calls this:** At the start of a procurement task when it needs to know which vendors carry a specific item or operate in a specific category.

**Data source:** PostgreSQL only. No live fetch.

**Input schema:**
```typescript
{
  query: string,          // product name, SKU, or category keyword
  filters?: {
    location_state?: string,    // e.g. "IL"
    certifications?: string[],  // e.g. ["ISO_9001"]
    min_reliability?: number    // 0.00 to 1.00
  },
  limit?: number          // max results to return, default 10
}
```

**Output schema:**
```typescript
{
  vendors: [
    {
      vendor_id: string,
      name: string,
      location_city: string,
      location_state: string,
      certifications: string[],
      reliability_score: number,
      response_time_avg: number,
      single_source_flag: boolean
    }
  ],
  total_found: number
}
```

**Handler logic:**
```
1. Validate input against zod schema
2. Build SQL query against vendors + products tables
3. Apply filters if provided
4. Return ranked results ordered by reliability_score DESC
```

**Error cases:**
- No vendors found → return empty array, `total_found: 0`
- Invalid filter values → return validation error with field name

---

### Tool 2 — `get_inventory`

**Purpose:** Check current stock status and available quantity for a specific product from a specific vendor.

**When the agent calls this:** After `search_vendors` returns candidates, before requesting a quote, to confirm the item is actually available.

**Data source:** PostgreSQL (primary). Redis cache checked first on repeat calls within the same session.

**Input schema:**
```typescript
{
  vendor_id: string,
  sku: string
}
```

**Output schema:**
```typescript
{
  vendor_id: string,
  sku: string,
  in_stock: boolean,
  lead_time_days: number,
  moq: number,
  last_synced_at: string    // ISO 8601 timestamp
}
```

**Handler logic:**
```
1. Validate input
2. Check Redis cache — key: "inventory:{vendor_id}:{sku}"
3. Cache hit → return cached result
4. Cache miss → query PostgreSQL products table
5. Write result to Redis (TTL: 15 minutes)
6. Return result
```

**Error cases:**
- `vendor_id` not found → return 404 error with message
- `sku` not found for that vendor → return 404 error with message

---

### Tool 3 — `get_quote`

**Purpose:** Get current unit price for a specific SKU and quantity from a specific vendor.

**When the agent calls this:** When it has confirmed inventory exists and needs a price to make a procurement decision.

**Data source:** Redis cache first, then PostgreSQL, then live Thomasnet fetch if data is stale (older than 15 minutes).

**Input schema:**
```typescript
{
  vendor_id: string,
  sku: string,
  quantity: number    // must be >= product MOQ
}
```

**Output schema:**
```typescript
{
  vendor_id: string,
  sku: string,
  quantity: number,
  unit_price: number,
  total_price: number,    // unit_price * quantity
  in_stock: boolean,
  lead_time_days: number,
  moq: number,
  quote_timestamp: string   // ISO 8601, when price was fetched
}
```

**Handler logic:**
```
1. Validate input — quantity must be >= MOQ
2. Check Redis cache — key: "quote:{vendor_id}:{sku}:{quantity}"
3. Cache hit → return cached quote
4. Cache miss → check PostgreSQL last_synced_at
5. If synced within 15 min → serve from PostgreSQL, write to Redis
6. If stale → live fetch from Thomasnet, update PostgreSQL, write to Redis
7. Return quote
```

**Error cases:**
- `quantity` below MOQ → return error with MOQ value so agent can adjust
- Thomasnet live fetch fails → return last known price with `stale: true` flag
- `vendor_id` or `sku` not found → return 404 error

---

### Tool 4 — `compare_vendors`

**Purpose:** Rank multiple vendors for the same SKU across price, lead time, and reliability. Returns a ranked recommendation list.

**When the agent calls this:** When `search_vendors` returns multiple options and the agent needs to decide which vendor to use.

**Data source:** PostgreSQL only. Calls `get_quote` internally for each vendor to ensure prices are fresh.

**Input schema:**
```typescript
{
  sku: string,
  quantity: number,
  rank_by: "price" | "lead_time" | "reliability"  // primary sort
}
```

**Output schema:**
```typescript
{
  sku: string,
  quantity: number,
  ranked_vendors: [
    {
      rank: number,
      vendor_id: string,
      name: string,
      unit_price: number,
      total_price: number,
      lead_time_days: number,
      reliability_score: number,
      single_source_flag: boolean,
      recommendation_reason: string  // plain English, e.g. "Lowest price, reliable delivery"
    }
  ]
}
```

**Handler logic:**
```
1. Validate input
2. Query all vendors carrying this SKU from PostgreSQL
3. For each vendor call get_quote internally to get fresh pricing
4. Score each vendor across price, lead_time_days, reliability_score
5. Sort by rank_by field, apply secondary sort by reliability_score
6. Generate recommendation_reason string for top 3 results
7. Return ranked list
```

**Error cases:**
- No vendors found for SKU → return empty array
- Only one vendor found → return single result with `single_source_flag: true`

---

### Tool 5 — `create_po`

**Purpose:** Execute a purchase order with a vendor. The most consequential tool in the system — it initiates a real transaction.

**When the agent calls this:** Only after `compare_vendors` or `get_quote` has confirmed price and availability, and the order value is within the agent's autonomous approval threshold.

**Data source:** Live Thomasnet call to confirm and submit PO. Writes PO record to PostgreSQL `purchase_orders` table.

**Input schema:**
```typescript
{
  vendor_id: string,
  sku: string,
  quantity: number,
  required_by_date: string,   // ISO 8601 date
  notes?: string              // optional delivery or specification notes
}
```

**Output schema:**
```typescript
{
  po_id: string,              // generated: "PO_{timestamp}_{vendor_id}"
  vendor_id: string,
  sku: string,
  quantity: number,
  unit_price: number,
  total_price: number,
  status: "confirmed" | "pending" | "flagged_for_review",
  required_by_date: string,
  created_at: string,
  approval_required: boolean,
  approval_reason?: string    // populated if approval_required is true
}
```

**Handler logic:**
```
1. Validate input
2. Check total_price against approval thresholds:
     < $5,000   → auto_approve = true
     >= $5,000  → auto_approve = false, call flag_for_review
3. If auto_approve:
     a. Live confirm stock with Thomasnet
     b. Submit PO to Thomasnet
     c. Write PO record to purchase_orders table with status "confirmed"
     d. Return confirmed PO
4. If not auto_approve:
     a. Write PO record with status "flagged_for_review"
     b. Call flag_for_review internally
     c. Return PO with approval_required: true
```

**Approval thresholds (MVP defaults):**

| Order value | Action |
|---|---|
| Below $5,000 | Agent executes autonomously |
| $5,000 and above | Flagged for human review |

**Error cases:**
- Stock no longer available at confirmation → return error, do not create PO
- Thomasnet submission fails → return error with `retry: true` flag, do not write to DB
- Quantity below MOQ → return error with MOQ value

---

### Tool 6 — `get_po_status`

**Purpose:** Check the current status of a previously created purchase order.

**When the agent calls this:** To track an in-progress PO, confirm a submission was received, or check if a flagged PO has been approved by a human.

**Data source:** PostgreSQL `purchase_orders` table.

**Input schema:**
```typescript
{
  po_id: string
}
```

**Output schema:**
```typescript
{
  po_id: string,
  vendor_id: string,
  vendor_name: string,
  sku: string,
  quantity: number,
  total_price: number,
  status: "confirmed" | "pending" | "flagged_for_review" | "approved" | "rejected" | "cancelled",
  created_at: string,
  updated_at: string,
  approval_required: boolean,
  approval_reason?: string,
  approved_by?: string,     // human reviewer name if approved
  notes?: string
}
```

**Handler logic:**
```
1. Validate input
2. Query purchase_orders table by po_id
3. Join with vendors table to get vendor_name
4. Return full PO record
```

**Error cases:**
- `po_id` not found → return 404 error

---

### Tool 7 — `flag_for_review`

**Purpose:** Escalate a PO or procurement decision to the human approval queue. Stops the agent from proceeding autonomously.

**When the agent calls this:** Automatically called internally by `create_po` when order value exceeds threshold. Can also be called directly by the agent when it encounters an unusual procurement situation.

**Data source:** Writes to PostgreSQL `review_queue` table.

**Input schema:**
```typescript
{
  po_id: string,
  reason: string,     // plain English reason for escalation
  urgency: "low" | "medium" | "high"
}
```

**Output schema:**
```typescript
{
  review_id: string,        // generated: "REV_{timestamp}"
  po_id: string,
  reason: string,
  urgency: string,
  status: "pending_review",
  created_at: string,
  estimated_review_time: string   // e.g. "Within 2 business hours"
}
```

**Handler logic:**
```
1. Validate input
2. Write review record to review_queue table
3. Update linked PO status to "flagged_for_review"
4. Return review confirmation
```

**Error cases:**
- `po_id` not found → return 404 error
- Duplicate review for same PO → return existing review record

---

## 5. Tool call sequence — typical agent workflow

```
Agent receives procurement task
        ↓
search_vendors(query, filters)
        ↓
get_inventory(vendor_id, sku)       ← for top candidates
        ↓
get_quote(vendor_id, sku, quantity)  ← for available candidates
        ↓
compare_vendors(sku, quantity, rank_by)
        ↓
create_po(vendor_id, sku, quantity, required_by_date)
        ↓
  ┌─────┴─────┐
confirmed   flagged_for_review
  ↓               ↓
get_po_status   flag_for_review (internal)
                    ↓
              human reviews
                    ↓
              get_po_status (agent polls)
```

---

## 6. Input validation

Every tool call must be validated against its zod schema before any database or network operation is attempted. If validation fails, return immediately with a structured error — do not proceed.

Error response format (all tools):

```typescript
{
  error: true,
  code: "VALIDATION_ERROR" | "NOT_FOUND" | "UPSTREAM_FAILURE" | "THRESHOLD_EXCEEDED",
  message: string,        // plain English, readable by the agent
  field?: string,         // which field failed, if applicable
  retry: boolean          // whether the agent should retry
}
```

---

## 7. Caching policy

| Tool | Cache | TTL | Cache key |
|---|---|---|---|
| `search_vendors` | None | — | — |
| `get_inventory` | Redis | 15 min | `inventory:{vendor_id}:{sku}` |
| `get_quote` | Redis | 15 min | `quote:{vendor_id}:{sku}:{quantity}` |
| `compare_vendors` | None | — | — |
| `create_po` | None | — | — |
| `get_po_status` | None | — | — |
| `flag_for_review` | None | — | — |

---

## 8. Database tables the MCP server touches

### Read
- `vendors` — all read tools
- `products` — all read tools

### Write
- `purchase_orders` — written by `create_po`
- `review_queue` — written by `flag_for_review`

### `purchase_orders` table
```sql
CREATE TABLE purchase_orders (
  po_id             VARCHAR PRIMARY KEY,
  vendor_id         VARCHAR REFERENCES vendors(vendor_id),
  sku               VARCHAR NOT NULL,
  quantity          INTEGER NOT NULL,
  unit_price        DECIMAL(10,2) NOT NULL,
  total_price       DECIMAL(12,2) NOT NULL,
  status            VARCHAR NOT NULL,
  required_by_date  DATE,
  approval_required BOOLEAN DEFAULT false,
  approval_reason   TEXT,
  approved_by       VARCHAR,
  notes             TEXT,
  created_at        TIMESTAMP DEFAULT NOW(),
  updated_at        TIMESTAMP DEFAULT NOW()
);
```

### `review_queue` table
```sql
CREATE TABLE review_queue (
  review_id   VARCHAR PRIMARY KEY,
  po_id       VARCHAR REFERENCES purchase_orders(po_id),
  reason      TEXT NOT NULL,
  urgency     VARCHAR NOT NULL,
  status      VARCHAR DEFAULT 'pending_review',
  created_at  TIMESTAMP DEFAULT NOW(),
  updated_at  TIMESTAMP DEFAULT NOW()
);
```

---

## 9. What the MCP server outputs

The MCP server does not write files. Its outputs are:

| Output | Where |
|---|---|
| Tool responses | Returned to the agent as structured JSON over MCP protocol |
| PO records | Written to PostgreSQL `purchase_orders` table |
| Review records | Written to PostgreSQL `review_queue` table |
| Cache entries | Written to Redis with TTL |
| Error responses | Returned to the agent as structured JSON |

---

## 10. Out of scope for MVP

- Authentication between agent and MCP server
- Multi-agent concurrency handling
- Webhook notifications when a flagged PO is approved
- Analytics tools (`get_vendor_analytics`) — deferred post-MVP
- Sector config layer — deferred for multi-sector expansion
- Rate limiting on tool calls
