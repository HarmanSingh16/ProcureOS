# Data cleanup requirements
## ProcureOS — Thomasnet MVP

---

## 1. Overview

The data cleanup pipeline sits between the raw Thomasnet scrape and the normalisation pipeline. Its sole responsibility is to take messy, inconsistent, incomplete raw HTML extracts and produce clean, consistently structured raw JSON that the normalisation pipeline can process without errors.

Cleanup does not apply business logic. It does not compute derived fields. It does not validate against the final schema. It just makes the data consistent and readable.

---

## 2. Where it starts

### 2.1 Input source

Raw HTML pages scraped from Thomasnet via Playwright. Two page types are scraped:

| Page type | URL pattern | Contains |
|---|---|---|
| Vendor profile page | `/suppliers/{vendor-slug}` | Company name, location, certifications, ratings |
| Product listing page | `/suppliers/{vendor-slug}/products` | SKUs, product names, pricing, stock status, lead times |

### 2.2 Input format

Each scrape run produces one raw file per vendor, stored as:

```
/raw/
  THN_001_profile.html
  THN_001_products.html
  THN_002_profile.html
  THN_002_products.html
  ...
```

BeautifulSoup parses each HTML file into a raw Python dict before cleanup begins. This raw dict is the actual input to the cleanup pipeline.

### 2.3 Example raw dict — vendor (before cleanup)

```json
{
  "company_name": "  Acme Industrial Supply, Inc. ",
  "location": "Chicago, IL 60601",
  "certifications": "ISO 9001, RoHS Compliant",
  "rating": "4.3 out of 5",
  "response_time": "Typically responds in 2-4 days",
  "products_url": "/suppliers/acme-industrial/products"
}
```

### 2.4 Example raw dict — product (before cleanup)

```json
{
  "part_number": " BRG-6204 ",
  "description": "Deep Groove Ball Bearing -- 6204 Series",
  "price": "$4.20/each",
  "minimum_order": "50 pieces",
  "availability": "In Stock",
  "lead_time": "5-7 Business Days",
  "category": "Bearings & Power Transmission"
}
```

---

## 3. What cleanup does

### 3.1 String cleaning

All string fields must be cleaned before output:

| Operation | Rule | Example |
|---|---|---|
| Strip whitespace | Remove leading and trailing spaces | `"  Acme "` → `"Acme"` |
| Collapse internal spaces | Replace multiple spaces with one | `"Acme  Supply"` → `"Acme Supply"` |
| Remove special characters | Strip `--`, `**`, excessive punctuation from descriptions | `"Bearing -- 6204"` → `"Bearing 6204"` |
| Normalise case | Company names title case, categories lowercase | `"ACME SUPPLY"` → `"Acme Supply"` |
| Remove legal suffixes | Strip `, Inc.` `, LLC` `, Ltd.` from vendor names | `"Acme Supply, Inc."` → `"Acme Supply"` |

### 3.2 Price cleaning

Raw prices from Thomasnet come in multiple inconsistent formats. All must be converted to a plain float:

| Raw value | Cleaned output |
|---|---|
| `"$4.20/each"` | `4.20` |
| `"$4.20 per unit"` | `4.20` |
| `"USD 4.20"` | `4.20` |
| `"4.20"` | `4.20` |
| `"Price on request"` | `null` |
| `""` | `null` |

Rule: extract the numeric value only. Strip currency symbols, unit suffixes, and surrounding text. If no numeric value is parseable, output `null`.

### 3.3 Quantity cleaning

Minimum order quantities come in mixed formats. All must be converted to a plain integer:

| Raw value | Cleaned output |
|---|---|
| `"50 pieces"` | `50` |
| `"50 units"` | `50` |
| `"Minimum 50"` | `50` |
| `"50"` | `50` |
| `""` | `null` |

Rule: extract the integer only. If no integer is parseable, output `null`.

### 3.4 Lead time cleaning

Lead times come in range and text formats. All must be converted to a single integer representing days:

| Raw value | Cleaned output | Rule applied |
|---|---|---|
| `"5-7 Business Days"` | `6` | Midpoint of range |
| `"3–5 days"` | `4` | Midpoint of range |
| `"1 week"` | `7` | Convert weeks to days |
| `"2 weeks"` | `14` | Convert weeks to days |
| `"24 hours"` | `1` | Convert hours to days |
| `"Ships same day"` | `1` | Treat as 1 day |
| `"Usually ships in 1 day"` | `1` | Extract integer |
| `""` | `null` | No data |

Rule: always take the midpoint of a range, round to nearest integer. Convert all non-day units to days.

### 3.5 Stock status cleaning

Availability fields come in multiple text variants. All must be converted to a boolean:

| Raw value | Cleaned output |
|---|---|
| `"In Stock"` | `true` |
| `"Available"` | `true` |
| `"In stock"` | `true` |
| `"Out of Stock"` | `false` |
| `"Unavailable"` | `false` |
| `"Discontinued"` | `false` |
| `"Call for availability"` | `null` |
| `""` | `null` |

