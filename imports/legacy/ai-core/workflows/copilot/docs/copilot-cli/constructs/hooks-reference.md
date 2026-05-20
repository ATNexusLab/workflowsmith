# Hooks Reference

Label: **Official reference** — Copilot CLI hook events, payloads, and output contracts

This document covers every lifecycle hook event available in Copilot CLI: when each fires, the JSON it receives on stdin, the JSON it may emit on stdout, exit-code semantics, and concrete use cases. For hook file format and operational guidance see [hooks.md](hooks.md).

---

## Input formats

Copilot CLI supports two input serialization styles. Use **camelCase** for new hooks; the PascalCase/snake_case variant exists for VS Code Chat extension compatibility.

| Field (camelCase) | Field (VS Code compatible) | Description |
|---|---|---|
| `hookType` | `hook_type` | Event name (e.g. `preToolUse`) |
| `sessionId` | `session_id` | Unique identifier for the current session |
| `transcriptPath` | `transcript_path` | Absolute path to the session transcript file |
| `toolName` | `tool_name` | Tool being invoked (tool events only) |
| `toolInput` | `tool_input` | Arguments passed to the tool (object) |
| `toolOutput` | `tool_output` | Result returned by the tool (post-events only) |
| `agentName` | `agent_name` | Name of the subagent (subagent events only) |

All examples below use camelCase.

---

## Exit code semantics

| Exit code | Meaning |
|---|---|
| `0` | Success — stdout JSON is processed if the event supports output |
| `2` | Special context injection for `postToolUseFailure` — stdout `additionalContext` is read |
| Any other non-zero | **Fail-open** — the hook error is logged but the agent run continues unblocked |

Only `preToolUse`, `agentStop`, `subagentStop`, and `permissionRequest` can actually block execution. All others are informational or context-injecting.

---

## Matcher filtering

The `matcher` field on a hook definition narrows which events trigger it. Not all events support matchers.

| Event | Matcher field | Matches on |
|---|---|---|
| `preToolUse` | `toolName` | Tool name string |
| `permissionRequest` | `toolName` | Tool name string |
| `notification` | `notificationType` | Notification type string |
| `subagentStart` | `agentName` | Agent name string |
| `preCompact` | `trigger` | Compact trigger type |

**Built-in tool names** available for matching:

`bash` · `powershell` · `create` · `edit` · `glob` · `grep` · `task` · `view` · `web_fetch`

---

## Event reference

### `sessionStart` / `SessionStart`

**Fires:** Once when a new session begins, before any user interaction.

**Input payload:**
```json
{
  "hookType": "sessionStart",
  "sessionId": "abc123",
  "transcriptPath": "/path/to/transcript.json"
}
```

**Output (processed):**
```json
{
  "additionalContext": "String injected into the session context before the first turn."
}
```

**Exit codes:** Non-zero is fail-open. No blocking capability.

**Use cases:**
- Inject environment metadata (hostname, project name, date) at session start
- Load standing preferences into session context
- Announce applicable policies or guardrails to the agent

---

### `sessionEnd` / `SessionEnd`

**Fires:** Once when the session terminates, after the final turn completes.

**Input payload:**
```json
{
  "hookType": "sessionEnd",
  "sessionId": "abc123",
  "transcriptPath": "/path/to/transcript.json"
}
```

**Output:** None processed.

**Exit codes:** Non-zero is fail-open.

**Use cases:**
- Flush session logs or audit records
- Post-session cleanup (temp files, lock files)
- Send session summary to an external system

---

### `userPromptSubmitted` / `UserPromptSubmitted`

**Fires:** Each time the user submits a prompt, before the agent processes it.

**Input payload:**
```json
{
  "hookType": "userPromptSubmitted",
  "sessionId": "abc123",
  "transcriptPath": "/path/to/transcript.json",
  "prompt": "Summarize the last three commits."
}
```

**Output:** None processed.

**Exit codes:** Non-zero is fail-open. No blocking capability.

**Use cases:**
- Log prompts for audit or analytics
- Emit prompt telemetry to an external service

---

### `preToolUse` / `PreToolUse`

**Fires:** Immediately before a tool executes. The most powerful hook event — can block execution or modify arguments.

**Input payload:**
```json
{
  "hookType": "preToolUse",
  "sessionId": "abc123",
  "transcriptPath": "/path/to/transcript.json",
  "toolName": "bash",
  "toolInput": {
    "command": "rm -rf /tmp/work"
  }
}
```

**Output — block execution:**
```json
{
  "permissionDecision": "deny",
  "permissionDecisionReason": "Destructive rm -rf outside of approved paths is not allowed."
}
```

