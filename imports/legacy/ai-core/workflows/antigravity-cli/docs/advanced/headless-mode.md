<!-- topic: headless-mode | section: advanced -->
# Headless Mode

## Quick Reference

> - Headless mode runs Gemini CLI without the interactive terminal UI.
> - It is triggered by `-p`/`--prompt`, by piping standard input, or by `GEMINI_HEADLESS=1`.
> - Use `--output-format text|json|stream-json` to control machine-readable output.
> - Use `--yolo` to auto-approve all tool calls in non-interactive runs.
> - In headless plan mode, plan entry and exit are auto-approved and execution continues in YOLO mode after plan approval.

## What Headless Mode Is

Headless mode is Gemini CLI's non-interactive execution mode. It runs without a TTY-based chat interface and prints a response directly to standard output, which makes it suitable for shell scripts, pipelines, automation jobs, and CI systems.

Gemini CLI enters headless mode when either of these conditions is true:

- You pass a prompt with `-p` or `--prompt`
- You pipe input into `gemini`
- You force the mode with `GEMINI_HEADLESS=1`

## How to Trigger It

Use a direct prompt when the instruction is short and already known at invocation time:

```bash
gemini -p "your prompt"
```

Pipe standard input when the prompt or source material comes from another command:

```bash
echo "prompt" | gemini
```

You can also combine both patterns: use `-p` for the instruction and pipe or redirect input for the material to analyze.

```bash
gemini -p "Summarize this file" < input.txt
```

If you need to force headless behavior even when a TTY is attached, set:

```bash
export GEMINI_HEADLESS=1
```

## Output Formats

Set the output format with `--output-format`.

| Format | Use when | Behavior |
|---|---|---|
| `text` | You want normal shell output | Plain text response; this is the default |
| `json` | A program needs one structured result object | Emits one JSON object with response content and metadata |
| `stream-json` | A program needs real-time events | Emits JSON Lines; each line is a standalone JSON object |

### `text`

`text` is the default format. It prints the final answer as plain text, which makes it the simplest choice for pipes, redirection, and quick shell usage.

### `json`

`json` emits one JSON object after the run completes. Use it when a script needs to inspect the result, status data, or response content in a single parse step.

```bash
gemini -p "List all functions in main.go" --output-format json
```

Example shape:

```json
{
  "content": "...final response text...",
  "model": "gemini-2.5-pro",
  "stats": {
    "inputTokens": 123,
    "outputTokens": 456
  },
  "error": null
}
```

### `stream-json`

`stream-json` emits a JSONL event stream, one JSON object per line. It is designed for consumers that need progress updates before the final result is available.

```bash
gemini -p "Refactor this function" --output-format stream-json
```

Typical event categories include initialization, streamed assistant output, tool activity, warnings, and the final result.

## Exit Codes

| Code | Meaning |
|---|---|
| `0` | Success — task completed |
| `1` | General error |
| `42` | Input error (invalid prompt, bad flags) |
| `53` | Turn limit exceeded |

Scripts should treat `0` as success and branch on the non-zero values when they need different retry or failure behavior.

## YOLO Mode in Headless Runs

YOLO mode means Gemini CLI auto-approves every tool call instead of waiting for confirmation. In headless mode, enable it with:

```bash
gemini -p "Review this PR diff for security issues" --yolo < diff.txt
```

Use YOLO only when the prompt, available tools, and workspace boundaries are already controlled by your automation.

## Plan Mode in Headless Runs

Plan mode is a read-only planning phase in which Gemini CLI researches and writes a Markdown execution plan before making changes. In headless sessions, the `enter_plan_mode` and `exit_plan_mode` transitions are auto-approved because there is no interactive approval prompt.

After the plan is approved, the same session switches into YOLO mode for execution. That makes headless plan mode useful for CI or scripted workflows that want a planning step without manual confirmation in the middle of the run.

## Common Patterns

```bash
# Simple query
gemini -p "Summarize this file" < input.txt

# Get JSON output
gemini -p "List all functions in main.go" --output-format json

# Stream JSON events
gemini -p "Refactor this function" --output-format stream-json

# CI pipeline usage
gemini -p "Review this PR diff for security issues" --yolo < diff.txt
```

## Practical Guidance

Use `text` for shell-first workflows, `json` for single-result integrations, and `stream-json` for event-driven consumers. Add `--yolo` only when the environment is safe for full automation, and set `GEMINI_HEADLESS=1` when a terminal is attached but you still want non-interactive behavior.
