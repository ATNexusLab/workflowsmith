<!-- topic: manifest-schema | section: extensions -->
# Extension Manifest Schema

`gemini-extension.json` is the manifest file Gemini CLI reads from an extension directory to discover bundled features, metadata, and runtime wiring.

## Quick Reference

> - Put `gemini-extension.json` at the root of an extension directory.
> - All top-level bundle fields are optional except `name`.
> - `mcpServers` uses the same shape as `settings.json`, but bundled servers cannot declare `trust`.
> - `${extensionPath}`, `${workspacePath}`, and `${/}` are substituted at runtime.
> - Slash command name conflicts fall back to `/<extensionName>.<commandname>`.

## Top-Level Fields

| Field | Type | Required | Description |
|---|---|---|---|
| `name` | string | Yes | Extension display name |
| `version` | string | No | Semantic version string |
| `description` | string | No | Human-readable description |
| `mcpServers` | object | No | MCP server configs (same schema as `settings.json` `mcpServers`, except `trust` not allowed) |
| `contextFileName` | string or string[] | No | Override default `GEMINI.md` filename (`"AGENTS.md"`, `"CONTEXT.md"`, etc.) |
| `slashCommands` | array | No | Custom slash command definitions |
| `hooks` | object | No | Hook configuration object (points to hooks file) |
| `skills` | array | No | Bundled skill definitions |
| `themes` | array | No | Bundled theme definitions |
| `agents` | array | No | Bundled agent definitions (preview) |
| `policies` | object | No | Configuration constraints |

## Manifest Variables

Gemini CLI substitutes the following variables at runtime inside manifest values.

| Variable | Resolves to |
|---|---|
| `${extensionPath}` | Absolute path to the extension directory |
| `${workspacePath}` | Absolute path to the current workspace root |
| `${/}` | Platform-specific path separator (`/` on Unix, `\` on Windows) |

### Portability Guidance

Use manifest variables anywhere a path would otherwise need to be absolute. This keeps the extension relocatable across machines and operating systems.

## `slashCommands` Entry Schema

Each entry in `slashCommands` defines one custom slash command exposed by the extension.

| Field | Type | Required | Description |
|---|---|---|---|
| `name` | string | Yes | Command name (without `/`) |
| `description` | string | No | Help text shown in `/help` |
| `handler` | object | Yes | Handler config |

### Handler Types

Two handler shapes are supported.

- `{"type": "prompt", "prompt": "string"}` — injects a prompt template.
- `{"type": "script", "command": "string", "args": [...]}` — runs a script and injects output.

## `hooks` Object

Use the `hooks` object to point Gemini CLI at the hook definition file bundled with the extension.

```json
{
  "hooks": {
    "hooksFile": "${extensionPath}/hooks/hooks.json"
  }
}
```

## Slash Command Conflict Resolution

Extension commands register as `/commandname` by default.

If an extension command name conflicts with a project command or a user command, Gemini CLI rewrites the extension command to `/<extensionName>.<commandname>`.

Conflict precedence is `extension commands < project commands < user commands`.

In practice, the higher-precedence source keeps the plain command name and the extension command receives the prefix.

## `mcpServers` Tool Filtering Merge Rules

When `mcpServers` tool filters are combined with user overrides, Gemini CLI resolves them conservatively.

- `excludeTools` arrays are **unioned**.
- `includeTools` arrays are **intersected**.

Both rules mean the most restrictive result wins.

## Complete Example Manifest

```json
{
  "name": "my-dev-tools",
  "version": "1.0.0",
  "description": "Development toolkit for Go projects",
  "mcpServers": {
    "go-tools": {
      "command": "${extensionPath}${/}bin${/}go-tools-server",
      "args": ["--workspace", "${workspacePath}"],
      "timeout": 30000
    }
  },
  "slashCommands": [
    {
      "name": "test-all",
      "description": "Run all tests",
      "handler": {
        "type": "script",
        "command": "${extensionPath}${/}scripts${/}test.sh",
        "args": ["${workspacePath}"]
      }
    }
  ],
  "hooks": {
    "hooksFile": "${extensionPath}/hooks/hooks.json"
  }
}
```
