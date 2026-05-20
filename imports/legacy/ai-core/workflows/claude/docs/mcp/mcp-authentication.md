# MCP — Authentication

How to configure authentication for MCP servers without committing secrets to the repository.

---

## The Template Pattern (Required)

Never commit real API keys. Use a two-file pattern:

| File | Contains | Committed |
|---|---|---|
| `mcp.json.template` | Structure with placeholder values | Yes |
| `mcp.json` | Real API keys and credentials | No (gitignored) |

`.gitignore` entries:
```
.claude/mcp.json
mcp.json
.credentials.json
```

**Workflow:**
1. Edit `mcp.json.template` with placeholder keys (`YOUR_API_KEY`)
2. Copy to `mcp.json` and replace placeholders with real values
3. Never `git add mcp.json`

---

## API Key via `env`

For `stdio` servers, pass credentials through environment variables:

```json
{
  "obsidian": {
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "@oleksandrkucherenko/mcp-obsidian"],
    "env": {
      "API_KEY": "YOUR_OBSIDIAN_API_KEY",
      "API_URLS": "[\"https://127.0.0.1:27124\"]"
    }
  }
}
```

The `env` object is merged into the child process's environment. Only the specified keys are injected — the full host environment is also inherited.

**Template placeholder convention:** Use `YOUR_<SERVER>_<KEY_TYPE>` as the placeholder value (e.g., `YOUR_OBSIDIAN_API_KEY`, `YOUR_STITCH_API_KEY`). This makes it clear what needs replacing and where to find the real value.

---

## API Key via `headers`

For `http` servers, pass credentials in HTTP headers:

```json
{
  "Stitch": {
    "type": "http",
    "url": "https://stitch.googleapis.com/mcp",
    "headers": {
      "X-Goog-Api-Key": "YOUR_STITCH_API_KEY",
      "Authorization": "Bearer YOUR_BEARER_TOKEN"
    }
  }
}
```

The `headers` object is sent with every HTTP request to the server. Common patterns:
- `X-Api-Key: <key>` — generic API key header
- `Authorization: Bearer <token>` — OAuth Bearer token
- `X-Goog-Api-Key: <key>` — Google APIs

---

## OAuth Flow

Some MCP servers (Google Drive, Gmail, Calendar) use OAuth 2.0. The flow works through two special tools the server exposes:

1. **Start authentication:** call `servername-authenticate` — returns an authorization URL
2. **User visits URL:** completes OAuth consent in browser
3. **Complete authentication:** call `servername-complete_authentication` — exchanges code for token
4. **Token stored:** saved to `.credentials.json` in the session or project directory

Example with Google Drive:

```
User: connect to Google Drive
Claude: [calls mcp__google_drive__authenticate]
→ returns: { "url": "https://accounts.google.com/o/oauth2/auth?..." }
→ User visits URL, grants permission
Claude: [calls mcp__google_drive__complete_authentication with the returned code]
→ Token stored in .credentials.json
```

`.credentials.json` must be gitignored:
```
.credentials.json
```

---

## `mcp-needs-auth-cache.json`

Claude Code maintains `~/.claude/mcp-needs-auth-cache.json` automatically. It records which servers have triggered auth flows, so future sessions know to authenticate before calling those servers.

Structure:
```json
{
  "google-drive": true,
  "gmail": true
}
```

This file is managed by Claude Code — do not edit manually. It is stored in `~/.claude/` (global), not in project directories.

---

## Rotating Credentials

1. Generate the new credential
2. Update `mcp.json` with the new value (not `mcp.json.template`)
3. If using OAuth: delete `.credentials.json` and re-run the auth flow
4. Verify with `/mcp` — server should reconnect

---

## Security Checklist

- [ ] `mcp.json` is in `.gitignore`
- [ ] `mcp.json.template` has placeholder values only (no real keys)
- [ ] `.credentials.json` is in `.gitignore`
- [ ] No secrets appear in `mcp.json.template`
- [ ] API keys are scoped to the minimum required permissions
- [ ] OAuth tokens are stored in `.credentials.json`, not hardcoded

---

## Related

- [mcp/mcp-overview.md](mcp-overview.md) — server types, config structure, tool naming
- [mcp/mcp-servers-catalog.md](mcp-servers-catalog.md) — the 4 configured servers with full config examples