**Output — modify arguments before execution:**
```json
{
  "modifiedArgs": {
    "command": "rm -rf /tmp/work/safe-subdir"
  }
}
```

**Output — allow (implicit):** exit 0 with no output or `{"permissionDecision": "allow"}`.

**Exit codes:** `0` = allow (with optional modified args). Non-zero (except 2) = fail-open, tool runs. Use the deny output for intentional blocks.

**Matcher:** Filter by `toolName` to target specific tools.

**Use cases:**
- Block `bash` commands matching dangerous patterns (`rm -rf /`, `curl | sh`)
- Enforce path restrictions on `edit` and `create` tools
- Rewrite arguments to add safety flags before execution
- Require confirmation before destructive operations

---

### `postToolUse` / `PostToolUse`

**Fires:** After a tool completes successfully.

**Input payload:**
```json
{
  "hookType": "postToolUse",
  "sessionId": "abc123",
  "transcriptPath": "/path/to/transcript.json",
  "toolName": "bash",
  "toolInput": { "command": "git status" },
  "toolOutput": "On branch main\nnothing to commit"
}
```

**Output:** None processed.

**Exit codes:** Non-zero is fail-open.

**Use cases:**
- Log tool invocations and outputs for audit
- Trigger downstream side effects after a specific tool completes

---

### `postToolUseFailure` / `PostToolUseFailure`

**Fires:** After a tool fails (non-zero exit or error).

**Input payload:**
```json
{
  "hookType": "postToolUseFailure",
  "sessionId": "abc123",
  "transcriptPath": "/path/to/transcript.json",
  "toolName": "bash",
  "toolInput": { "command": "npm test" },
  "error": "Process exited with code 1"
}
```

**Output (exit code 2 only):**
```json
{
  "additionalContext": "Note: this project requires Node 20+. Check nvm or .nvmrc before retrying."
}
```

**Exit codes:** Exit `2` triggers context injection into the agent turn. Other non-zero values are fail-open.

**Use cases:**
- Inject remediation hints when a known tool fails (e.g. missing env var, wrong runtime version)
- Log failures to an external audit system

---

### `agentStop` / `AgentStop`

**Fires:** When the main agent finishes a turn and is about to stop.

**Input payload:**
```json
{
  "hookType": "agentStop",
  "sessionId": "abc123",
  "transcriptPath": "/path/to/transcript.json"
}
```

**Output — force another turn:**
```json
{
  "decision": "block",
  "reason": "Closeout checklist was not found in the response. Require the agent to run it."
}
```

**Output — allow stop (implicit):** exit 0 with no output.

**Exit codes:** `0` + `{"decision": "block"}` forces an additional agent turn. Exit 0 with no output allows the stop.

**Use cases:**
- Enforce a mandatory closeout or summary block at session end
- Validate that required output sections are present before the turn closes
- Trigger post-turn policy checks

---

### `subagentStart` / `SubagentStart`

**Fires:** When a subagent is spawned, before it begins its first turn.

**Input payload:**
```json
{
  "hookType": "subagentStart",
  "sessionId": "abc123",
  "transcriptPath": "/path/to/transcript.json",
  "agentName": "engine"
}
```

**Output (processed):**
```json
{
  "additionalContext": "Context string injected into the subagent before its first turn."
}
```

**Exit codes:** Non-zero is fail-open. No blocking capability.

**Matcher:** Filter by `agentName` to target specific subagents.

**Use cases:**
- Inject agent-specific standing context (e.g. security reminders to `@engine`)
- Log subagent spawning for orchestration audits

---

### `subagentStop` / `SubagentStop`

**Fires:** When a subagent finishes a turn and is about to return to the parent session.

**Input payload:**
```json
{
  "hookType": "subagentStop",
  "sessionId": "abc123",
  "transcriptPath": "/path/to/transcript.json",
  "agentName": "engine"
}
```

**Output — force another subagent turn:**
```json
{
  "decision": "block",
  "reason": "No test plan was included in the response. The subagent must provide one."
}
```

**Output — allow return (implicit):** exit 0 with no output.

**Exit codes:** Same semantics as `agentStop` — `{"decision": "block"}` forces another turn.

**Use cases:**
- Validate subagent output quality before results propagate to the parent session
- Enforce required sections in subagent responses

---

### `errorOccurred` / `ErrorOccurred`

**Fires:** When an unhandled error occurs during agent execution.

**Input payload:**
```json
{
  "hookType": "errorOccurred",
  "sessionId": "abc123",
  "transcriptPath": "/path/to/transcript.json",
  "error": "Connection timeout to MCP server obsidian"
}
```

