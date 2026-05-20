# MCP Governance

Label: **Security reference** with **repo-specific** conventions

This document covers credential management, trust hierarchy, security controls, and approval policies for MCP servers in Copilot CLI. For server configuration and transport types see [mcp-servers.md](mcp-servers.md).

---

## Credentials management

### Two-file template pattern

This repository uses a committed template file and a gitignored live file:

| File | Committed | Contains |
|---|---|---|
| `mcp-config.template copy.json` | **Yes** | Placeholder values only — no real credentials |
| `mcp-config.json` | **No** (gitignored) | Real API keys and tokens — never committed |

The template file documents server structure and required fields. Anyone setting up the configuration copies the template, renames it to `mcp-config.json`, and fills in real values locally.

### `.gitignore` requirements

At minimum, these entries must be present:

```
mcp-config.json
.credentials.json
```

Verify with `git check-ignore -v mcp-config.json` before committing any config changes.

### Placeholder convention

Template placeholders follow the pattern `YOUR_<SERVER>_<KEY>`:

```json
{
  "mcpServers": {
    "obsidian": {
      "command": "npx",
      "args": ["-y", "mcp-obsidian"],
      "env": {
        "OBSIDIAN_API_KEY": "YOUR_OBSIDIAN_API_KEY"
      }
    }
  }
}
```

This makes it immediately obvious which values need substitution and which server they belong to.

### OAuth tokens

OAuth tokens for servers configured with an OAuth flow are stored in the `~/.copilot/` area and managed by the CLI. Do not edit them manually. To re-authenticate, use:

```
/mcp auth SERVER-NAME
```

### Credential rotation workflow

1. Update the real value in `mcp-config.json`.
2. If the server uses OAuth, re-run the OAuth flow: `/mcp auth SERVER-NAME`.
3. Verify the server is reachable and tools are listed: `/mcp show SERVER-NAME`.
4. If the template placeholder label needs updating (e.g. key name changed), update `mcp-config.template copy.json` — placeholder value only, never the real key.

---

## Trust hierarchy

The CLI assigns trust levels to MCP servers based on where they are configured. Higher trust means fewer confirmation prompts and broader tool execution permissions.

| Trust level | Source | Notes |
|---|---|---|
| **Built-in** | Ships with the CLI runtime | Fully trusted; no extra vetting required |
| **Repository** | `.github/mcp.json` | Scoped to the repo; useful for team-wide tools |
| **Workspace** | `.mcp.json` in working directory | Scoped to the local workspace |
| **User config** | `~/.copilot/mcp-config.json` | Personal servers; applies across all sessions |
| **Remote** | Configured via URL transport | Lowest implicit trust; vet before adding |

Servers at lower trust levels may require explicit confirmation before tool calls execute in certain policy environments.

### Enterprise allowlist enforcement

In enterprise-managed environments, non-default MCP servers must be explicitly allowlisted by an enterprise administrator before they can be used. A server that works in a personal setup may be silently blocked under enterprise policy. Always check allowlist status when designing team-wide MCP configurations.

### Per-server tool filtering

Use `enabledTools` in the server configuration to limit which tools from a server are exposed to the agent:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed/directory"],
      "enabledTools": ["read_file", "list_directory"]
    }
  }
}
```

This restricts the agent to read-only operations even if the server exposes write tools.

---

## Security controls

### Environment variable injection

The `env` block in a server configuration is **explicit consent** — only the listed variables are passed to the server subprocess. Variables not listed are not inherited from the parent process.

```json
"env": {
  "API_KEY": "YOUR_API_KEY"
}
```

Treat this block as a minimal allowlist. Do not pass broad environment variables (e.g. `HOME`, `PATH`) unless the server requires them.

### Avoiding hardcoded secrets

Never place real credentials in `mcp-config.template copy.json`. The template is committed and visible in version history. If a real key is accidentally committed:

1. Rotate the key immediately — treat it as compromised.
2. Remove the secret from git history (rebase or `git filter-repo`).
3. Audit whether the key was exposed in any CI/CD logs.

### OAuth flow vs API keys

| Approach | Use when |
|---|---|
| **OAuth flow** | Server supports it — tokens are scoped, short-lived, and rotatable without editing config files |
| **API keys** | OAuth is not available — store only in `mcp-config.json`, scope to minimum required permissions, set an expiry if the service supports it |

Prefer OAuth where available. API keys are static credentials and rotation is a manual operation.

### Server vetting checklist before adding

Before adding any new MCP server:

1. Check the server's origin: is it from a trusted publisher or official GitHub organization?
2. Review its license and source code if available.
3. Identify which tools it exposes and what data it can access.
4. Confirm the trust level it will receive given where you configure it.
5. Apply `enabledTools` to restrict access to only what the workflow actually needs.

### Scope principle

Prefer `enabledTools` over full server access. The agent only needs the tools relevant to the workflow. Unrestricted tool access from a server with broad permissions increases the blast radius of a misconfigured prompt or a compromised session.

---

## Approval policies

### When to trust a server

A server is ready to add when:

- Its origin is verified (official publisher, known open-source project, or internal team ownership)
- Its exposed tools are understood and scoped with `enabledTools`
- Credentials are stored in `mcp-config.json` only, with the template updated to placeholder values
- Enterprise allowlist status is confirmed if operating in a managed environment

### Review process before adding a new server

1. Identify the need — which workflow requires a capability not available in built-in tools?
2. Find the server — marketplace, official MCP registry, or internal source.
3. Vet origin, license, and tool surface (see checklist above).
4. Add to `mcp-config.json` with `enabledTools` restricted to minimum needed.
5. Update `mcp-config.template copy.json` with the new server block using placeholder values.
6. Verify with `/mcp show SERVER-NAME` that tools appear as expected.
7. Test the workflow before relying on the server for production use.

### Enterprise context

Enterprise allowlist enforcement is opaque — there is no in-CLI indicator that a server has been blocked by policy until a tool call fails. If deploying MCP configurations for a team, confirm with the enterprise admin that required servers are on the allowlist before distributing the configuration.

---

## Security checklist

Run this checklist before committing any MCP configuration changes:

```
- [ ] mcp-config.json is gitignored
- [ ] mcp-config.template copy.json has placeholder values only (no real keys)
- [ ] .credentials.json is gitignored
- [ ] No secrets in template files
- [ ] API keys scoped to minimum required permissions
- [ ] New servers vetted for trustworthiness (origin, license, tool surface)
- [ ] Tool access restricted to minimum needed (enabledTools applied)
```

---

## Repo examples

- [mcp-config.template copy.json](../../mcp-config.template%20copy.json) — committed template with placeholder values; use as the starting point for local setup
- [mcp-config.json](../../mcp-config.json) — gitignored live configuration (will not exist in a fresh clone; create from the template)

---

## Sources

- [Adding MCP servers for GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers)
- [GitHub Copilot CLI configuration directory reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference)
- [MCP server configuration overview — this repo](mcp-servers.md)
