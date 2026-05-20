<!-- topic: configuration | section: mcp -->
# MCP Configuration Reference

## Quick Reference

> - Configure MCP servers under the top-level `mcpServers` object in `settings.json`.
> - Use exactly one transport key per server: `command`, `url`, or `httpUrl`.
> - Do not use underscores in server names; use `my-server`, not `my_server`.
> - `excludeTools` overrides `includeTools` for the same server.
> - The separate top-level `mcp` block filters which configured servers Gemini CLI connects to.

## `mcpServers` Object

`mcpServers` is a top-level object in `settings.json`. Each property name is a server name, and each property value is a server configuration object.

```json
{
  "mcpServers": {
    "server-name": {
      "command": "node",
      "args": ["/path/to/server.js"]
    }
  }
}
```

### Server Naming Rule

Do not use underscores in server names. Use `my-server`, not `my_server`.

This is a hard operational constraint for Gemini CLI's MCP integration. The policy parser splits fully qualified MCP tool names on the first underscore after the `mcp_` prefix, so underscores inside the server name can make tool policy parsing ambiguous.

### Transport Selection Rule

A server object is interpreted by its transport key:

| If this key is present | Gemini CLI uses |
|---|---|
| `httpUrl` | Streamable HTTP |
| `url` | SSE |
| `command` | Stdio |

If more than one transport key is present, Gemini CLI resolves in that precedence order. Define exactly one transport key per server for predictable behavior.

## Stdio Server Fields

Use a stdio server when Gemini CLI should spawn a subprocess and communicate through stdin and stdout.

| Field | Type | Required | Default | Description |
|---|---|---|---|---|
| `command` | string | Yes | — | Executable path |
| `args` | string[] | No | `[]` | CLI arguments |
| `env` | object | No | `{}` | Env vars; supports `$VAR`, `${VAR}`, `${VAR:-default}`, `%VAR%` |
| `cwd` | string | No | — | Working directory |
| `timeout` | number | No | `600000` | Request timeout ms (10 min) |
| `trust` | boolean | No | `false` | Bypass ALL confirmation dialogs |
| `includeTools` | string[] | No | — | Tool allowlist |
| `excludeTools` | string[] | No | — | Tool blocklist (takes precedence over includeTools) |

### Stdio Example

```json
{
  "mcpServers": {
    "my-local-server": {
      "command": "node",
      "args": ["/path/to/server.js"],
      "env": {
        "MY_KEY": "$MY_ENV_VAR"
      },
      "cwd": "/path/to/project",
      "timeout": 30000,
      "includeTools": ["search", "fetch"]
    }
  }
}
```

## SSE Server Fields

Use an SSE server when Gemini CLI should connect to a Server-Sent Events endpoint.

| Field | Type | Required | Default | Description |
|---|---|---|---|---|
| `url` | string | Yes | — | SSE endpoint URL |
| `headers` | object | No | `{}` | Custom HTTP headers |
| `timeout` | number | No | `600000` | Request timeout ms |
| `trust` | boolean | No | `false` | Bypass confirmations |
| `includeTools` | string[] | No | — | Tool allowlist |
| `excludeTools` | string[] | No | — | Tool blocklist |
| `authProviderType` | string | No | `"dynamic_discovery"` | Auth provider type |
| `oauth` | object | No | — | OAuth config block |

### SSE Example

```json
{
  "mcpServers": {
    "my-sse-server": {
      "url": "http://localhost:8080/sse",
      "headers": {
        "Authorization": "Bearer $TOKEN"
      },
      "trust": true
    }
  }
}
```

## HTTP Streaming Server Fields

Use an HTTP streaming server when Gemini CLI should connect to a streamable HTTP endpoint.

| Field | Type | Required | Default | Description |
|---|---|---|---|---|
| `httpUrl` | string | Yes | — | HTTP streaming URL |
| `headers` | object | No | `{}` | Custom HTTP headers |
| `timeout` | number | No | `600000` | Request timeout ms |
| `trust` | boolean | No | `false` | Bypass confirmations |
| `includeTools` | string[] | No | — | Tool allowlist |
| `excludeTools` | string[] | No | — | Tool blocklist |
| `authProviderType` | string | No | `"dynamic_discovery"` | `"google_credentials"` or `"service_account_impersonation"` |
| `targetAudience` | string | No | — | IAP OAuth Client ID |
| `targetServiceAccount` | string | No | — | SA email to impersonate |

### HTTP Streaming Example

```json
{
  "mcpServers": {
    "my-http-server": {
      "httpUrl": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer $TOKEN"
      }
    }
  }
}
```

## OAuth Config Block

The `oauth` object is nested inside an SSE or HTTP streaming server configuration when OAuth is required.

| Field | Type | Required | Description |
|---|---|---|---|
| `enabled` | boolean | Yes | Enable OAuth |
| `clientId` | string | No | Optional with dynamic registration |
| `clientSecret` | string | No | Optional for public clients |
| `authorizationUrl` | string | No | Auto-discovered if omitted |
| `tokenUrl` | string | No | Auto-discovered if omitted |
| `scopes` | string[] | No | OAuth scopes |
| `redirectUri` | string | No | Default: `http://localhost:<random>/oauth/callback` |
| `tokenParamName` | string | No | Query param name for tokens in SSE URLs |
| `audiences` | string[] | No | — |

### OAuth Example

```json
{
  "mcpServers": {
    "my-oauth-server": {
      "url": "https://example.com/sse",
      "oauth": {
        "enabled": true,
        "clientId": "client-id",
        "scopes": ["read", "write"]
      }
    }
  }
}
```

## Global `mcp` Block

The top-level `mcp` block is separate from `mcpServers`. It controls global MCP connection behavior rather than the details of an individual server definition.

```json
{
  "mcp": {
    "serverCommand": "string",
    "allowed": [],
    "excluded": []
  }
}
```

| Field | Type | Description |
|---|---|---|
| `serverCommand` | string | Global command to start an MCP server |
| `allowed` | string[] | Only connect to servers with these names |
| `excluded` | string[] | Never connect to servers with these names |

## Complete Example Configuration

```json
{
  "mcpServers": {
    "my-local-server": {
      "command": "node",
      "args": ["/path/to/server.js"],
      "env": {"MY_KEY": "$MY_ENV_VAR"},
      "timeout": 30000
    },
    "my-sse-server": {
      "url": "http://localhost:8080/sse",
      "trust": true
    },
    "my-http-server": {
      "httpUrl": "https://api.example.com/mcp",
      "headers": {"Authorization": "Bearer $TOKEN"}
    }
  }
}
```

## Configuration Notes

### Environment Variable Expansion

String values in MCP configuration support environment variable expansion. Supported forms include `$VAR`, `${VAR}`, `${VAR:-default}`, and `%VAR%`.

Use expansion instead of hardcoding secrets directly into `settings.json`.

### Tool Filtering

`includeTools` narrows a server to a specific allowlist of tool names. `excludeTools` removes tool names even if they also appear in `includeTools`.

The precedence rule is simple: if a tool name appears in `excludeTools`, it is blocked for that server.
