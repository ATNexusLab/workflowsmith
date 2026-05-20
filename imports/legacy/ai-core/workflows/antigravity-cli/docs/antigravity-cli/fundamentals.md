<!-- topic: fundamentals | section: antigravity-cli -->
# Antigravity CLI Fundamentals

Antigravity CLI is the **preferred operating model** for this repository's local agent environment. In practice, that means new documentation, workflow design, and migration guidance should talk about **Antigravity CLI** first, even when some lower-level assets still use Gemini-era names or filenames.

## What Antigravity CLI offers here

This repository already contains a mature local agent ecosystem. Antigravity CLI, as documented here, is not just a shell executable. It is the combined system of:

- persistent instructions
- reusable workflows
- specialist agents
- tool integration
- runtime automation
- local runtime state

## Capability map

| Capability | Primary local surface | Deep reference |
|---|---|---|
| Persistent ambient instructions | `GEMINI.md` hierarchy | [configuration.md](configuration.md) |
| Reusable procedural workflows | `skills/*/SKILL.md` | [../skills/index.md](../skills/index.md) |
| Specialist delegated execution | `agents/*.md` | [../agents/index.md](../agents/index.md) |
| Lifecycle automation | `docs/hooks/` + hook configuration surfaces | [../hooks/index.md](../hooks/index.md) |
| External tools and resources | MCP configuration and servers | [../mcp/index.md](../mcp/index.md) |
| Packaged add-ons | extensions and local plugins | [../extensions/index.md](../extensions/index.md) |
| Runtime settings and state | `antigravity-cli/` and config surfaces | [configuration.md](configuration.md) |
| Execution modes and power-user features | CLI flags, advanced modes, built-in tools | [../reference/index.md](../reference/index.md), [../advanced/index.md](../advanced/index.md) |

## Quick Start

To go from zero to a working local installation:

1. **Place the repo at `~/.gemini/`** — clone it there or confirm it already exists at that path.
2. **Copy `settings.example.json` → `~/.gemini/settings.json`**, then open the copy and fill in every `YOUR_*` placeholder:
   - `YOUR_GOOGLE_API_KEY` — the Stitch MCP API key
   - `/path/to/your/obsidian/vault` — absolute path to your Obsidian vault directory
3. *(Optional)* **Copy `mcp.json.template` → `~/.gemini/mcp_config.json`** and adjust any server entries you want to enable or override.
4. **Make hook scripts executable:**
   ```
   chmod +x ~/.gemini/hooks/*.js
   ```
5. **`GEMINI.md` is already in place** — it is the native persistent instruction file for the tool. Do not rename or move it.
6. **Start Antigravity CLI.** It auto-discovers `GEMINI.md` and the `skills/` directory from `~/.gemini/` on startup — no extra configuration is needed.

After these steps the full agent environment (skills, agents, hooks, MCP servers) is active.

## Mental model

Think about the system in four layers:

1. **Instruction layer**  
   Always-on and task-specific guidance, primarily through `GEMINI.md` and `SKILL.md`
2. **Execution layer**  
   Main session plus isolated agents that do work
3. **Integration layer**  
   Hooks, MCP, extensions, and plugins that add reach or automation
4. **Runtime layer**  
   Local state, cache, logs, trusted workspace metadata, and runtime settings

## Current naming reality

The repository is in a migration window:

- **Antigravity CLI** is the canonical user-facing term
- **Gemini CLI** remains the name used across many existing deep-reference docs
- **`GEMINI.md`** is still the documented filename for persistent instruction files in the current lower-level system

All technical detail for `GEMINI.md` format internals, imports, settings, and Auto Memory now lives in [configuration.md](configuration.md).

## What this section is not

This section does **not** replace every existing detailed module. It is the routing and capability layer that helps you:

- discover what exists,
- choose the right construct,
- understand how local pieces fit together, and
- avoid mixing runtime state with documentation.

For concrete configuration and repository-specific boundaries, continue with [configuration.md](configuration.md) and [runtime-and-plugin-surfaces.md](runtime-and-plugin-surfaces.md).

---

## How the instruction layer works

### The 3-Tier Hierarchy

Antigravity CLI resolves `GEMINI.md` context across three scopes.

| Tier | Default location | Scope |
|---|---|---|
| Global | `~/.gemini/GEMINI.md` | Applies to all projects and sessions for the current user |
| Project root | `./GEMINI.md` | Applies to the current repository or workspace |
| Subdirectory | `./src/GEMINI.md` | Applies only to work inside that subtree or component |

The global file is the widest scope. Put cross-project preferences, long-lived working rules, and personal defaults there. A repository-root `GEMINI.md` carries shared project instructions and conventions. A deeper file such as `./src/GEMINI.md` narrows scope further to a component or subtree.

### Just-in-Time Discovery

Antigravity CLI also performs just-in-time discovery. When a tool accesses a file or directory, the CLI scans upward from that location to find applicable `GEMINI.md` files. The upward scan stops at the configured `memoryBoundaryMarkers`, which default to `.git`. This keeps discovery inside a trusted project boundary.

A deeper `GEMINI.md` is not loaded merely because it exists somewhere in the repository; it becomes active when the agent actually works in or under that directory.

### How Prompt Context Is Built

Antigravity CLI collects every applicable `GEMINI.md` file it has discovered, expands any imports, concatenates the resulting content, and sends that combined context with every prompt. The model receives one merged context payload assembled from all active files — not separate memory layers.

Operational implications:

- Editing a `GEMINI.md` file changes future prompts, not past ones.
- Deeper scope files add narrow instructions without replacing broader ones.
- Imported files become part of the same final concatenated payload.

### UI Feedback and Loaded Context Count

Antigravity CLI surfaces how much persistent context is active. The interface footer shows the number of loaded context files, making it easy to notice when a subdirectory file or imported file has joined the active set.

When `ui.hideContextSummary` is `false` (the default), a context summary appears above the input area. That summary is a UI convenience; the authoritative context is the concatenated payload actually sent to the model.

### Memory Routing

When the agent saves durable facts, Antigravity CLI routes them by scope.

| Memory type | Destination |
|---|---|
| Shared project instructions | Repository `GEMINI.md` files |
| Private project notes | The per-project private memory area |
| Cross-project personal preferences | `~/.gemini/GEMINI.md` |

Save a fact to the narrowest durable scope that matches who should inherit it. Team-visible repository rules belong in project files. Personal habits that should apply everywhere belong in the global file. Sensitive or private project notes belong in private project memory.
