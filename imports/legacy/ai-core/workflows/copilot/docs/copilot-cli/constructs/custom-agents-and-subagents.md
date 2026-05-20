# Custom Agents And Subagents

Label: **Official reference** with **generic adaptation** notes

Custom agents and subagents are related, but they are not the same thing.

- A **custom agent** is a specialist profile defined in Markdown.
- A **subagent** is a delegated execution spun up by the main agent.

Copilot CLI can run a custom agent as a subagent when that specialist profile is the right fit for the work.

## Custom agent locations

| Scope | Official locations |
| --- | --- |
| Project | `.github/agents/`, `.claude/agents/` |
| User | `~/.copilot/agents/` |
| Plugin | Plugin-provided agent directories |

The invocation guide also documents organization and enterprise-level agents distributed from `.github-private`.

Official precedence guidance indicates that more personal or system-level definitions override broader scopes when names collide.

## File format

Custom agents are defined in Markdown files that usually end with `.agent.md`.

The command reference documents these important frontmatter fields:

- `description`
- `infer`
- `mcp-servers`
- `model`
- `name`
- `tools`

The file body carries the agent's role, instructions, and constraints.

## How custom agents are created

Official interactive flow:

1. Run `/agent`.
2. Choose to create a new agent.
3. Choose project or user scope.
4. Let Copilot draft the file, or create it manually.
5. Choose the toolset.
6. Restart the CLI to load the new agent.

When authoring manually, official guidance recommends lowercase names with hyphens for easier programmatic use.

## How custom agents are used

Official docs describe three main usage paths:

- `/agent` to select one in the interactive interface
- explicit prompt callout, such as asking Copilot to use a named agent
- automatic inference based on the agent description

There is also programmatic usage with `--agent`, for example `copilot --agent security-auditor --prompt "..."`.

## Built-in agents and delegated work

Official docs show that Copilot CLI already ships with built-in specialist agents. Across the command reference and invocation guide, these include agents such as:

- Explore
- Task
- General-purpose
- Code-review
- Research
- Rubber-duck

These are version-sensitive and should be revalidated against the command reference after CLI upgrades.

## Subagent limits

The command reference documents runtime limits for subagent depth and concurrency, backed by environment variables:

- `COPILOT_SUBAGENT_MAX_DEPTH`
- `COPILOT_SUBAGENT_MAX_CONCURRENT`

Those limits exist to prevent runaway delegation.

## Generic adaptation guidance

Choose a custom agent when the foreign pattern you are translating needs one or more of these properties:

- a specialist persona
- a constrained toolset
- optional inference from prompts
- its own instructions and possibly its own MCP connections

Choose a subagent-oriented design when the main need is context isolation, delegated execution, or parallel work.

## Repo example

The [agents](../../agents) directory in this repository is a personal user-level custom-agent library. Its three-agent roster is a local design choice, not an official Copilot CLI limit or default.

## Sources

- [Creating and using custom agents for GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli)
- [Invoking custom agents](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/invoke-custom-agents)
- [GitHub Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
- [Comparing GitHub Copilot CLI customization features](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features)