# CLI Reference

Complete reference for the `claude` command-line interface.

---

## Models

| Model ID | Speed | Context | Best for |
|---|---|---|---|
| `claude-opus-4-7` | Slower | 200k | Complex reasoning, architecture, code review |
| `claude-sonnet-4-6` | Balanced | 200k | Default — general development tasks |
| `claude-haiku-4-5` | Fastest | 200k | Quick lookups, simple edits, low-cost automation |

Set model with `--model <id>` or `/model` inside a session.

---

## Basic Usage

```bash
# Start interactive session
claude

# One-shot (print mode)
claude --print "Explain what this function does"
claude -p "List all TODO comments in the codebase"

# One-shot with stdin pipe
cat main.py | claude -p "Review this for security issues"

# Continue last session
claude --continue
claude -c

# Resume a specific session
claude --resume <session-id>
claude -r <session-id>
```

---

## All CLI Flags

### Model and Effort

| Flag | Short | Type | Default | Description |
|---|---|---|---|---|
| `--model` | `-m` | string | sonnet | Model ID or alias (`opus`, `sonnet`, `haiku`) |
| `--effort` | | string | `medium` | Effort level: `low`, `medium`, `high`, `max` |

---

### Output Mode

| Flag | Short | Type | Description |
|---|---|---|---|
| `--print` | `-p` | string | Non-interactive: print response and exit |
| `--output-format` | | string | `text` (default), `json`, `stream-json` |
| `--bare` | | boolean | Strip formatting — plain text output only |
| `--verbose` | | boolean | Show full tool call details |

**`--output-format` options:**
- `text` — plain text response
- `json` — single JSON object with full turn details
- `stream-json` — NDJSON stream, one object per event (useful for CI/scripting)

---

### Session Management

| Flag | Short | Type | Description |
|---|---|---|---|
| `--continue` | `-c` | boolean | Continue the most recent session |
| `--resume` | `-r` | string | Resume session by ID |

---

### Permissions and Safety

| Flag | Short | Type | Description |
|---|---|---|---|
| `--permission-mode` | | string | `default`, `acceptEdits`, `plan`, `auto`, `dontAsk`, `bypassPermissions` |
| `--dangerously-skip-permissions` | | boolean | Skip all permission prompts (dangerous — CI use only) |

**Permission modes:**
| Mode | Behavior |
|---|---|
| `default` | Prompts for all tool use |
| `acceptEdits` | Auto-accept file edits; prompt for Bash/network |
| `plan` | Enter plan mode automatically |
| `auto` | Auto-accept most actions; prompt for destructive ones |
| `dontAsk` | Minimal prompting |
| `bypassPermissions` | Skip all checks (sandbox recommended) |

---

### Tool Control

| Flag | Type | Description |
|---|---|---|
| `--tools` | string | Comma-separated list of tools to enable (overrides default set) |
| `--allowedTools` | string | Additional tools to allow (additive) |
| `--disallowedTools` | string | Tools to block |

Examples:
```bash
# Allow only safe read-only tools
claude --tools "Read,Grep,Glob,WebSearch"

# Block network access
claude --disallowedTools "WebFetch,WebSearch"
```

---

### System Prompt

| Flag | Type | Description |
|---|---|---|
| `--system-prompt` | string | Replace the default system prompt |
| `--append-system-prompt` | string | Append to the default system prompt |

---

### Context and Working Directory

| Flag | Short | Type | Description |
|---|---|---|---|
| `--add-dir` | | string[] | Additional directories Claude can read |
| `--worktree` | `-w` | string | Start in a specific git worktree |

---

### Multi-turn Control

| Flag | Type | Default | Description |
|---|---|---|---|
| `--max-turns` | number | unlimited | Max back-and-forth turns (non-interactive) |

---

### Background and Agents

| Flag | Type | Description |
|---|---|---|
| `--bg` | boolean | Run session in the background |
| `--agents` | string | Agent definition files to load (comma-separated paths) |

---

### MCP

| Flag | Type | Description |
|---|---|---|
| `--mcp-config` | string | Path to MCP config file (overrides `~/.claude/mcp.json`) |

---

### Debug

| Flag | Short | Description |
|---|---|---|
| `--debug` | | Enable debug logging |
| `--version` | `-v` | Print the installed version |
| `--help` | `-h` | Show help |

---

## Non-Interactive Scripting

For CI/CD, cron jobs, and automation:

```bash
# Basic: print response to stdout
claude -p "Run a security audit on src/auth/" --output-format json

# Pipe code into Claude for review
git diff HEAD~1 | claude -p "Review these changes for security issues" --output-format text

# Stream JSON for real-time processing
claude -p "Generate tests for utils.ts" --output-format stream-json | jq '.text'

# With permission bypass for fully automated CI
claude -p "Run all failing tests and fix them" \
  --dangerously-skip-permissions \
  --max-turns 20 \
  --output-format json
```

---

## Environment Variables

| Variable | Description |
|---|---|
| `ANTHROPIC_API_KEY` | API key for authentication |
| `CLAUDE_MODEL` | Default model (overridden by `--model`) |
| `CLAUDE_EFFORT` | Default effort level |
| `NO_COLOR` | Disable colored output |
| `CLAUDE_DEBUG` | Enable debug mode |

---

## `claude config` Subcommand

Manage Claude Code settings from the CLI:

```bash
# View current settings
claude config list

# Get a specific setting
claude config get model

# Set a value
claude config set model claude-opus-4-7

# Remove a setting
claude config delete model
```

Settings modified with `claude config` are written to `~/.claude/settings.json`.

---

## Session IDs

Every session gets a unique ID shown in the terminal. Useful for:

```bash
# Resume by ID
claude --resume session-abc123

# Reference in hooks (available as input.session_id)
# Reference in status line with custom commands
```

Session transcripts are stored at:
```
~/.claude/projects/<encoded-path>/<session-id>.jsonl
```

---

## IDE Integration Usage

VS Code and JetBrains extensions use the same CLI internally. The extensions read:
- `~/.claude/settings.json` — global settings
- `.claude/settings.json` — project settings
- `~/.claude/CLAUDE.md` — global instructions
- `CLAUDE.md` — project instructions
- MCP configs at both locations

IDE usage does not require `--print` mode — the extension manages the session interactively.

---

## Related

- [core/settings-json.md](../core/settings-json.md) — `settings.json` schema and hooks
- [reference/ide-integrations.md](ide-integrations.md) — VS Code and JetBrains
- [core/context-management.md](../core/context-management.md) — effort, plan mode, /loop
