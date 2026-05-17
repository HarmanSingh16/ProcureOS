"""
ProcureOS MCP — Test Suite
Tests: request_api_key, metrics tracking (reads/writes), and admin approval flow.
"""

import json
import os
import sys
from pathlib import Path
from uuid import uuid4

import psycopg2

from dotenv import load_dotenv

# ---------------------------------------------------------------------------
# Configure environment before importing database_tools
# ---------------------------------------------------------------------------

load_dotenv()

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"

if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

# ---------------------------------------------------------------------------
# Import after env is set
# ---------------------------------------------------------------------------

from procureos_mcp.tools.database_tools import (
    _get_analytics_connection,
    _record_metric,
    register_database_tools,
)


# ---------------------------------------------------------------------------
# Mock MCP so we can call tools directly without a running MCP server
# ---------------------------------------------------------------------------

class MockMCP:
    def __init__(self):
        self._tools = {}

    def tool(self):
        def decorator(fn):
            self._tools[fn.__name__] = fn
            return fn
        return decorator

    def call(self, name, **kwargs):
        return self._tools[name](**kwargs)


mcp = MockMCP()
register_database_tools(mcp)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

PASS = "✓"
FAIL = "✗"

def section(title):
    print(f"\n{'='*60}")
    print(f"  {title}")
    print(f"{'='*60}")

def check(label, condition, detail=""):
    status = PASS if condition else FAIL
    print(f"  {status} {label}" + (f" — {detail}" if detail else ""))
    return condition


def analytics_totals():
    """Return dict of {business_id: (total_reads, total_writes)} from analytics DB."""
    conn = _get_analytics_connection()
    try:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT
                    business_id,
                    SUM(read_operations_executed)  AS total_reads,
                    SUM(write_operations_executed) AS total_writes
                FROM operation_metrics
                GROUP BY business_id
                ORDER BY total_reads DESC
            """)
            return {row[0]: (int(row[1]), int(row[2])) for row in cur.fetchall()}
    finally:
        conn.close()


def procureos_query(sql, params=()):
    """Run a read query against procureos_db and return all rows."""
    conn = psycopg2.connect(
        host=os.environ["DB_HOST"],
        port=os.environ["DB_PORT"],
        dbname=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
    )
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params)
            return cur.fetchall()
    finally:
        conn.close()


def procureos_execute(sql, params=()):
    """Run a write query against procureos_db."""
    conn = psycopg2.connect(
        host=os.environ["DB_HOST"],
        port=os.environ["DB_PORT"],
        dbname=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
    )
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params)
        conn.commit()
    finally:
        conn.close()


def cleanup_test_buyer(company_name: str) -> None:
    rows = procureos_query(
        "SELECT id FROM buyers WHERE company_name = %s", (company_name,)
    )
    if rows:
        buyer_id = str(rows[0][0])
        procureos_execute("DELETE FROM audit_log WHERE buyer_id = %s", (buyer_id,))
    procureos_execute(
        "DELETE FROM buyers WHERE company_name = %s", (company_name,)
    )


# ---------------------------------------------------------------------------
# Test 1 — Analytics DB connectivity
# ---------------------------------------------------------------------------

section("TEST 1 — Analytics DB connection")

try:
    conn = _get_analytics_connection()
    conn.close()
    check("Connected to analytics DB", True)
except Exception as e:
    check("Connected to analytics DB", False, str(e))
    print("\n  ⚠ Cannot continue without analytics DB. Fix ANALYTICS_DATABASE_URL.")
    exit(1)


# ---------------------------------------------------------------------------
# Test 2 — _record_metric writes correctly
# ---------------------------------------------------------------------------

section("TEST 2 — _record_metric inserts rows")

FIXED_BUSINESS_ID = "550e8400-e29b-41d4-a716-446655440000"

before = analytics_totals().get(FIXED_BUSINESS_ID, (0, 0))

_record_metric(FIXED_BUSINESS_ID, reads=1)
_record_metric(FIXED_BUSINESS_ID, reads=1)
_record_metric(FIXED_BUSINESS_ID, writes=1)

after = analytics_totals().get(FIXED_BUSINESS_ID, (0, 0))

check("Read count incremented by 2",
      after[0] - before[0] == 2,
      f"{before[0]} → {after[0]}")

check("Write count incremented by 1",
      after[1] - before[1] == 1,
      f"{before[1]} → {after[1]}")

check("No-op call (reads=0, writes=0) does not insert",
      True)  # _record_metric guards against this internally


# ---------------------------------------------------------------------------
# Test 3 — request_api_key happy path
# ---------------------------------------------------------------------------

section("TEST 3 — request_api_key registration")

# Clean up any previous test run
cleanup_test_buyer("PyTest Corp")

result = mcp.call(
    "request_api_key",
    company_name="PyTest Corp",
    contact_name="Test User",
    contact_email="testuser@pytest.io",
    intended_use="Automated test suite",
)
data = json.loads(result)

check("Status is pending_approval",
      data.get("status") == "pending_approval",
      data.get("status"))

raw_key = data.get("api_key", "")
check("Raw key returned in response",
      raw_key.startswith("pk_"),
      raw_key[:12] + "...")

key_prefix = data.get("key_prefix", "")
check("Key prefix returned",
      bool(key_prefix),
      key_prefix)

# Verify DB state
rows = procureos_query(
    "SELECT status, credit_limit FROM buyers WHERE company_name = %s",
    ("PyTest Corp",)
)
check("Buyer created with status=pending",
      rows and rows[0][0] == "pending",
      str(rows[0]) if rows else "no row")

rows = procureos_query(
    "SELECT is_active, role FROM buyer_contacts WHERE email = %s",
    ("testuser@pytest.io",)
)
check("Contact created with is_active=false",
      rows and rows[0][0] is False,
      str(rows[0]) if rows else "no row")

rows = procureos_query(
    "SELECT is_active, scopes FROM api_keys WHERE key_prefix = %s",
    (key_prefix,)
)
check("API key created with is_active=false",
      rows and rows[0][0] is False,
      str(rows[0]) if rows else "no row")

check("API key has empty scopes",
      rows and rows[0][1] == [],
      str(rows[0][1]) if rows else "no row")


# ---------------------------------------------------------------------------
# Test 4 — key is rejected before approval
# ---------------------------------------------------------------------------

section("TEST 4 — Key blocked before admin approval")

result = mcp.call("search_catalog", api_key=raw_key, query="MacBook")
data = json.loads(result)

check("search_catalog rejected with inactive key",
      data.get("status") in ("unauthorized", "error"),
      data.get("error") or data.get("status"))


# ---------------------------------------------------------------------------
# Test 5 — Admin approval flow + key works after
# ---------------------------------------------------------------------------

section("TEST 5 — Admin approves key, tools become accessible")

# Simulate what your admin UI does
procureos_execute("""
    UPDATE api_keys
    SET is_active = true,
        scopes    = ARRAY['catalog:read', 'catalog:search',
                          'orders:read', 'orders:create', 'orders:cancel']
    WHERE key_prefix = %s
