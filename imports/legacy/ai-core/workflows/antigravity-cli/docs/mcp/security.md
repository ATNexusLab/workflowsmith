<!-- topic: security | section: mcp -->
# MCP Security

## Quick Reference

> - Untrusted MCP servers require confirmation for every tool call by default.
> - Setting `"trust": true` trusts every tool from that server and bypasses all confirmations.
> - Gemini CLI redacts sensitive inherited environment variables before launching stdio servers.
> - Explicit variables in a server's `env` block bypass redaction by informed consent.
> - OAuth tokens and server enablement state are stored under `~/.gemini/`.

## Trust Model

Gemini CLI applies a three-level trust model to MCP tool execution.

| Trust level | How it works |
|---|---|
| Untrusted | Default behavior. Every tool call requires user confirmation |
| Server-trusted | `"trust": true` on the server config bypasses every confirmation for that server |
| Tool-level allow-lists | A user can promote an individual tool or an entire server during the session |

### 1. Untrusted Servers

Untrusted is the default state. When a tool from an untrusted MCP server is about to run, Gemini CLI asks for confirmation.

The confirmation flow presents these choices:

- Proceed once
- Always allow this tool
- Always allow this server
- Cancel

This default protects against silent execution from newly added or only partially trusted MCP servers.

### 2. Server-Trusted Configuration

Setting `"trust": true` on a server configuration marks the entire server as trusted.

```json
{
  "mcpServers": {
    "my-server": {
      "url": "https://example.com/sse",
      "trust": true
    }
  }
}
```

When a server is trusted this way, Gemini CLI bypasses all confirmation dialogs for every tool exposed by that server. Use this only for servers you fully control or fully trust.

### 3. Tool-Level Allow-Lists

Gemini CLI also supports dynamic trust promotion inside the session. A user can allow a single tool or promote the entire server from the confirmation dialog without editing configuration first.

This mechanism is narrower than `"trust": true` when only one or two tools are safe to use repeatedly during the current session.

## Environment Variable Redaction

When Gemini CLI spawns a stdio MCP server subprocess, it automatically redacts sensitive values from the inherited environment.

### Redacted Key Classes

| Pattern class | Examples |
|---|---|
| Core API key names | `GEMINI_API_KEY`, `GOOGLE_API_KEY` |
| Sensitive name patterns | `*TOKEN*`, `*SECRET*`, `*PASSWORD*`, `*KEY*`, `*AUTH*`, `*CREDENTIAL*` |
| Private key and certificate patterns | Certificate and private-key style variables |

The redaction happens before the subprocess starts, so the server does not automatically inherit the user's full shell environment.

## Explicit `env` Override

If a variable is explicitly listed in the server's `env` block, Gemini CLI treats that as informed consent and passes it through even if it would otherwise match redaction rules.

```json
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["server.js"],
      "env": {
        "MY_API_KEY": "$MY_API_KEY"
      }
    }
  }
}
```

This is the recommended way to share a secret with a server: reference an existing environment variable through expansion instead of hardcoding the value into `settings.json`.

## OAuth Token Storage

Gemini CLI stores MCP OAuth tokens at:

```text
~/.gemini/mcp-oauth-tokens.json
```

Tokens are automatically refreshed when they expire, so the file acts as the local persistence layer for MCP OAuth sessions.

## Server Enablement State

Gemini CLI stores MCP server enablement state at:

```text
~/.gemini/mcp-server-enablement.json
```

This file tracks whether configured servers are currently enabled or disabled from the CLI's point of view.

## Sandbox Considerations

When sandboxing is enabled, MCP servers must be reachable from inside the sandbox environment.

### Practical Implications

- A local stdio server must be executable inside the sandbox.
- A remote server must be network-reachable from the sandbox.
- File paths needed by a server must be visible inside the sandbox.

### Common Pattern

Docker-based MCP servers are a common solution because they package the runtime and dependencies in a predictable environment.

### Path Access

Use `tools.sandboxAllowedPaths` to grant sandbox access to directories an MCP server needs to read or execute from.

## Security Summary

The MCP security model is based on explicit trust, constrained inheritance, and auditable local state. By default, Gemini CLI assumes an MCP server should not execute tools silently, and it assumes sensitive environment data should not be passed through unless the user configures it deliberately.
