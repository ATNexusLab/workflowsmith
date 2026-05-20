# Agents

> **Migration note:** This section remains the detailed reference for agent mechanics, but Antigravity-first readers should start from [../antigravity-cli/workflow-authoring.md](../antigravity-cli/workflow-authoring.md) to decide where new workflow behavior belongs and use [../antigravity-cli/index.md](../antigravity-cli/index.md) for the preferred navigation layer and migration guidance.

Gemini CLI agents are reusable, isolated workers defined in Markdown files and invoked explicitly or by automatic routing.

> **Quick Reference**
> - Agents are Markdown definitions discovered from `.gemini/agents/*.md` and `~/.gemini/agents/*.md`.
> - `@agent-name` forces a specific agent; natural language can trigger automatic dispatch.
> - Every subagent runs in its own context and returns through `complete_task`.
> - Subagents cannot invoke other subagents, even when they have all tools.
> - Use the table below to load exactly one module for the task at hand.

## Load by task

| Task | Load this module | What it answers |
|---|---|---|
| Understand what an agent or subagent is | [`fundamentals.md`](./fundamentals.md) | Core concepts, isolation, discovery, invocation basics, and recursion limits |
| Look up every supported frontmatter field | [`frontmatter-schema.md`](./frontmatter-schema.md) | Field-by-field reference, defaults, inheritance rules, and schema notes |
| Force an agent or understand automatic routing | [`invocation-and-routing.md`](./invocation-and-routing.md) | Explicit `@agent-name`, description-driven dispatch, parallel routing, and `complete_task` flow |
| Check what built-in agents already exist | [`built-in-agents.md`](./built-in-agents.md) | Names, default state, best use cases, and when not to use each built-in agent |
| Configure an agent that runs over HTTP with A2A | [`remote-agents.md`](./remote-agents.md) | `kind: remote`, `url`, auth types, execution differences, and security guidance |
| Write a new agent file effectively | [`authoring-guide.md`](./authoring-guide.md) | Placement, naming, description writing, tool/model choices, and common authoring mistakes |
| Find the documented discovery paths and precedence rules | [`fundamentals.md`](./fundamentals.md) | Official locations, workspace override behavior, and what is not documented |
| Decide whether to create an agent or a skill | [`authoring-guide.md`](./authoring-guide.md) | Decision rule for isolated workers versus parent-loaded playbooks |
