# ProcureOS MCP Folder Structure Plan

## Project Goal

ProcureOS is an MCP server project that allows Claude Desktop to query a PostgreSQL database for an electronics and hardware vendor.

The intended flow is:

```text
Claude Desktop
    -> MCP server
    -> MCP database tools
    -> database query/schema logic
    -> PostgreSQL database
```

The folder structure should separate these responsibilities clearly:

- MCP server startup
- MCP tool registration
- Database connection
- Database schema discovery
- Query functions
- Configuration and secrets
- Tests and developer scripts

## Recommended Folder Structure

```text
ProcureOS/
├── src/
│   └── procureos_mcp/
│       ├── __init__.py
│       ├── server.py
│       ├── config.py
│       ├── db/
│       │   ├── __init__.py
│       │   ├── connection.py
│       │   ├── schema.py
│       │   └── queries.py
│       ├── tools/
│       │   ├── __init__.py
│       │   └── database_tools.py
│       └── utils/
│           ├── __init__.py
│           └── json_helpers.py
├── scripts/
│   └── inspect_schema.py
├── tests/
│   ├── test_connection.py
│   ├── test_schema.py
│   └── test_queries.py
├── .env
├── .env.example
├── requirements.txt
└── README.md
```

## Root Folder

```text
ProcureOS/
```

The root folder should contain project-level files such as:

- `requirements.txt`
- `.env`
- `.env.example`
- `README.md`
- `src/`
- `tests/`
- `scripts/`

Avoid placing all Python application files directly in the root as the project grows. Keeping source code under `src/` makes the project easier to maintain, test, and package.

## Source Folder

```text
src/
```

The `src` folder contains the actual application code.

Recommended package:

```text
src/procureos_mcp/
```

This keeps application code separate from tests, scripts, environment files, documentation, and dependency files.

## Main Package Folder

```text
src/procureos_mcp/
```

This is the main Python package for the MCP server.

It should contain:

```text
src/procureos_mcp/
├── __init__.py
├── server.py
├── config.py
├── db/
├── tools/
└── utils/
```

The package name `procureos_mcp` clearly describes that this code belongs to the ProcureOS MCP server.

## `__init__.py`

```text
src/procureos_mcp/__init__.py
```

Purpose:

```text
Marks procureos_mcp as a Python package.
```

This file can remain nearly empty at first:

```python
"""ProcureOS MCP server package."""
```

It allows imports such as:

```python
from procureos_mcp.db.connection import get_connection
from procureos_mcp.tools.database_tools import register_database_tools
```

## MCP Server Entrypoint

```text
src/procureos_mcp/server.py
```

Purpose:

```text
Creates the MCP server, registers tools, and starts the MCP process.
```

This file should stay small. It should not contain database queries directly.

Recommended shape:

```python
from mcp.server.fastmcp import FastMCP
from procureos_mcp.tools.database_tools import register_database_tools

mcp = FastMCP("procureos-db-server")

register_database_tools(mcp)

if __name__ == "__main__":
    mcp.run()
```

Responsibilities:

- Create the `FastMCP` server instance.
- Register available MCP tools.
- Start the server.

It should not be responsible for:

- Database credentials
- SQL queries
- Schema inspection
- Product search logic
- Vendor lookup logic

## Configuration File

```text
src/procureos_mcp/config.py
```

Purpose:

```text
Loads database configuration from environment variables.
```

Database credentials should not be hardcoded in source code.

Avoid this:

```python
DB_CONFIG = {
    "host": "100.72.202.71",
    "port": 5432,
    "database": "procureos_db",
    "user": "kushal",
    "password": "kushal",
}
```

Prefer this:

```python
import os

DB_CONFIG = {
    "host": os.getenv("DB_HOST"),
    "port": int(os.getenv("DB_PORT", "5432")),
    "database": os.getenv("DB_NAME"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
}
```

If using `python-dotenv`, the file can also load `.env` values locally.

## Database Folder

```text
src/procureos_mcp/db/
```

Purpose:

```text
Contains all PostgreSQL database-related logic.
```

Recommended files:

```text
db/
├── __init__.py
├── connection.py
├── schema.py
└── queries.py
```

