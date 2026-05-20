<!-- topic: commands-reference | section: mcp -->
# MCP Commands Reference

## Quick Reference

> - Use `/mcp` inside a Gemini CLI session to inspect and manage connected MCP servers.
> - Use `gemini mcp add` to write MCP server configuration into `settings.json`.
> - `gemini mcp add` defaults to project scope unless `--scope user` is specified.
> - Use `/mcp reload` after configuration changes when you need the current session to reconnect.
> - Use `--include-tools` and `--exclude-tools` to narrow a server's exposed tool set.

## In-Session Slash Commands

Use these commands inside an active Gemini CLI session.

| Command | Description |
|---|---|
| `/mcp` | Show all configured servers, status, tools, resources |
| `/mcp list` | Same as `/mcp` |
| `/mcp auth` | List servers requiring OAuth auth |
| `/mcp auth <serverName>` | Authenticate (or re-authenticate) with a specific server |
| `/mcp enable <name>` | Enable a server for this session |
| `/mcp disable <name>` | Disable a server for this session |
| `/mcp desc` | Show tool descriptions |
| `/mcp schema` | Show tool schemas |
| `/mcp reload` | Reload MCP server connections |

### Command Notes

| Command | Operational note |
|---|---|
| `/mcp` and `/mcp list` | Use these when you need a high-level inventory of configured servers and what each server exposes |
| `/mcp auth` | Use this when a remote MCP server requires OAuth before tools or resources become available |
| `/mcp enable` / `/mcp disable` | Use these for non-destructive session control without rewriting server definitions |
| `/mcp desc` | Use this to inspect human-readable tool descriptions before allowing or calling a tool |
| `/mcp schema` | Use this to inspect parameter schemas when you need exact tool input shapes |
| `/mcp reload` | Use this after editing settings so the current session reconnects and refreshes discovery |

## Terminal CLI Commands

Use these commands in the terminal, outside the in-session slash-command interface.

| Command | Description |
|---|---|
| `gemini mcp add [options] <name> <commandOrUrl> [args...]` | Add a new MCP server to settings.json |
| `gemini mcp list` | List all configured servers with connection status |
| `gemini mcp remove <name> [-s scope]` | Remove a server |
| `gemini mcp enable <name> [--session]` | Enable a disabled server |
| `gemini mcp disable <name> [--session]` | Disable a server (non-destructive) |

### Scope Behavior

`gemini mcp add` defaults to `project` scope, which writes configuration to the project's `.gemini/settings.json`. Use `--scope user` to write to `~/.gemini/settings.json` instead.

The `--session` flag on `gemini mcp enable` and `gemini mcp disable` applies the change only to the current session rather than changing the persistent server definition.

## `gemini mcp add` Flags

| Flag | Description |
|---|---|
| `-s, --scope` | `user` or `project` (default: `"project"`) |
| `-t, --transport` | `stdio`, `sse`, `http` (default: `"stdio"`) |
| `-e, --env` | Set env vars: `-e KEY=value` |
| `-H, --header` | Set HTTP headers |
| `--timeout` | Timeout in ms |
| `--trust` | Trust the server |
| `--include-tools` | Comma-separated allowlist |
| `--exclude-tools` | Comma-separated blocklist |

## Command Examples

### Add a Local Stdio Server

```bash
gemini mcp add my-local-server node /path/to/server.js --timeout 30000
```

### Add a Remote SSE Server

```bash
gemini mcp add --transport sse my-sse-server http://localhost:8080/sse --trust
```

### Add a Remote HTTP Streaming Server with a Header

```bash
gemini mcp add --transport http -H "Authorization: Bearer $TOKEN" my-http-server https://api.example.com/mcp
```

### Inspect MCP Status In Session

```text
/mcp
```

### Reconnect After Changing Configuration

```text
/mcp reload
```

## Command Summary

Use slash commands when the goal is live inspection or session-local control. Use terminal `gemini mcp ...` commands when the goal is to create, remove, or persist MCP server configuration.
