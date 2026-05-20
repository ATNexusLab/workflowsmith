<!-- topic: slash commands | section: reference -->
# Slash Commands Reference

> **Quick Reference**
> - Slash commands run inside an interactive Antigravity CLI session.
> - Built-in commands cover session control, memory, history, tools, integrations, and diagnostics.
> - Command names always begin with `/`.
> - Custom slash commands can come from extensions or project-local command files.
> - This file is the canonical reference for slash-command behavior.

## What slash commands are

Slash commands are in-session control commands for Antigravity CLI. They do not launch a new process. Instead, they change session state, inspect runtime information, or trigger built-in management flows such as memory reloads, model switching, and MCP authentication.

## Built-in slash commands

| Command | Description |
|---|---|
| `/help` | Show all available commands and their descriptions |
| `/clear` | Clear conversation history (keeps context instructions) |
| `/quit` or `/exit` | End the session |
| `/new` | Start a fresh session (reset everything) |
| `/chat save [title]` | Save current conversation |
| `/chat list` | List saved conversations |
| `/chat resume [title]` | Resume a saved conversation |
| `/memory show` | Display all loaded memory/context files |
| `/memory reload` | Reload memory from disk |
| `/memory inbox` | Show items in the auto-memory inbox |
| `/memory add <text>` | Add a note to `GEMINI.md` |
| `/history` | Show conversation turn history |
| `/restore` | List checkpoints to restore from |
| `/rewind` | Rewind conversational history (not the same as restore) |
| `/compress` | Manually trigger context compression |
| `/stats` | Show token usage and session statistics |
| `/theme` | Show or set the active theme |
| `/theme <name>` | Switch to a named theme |
| `/model` | Show the current active model |
| `/model <name>` | Switch model for this session |
| `/tools` | List available tools with descriptions |
| `/tools <name>` | Show details for a specific tool |
| `/mcp` | Show MCP server status and tools |
| `/mcp list` | Same as `/mcp` |
| `/mcp auth` | List servers needing authentication |
| `/mcp auth <name>` | Authenticate with an MCP server |
| `/mcp enable <name>` | Enable a server |
| `/mcp disable <name>` | Disable a server |
| `/mcp schema` | Show MCP tool schemas |
| `/mcp reload` | Reconnect to MCP servers |
| `/hooks` | Show hooks status and configuration |
| `/hooks list` | Same as `/hooks` |
| `/hooks enable <name>` | Enable a hook |
| `/hooks disable <name>` | Disable a hook |
| `/hooks enable-all` | Enable all hooks |
| `/hooks disable-all` | Disable all hooks |
| `/extensions` | List loaded extensions |
| `/extensions <name>` | Show extension details |
| `/extensions enable <name>` | Enable an extension |
| `/extensions disable <name>` | Disable an extension |
| `/bug` | File a bug report using `bugCommand` if configured |
| `/editor` | Open the current conversation in `$EDITOR` |
| `/trust` | Approve a workspace skill or hook for this session |

## Memory commands in detail

The `/memory` command family inspects, refreshes, and manages the persistent context layer built from active `GEMINI.md` files and imported memory fragments.

| Command | Purpose |
|---|---|
| `/memory show` | Displays the full concatenated context currently sent to the model — the authoritative way to inspect merged payload after hierarchy resolution and import expansion |
| `/memory reload` | Re-scans all `GEMINI.md` files and rebuilds the active memory set — use after editing any context file during an active session |
| `/memory inbox` | Opens the Auto Memory review queue (only meaningful when Auto Memory is enabled) |
| `/memory add <text>` | Adds a note directly to `GEMINI.md` |

### Natural-language memory saves

You do not need a slash command to save durable facts. Antigravity CLI interprets natural-language requests:

```text
Remember that I prefer terse commit messages.
Remember that this repository uses AGENTS.md as its context filename.
Remember that private client notes must stay out of the shared repo.
```

A `Remember that...` request tells the agent the fact should persist beyond the current turn. Antigravity CLI then routes it to the most appropriate durable scope — global memory, a shared project file, or private project memory.

### Persistent memory vs. session memory

| Memory type | Lifetime | When to use |
|---|---|---|
| Session memory | Current session only | Temporary context, one-off clarifications, transient tasks |
| Persistent memory | Survives across sessions | Durable preferences, rules, conventions, and recurring facts |

Session memory disappears when the session ends. Persistent memory is stored in `GEMINI.md` files or private project memory and remains available to future sessions after files are reloaded or rediscovered.

---

## Custom slash commands

Custom slash commands extend the built-in command set without modifying Antigravity CLI core behavior.

### Where custom commands come from

| Source | Registration rule | Resulting command form |
|---|---|---|
| Extension command | Registered by an extension | `/<name>` or `/<extension>.<name>` when there is a name conflict |
| Project command | `.gemini/commands/<name>.md` | `/<name>` |

### Command handler types

| Handler type | What it does |
|---|---|
| `prompt` | Injects predefined text into the session as a prompt |
| `script` | Runs a script and injects its output into the session |

### Resolution notes

- Extension commands may be namespaced as `/<extension>.<name>` to avoid collisions
- Project command files are discovered from `.gemini/commands/`
- Custom commands behave like normal slash commands once loaded into the session
