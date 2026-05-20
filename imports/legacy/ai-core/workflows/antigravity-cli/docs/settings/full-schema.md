<!-- topic: full-schema | section: settings -->
# Settings JSON Full Schema

## Quick Reference

> - `settings.json` is a layered configuration file; every key is optional.
> - Unset keys fall through to lower-precedence layers or documented defaults.
> - Add `"$schema"` for IDE validation and autocomplete.
> - `mcpServers` is a named map of server definitions; `mcp` controls global MCP connection policy.
> - Use this file as the authoritative field reference for the documented settings surface.

## Settings JSON Shape

The documented top-level structure is:

```json
{
  "$schema": "...",
  "theme": "string",
  "model": "string",
  "sandbox": {...},
  "auth": {...},
  "vertexai": {...},
  "general": {...},
  "generationConfig": {...},
  "mcpServers": {...},
  "mcp": {...},
  "hooksConfig": {...},
  "extensions": {...},
  "security": {...},
  "telemetry": {...},
  "bugCommand": "string"
}
```

All top-level keys are optional. If a key is omitted, Gemini CLI uses the next lower precedence layer or the documented default.

## Top-Level Object Fields

| Field | Type | Default | Description |
|---|---|---|---|
| `sandbox` | object | — | Sandbox configuration block |
| `auth` | object | — | Authentication configuration block |
| `vertexai` | object | — | Vertex AI configuration block |
| `general` | object | — | General runtime behavior block |
| `generationConfig` | object | — | Model sampling and output-control block |
| `mcpServers` | object | `{}` | Named map of MCP server definitions |
| `mcp` | object | — | Global MCP connection policy block |
| `hooksConfig` | object | — | Global hooks enablement block |
| `extensions` | object | — | Extension loading block |
| `security` | object | — | Security guardrail block |
| `telemetry` | object | — | Telemetry configuration block |

## Root Scalar Fields

| Field | Type | Default | Description |
|---|---|---|---|
| `$schema` | string | — | JSON Schema URL for editor validation and autocomplete |
| `theme` | string | `"default"` | Active color theme; built-in: `"default"`, `"dark"`, `"light"`, `"solarized"`, `"dracula"` |
| `model` | string | `"gemini-2.5-pro"` | Active Gemini model |
| `bugCommand` | string | — | Shell command to invoke for the `/bug` slash command |

## `sandbox` Block

The `sandbox` object controls whether Gemini CLI runs commands inside a restricted execution environment.

| Field | Type | Default | Description |
|---|---|---|---|
| `sandbox` | boolean \| string | `false` | Enable sandbox: `true` = auto-detect; `"docker"` = force Docker; `"macos-seatbelt"` = force macOS sandbox |
| `dockerImage` | string | `"gemini-cli-sandbox:latest"` | Docker image for sandbox |
| `dockerVolumes` | object | `{}` | Map of host path → container path to mount |
| `allowedPaths` | string[] | `[]` | Paths accessible in sandbox environment; equivalent in effect to `tools.sandboxAllowedPaths` |

## `auth` Block

The `auth` object chooses how Gemini CLI authenticates to Gemini services.

| Field | Type | Default | Description |
|---|---|---|---|
| `type` | string | `"apiKey"` | Auth type: `"apiKey"`, `"oauth-personal"`, `"oauth-service-account"`, `"vertex-ai"` |
| `serviceAccountKeyPath` | string | — | Path to a service account JSON file when `type` is `"oauth-service-account"` |

## `vertexai` Block

The `vertexai` object configures Google Cloud Vertex AI usage.

| Field | Type | Default | Description |
|---|---|---|---|
| `project` | string | — | Google Cloud project ID |
| `location` | string | `"us-central1"` | Google Cloud region |
| `express` | boolean | `false` | Use Vertex AI Express mode |

## `general` Block

The `general` object holds session-wide behavior that does not fit a more specific subsystem.

| Field | Type | Default | Description |
|---|---|---|---|
| `autoAcceptedEditCount` | number | `0` | Auto-accept edit suggestions up to this many times per session; `0` disables the behavior |
| `project` | object | — | Project-level general settings container |
| `plan` | object | — | Plan mode settings |

### `general.plan` Block

| Field | Type | Default | Description |
|---|---|---|---|
| `enabled` | boolean | `false` | Enable plan mode by default |
| `modelRouting` | boolean | `false` | Use Pro during planning and Flash after approval |

## `generationConfig` Block

The `generationConfig` object tunes model sampling and output limits.

| Field | Type | Default | Description |
|---|---|---|---|
| `temperature` | number | — | Sampling temperature from `0.0` to `2.0` |
| `topP` | number | — | Nucleus sampling threshold |
| `topK` | number | — | Top-K token limit |
| `maxOutputTokens` | number | — | Maximum response tokens |
| `candidateCount` | number | `1` | Number of response candidates |
| `stopSequences` | string[] | `[]` | Sequences that halt generation |
| `thinkingBudget` | number | — | Maximum thinking-token budget for thinking-capable models |

## `mcpServers` Block

`mcpServers` is a named map of MCP server definitions. Each property name is the server name, and each property value is one server configuration object.

```json
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["/path/to/server.js"]
    }
  }
}
```

### `mcpServers.<name>` Server Object

Use exactly one transport selector per server: `command`, `url`, or `httpUrl`.

| Field | Type | Default | Description |
|---|---|---|---|
| `command` | string | — | Start the MCP server as a stdio subprocess |
| `args` | string[] | `[]` | Command arguments for stdio transport |
| `env` | object | `{}` | Environment variables passed to the stdio server |
| `cwd` | string | — | Working directory for the stdio server |
| `url` | string | — | SSE endpoint URL |
| `httpUrl` | string | — | Streamable HTTP endpoint URL |
| `headers` | object | `{}` | Custom HTTP headers for SSE or HTTP transport |
| `timeout` | number | `600000` | Request timeout in milliseconds |
| `trust` | boolean | `false` | Skip confirmation prompts for tools from this server |
| `includeTools` | string[] | — | Allowlist of tool names exposed from this server |
| `excludeTools` | string[] | — | Blocklist of tool names exposed from this server; takes precedence over `includeTools` |
| `authProviderType` | string | `"dynamic_discovery"` | Auth provider type for remote transports |
| `oauth` | object | — | OAuth configuration block for authenticated remote transports |
| `targetAudience` | string | — | IAP OAuth client ID for HTTP transport |
| `targetServiceAccount` | string | — | Service account email to impersonate for HTTP transport |

### `mcpServers.<name>.oauth` Block

| Field | Type | Default | Description |
|---|---|---|---|
| `enabled` | boolean | — | Enable OAuth for the server |
| `clientId` | string | — | OAuth client ID |
| `clientSecret` | string | — | OAuth client secret for confidential clients |
| `authorizationUrl` | string | — | Authorization endpoint; auto-discovered when omitted |
| `tokenUrl` | string | — | Token endpoint; auto-discovered when omitted |
| `scopes` | string[] | — | OAuth scopes |
| `redirectUri` | string | — | Redirect URI; defaults to a local callback URL when omitted |
| `tokenParamName` | string | — | Query-string parameter name for tokens in SSE URLs |
| `audiences` | string[] | — | Audience values used by the OAuth flow |

## `mcp` Block

The `mcp` object applies global connection policy across all configured MCP servers.

| Field | Type | Default | Description |
|---|---|---|---|
| `serverCommand` | string | — | Global MCP server start command |
| `allowed` | string[] | — | Only connect to servers with these names |
| `excluded` | string[] | — | Never connect to servers with these names |

## `hooksConfig` Block

The `hooksConfig` object enables or disables the hook system globally.

| Field | Type | Default | Description |
|---|---|---|---|
| `enabled` | boolean | `true` | Master switch for all hooks |
| `notifications` | boolean | `true` | Show a visual indicator when hooks run |

## `extensions` Block

The `extensions` object controls extension loading.

| Field | Type | Default | Description |
|---|---|---|---|
| `disabled` | string[] | `[]` | Extension names to skip loading |

## `security` Block

The `security` object holds guardrails that restrict risky runtime modes.

| Field | Type | Default | Description |
|---|---|---|---|
| `disableYoloMode` | boolean | `false` | Prevent YOLO mode from being enabled through the `--yolo` flag |

## `telemetry` Block

The `telemetry` object controls whether Gemini CLI emits usage telemetry and where that data goes.

| Field | Type | Default | Description |
|---|---|---|---|
| `enabled` | boolean | `true` | Enable telemetry data collection |
| `target` | string | `"google"` | Telemetry destination; use `"google"` for the default pipeline or pair a custom collector with `otlpEndpoint` |
| `otlpEndpoint` | string | — | Custom OpenTelemetry collector endpoint |
| `logPrompts` | boolean | `false` | Include prompts in telemetry payloads |

## Full Example `settings.json`

```json
{
  "$schema": "https://raw.githubusercontent.com/google-gemini/gemini-cli/main/schemas/settings.schema.json",
  "theme": "dark",
  "model": "gemini-2.5-pro",
  "generationConfig": {
    "temperature": 0.7,
    "thinkingBudget": 8192
  },
  "hooksConfig": {
    "enabled": true,
    "notifications": true
  },
  "security": {
    "disableYoloMode": false
  },
  "telemetry": {
    "enabled": false
  },
  "sandbox": {
    "sandbox": false
  },
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["/path/to/server.js"],
      "trust": false
    }
  }
}
```
