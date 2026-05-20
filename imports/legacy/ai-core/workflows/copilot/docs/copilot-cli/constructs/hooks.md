# Hooks

Label: **Official reference** with **generic adaptation** notes

Hooks let you run shell commands at defined lifecycle moments during Copilot agent execution. They are the right construct when prompt text is not enough and you need policy, validation, audit, or automation to happen at a specific event boundary.

## Hook locations

| Scope | Official location |
| --- | --- |
| Repository | `.github/hooks/*.json` |
| Personal | `~/.copilot/hooks/*.json` |

The configuration-directory reference also documents inline user-level hooks through the `hooks` key in `~/.copilot/settings.json`.

## Hook file format

Hook files are JSON and must contain:

- `version: 1`
- a `hooks` object whose keys map to arrays of hook definitions

Each hook definition uses `type: "command"` and can include:

- `bash`
- `powershell`
- `cwd`
- `env`
- `timeoutSec`

On multi-platform teams, the official guidance is to provide both `bash` and `powershell` entries so the right script is used on each operating system.

## Hook types

Official docs describe these lifecycle hooks:

- `sessionStart`
- `sessionEnd`
- `userPromptSubmitted`
- `preToolUse`
- `postToolUse`
- `agentStop`
- `subagentStop`
- `errorOccurred`

`preToolUse` is the most powerful boundary because it can approve or deny tool execution before the action happens.

## Operational behavior

Hooks run synchronously and block agent execution.

Official performance guidance:

- keep hooks under 5 seconds when possible
- use lightweight logging patterns
- move expensive work into background processing when appropriate
- cache expensive computations where it makes sense

Official security guidance:

- validate and sanitize hook input
- escape shell commands correctly
- do not log secrets
- set sensible timeouts
- be careful with external network calls

## Troubleshooting notes

The CLI hook guide specifically calls out these common failure cases:

- hook file is in the wrong directory
- invalid JSON syntax
- missing `version: 1`
- non-executable scripts or missing shebangs
- timeouts from slow scripts
- invalid JSON output from hooks that are expected to emit structured data

## Generic adaptation guidance

Use hooks when the requirement is event-driven and enforceable:

- log every prompt or tool invocation
- block dangerous shell patterns before they execute
- require a policy check before edits under sensitive paths
- react to subagent completion before results return upstream

Do not start with hooks when the problem is only about how Copilot should think. That usually belongs in custom instructions or a skill.

## Repo example

This repository's [hooks/guardrails.json](../../hooks/guardrails.json) is a concrete example of repository-level policy hooks. It is useful as a pattern example, not as a statement that every Copilot CLI setup should use the same guardrails.

## Sources

- [About hooks for GitHub Copilot](https://docs.github.com/en/copilot/concepts/agents/hooks)
- [Using hooks with GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/use-hooks)
- [GitHub Copilot CLI configuration directory](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference)
- [GitHub Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)