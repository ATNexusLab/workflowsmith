<!-- topic: fundamentals | section: hooks -->
# Hooks Fundamentals

> **Quick Reference**
> - Hooks are external scripts or executables that Gemini CLI can run at documented hook event points.
> - Gemini CLI sends each event as JSON on stdin and expects valid JSON on stdout.
> - Use stderr for logging only; stdout is reserved for the structured hook reply.
> - Enable hooks with `hooksConfig.enabled: true` and the visual indicator with `hooksConfig.notifications: true`.
> - Hooks are optional, run synchronously, and should stay fast so the CLI does not stall.

## What Hooks Are

Hooks are external scripts or executables that Gemini CLI runs at defined hook event points. A hook lets you inspect an event payload and return the documented JSON response for that event without changing Gemini CLI itself.

Common use cases include validation before a tool runs, audit logging after a tool completes, model-request shaping, and desktop notifications for background activity.

Hooks are a separate extension surface from MCP. This section is only about documented event-triggered scripts, not MCP tools, resources, or prompts.

## How Hooks Work

Gemini CLI handles a hook in three steps:

1. It serializes the current event into a JSON payload.
2. It spawns the configured hook process and writes that JSON to the hook's stdin.
3. It reads stdout, parses the returned JSON envelope, and applies the hook's response.

A hook script therefore has a strict channel contract.

| Channel | Purpose |
|---|---|
| `stdin` | Receives the event payload as JSON |
| `stdout` | Returns the hook response as JSON |
| `stderr` | Emits debug logs and diagnostics only |

A well-behaved hook reads stdin once, makes a fast decision, writes exactly one JSON response to stdout, and sends any logs to stderr.

## Hook Events Overview

Gemini CLI exposes 11 documented hook events. This file gives the mental model only; the dedicated event reference in this section is where the full input and output schemas live.

| Event | What it means |
|---|---|
| `SessionStart` | Fires when a CLI session begins. |
| `SessionEnd` | Fires when a CLI session ends. |
| `BeforeAgent` | Fires before an agent is invoked. |
| `AfterAgent` | Fires after an agent finishes. |
| `BeforeModel` | Fires before a model API call is sent. |
| `AfterModel` | Fires after a model API call returns. |
| `BeforeToolSelection` | Fires before the model chooses which tools it may call. |
| `BeforeTool` | Fires before a specific tool executes. |
| `AfterTool` | Fires after a specific tool completes. |
| `PreCompress` | Fires before Gemini CLI compresses context. |
| `Notification` | Receives CLI notifications such as background-process updates. |

## Enabling Hooks

Hooks are controlled by `settings.json`.

```json
{
  "hooksConfig": {
    "enabled": true,
    "notifications": true
  }
}
```

| Setting | Meaning |
|---|---|
| `hooksConfig.enabled` | Master switch for the entire hooks system |
| `hooksConfig.notifications` | Shows the visual hook activity indicator and related notifications |

If the master switch is off, Gemini CLI does not run hooks even if they are configured correctly.

## Optional Behavior and Skips

Hooks are optional. Gemini CLI silently skips any missing hook definitions, unmatched hooks, or empty hook lists. A session therefore keeps working when no hooks are installed.

This is important operationally: hooks add extensibility, not a required bootstrap dependency.

## Synchronous Execution Model

Hooks run synchronously when their configured events fire. When an event fires, Gemini CLI blocks until the matching hook finishes or times out. Slow hooks therefore create visible latency for the user.

Keep hooks fast, deterministic, and lightweight. For most policies and notifications, aim for sub-second execution and avoid expensive network round-trips inside the critical path.
