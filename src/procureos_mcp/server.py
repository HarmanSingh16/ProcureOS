"""ProcureOS MCP server entrypoint."""

from mcp.server.fastmcp import FastMCP

from procureos_mcp.tools.database_tools import register_database_tools

mcp = FastMCP("procureos-db-server")

register_database_tools(mcp)


def main() -> None:
    """Run the ProcureOS MCP server."""
    mcp.run()


if __name__ == "__main__":
    main()