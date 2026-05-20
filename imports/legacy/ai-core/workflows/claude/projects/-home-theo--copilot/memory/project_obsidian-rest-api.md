---
name: obsidian-rest-api-migration
description: Obsidian vault access migrated from filesystem to Local REST API plugin — all read/write paths use the API
metadata: 
  node_type: memory
  type: project
  originSessionId: 7bc1fcd5-fccd-428c-bcdf-0102a7baaaff
---

Obsidian vault is no longer accessed via the filesystem (`/mnt/storage/obsidian/brain`). All vault operations go through the **Obsidian Local REST API plugin** at `https://127.0.0.1:27124`.

**Why:** User switched from filesystem mount to Local REST API plugin for vault access.

**How to apply:**
- Reads and searches: use MCP `obsidian` server tools (`obsidian-get_note_content`, `obsidian-obsidian_search`, `obsidian-obsidian_semantic_search`)
- Writes: curl PUT to `https://127.0.0.1:27124/vault/{path}` with API key from `~/.copilot/mcp-config.json` (`mcpServers.obsidian.env.API_KEY`)
- `-k` flag required on all curl calls (self-signed cert)
- MCP package (`@oleksandrkucherenko/mcp-obsidian`) is read-only — no write tools exposed

Updated files: `~/.copilot/skills/obsidian-memory/SKILL.md`, `~/.claude/skills/obsidian-memory/SKILL.md`, `~/.claude/CLAUDE.md`
