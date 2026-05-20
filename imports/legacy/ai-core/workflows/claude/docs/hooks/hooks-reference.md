# Hooks — Reference

Complete reference for all 29 hook events: input schema, output schema, and behavior.

---

## Common Input Fields (All Events)

Every hook receives these fields via stdin regardless of event type:

```json
{
  "session_id": "string — unique session identifier",
  "transcript_path": "string — path to the session .jsonl transcript",
  "cwd": "string — current working directory",
  "permission_mode": "default | acceptEdits | plan | auto | dontAsk | bypassPermissions",
  "effort": "low | medium | high | max",
  "hook_event_name": "string — the event name (e.g. UserPromptSubmit)",
  "agent_id": "string | null — set if running inside a sub-agent",
  "agent_type": "string | null — set if running inside a sub-agent"
}
```

---

## Matcher Syntax

Matchers narrow which hook group fires. Applied to the tool name for tool events, or other event-specific identifiers.

| Pattern | Example | Matches |
|---|---|---|
| Exact | `"Bash"` | Only the Bash tool |
| Pipe-separated | `"Bash\|Edit\|Write"` | Any of the listed tools |
| Glob | `"mcp__*"` | All MCP tool calls |
| Regex | `"^Read$"` | Exact regex match |
| Omitted | (no matcher) | Every invocation of this event |

```json
{
  "matcher": "Bash",
  "hooks": [...]
}
```

---

## Event Reference

### `SessionStart`

Fires when a session begins, before any user interaction.

**Extra input fields:** none

**Output:** `{}` (informational only)

---

### `Setup`

Fires after session initialization, before the first user prompt.

**Extra input fields:** none

**Output:** `{}` (informational only)

---

### `UserPromptSubmit`

Fires every time the user sends a message, before Claude processes it.

**Extra input fields:**

```json
{
  "prompt": "string — the raw user prompt text"
}
```

**Output:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "string — injected into Claude's context alongside the prompt"
  }
}
```

**Timeout:** 30 seconds (shorter than most events — Claude waits for this before responding)

**Use case:** Inject policies, enforce workflows, add dynamic context to every prompt.

---

### `UserPromptExpansion`

Fires when a prompt is expanded — for example, when `@-imports` in the prompt are resolved.

**Extra input fields:**

```json
{
  "prompt": "string — the expanded prompt text"
}
```

**Output:** `{}` (informational only)

---

### `PreToolUse`

Fires before any tool is invoked. Can block the tool call.

**Extra input fields:**

```json
{
  "tool_name": "string — e.g. Bash, Read, Edit, Write",
  "tool_input": "object — the parameters being passed to the tool"
}
```

**Output:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "decision": "allow | block",
    "reason": "string — shown to the user if decision is block"
  }
}
```

Omitting `decision` defaults to `"allow"`. Returning `{}` is equivalent to allowing.

**Use case:** Block dangerous operations, enforce code review gates, audit tool usage.

---

### `PostToolUse`

Fires after a tool call completes successfully.

**Extra input fields:**

```json
{
  "tool_name": "string",
  "tool_input": "object",
  "tool_result": "any — the return value of the tool"
}
```

**Output:** `{}` (informational only)

---

### `PostToolUseFailure`

Fires after a tool call fails.

**Extra input fields:**

```json
{
  "tool_name": "string",
  "tool_input": "object",
  "error": "string — the error message"
}
```

**Output:** `{}` (informational only)

---

### `PostToolBatch`

Fires after a batch of parallel tool calls all complete (either success or failure).

**Extra input fields:**

```json
{
  "tool_calls": [
    {
      "tool_name": "string",
      "tool_input": "object",
      "result": "any | null",
      "error": "string | null"
    }
  ]
}
```

**Output:** `{}` (informational only)

---

### `PermissionRequest`

Fires when Claude requests permission to perform an action.

**Extra input fields:**

```json
{
  "tool_name": "string",
  "tool_input": "object",
  "permission_type": "string — e.g. execute, write, network"
}
```