The `db/` layer should know how to talk to PostgreSQL, but it should not know about Claude Desktop or MCP.

Important rule:

```text
Files inside db/ should not import FastMCP.
```

That keeps the database layer reusable outside the MCP server.

## Database Connection

```text
src/procureos_mcp/db/connection.py
```

Purpose:

```text
Creates PostgreSQL database connections.
```

Recommended shape:

```python
import psycopg2

from procureos_mcp.config import DB_CONFIG


def get_connection():
    return psycopg2.connect(**DB_CONFIG)
```

This file should only handle connection creation.

It should not contain:

- MCP tools
- Schema inspection functions
- Business queries
- Raw SQL execution tools

## Database Schema Logic

```text
src/procureos_mcp/db/schema.py
```

Purpose:

```text
Reads and describes database structure.
```

This file should contain functions such as:

```python
list_tables()
describe_table(table_name)
list_columns(table_name)
get_database_schema()
get_relationships()
```

These functions help Claude understand what data exists before querying it.

For an electronics and hardware vendor, the schema may include tables like:

- `products`
- `vendors`
- `categories`
- `inventory`
- `purchase_orders`
- `order_items`
- `warehouses`
- `customers`

Example responsibilities:

```text
list_tables()
```

Returns all tables in the public schema.

```text
describe_table(table_name)
```

Returns columns, data types, nullability, and defaults for one table.

```text
get_relationships()
```

Returns foreign key relationships between tables.

```text
get_database_schema()
```

Returns a complete schema summary.

## Database Query Logic

```text
src/procureos_mcp/db/queries.py
```

Purpose:

```text
Contains safe, reusable database query functions.
```

This is where business-specific database access should live.

For an electronics and hardware vendor, useful functions may include:

```python
search_products(search_text)
get_product_by_sku(sku)
get_vendor_by_name(name)
get_inventory_for_product(product_id)
get_low_stock_products()
get_products_by_category(category_name)
get_purchase_orders_for_vendor(vendor_id)
```

Prefer specific safe query functions over unrestricted SQL execution.

Better:

```text
search_products("resistor")
get_inventory_for_product("ABC-123")
get_vendor_by_name("Texas Instruments")
```

Riskier:

```text
execute("DELETE FROM products")
query("SELECT * FROM anything")
```

For early testing, you can expose a read-only SQL function, but it should validate that only `SELECT` queries are allowed.

Example:

```python
def run_readonly_query(sql: str):
    if not sql.strip().lower().startswith("select"):
        raise ValueError("Only SELECT queries are allowed.")
```

## Tools Folder

```text
src/procureos_mcp/tools/
```

Purpose:

```text
Contains MCP tool definitions exposed to Claude Desktop.
```

Recommended files:

```text
tools/
├── __init__.py
└── database_tools.py
```

This folder is the bridge between Claude Desktop and your database code.

The MCP tool layer should:

- Receive input from Claude.
- Call functions from `db/schema.py` and `db/queries.py`.
- Return JSON or text responses back to Claude.

It should not directly manage connection configuration.

## Database MCP Tools

```text
src/procureos_mcp/tools/database_tools.py
```

Purpose:

```text
Registers database-related MCP tools.
```

Recommended shape:

```python
from procureos_mcp.db.schema import describe_table, list_tables
from procureos_mcp.db.queries import search_products


def register_database_tools(mcp):
    @mcp.tool()
    def list_database_tables() -> str:
        return list_tables()

    @mcp.tool()
    def describe_database_table(table_name: str) -> str:
        return describe_table(table_name)

    @mcp.tool()
    def search_vendor_products(search_text: str) -> str:
        return search_products(search_text)
```

This creates a clean separation:

```text
tools/database_tools.py
    knows about MCP

db/schema.py and db/queries.py
    know about PostgreSQL
```

## Utils Folder

```text
src/procureos_mcp/utils/
```

Purpose:

```text
Contains shared helper functions.
```

Recommended file:

```text
utils/json_helpers.py
```

Your current code converts database rows to JSON using logic like:

```python
json.dumps([dict(r) for r in rows], indent=2, default=str)
```

Instead of repeating that in many files, move it into a helper:

