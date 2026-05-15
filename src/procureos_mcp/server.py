from mcp.server.fastmcp import FastMCP

from procureos_mcp.tools.database_tools import register_database_tools

mcp = FastMCP("ProcureOS_B2B_Agent")

register_database_tools(mcp)

if __name__ == "__main__":
	mcp.run()
