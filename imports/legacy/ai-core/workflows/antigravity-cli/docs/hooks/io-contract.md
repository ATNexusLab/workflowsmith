<!-- topic: io contract | section: hooks -->
# Hooks I/O Contract

> **Quick Reference**
> - The golden rule is absolute: stdout must contain valid JSON only.
> - Send debug logs to stderr, never to stdout.
> - Exit code `0` means Gemini CLI parses stdout as the hook response.
> - Exit code `2` is the emergency block path; other non-zero exit codes are warnings and do not stop the operation.
> - Always wrap hook replies in `{"output": {...}}` and keep hooks under five seconds.

## The Golden Rule

Stdout must contain valid JSON only. Nothing else is allowed on that channel.

If a hook prints banners, debug text, or accidental shell output to stdout, Gemini CLI cannot safely parse the response. The hook should therefore treat stdout as a structured transport channel, not as a human log stream.

### Good stdout

```json
{
  "output": {}
}
```

### Bad stdout

```text
checking tool arguments...
{"output": {}}
```

The second example is invalid because stdout contains non-JSON text before the JSON object.

## Channel Rules

| Channel | Rule |
|---|---|
| `stdin` | Gemini CLI sends one JSON event payload to the hook process. |
| `stdout` | The hook returns one valid JSON object only. |
| `stderr` | The hook may emit debug logs, warnings, and trace output. |

`stderr` is the correct place for `echo`, `print`, stack traces, and diagnostic logs.

## Exit Codes

| Exit code | Meaning | CLI behavior |
|---|---|---|
| `0` | Success | Gemini CLI reads stdout and processes the structured response. |
| `2` | Emergency block | Gemini CLI immediately cancels the operation. This path is primarily intended for `BeforeTool`. |
| Any other non-zero value | Warning | Gemini CLI logs a warning, ignores stdout, and continues the original operation. |

The important operational distinction is that exit code `2` is an intentional control signal. Other non-zero codes are treated as hook failures, not policy decisions.

## Response Envelope

Every structured hook reply must be wrapped in an `output` object.

```json
{
  "output": {}
}
```

Event-specific data lives inside that envelope.

```json
{
  "output": {
    "tool": {
      "args": {
        "path": "src/app.ts"
      }
    }
  }
}
```

If the hook returns JSON without the `output` wrapper, the response is not in the documented contract.

## hookSpecificOutput

Some hook implementations expose event-specific fields through `hookSpecificOutput`. When that form is used, it still belongs inside the outer `output` envelope.

```json
{
  "output": {
    "hookSpecificOutput": {
      "BeforeToolSelection": {
        "tools": [
          {
            "name": "run_shell_command",
            "mode": "NONE"
          }
        ]
      }
    }
  }
}
```

`hookSpecificOutput` is the carrier for event-specific data. The event name selects the branch, and the nested object contains the fields Gemini CLI applies for that event.

## Timeout Behavior

Hooks run in the foreground of the CLI lifecycle, so latency matters. If a hook takes too long, Gemini CLI continues with a warning rather than waiting forever.

Keep hooks under five seconds whenever possible. Short hooks feel invisible to the user; slow hooks feel like the CLI is frozen.
