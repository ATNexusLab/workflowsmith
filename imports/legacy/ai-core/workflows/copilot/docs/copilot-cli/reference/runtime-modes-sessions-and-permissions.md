# Runtime Modes, Sessions, And Permissions

Label: **Official reference**
Owner: `Interactive runtime modes and session lifecycle`
Last checked: `2026-05-20`
Version note: Mode names, slash commands, and session controls are version-sensitive.

This page owns the interactive runtime model for GitHub Copilot CLI: interfaces, modes, session continuity, steering, and context handling.

Related owner pages:

| Fact area | Owner page |
| --- | --- |
| Install and authenticate the CLI | [Installation, getting started, and authentication](installation-getting-started-and-authentication.md) |
| Full command and flag inventory | [Commands and official command surface](commands-and-official-command-surface.md) |
| Tool approvals, permission filters, and safety controls | [Tools, permissions, and safety controls](tools-permissions-and-safety-controls.md) |
| Prompt mode, CI/CD, and GitHub Actions | [Programmatic use and automation](programmatic-use-and-automation.md) |
| Models and OpenTelemetry | [Models, automation, and observability](models-automation-and-observability.md) |
| LSP, ACP, and remote interactive access | [LSP, ACP, and remote control](../integrations/lsp-acp-and-remote-control.md) |

## Two interfaces

Official docs describe two ways to use Copilot CLI:

| Interface | Entry point | Runtime shape |
| --- | --- | --- |
| Interactive | `copilot` | Session-oriented conversation with slash commands, approvals, context controls, and resume support |
| Programmatic | `copilot -p ...` or `copilot --prompt ...` | One-shot task execution that exits after completion |

## Documented mode controls

Official docs explicitly describe these interactive-session modes:

- default interactive ask/execute mode
- plan mode

The command reference also exposes `autopilot` through `--mode` and `--autopilot`.

Documented mode controls include:

- `/plan`
- `--plan`
- `--mode interactive|plan|autopilot`
- `--autopilot`
- `Shift + Tab` to cycle modes in the interactive interface

Plan mode is explicitly described as a pre-implementation planning phase in which Copilot can ask clarifying questions and build a structured plan before writing code.

## Session lifecycle

Official session continuity surfaces include:

| Capability | Official controls |
| --- | --- |
| Resume the most recent session | `--continue` |
| Browse and resume a prior session | `--resume`, `/resume`, `/continue` |
| Inspect or manage session metadata | `/session`, `/sessions` |
| Rename the current session | `/rename`, `/session rename` |
| Share or export a session transcript | `/share`, `/export`, `--share`, `--share-gist` |

The session picker also has documented keyboard controls for opening, sorting, switching local versus remote tabs, deleting, and closing.

## Steering active work

Official steering behavior includes both queued input and direct feedback:

- you can enter a new prompt while Copilot is still thinking
- each message is processed in order as part of the active task
- queued follow-up messages can also be sent with `Ctrl+Enter` or `Ctrl+Q`
- if you reject a tool request, you can give inline feedback so Copilot adapts its approach
- `Esc` cancels the current operation

Remote access to an interactive session is documented separately in [LSP, ACP, and remote control](../integrations/lsp-acp-and-remote-control.md).

## Context management

Official context controls include:

- automatic history compaction when the conversation approaches 95% of the token limit
- `/compact` for manual compaction
- `/context` for token-usage inspection and visualization

This is why official docs describe Copilot CLI sessions as effectively long-lived rather than single-prompt exchanges.

## Working-directory trust

Official docs recommend launching Copilot CLI only from directories you trust.

Why that matters:

- the CLI can read and modify files in scope
- it can run commands on your behalf
- repository-provided hooks, instructions, MCP configuration, and LSP configuration can affect runtime behavior

Official guidance also says you should typically avoid launching the CLI from your home directory.

## Permission boundary at runtime

At runtime, file access is scoped to the launch directory and its descendants unless you approve or configure broader access.

Related controls are documented elsewhere:

- directory expansion: `/add-dir`, `--add-dir`
- automatic approvals: `--allow-all`, `--allow-all-tools`, `--allow-tool`, and related flags
- remote access enablement: `/remote`, `--remote`, `--no-remote`

Use the tools page for the canonical approval and permission inventory.

## Sources

- [About GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli)
- [Using GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/overview)
- [Steering agents in GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/steer-agents)
- [GitHub Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