**Output:** None processed.

**Exit codes:** Non-zero is fail-open.

**Use cases:**
- Log errors to an external monitoring service
- Alert on specific error patterns

---

### `permissionRequest` / `PermissionRequest`

**Fires:** Before the built-in permission service evaluates a tool execution request. CLI only (not available in VS Code Chat).

**Input payload:**
```json
{
  "hookType": "permissionRequest",
  "sessionId": "abc123",
  "transcriptPath": "/path/to/transcript.json",
  "toolName": "bash",
  "toolInput": { "command": "cat /etc/passwd" }
}
```

**Output — override to allow:**
```json
{
  "behavior": "allow",
  "message": "Allowed by policy: read-only /etc access is permitted."
}
```

**Output — override to deny:**
```json
{
  "behavior": "deny",
  "message": "Access to /etc/passwd is not permitted in this environment."
}
```

**Exit codes:** `0` with output overrides the permission service decision. Non-zero is fail-open (permission service runs normally).

**Matcher:** Filter by `toolName`.

**Use cases:**
- Grant pre-approved tool operations without interactive prompts
- Enforce a deny list at the permission layer before the tool runs
- Customize the message shown to the user when a permission is denied

---

### `notification` / `Notification`

**Fires:** When the system generates an async notification (fire-and-forget).

**Input payload:**
```json
{
  "hookType": "notification",
  "sessionId": "abc123",
  "transcriptPath": "/path/to/transcript.json",
  "notificationType": "tool_result",
  "message": "Tool completed with warnings."
}
```

**Output (optional):**
```json
{
  "additionalContext": "Additional information to attach to the notification context."
}
```

**Exit codes:** Non-zero is fail-open.

**Matcher:** Filter by `notificationType`.

**Use cases:**
- Forward system notifications to external channels (Slack, webhook)
- Filter or enrich notifications before they reach the user

---

### `preCompact` / `PreCompact`

**Fires:** Before context compaction (summarization) is triggered — either automatically when the context window nears its limit, or manually by the user.

**Input payload:**
```json
{
  "hookType": "preCompact",
  "sessionId": "abc123",
  "transcriptPath": "/path/to/transcript.json",
  "trigger": "auto"
}
```

`trigger` values: `"auto"` (context window limit reached) · `"manual"` (user-initiated compaction)

**Output (optional):**
```json
{
  "additionalContext": "Critical state to preserve across the compaction boundary."
}
```

Return `additionalContext` to inject content that must survive compaction and remain available in the new summary context.

**Exit codes:** Non-zero is fail-open. No blocking capability.

**Matcher:** Filter by `trigger` value.

**Use cases:**
- Preserve key decisions, constraints, or variable values that would otherwise be lost in compaction
- Log compaction events to an external monitoring system
- Inject a reminder of invariants (e.g. "branch: feature/x, do not push to main") into post-compaction context

---

## Hook events summary

| Event | Fires when | Output processed | Block capable |
|---|---|---|---|
| `sessionStart` | Session begins | Yes — `additionalContext` | No |
| `sessionEnd` | Session ends | No | No |
| `userPromptSubmitted` | User submits a prompt | No | No |
| `preToolUse` | Before tool executes | Yes — `permissionDecision`, `modifiedArgs` | **Yes** |
| `postToolUse` | After tool completes | No | No |
| `postToolUseFailure` | After tool fails | Yes — `additionalContext` (exit 2 only) | No |
| `agentStop` | Main agent finishes a turn | Yes — `decision: "block"` | **Yes** |
| `subagentStart` | Subagent spawned | Yes — `additionalContext` | No |
| `subagentStop` | Subagent finishes | Yes — `decision: "block"` | **Yes** |
| `errorOccurred` | Error during execution | No | No |
| `permissionRequest` | Before permission service runs | Yes — `behavior: "allow"\|"deny"` | **Yes** (CLI only) |
| `notification` | System notification (async) | Optional — `additionalContext` | No |
| `preCompact` | Before context compaction | Optional — `additionalContext` | No |

---

## Repo examples

This repository includes working hook examples:

- [hooks/guardrails.json](../../hooks/guardrails.json) — `preToolUse` policy hooks blocking dangerous shell patterns
- [hooks/session-log.json](../../hooks/session-log.json) — `sessionStart` / `sessionEnd` logging hooks

---

## Sources

- [GitHub Copilot CLI hooks reference](https://docs.github.com/en/copilot/reference/hooks-reference)
- [Using hooks with GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-hooks)
- [Hooks overview — this repo](hooks.md)
