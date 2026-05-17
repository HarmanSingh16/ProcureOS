# test_register.py
import os
import sys
from pathlib import Path

os.environ["DB_HOST"] = "100.72.202.71"
os.environ["DB_PORT"] = "5432"
os.environ["DB_NAME"] = "procureos_db"
os.environ["DB_USER"] = "kushal"
os.environ["DB_PASSWORD"] = "kushal"

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"

if str(SRC) not in sys.path:
    sys.path.insert(0, str(SRC))

from procureos_mcp.tools.database_tools import register_database_tools

class MockMCP:
    def __init__(self):
        self.tools = {}

    def tool(self):
        def decorator(fn):
            self.tools[fn.__name__] = fn
            return fn
        return decorator

mcp = MockMCP()
register_database_tools(mcp)

request_api_key = mcp.tools["request_api_key"]

result = request_api_key(
    company_name="Test Corp",
    contact_name="Jane Doe",
    contact_email="jane@testcorp.com",
    intended_use="Testing the registration flow"
)
print(result)