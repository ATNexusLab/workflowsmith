# MCP Servers Catalog

All 4 MCP servers configured in `~/.claude/mcp.json.template`. Each section shows the full config, available tools, and usage notes.

---

## Stitch (Google)

**Type:** `http`
**Purpose:** Google's Stitch service — data integration and workflow automation via Google's MCP gateway.

```json
{
  "Stitch": {
    "tools": ["*"],
    "type": "http",
    "url": "https://stitch.googleapis.com/mcp",
    "headers": {
      "X-Goog-Api-Key": "YOUR_STITCH_API_KEY"
    }
  }
}
```

**Authentication:** API key in `X-Goog-Api-Key` header. Replace `YOUR_STITCH_API_KEY` with a real key in `mcp.json` (not committed).

**Tools:** All tools exposed by the server (`"*"`). Actual tool list depends on your Stitch configuration.

**When to use:** Automating Google Workspace workflows, connecting to Google data sources, triggering Stitch pipelines from Claude Code.

---

## React-Bit (shadcn)

**Type:** `stdio`
**Purpose:** shadcn component library integration — browse, preview, and scaffold shadcn/ui components directly from Claude Code.

```json
{
  "React-Bit": {
    "tools": ["*"],
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "shadcn@4.6.0", "mcp"]
  }
}
```

**Authentication:** None required — runs locally via npx.

**Version pinned:** `shadcn@4.6.0` — pin version to avoid breaking changes from auto-upgrades.

**Available tools (examples):**
- Component search and browsing
- Component scaffolding into the project
- Preview generation

**When to use:** Building UIs with shadcn/ui components, scaffolding Tailwind-based component code, looking up component APIs.

---

## Playwright

**Type:** `stdio`
**Purpose:** Browser automation — navigate, click, fill forms, take screenshots, handle dialogs, monitor network requests. Used for E2E testing, web scraping, and UI verification.

```json
{
  "Playwright": {
    "tools": [
      "browser_snapshot",
      "browser_navigate",
      "browser_navigate_back",
      "browser_click",
      "browser_type",
      "browser_fill_form",
      "browser_select_option",
      "browser_press_key",
      "browser_wait_for",
      "browser_take_screenshot",
      "browser_tabs",
      "browser_resize",
      "browser_close",
      "browser_drag",
      "browser_drop",
      "browser_hover",
      "browser_handle_dialog",
      "browser_network_requests",
      "browser_console_messages"
    ],
    "type": "stdio",
    "command": "npx",
    "args": ["-y", "@playwright/mcp@0.0.71"]
  }
}
```

**Authentication:** None — runs locally.

**Version pinned:** `@playwright/mcp@0.0.71`.

**Tool reference:**

| Tool | Purpose |
|---|---|
| `browser_snapshot` | Capture accessibility tree snapshot |
| `browser_navigate` | Navigate to a URL |
| `browser_navigate_back` | Go back in browser history |
| `browser_click` | Click an element |
| `browser_type` | Type text into an element |
| `browser_fill_form` | Fill a form with multiple fields |
| `browser_select_option` | Select a dropdown option |
| `browser_press_key` | Press a keyboard key |
| `browser_wait_for` | Wait for selector, network, or timeout |
| `browser_take_screenshot` | Capture a screenshot |
| `browser_tabs` | Manage browser tabs |
| `browser_resize` | Resize the browser window |
| `browser_close` | Close the browser |
| `browser_drag` | Drag an element |
| `browser_drop` | Drop a dragged element |
| `browser_hover` | Hover over an element |
| `browser_handle_dialog` | Accept or dismiss dialogs |
| `browser_network_requests` | Inspect network requests |
| `browser_console_messages` | Read browser console output |

**When to use:** Verifying UI features after implementation, E2E testing, scraping data from web pages, testing form behavior.

---

## Obsidian

**Type:** `stdio`
**Purpose:** Read from and write to the personal Obsidian knowledge vault via the Obsidian Local REST API. Enables cross-project memory, preference loading, and pattern capture.

```json
{
  "obsidian": {
    "type": "stdio",
    "command": "npx",
    "tools": ["*"],
    "args": ["-y", "@oleksandrkucherenko/mcp-obsidian"],
    "env": {
      "API_KEY": "YOUR_OBSIDIAN_API_KEY",
      "API_URLS": "[\"https://127.0.0.1:27124\"]"
    }
  }
}
```

**Authentication:** API key passed via `API_KEY` env var. Obtain from the Obsidian Local REST API plugin settings.

**Vault URL:** Defaults to `https://127.0.0.1:27124`. The `API_URLS` env var accepts a JSON array for multi-vault setups.

**Available tools (examples):**
- `obsidian-get_note_content` — read a note by path
- `obsidian-create_or_update_note` — write or update a note
- `obsidian-search_notes` — full-text search across the vault
- `obsidian-list_notes` — list notes in a directory

**Two-tier access pattern:**
- **Tier 1 (mandatory):** `obsidian-get_note_content("knowledge/user-preferences.md")` before every non-trivial task
- **Tier 2 (lazy):** project context, sessions, patterns — only when local docs are insufficient

**When to use:** Loading user preferences before routing decisions, capturing cross-project learned patterns, storing session notes with unresolved items.

See [memory/obsidian-vault.md](../memory/obsidian-vault.md) for the full vault usage protocol.

---

## Adding a New MCP Server

1. Add the server entry to `~/.claude/mcp.json` (global) or `.claude/mcp.json` (project):

```json
{
  "mcpServers": {
    "my-server": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "my-mcp-package@1.0.0"],
      "tools": ["*"]
    }
  }
}
```

2. Add a template entry to `mcp.json.template` (no real credentials):

```json
{
  "mcpServers": {
    "my-server": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "my-mcp-package@1.0.0"],
      "tools": ["*"]
    }
  }
}
```

3. Run `/mcp` in a session to verify the server connects.
4. Run `/doctor` if the server shows an error.

---

## Related

- [mcp/mcp-overview.md](mcp-overview.md) — config structure, server types, tool naming
- [mcp/mcp-authentication.md](mcp-authentication.md) — API keys, OAuth, `.gitignore` pattern
- [memory/obsidian-vault.md](../memory/obsidian-vault.md) — obsidian MCP usage protocol
