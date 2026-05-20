<!-- topic: cli flags | section: reference -->
# CLI Flags Reference

> **Quick Reference**
> - CLI flags configure Gemini CLI before a session starts.
> - Use `--prompt` for headless execution and `--output-format` to control machine-readable output.
> - Use sandbox flags when you need execution isolation.
> - Authentication flags choose how the CLI acquires credentials.
> - Headless mode uses fixed exit codes that scripts can rely on.

## Usage

```bash
gemini [flags] [prompt]
```

## What flags are

CLI flags are process-start options passed to the `gemini` executable. They affect model selection, execution mode, sandboxing, authentication, telemetry, and output formatting before the interactive session or headless run begins.

## Core flags

| Flag | Short | Type | Default | Description |
|---|---|---|---|---|
| `--model` | `-m` | string | `gemini-2.5-pro` | Model to use |
| `--prompt` | `-p` | string | — | Run in headless mode with this prompt |
| `--output-format` | — | string | `text` | Headless output format: `text`, `json`, `stream-json` |
| `--debug` | `-d` | boolean | `false` | Enable debug logging |
| `--yolo` | `-y` | boolean | `false` | Auto-approve all tool calls (YOLO mode) |
| `--checkpointing` | — | REMOVED | — | **Removed in v0.11.0** — use `settings.json` instead |

## Authentication flags

| Flag | Type | Description |
|---|---|---|
| `--google-auth` | boolean | Use Google OAuth instead of API key |
| `--service-account` | string | Path to service account JSON |

## Sandbox flags

| Flag | Type | Description |
|---|---|---|
| `--sandbox` | boolean/string | Enable sandbox with `true`, `docker`, or `macos-seatbelt` |
| `--sandbox-image` | string | Override the Docker sandbox image |

## Telemetry and debug flags

| Flag | Type | Description |
|---|---|---|
| `--telemetry` | boolean | Override telemetry enabled or disabled |
| `--debug-http` | boolean | Log all HTTP traffic |

## Sub-commands

Sub-commands are not flags. They change the top-level CLI verb.

| Sub-command | Description |
|---|---|
| `gemini mcp <subcommand>` | Manage MCP servers |
| `gemini extension <subcommand>` | Manage extensions |
| `gemini auth` | Configure authentication |
| `gemini update` | Update Gemini CLI to the latest version |

## Exit codes in headless mode

| Code | Meaning |
|---|---|
| `0` | Success |
| `1` | General error |
| `42` | Input or prompt error |
| `53` | Turn limit exceeded |