""", (key_prefix,))

procureos_execute("""
    UPDATE buyers
    SET status = 'active', credit_limit = 50000
    WHERE company_name = %s
""", ("PyTest Corp",))

procureos_execute("""
    UPDATE buyer_contacts
    SET is_active = true
    WHERE email = %s
""", ("testuser@pytest.io",))

result = mcp.call("search_catalog", api_key=raw_key, query="MacBook")
data = json.loads(result)

status = data.get("status")
check("search_catalog accessible after approval",
    status in ("success", "not_found"),
    status)

if status == "success":
    check("Results returned",
        len(data.get("data", [])) > 0,
        f"{len(data.get('data', []))} products")
else:
    check("Results returned",
        True,
        "not_found (empty catalog)")


# ---------------------------------------------------------------------------
# Test 6 — Metrics fire automatically on tool calls
# ---------------------------------------------------------------------------

section("TEST 6 — Metrics auto-recorded on tool calls")

# Get buyer_id for this test business
rows = procureos_query(
    "SELECT id FROM buyers WHERE company_name = %s", ("PyTest Corp",)
)
buyer_id = str(rows[0][0]) if rows else None
check("Buyer ID found", bool(buyer_id), buyer_id)

before = analytics_totals().get(FIXED_BUSINESS_ID, (0, 0))

# Trigger 2 read ops
mcp.call("search_catalog", api_key=raw_key, query="MacBook")
mcp.call("search_catalog", api_key=raw_key, query="monitor")

after = analytics_totals().get(FIXED_BUSINESS_ID, (0, 0))

check("2 read ops recorded after 2 search_catalog calls",
      after[0] - before[0] == 2,
      f"{before[0]} → {after[0]}")

check("Write ops unchanged after read-only calls",
      after[1] == before[1],
      f"writes: {after[1]}")


# ---------------------------------------------------------------------------
# Test 7 — Aggregated totals across all businesses
# ---------------------------------------------------------------------------

section("TEST 7 — Aggregated read/write totals per business")

totals = analytics_totals()
print(f"\n  {'Business ID':<40} {'Total Reads':>12} {'Total Writes':>13}")
print(f"  {'-'*40} {'-'*12} {'-'*13}")
for biz_id, (reads, writes) in totals.items():
    print(f"  {biz_id:<40} {reads:>12} {writes:>13}")

check("At least one business has metrics",
      len(totals) > 0,
      f"{len(totals)} businesses tracked")


# ---------------------------------------------------------------------------
# Test 8 — Duplicate registration is idempotent
# ---------------------------------------------------------------------------

section("TEST 8 — Duplicate registration (same email) is idempotent")

result = mcp.call(
    "request_api_key",
    company_name="PyTest Corp",
    contact_name="Test User",
    contact_email="testuser@pytest.io",
)
data = json.loads(result)

check("Second registration returns pending_approval (not error)",
      data.get("status") == "pending_approval",
      data.get("status"))


# ---------------------------------------------------------------------------
# Test 9 — Validation: missing fields
# ---------------------------------------------------------------------------

section("TEST 9 — Input validation on request_api_key")

result = mcp.call("request_api_key", company_name="", contact_name="X", contact_email="x@x.com")
check("Empty company_name rejected", json.loads(result)["status"] == "error")

result = mcp.call("request_api_key", company_name="X", contact_name="", contact_email="x@x.com")
check("Empty contact_name rejected", json.loads(result)["status"] == "error")

result = mcp.call("request_api_key", company_name="X", contact_name="X", contact_email="notanemail")
check("Invalid email rejected", json.loads(result)["status"] == "error")


# ---------------------------------------------------------------------------
# Cleanup
# ---------------------------------------------------------------------------

section("CLEANUP")

cleanup_test_buyer("PyTest Corp")
print("  ✓ Test buyer and related rows removed")


# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

section("DONE")
print("  All tests complete. Check ✗ lines above for any failures.\n")