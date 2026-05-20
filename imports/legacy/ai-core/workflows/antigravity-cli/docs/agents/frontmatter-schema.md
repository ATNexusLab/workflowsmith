<!-- topic: frontmatter schema | section: agents -->
# Agent Frontmatter Schema

> **Quick Reference**
> - Agent frontmatter is YAML between `---` markers at the top of the Markdown file.
> - `name` and `description` are required; `description` is the most important routing field.
> - If `tools` is omitted, the agent inherits all parent tools.
> - `tools: ["*"]` also grants all tools, but recursive subagent invocation is still blocked.
> - There is no `version` field and no `memory` field in the documented schema.

## What frontmatter controls

Agent frontmatter defines how Gemini CLI should identify, route, and run an agent. The Markdown body below the frontmatter remains the instruction prompt for the agent itself.

## Complete schema reference

| Field | Type | Required | Default | Description |
|---|---|---|---|---|
| `name` | string | yes | — | Display name for the agent |
| `description` | string | yes | — | Purpose, skills, and when to use the agent. This field is the primary input for automatic dispatch. |
| `kind` | enum | no | `local` | Execution mode. Use `local` for an agent that runs inside Gemini CLI or `remote` for an agent reached through the A2A protocol. |
| `tools` | string[] | no | inherit all | Tools this agent can use. If omitted, the agent inherits all parent tools. Recursive agent invocation remains blocked. |
| `mcpServers` | object | no | — | MCP server configuration available to this agent. Use this when the agent needs a specific MCP server scope. |
| `model` | string | no | parent model | Model used by this agent. If set on the agent, that selection is used for the subagent run. |
| `temperature` | number | no | default | Sampling temperature for the agent's model run. |
| `max_turns` | number | no | default | Maximum number of conversation turns allowed for the agent run. |
| `timeout_mins` | number | no | default | Timeout for the agent run, measured in minutes. |

## Notes that affect behavior

### `description` drives routing quality

`description` is the most important field in the schema because Gemini CLI reads it when deciding whether to auto-dispatch an agent. A vague description produces weak routing. A concrete description produces reliable routing.

### `tools` inheritance is implicit when omitted

If you leave out `tools`, the agent inherits **all** tools from the parent. This is the simplest starting point and the default behavior.

### `tools: ["*"]` is explicit all-tools access

`tools: ["*"]` is functionally similar to omit-and-inherit for tool breadth, but it does **not** remove the recursion block. Even with the wildcard, a subagent still cannot invoke other subagents.

### `model` is agent-local once set

If an agent defines `model`, that model selection applies to the subagent run. The parent session's `--model` flag does **not** override a subagent model configured in frontmatter.

### Remote-only additions

The schema above is the complete documented shared schema. Remote agents add remote-execution fields such as `url` and typically `auth`; those fields apply only when `kind: remote` is used.

### Unsupported documented assumptions

This reference does not document a `version` field or a `memory` field. If you are authoring against the documented schema, do not include either one.

## Example: local agent frontmatter

```yaml
---
name: docs-writer
description: Writes and restructures technical documentation, README files, and operator runbooks.
tools: ["*"]
model: gemini-2.5-pro
temperature: 0.2
max_turns: 12
timeout_mins: 20
---
```