```python
import json


def to_json(data) -> str:
    return json.dumps(data, indent=2, default=str)
```

## Scripts Folder

```text
scripts/
```

Purpose:

```text
Contains local developer scripts that are not part of the MCP runtime.
```

Recommended file:

```text
scripts/inspect_schema.py
```

This script can connect to the database and print table/column information locally.

Example use:

```powershell
python scripts/inspect_schema.py
```

Scripts should be optional helpers. Claude Desktop should not depend on them to run the MCP server.

## Tests Folder

```text
tests/
```

Purpose:

```text
Contains automated tests.
```

Recommended files:

```text
tests/
├── test_connection.py
├── test_schema.py
└── test_queries.py
```

Suggested responsibilities:

```text
test_connection.py
```

Checks that database configuration loads correctly.

```text
test_schema.py
```

Tests schema-related functions such as `list_tables()` and `describe_table()`.

```text
test_queries.py
```

Tests product search, vendor lookup, inventory lookup, and read-only query validation.

## Environment Files

### `.env`

Purpose:

```text
Stores real local secrets and database credentials.
```

Example:

```env
DB_HOST=100.72.202.71
DB_PORT=5432
DB_NAME=procureos_db
DB_USER=kushal
DB_PASSWORD=your_real_password
```

This file should not be committed to Git.

### `.env.example`

Purpose:

```text
Documents required environment variables without exposing real secrets.
```

Example:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=procureos_db
DB_USER=your_user
DB_PASSWORD=your_password
```

This file can be committed.

## Requirements File

```text
requirements.txt
```

Purpose:

```text
Lists Python dependencies.
```

Likely starting dependencies:

```text
mcp
psycopg2-binary
python-dotenv
```

## Runtime Flow

The application should run in this order:

```text
Claude Desktop
    -> MCP protocol
    -> src/procureos_mcp/server.py
    -> src/procureos_mcp/tools/database_tools.py
    -> src/procureos_mcp/db/schema.py
    -> src/procureos_mcp/db/queries.py
    -> src/procureos_mcp/db/connection.py
    -> PostgreSQL database
```

## Import Direction

The dependency direction should be:

```text
server.py
    imports tools

tools/database_tools.py
    imports db/schema.py
    imports db/queries.py

db/schema.py and db/queries.py
    import db/connection.py
    import utils/json_helpers.py

db/connection.py
    imports config.py

config.py
    imports os and dotenv only
```

Avoid this:

```text
db/ importing tools/
db/ importing FastMCP
config.py importing server.py
queries.py registering MCP tools
```

## Mapping From Current Files

The current project has:

```text
ProcureOS/
├── server.py
└── db_server.py
```

The current `db_server.py` should eventually be split like this:

```text
DB_CONFIG
    -> src/procureos_mcp/config.py

get_connection()
    -> src/procureos_mcp/db/connection.py

list_tables()
describe_table()
    -> src/procureos_mcp/db/schema.py

query()
execute()
    -> src/procureos_mcp/db/queries.py

@mcp.tool() decorators
    -> src/procureos_mcp/tools/database_tools.py

mcp.run()
    -> src/procureos_mcp/server.py
```

## Minimal First Version

Start with this structure first:

```text
ProcureOS/
├── src/
│   └── procureos_mcp/
│       ├── __init__.py
│       ├── server.py
│       ├── config.py
│       ├── db/
│       │   ├── __init__.py
│       │   ├── connection.py
│       │   ├── schema.py
│       │   └── queries.py
│       └── tools/
│           ├── __init__.py
│           └── database_tools.py
├── .env
├── .env.example
└── requirements.txt
```

Add these later when needed:

```text
utils/
scripts/
tests/
README.md
```

## Summary

Use this structure because it gives each part of the project one clear job:

```text
server.py
    Starts MCP.

tools/
    Exposes functions to Claude Desktop.

db/connection.py
    Connects to PostgreSQL.

db/schema.py
    Reads database structure.

db/queries.py
    Contains safe query functions.

config.py
    Loads configuration from environment variables.

.env
    Stores local secrets.
```

This keeps the MCP server understandable, safer, and easier to extend as the electronics and hardware vendor database grows.
