# Hooks — Overview

Hooks are shell commands (or HTTP endpoints, MCP tools, or prompts) that Claude Code runs in response to session lifecycle events. They let you inject additional context, enforce policies, automate cleanup, or gate actions before Claude acts.

---

## Configuration

Hooks are defined under the `hooks` key in `settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "node",
            "args": ["~/.claude/hooks/plan-first.js"]
          }
        ]
      }
    ]
  }
}
```

Config locations:
- `~/.claude/settings.json` — global, applies to all sessions
- `.claude/settings.json` — project-local, applies only in this repo

See [core/settings-json.md](../core/settings-json.md) for the full settings schema.

---

## Hook Object Schema

Each entry in a hook event array is a **hook group** containing an inner `hooks` array:

```json
{
  "matcher": "optional-tool-name-or-pattern",
  "hooks": [
    {
      "type": "command",
      "command": "node",
      "args": ["/path/to/script.js"],
      "timeout": 30
    }
  ]
}
```

| Field | Type | Description |
|---|---|---|
| `matcher` | string | Tool name, glob, or pattern to narrow when this group fires |
| `hooks[].type` | string | Handler type: `command`, `http`, `mcp_tool`, `prompt`, `agent` |
| `hooks[].command` | string | Executable for `command` type |
| `hooks[].args` | string[] | Arguments for `command` type |
| `hooks[].timeout` | number | Seconds before the hook is killed (default varies by event) |
| `hooks[].url` | string | Endpoint URL for `http` type |
| `hooks[].tool_name` | string | Tool name for `mcp_tool` type |
| `hooks[].prompt` | string | Prompt text for `prompt` type |

---

## Handler Types

| Type | What runs | Use case |
|---|---|---|
| `command` | Shell executable or script | Node.js, Python, bash — most flexible |
| `http` | HTTP POST to a URL | Webhooks, external services |
| `mcp_tool` | An MCP server tool | Delegate to a connected MCP server |
| `prompt` | A prompt sent to Claude | Context injection using natural language |
| `agent` | Spawns a sub-agent | Complex automation requiring tool access |

`command` is the most common type and covers all use cases where a local script can respond.

---

## Input / Output Contract

### Input (via stdin, all events)

Common fields in every hook's JSON input:

```json
{
  "session_id": "abc123",
  "transcript_path": "/tmp/claude-session-abc123.jsonl",
  "cwd": "/home/user/project",
  "permission_mode": "default",
  "effort": "medium",
  "hook_event_name": "UserPromptSubmit",
  "agent_id": null,
  "agent_type": null
}
```

Event-specific fields are added on top of these common fields (see [hooks-reference.md](hooks-reference.md) for per-event schemas).

### Output (via stdout, `command` type)

The hook writes JSON to stdout:

```json
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "string injected into Claude's context"
  }
}
```

The `hookSpecificOutput` object is event-specific. Different events expect different fields:
- `UserPromptSubmit` → `additionalContext` (string)
- `PermissionRequest` → `permissionDecision` (`"allow"` | `"deny"`)
- `PreToolUse` → `decision` (`"allow"` | `"block"`, optional `reason`)
- `Stop` → `decision` (`"block"` to prevent stopping, `"allow"` to proceed)

### Exit Codes

| Exit code | Meaning |
|---|---|
| `0` | Success — parse stdout as JSON |
| `2` | Blocking error — show stderr to user, abort the triggering action |
| Other | Non-blocking error — log stderr, continue without hook output |

---

## All Event Types (29)

### Session Lifecycle

| Event | When it fires |
|---|---|
| `SessionStart` | When a session begins |
| `Setup` | After session starts, before first user prompt |
| `SessionEnd` | When the session ends (normal or interrupt) |
| `Stop` | When Claude is about to stop responding |
| `StopFailure` | When Claude fails to stop cleanly |

### User Interaction

| Event | When it fires |
|---|---|
| `UserPromptSubmit` | Every time a user sends a prompt |
| `UserPromptExpansion` | When a prompt is expanded (e.g., @-imports resolved) |
| `Elicitation` | When Claude elicits structured input from the user |
| `ElicitationResult` | When the user responds to an elicitation |
| `Notification` | When Claude sends a notification to the user |

### Tool Execution

| Event | When it fires |
|---|---|
| `PreToolUse` | Before any tool call (can block it) |
| `PostToolUse` | After a tool call succeeds |
| `PostToolUseFailure` | After a tool call fails |
| `PostToolBatch` | After a batch of parallel tool calls completes |
| `PermissionRequest` | When Claude asks for permission (can auto-approve) |
| `PermissionDenied` | When a permission is denied |

### Agents and Tasks

| Event | When it fires |
|---|---|
| `SubagentStart` | When a sub-agent is spawned |
| `SubagentStop` | When a sub-agent finishes |
| `TaskCreated` | When a task is created via TaskCreate |
| `TaskCompleted` | When a task completes |
| `TeammateIdle` | When a teammate agent becomes idle |

### Instructions and Config

| Event | When it fires |
|---|---|
| `InstructionsLoaded` | After CLAUDE.md files are loaded |
| `ConfigChange` | When settings change during a session |
| `CwdChanged` | When the working directory changes |
| `FileChanged` | When a watched file changes |

### Context Management

| Event | When it fires |
|---|---|
| `PreCompact` | Before conversation history is compacted |
| `PostCompact` | After conversation history is compacted |

### Worktrees

| Event | When it fires |
|---|---|
| `WorktreeCreate` | When a git worktree is created |
| `WorktreeRemove` | When a git worktree is removed |

---

## Timeout Defaults

| Scope | Default timeout |
|---|---|
| Most events | 600 seconds |
| `UserPromptSubmit` | 30 seconds |
| `agent` handler type | 60 seconds |

Override with the `timeout` field in the hook object.

---

## Related

- [hooks/hooks-patterns.md](hooks-patterns.md) — the 4 real hook implementations annotated
- [hooks/hooks-reference.md](hooks-reference.md) — complete per-event JSON schema reference
- [core/settings-json.md](../core/settings-json.md) — settings.json structure and hook config location