**Output:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PermissionRequest",
    "permissionDecision": "allow | deny",
    "reason": "string — optional, shown to user if denied"
  }
}
```

**Use case:** Auto-approve all permissions (see `auto-approve-permissions.js`), or approve selectively based on tool/path patterns.

---

### `PermissionDenied`

Fires when a permission is denied (either by the user or a hook).

**Extra input fields:**

```json
{
  "tool_name": "string",
  "tool_input": "object",
  "reason": "string — why it was denied"
}
```

**Output:** `{}` (informational only)

---

### `Stop`

Fires when Claude is about to stop responding. Can block the stop (force Claude to continue).

**Extra input fields:**

```json
{
  "stop_reason": "string — e.g. end_turn, max_tokens, stop_sequence"
}
```

**Output:**

```json
{
  "hookSpecificOutput": {
    "hookEventName": "Stop",
    "decision": "allow | block",
    "reason": "string — if blocking, why"
  }
}
```

---

### `StopFailure`

Fires when Claude fails to stop cleanly.

**Extra input fields:**

```json
{
  "error": "string"
}
```

**Output:** `{}` (informational only)

---

### `SubagentStart`

Fires when a sub-agent is spawned via the Agent tool.

**Extra input fields:**

```json
{
  "subagent_id": "string",
  "subagent_type": "string | null",
  "prompt": "string — the task given to the sub-agent"
}
```

**Output:** `{}` (informational only)

---

### `SubagentStop`

Fires when a sub-agent finishes.

**Extra input fields:**

```json
{
  "subagent_id": "string",
  "subagent_type": "string | null",
  "result": "string — the sub-agent's final response"
}
```

**Output:** `{}` (informational only)

---

### `TaskCreated`

Fires when a task is created via the TaskCreate tool.

**Extra input fields:**

```json
{
  "task_id": "string",
  "task_title": "string",
  "task_description": "string | null"
}
```

**Output:** `{}` (informational only)

---

### `TaskCompleted`

Fires when a task transitions to completed state.

**Extra input fields:**

```json
{
  "task_id": "string",
  "task_title": "string"
}
```

**Output:** `{}` (informational only)

---

### `TeammateIdle`

Fires when a teammate agent becomes idle (waiting for work).

**Extra input fields:**

```json
{
  "teammate_id": "string"
}
```

**Output:** `{}` (informational only)

---

### `InstructionsLoaded`

Fires after all CLAUDE.md files (global + project) are loaded for the session.

**Extra input fields:**

```json
{
  "instruction_paths": ["string — paths to all loaded instruction files"]
}
```

**Output:** `{}` (informational only)

---

### `ConfigChange`

Fires when settings change during an active session (e.g., `/model` or `/effort`).

**Extra input fields:**

```json
{
  "changed_keys": ["string — settings keys that changed"]
}
```

**Output:** `{}` (informational only)

---

### `CwdChanged`

Fires when the working directory changes during a session.

**Extra input fields:**

```json
{
  "old_cwd": "string",
  "new_cwd": "string"
}
```

**Output:** `{}` (informational only)

---

### `FileChanged`

Fires when a file Claude is watching changes.

**Extra input fields:**

```json
{
  "file_path": "string — absolute path to the changed file",
  "change_type": "created | modified | deleted"
}
```

**Output:** `{}` (informational only)

---

### `PreCompact`

Fires before conversation history is compacted.

**Extra input fields:** none

**Output:** `{}` (informational only — cannot block compaction)

---

### `PostCompact`

Fires after conversation history has been compacted.

**Extra input fields:**

```json
{
  "summary": "string — the generated compact summary"
}
```

**Output:** `{}` (informational only)

---

### `Elicitation`

Fires when Claude requests structured input from the user (e.g., AskUserQuestion).

**Extra input fields:**

```json
{
  "elicitation_id": "string",
  "question": "string | object — the question(s) being asked"
}
```

**Output:** `{}` (informational only)

---

### `ElicitationResult`

Fires when the user responds to an elicitation.

**Extra input fields:**

```json
{
  "elicitation_id": "string",
  "answers": "object — user's responses keyed by question"
}
```

**Output:** `{}` (informational only)

---

### `Notification`

Fires when Claude sends a notification (PushNotification tool).

**Extra input fields:**

```json
{
  "message": "string"
}
```

**Output:** `{}` (informational only)

---

### `WorktreeCreate`

Fires when a git worktree is created.

**Extra input fields:**

```json
{
  "worktree_path": "string",
  "branch": "string | null"
}
```

**Output:** `{}` (informational only)

---

### `WorktreeRemove`

Fires when a git worktree is removed.

**Extra input fields:**

```json
{
  "worktree_path": "string"
}
```

**Output:** `{}` (informational only)

---

### `SessionEnd`

Fires when the session ends (user exits, `/exit`, or interrupt).

**Extra input fields:**

```json
{
  "exit_reason": "string — e.g. user_exit, interrupt, max_turns"
}
```

**Output:** `{}` (informational only — session is ending regardless)

**Use case:** Cleanup tasks, worktree removal, session logging.

---

## Multiple Hooks Per Event

Multiple hook groups can be registered for the same event. They run in definition order:

```json
{
  "UserPromptSubmit": [
    { "hooks": [{ "type": "command", "command": "node", "args": ["hook-a.js"] }] },
    { "hooks": [{ "type": "command", "command": "node", "args": ["hook-b.js"] }] }
  ]
}
```

If `hook-a.js` returns a blocking result (exit code 2), `hook-b.js` does not run.

---

## Related

- [hooks/hooks-overview.md](hooks-overview.md) — lifecycle, handler types, timeout defaults
- [hooks/hooks-patterns.md](hooks-patterns.md) — annotated real implementations
- [core/settings-json.md](../core/settings-json.md) — where hooks are configured