Rule: only set `true` or `false` when status is unambiguous. Anything uncertain outputs `null`.

### 3.6 Location cleaning

Location strings must be split into city and state:

| Raw value | city | state |
|---|---|---|
| `"Chicago, IL 60601"` | `"Chicago"` | `"IL"` |
| `"Chicago, IL"` | `"Chicago"` | `"IL"` |
| `"Chicago"` | `"Chicago"` | `null` |
| `""` | `null` | `null` |

Rule: split on comma, take first part as city, extract two-letter state code from second part. Strip zip codes. If format is unrecognised, output both as `null`.

### 3.7 Certifications cleaning

Certifications come as a single comma-separated string. Must be split into a clean array:

| Raw value | Cleaned output |
|---|---|
| `"ISO 9001, RoHS Compliant"` | `["ISO_9001", "RoHS"]` |
| `"ISO9001"` | `["ISO_9001"]` |
| `"None"` | `[]` |
| `""` | `[]` |

Rule: split on comma, strip whitespace from each item, normalise to uppercase with underscores. Known mappings:

```python
CERT_MAPPINGS = {
  "ISO 9001": "ISO_9001",
  "ISO9001": "ISO_9001",
  "ROHS": "RoHS",
  "ROHS COMPLIANT": "RoHS",
  "AS9100": "AS9100",
  "IATF 16949": "IATF_16949"
}
```

Any unrecognised certification string is kept as-is after normalising whitespace and casing.

### 3.8 Rating cleaning

Ratings come in text formats. Must be extracted as a float between 0 and 5:

| Raw value | Cleaned output |
|---|---|
| `"4.3 out of 5"` | `4.3` |
| `"4.3/5"` | `4.3` |
| `"4.3"` | `4.3` |
| `""` | `null` |

Rule: extract the numeric value before the denominator. If no numeric value is parseable, output `null`.

### 3.9 Response time cleaning

Response time strings must be converted to a float representing average days:

| Raw value | Cleaned output |
|---|---|
| `"Typically responds in 2-4 days"` | `3.0` |
| `"Responds within 24 hours"` | `1.0` |
| `"1-2 business days"` | `1.5` |
| `""` | `null` |

Rule: extract numeric range, take midpoint, convert to days. If not parseable, output `null`.

---

## 4. What cleanup does not do

| Out of scope | Reason |
|---|---|
| Generate `vendor_id` or `product_id` | Done in normalisation |
| Compute `reliability_score` | Done in normalisation |
| Compute `single_source_flag` | Done in normalisation |
| Validate against final schema | Done in normalisation |
| Insert into database | Done in normalisation |
| Fetch or re-scrape missing data | Cleanup works with what the scraper provides |

---

## 5. What cleanup outputs

### 5.1 Output format

One clean JSON file per vendor, written to:

```
/clean/
  THN_001.json
  THN_002.json
  ...
```

### 5.2 Output structure

```json
{
  "raw_vendor_id": "THN_001",
  "vendor": {
    "name": "Acme Industrial Supply",
    "location_city": "Chicago",
    "location_state": "IL",
    "certifications": ["ISO_9001"],
    "rating": 4.3,
    "response_time_avg": 3.0
  },
  "products": [
    {
      "sku": "BRG-6204",
      "name": "Deep groove ball bearing 6204 series",
      "category": "bearings",
      "unit_price": 4.20,
      "moq": 50,
      "in_stock": true,
      "lead_time_days": 6
    }
  ],
  "cleanup_timestamp": "2026-05-13T08:00:00Z",
  "warnings": []
}
```

### 5.3 Warnings array

Any field that required a fallback, a default, or a best-guess conversion must be logged in the `warnings` array:

```json
"warnings": [
  "lead_time: range '5-7 days' converted to midpoint 6",
  "certifications: unrecognised value 'NADCAP' kept as-is",
  "unit_price: null — 'Price on request' could not be parsed"
]
```

This gives the normalisation pipeline full visibility into what was approximated.

---

## 6. Error handling

| Scenario | Behaviour |
|---|---|
| Field missing entirely from raw dict | Output `null` for that field, log to warnings |
| Field present but unparseable | Output `null`, log to warnings |
| Entire vendor record unparseable | Write to `/failed/THN_XXX_raw.json`, skip clean output |
| Product record unparseable | Skip that product, log to vendor warnings, continue |

---

## 7. Pipeline handoff

The normalisation pipeline expects clean JSON files from `/clean/`. It will not accept raw HTML or uncleaned dicts. The cleanup pipeline must complete and write all clean files before normalisation begins.

Suggested run order:

```
scraper.py        →  /raw/*.html
cleanup.py        →  /clean/*.json
normalisation.py  →  PostgreSQL
```

---

## 8. Out of scope for MVP

- Deduplication across vendors (same product listed by multiple vendors)
- Image or document attachment handling
- Non-English vendor page parsing
- Price currency conversion (USD only for MVP)
