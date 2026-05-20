# IDE Integrations

Claude Code is available as an extension for VS Code and JetBrains IDEs, in addition to the CLI, desktop app, and web interface.

---

## VS Code Extension

### Installation

1. Open VS Code
2. Open the Extensions panel (`Ctrl+Shift+X` / `Cmd+Shift+X`)
3. Search for **"Claude Code"**
4. Install the Anthropic-published extension

Or via CLI:
```bash
code --install-extension anthropic.claude-code
```

### Features

| Feature | Description |
|---|---|
| Inline assistant | Ask Claude about highlighted code without leaving the editor |
| Chat panel | Full Claude Code session embedded in the IDE sidebar |
| Diff view | Review Claude's file edits with VS Code's native diff UI |
| Terminal integration | Claude Code CLI runs in VS Code's integrated terminal |
| Context awareness | Claude sees your open files and workspace |
| MCP support | All configured MCP servers work in IDE sessions |

### Configuration

The VS Code extension reads the same config files as the CLI:
- `~/.claude/settings.json` — global settings, hooks, permissions
- `.claude/settings.json` — project-local settings
- `~/.claude/CLAUDE.md` — global instructions
- `CLAUDE.md` — project instructions
- `~/.claude/mcp.json` — MCP server config

No separate extension-specific config is required. Changes to `settings.json` apply immediately.

### Keyboard Shortcuts

| Action | macOS | Windows/Linux |
|---|---|---|
| Open Claude Code | `Cmd+Shift+C` | `Ctrl+Shift+C` |
| Ask about selection | `Cmd+Shift+A` | `Ctrl+Shift+A` |
| Accept edit | `Tab` | `Tab` |
| Reject edit | `Escape` | `Escape` |

Shortcuts are configurable via VS Code's keybindings editor (`keybindings.json`).

### Status Line

The `statusLine` field in `settings.json` controls the status indicator shown in the editor:

```json
{
  "statusLine": "echo 'ctx:$(claude ctx)%'"
}
```

See [core/settings-json.md](../core/settings-json.md) for the full statusLine format.

---

## JetBrains Plugin

### Supported IDEs

| IDE | Version |
|---|---|
| IntelliJ IDEA | 2023.1+ |
| PyCharm | 2023.1+ |
| WebStorm | 2023.1+ |
| GoLand | 2023.1+ |
| Rider | 2023.1+ |
| CLion | 2023.1+ |
| DataGrip | 2023.1+ |
| Android Studio | Electric Eel+ |

### Installation

1. Open IDE Settings/Preferences
2. Navigate to **Plugins → Marketplace**
3. Search for **"Claude Code"**
4. Install and restart the IDE

Or download from the [JetBrains Marketplace](https://plugins.jetbrains.com/).

### Features

| Feature | Description |
|---|---|
| Tool window | Embedded Claude Code session in a JetBrains tool window |
| Inline actions | Context menu and intention actions powered by Claude |
| Terminal integration | Claude CLI accessible in JetBrains terminal |
| File context | Claude sees the current file and project structure |
| MCP support | Full MCP server support in IDE sessions |

### Configuration

Same as VS Code — reads `~/.claude/settings.json`, `CLAUDE.md`, and `~/.claude/mcp.json`. No plugin-specific config.

---

## Shared Behavior Across All Surfaces

All surfaces (CLI, desktop app, VS Code, JetBrains, web) share:

| Behavior | Detail |
|---|---|
| Global instructions | `~/.claude/CLAUDE.md` always loaded |
| Project instructions | `CLAUDE.md` loaded when working in a repo |
| Settings | `~/.claude/settings.json` (global) + `.claude/settings.json` (project) |
| Hooks | All 4 hook types fire regardless of surface |
| MCP servers | `~/.claude/mcp.json` loaded everywhere |
| Memory | `~/.claude/projects/*/memory/MEMORY.md` loaded per project |
| Skills | `~/.claude/skills/` always available |
| Agents | `~/.claude/agents/*.md` always loaded |
| Session continuity | Sessions are resumable across surfaces (same session ID) |

---

## Web Interface

Claude Code is available at `claude.ai/code`. The web interface provides:
- Full session management with the same CLI capabilities
- No local installation required
- MCP servers configured at `claude.ai` scope (separate from local `~/.claude/mcp.json`)

---

## Known Limitations

| Limitation | Detail |
|---|---|
| Hooks | Shell hooks (`command` type) require the CLI to be running locally; IDE-only sessions may not fire shell hooks |
| Local MCP servers | `stdio` MCP servers require the CLI host machine to be available |
| File system access | Web sessions have limited file system access compared to CLI |
| Worktrees | `isolation: worktree` in agents requires local git setup |

---

## Related

- [core/settings-json.md](../core/settings-json.md) — settings.json schema
- [reference/cli-reference.md](cli-reference.md) — full CLI flags
- [mcp/mcp-overview.md](../mcp/mcp-overview.md) — MCP server config
