# Customization Taxonomy

Label: **Official reference** with **generic adaptation** notes

This page turns the official Copilot CLI customization taxonomy into a decision aid. The core distinction comes from GitHub's own comparison of custom instructions, skills, tools, MCP servers, hooks, subagents, custom agents, and plugins.

For a full workflow-design procedure, use [Native workflow design playbook](../translation/native-workflow-design-playbook.md). For cross-tool mapping, use [Workflow translation method](../translation/workflow-translation-method.md).

## Choose by intent

| If your goal is... | Primary construct | Why this is the right fit |
| --- | --- | --- |
| Make Copilot follow repository or team conventions in every session | Custom instructions | They provide always-on guidance loaded at session start |
| Provide a repeatable workflow that only matters for a specific class of task | Skill | Skills inject focused instructions just in time |
| Let Copilot search, read, edit, or execute work to complete a request | Tool | Tools are the abilities the agent uses to act |
| Give Copilot access to external systems or domain-specific actions | MCP server | MCP adds tool collections beyond the built-in runtime |
| Enforce policy, logging, or lifecycle automation around agent behavior | Hook | Hooks run your logic at defined lifecycle moments |
| Apply specialist expertise or a constrained toolset to a type of work | Custom agent | Custom agents define a specialist profile that the main agent can delegate to |
| Offload work into a separate context window or run specialized work in parallel | Subagent | Subagents keep the main context focused and isolate delegated execution |
| Distribute a reusable bundle of customizations | Plugin | Plugins package skills, hooks, agents, MCP, and related assets together |

## When not to reach for a heavier construct

| Construct | Do not lead with it when... | Prefer instead |
| --- | --- | --- |
| Custom instructions | The behavior should only apply to one workflow or one class of task | Skill |
| Skill | You need a new capability, not just a new workflow | MCP server or custom agent |
| Hook | You only need prompt guidance, not lifecycle control | Custom instructions or skill |
| MCP server | Built-in tools already solve the problem | Existing tools |
| Custom agent | A lighter-weight skill is enough | Skill |
| Plugin | You are experimenting locally and do not need packaging or distribution | Local files in the repo or user config |

## Generic composition patterns

These are common compositions supported by the official model:

### Always-on conventions plus on-demand workflow

Combine **custom instructions** with one or more **skills** when you need a stable baseline and a task-specific overlay.

### Specialist persona with constrained permissions

Use a **custom agent** when the main agent should be able to delegate work to a specialist with a narrower toolset or domain focus.

### External capability with lifecycle guardrails

Combine an **MCP server** with **hooks** when you need extra tools plus policy or logging around how they are used.

### Team distribution

Use a **plugin** when you need to ship a consistent package of instructions, skills, hooks, agents, or MCP configuration to multiple users.

## Important distinction: custom agent vs subagent

- A **custom agent** is a definition.
- A **subagent** is a delegated execution.

In practice, Copilot CLI can run a custom agent *as* a subagent, but the two terms do not mean the same thing.

## Important distinction: skill vs tool

- A **skill** changes how Copilot approaches a task.
- A **tool** changes what Copilot can do while completing a task.

This distinction matters when translating from other ecosystems. If another tool exposes a static workflow document, it probably maps closer to a **skill** or **custom instructions**. If it exposes executable capabilities or external system access, it maps closer to a **tool** or **MCP server**.

## Sources

- [Comparing GitHub Copilot CLI customization features](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features)
- [Overview of customizing GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/overview)
- [About GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli)