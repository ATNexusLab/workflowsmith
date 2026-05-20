# MCP — Overview

MCP (Model Context Protocol) is the extension protocol that lets Claude Code call external tools — browser automation, file system APIs, web services, databases, and anything else that exposes an MCP server. Each MCP server adds new tools to Claude's tool list under a `servername-toolname` naming convention.

---

## Configuration

MCP servers are configured in JSON files at two scopes:

| File | Scope |
|---|---|
| `~/.claude/mcp.json` | Global — all sessions |
| `.claude/mcp.json` | Project-local — this repo only |

Project-local config overrides global when the same server name appears in both.

**Important:** Real credentials and API keys must never be committed. Use `mcp.json.template` (committed, safe) alongside `mcp.json` (gitignored, holds real keys). See [mcp-authentication.md](mcp-authentication.md).

---

## Config Structure

```json
{
  "mcpServers": {
    "<server-name>": {
      "type": "stdio | http",
      ...server-specific fields...
    }
  }
}
```

The server name becomes the prefix for all tools that server exposes:
- Server `playwright` + tool `browser_navigate` → invoked as `playwright-browser_navigate`
- Server `obsidian` + tool `get_note_content` → invoked as `obsidian-get_note_content`

---

## Server Types

### `stdio`

Claude spawns a local process and communicates over stdin/stdout:

```json
{
  "type": "stdio",
  "command": "npx",
  "args": ["-y", "@playwright/mcp@0.0.71"],
  "env": {
    "OPTIONAL_VAR": "value"
  },
  "tools": ["browser_navigate", "browser_click"]
}
```

| Field | Description |
|---|---|
| `type` | `"stdio"` |
| `command` | Executable to spawn (`node`, `npx`, `python`, etc.) |
| `args` | Arguments to pass to the command |
| `env` | Environment variables injected into the child process |
| `tools` | Tool allowlist — `["*"]` allows all tools from this server |

Use `stdio` for: local CLI tools, Node.js/Python packages, any server you control.

---

### `http`

Claude makes HTTP POST requests to a remote server:

```json
{
  "type": "http",
  "url": "https://stitch.googleapis.com/mcp",
  "headers": {
    "X-Goog-Api-Key": "YOUR_API_KEY"
  },
  "tools": ["*"]
}
```

| Field | Description |
|---|---|
| `type` | `"http"` |
| `url` | The MCP server endpoint |
| `headers` | HTTP headers sent with every request (authentication, etc.) |
| `tools` | Tool allowlist |

Use `http` for: remote APIs, hosted MCP servers, cloud services.

---

## Tool Allowlist

The `tools` field filters which tools from a server Claude can call:

```json
"tools": ["*"]                            // All tools
"tools": ["browser_navigate", "browser_click"]  // Specific tools only
```

Restricting the allowlist reduces the tool surface and prevents accidental use of destructive tools (e.g., allowing only read operations from a database server).

---

## `mcp-needs-auth-cache.json`

Claude Code maintains a cache file at `~/.claude/mcp-needs-auth-cache.json` that records which MCP servers require authentication. When an `http` server returns a 401 or triggers an OAuth flow, Claude records it here so future sessions know to authenticate first.

---

## Connecting to MCP Servers in a Session

Run `/mcp` inside a session to see connected servers and their status. Each server listed shows:
- Connection status (connected / disconnected / error)
- Available tools
- Authentication state

---

## Related

- [mcp/mcp-servers-catalog.md](mcp-servers-catalog.md) — all 4 configured MCP servers
- [mcp/mcp-authentication.md](mcp-authentication.md) — API keys, OAuth, secrets handling
- [tools/built-in-tools.md](../tools/built-in-tools.md) — built-in tools vs MCP tools
