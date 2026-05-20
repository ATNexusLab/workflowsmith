# Antigravity CLI documentation index

This documentation suite is now **Antigravity-first** for user-facing navigation.

The existing Gemini-named modules remain as detailed implementation reference during the migration window. Start with the Antigravity atlas for capability discovery, workflow design, and lifecycle guidance, then load only the specific deep-reference module you need because each file is self-contained.

## Quick orientation

| I want to… | Start here |
|---|---|
| Understand Antigravity CLI in this repo | [antigravity-cli/](antigravity-cli/) |
| Create new workflow assets or choose where behavior belongs | [antigravity-cli/workflow-authoring.md](antigravity-cli/workflow-authoring.md) |
| Translate workflows from other agent/tools into local constructs | [antigravity-cli/workflow-adaptation.md](antigravity-cli/workflow-adaptation.md) |
| Plan, approve, then execute work | [antigravity-cli/planning-approval-execution.md](antigravity-cli/planning-approval-execution.md) → [advanced/plan-mode.md](advanced/plan-mode.md) |
| Inject instructions/context into every session | [antigravity-cli/configuration.md](antigravity-cli/configuration.md) |
| Follow the routing and planning protocol | [common/routing.md](../common/routing.md) |
| Create a reusable command or slash-like kickoff flow | [antigravity-cli/workflow-authoring.md](antigravity-cli/workflow-authoring.md) → [reference/slash-commands.md](reference/slash-commands.md) |
| Create a reusable agent for specialized tasks | [antigravity-cli/workflow-authoring.md](antigravity-cli/workflow-authoring.md) → [agents/](agents/) |
| Add procedural knowledge to the model (skills) | [antigravity-cli/workflow-authoring.md](antigravity-cli/workflow-authoring.md) → [skills/](skills/) |
| Intercept CLI lifecycle events | [antigravity-cli/workflow-authoring.md](antigravity-cli/workflow-authoring.md) → [hooks/](hooks/) |
| Connect external tools via MCP protocol | [antigravity-cli/workflow-authoring.md](antigravity-cli/workflow-authoring.md) → [mcp/](mcp/) |
| Bundle features as a distributable extension | [antigravity-cli/workflow-authoring.md](antigravity-cli/workflow-authoring.md) → [extensions/](extensions/) |
| Configure settings.json or environment variables | [antigravity-cli/configuration.md](antigravity-cli/configuration.md) → [settings/](settings/) |
| Look up built-in tools, slash commands, or CLI flags | [reference/](reference/) |
| Understand key architectural decisions | [decisions/](decisions/) |

## antigravity-cli/

The `antigravity-cli/` section is the top-level atlas for this repository. It explains what Antigravity CLI offers here, where new workflow behavior belongs, how the planning lifecycle works, how editable workflow surfaces fit together, and how the Gemini-to-Antigravity migration is being handled. Start with [`index.md`](antigravity-cli/index.md).

## agents/

Start with [`antigravity-cli/workflow-authoring.md`](antigravity-cli/workflow-authoring.md) to decide whether the new behavior should be an agent at all. The `agents/` section is the detailed implementation reference once you know the work needs isolated execution with its own model budget, tools, and context window. Start with [`fundamentals.md`](agents/fundamentals.md).

## skills/

Start with [`antigravity-cli/workflow-authoring.md`](antigravity-cli/workflow-authoring.md) to decide whether the new behavior belongs in a skill, command, or agent. The `skills/` section then covers how to package procedural knowledge into passive `SKILL.md` files that can be loaded into context. Start with [`fundamentals.md`](skills/fundamentals.md).

## hooks/

Start with [`antigravity-cli/workflow-authoring.md`](antigravity-cli/workflow-authoring.md) when you are deciding whether the behavior is a hook, agent, or skill. The `hooks/` section is the deeper reference for lifecycle hooks: external executables launched on CLI events with a strict JSON I/O contract. Start with [`fundamentals.md`](hooks/fundamentals.md).

## mcp/

Start with [`antigravity-cli/workflow-authoring.md`](antigravity-cli/workflow-authoring.md) when you are deciding whether the work belongs in MCP versus another local workflow surface. The `mcp/` section is the deeper reference for configuring external tool servers and resources. Start with [`fundamentals.md`](mcp/fundamentals.md).

## extensions/

Start with [`antigravity-cli/workflow-authoring.md`](antigravity-cli/workflow-authoring.md) when you are deciding whether to bundle multiple surfaces as an extension. The `extensions/` section documents installable bundles that package MCP servers, commands, skills, hooks, themes, and agents under one manifest. Start with [`fundamentals.md`](extensions/fundamentals.md).

## settings/

Start with [`antigravity-cli/configuration.md`](antigravity-cli/configuration.md) when you are deciding whether the change belongs in runtime configuration or an authored workflow surface. The `settings/` section remains the detailed reference for `settings.json`, environment variables, and precedence. Start with [`fundamentals.md`](settings/fundamentals.md).

## reference/

Use [`antigravity-cli/workflow-authoring.md`](antigravity-cli/workflow-authoring.md) first when you are deciding whether new behavior should be a command, skill, agent, or integration. The `reference/` section is the authoritative lookup area for exact built-in tools, slash commands, and CLI flags once the construct is already chosen. Start with [`built-in-tools.md`](reference/built-in-tools.md) or [`slash-commands.md`](reference/slash-commands.md), depending on what you need.

## advanced/

Start with [`antigravity-cli/planning-approval-execution.md`](antigravity-cli/planning-approval-execution.md) for the canonical planning lifecycle. The `advanced/` section remains the deeper reference for plan mode, headless mode, checkpointing, sandbox behavior, authentication, themes, and telemetry. Start with the module for your specific need, using [`index.md`](advanced/index.md) only as a chooser.

## decisions/

The `decisions/` section contains the architecture decision records that explain why key CLI behaviors exist. It covers the documented rationale behind context hierarchy, the skills-versus-agents split, the MCP naming convention, and the hook I/O contract. Start with [`index.md`](decisions/index.md).

## common/

The `common/` directory contains the shared operational protocols that apply in every session and across all agents: task completion criteria, test contract (3-axis: Behavior + Security + Performance), engineering principles, and the routing protocol. These are not documentation — they are standing rules. Load `common/routing.md` when making routing decisions; load the others at task completion to run the closeout and completion checklist.

## Modularity contract reminder

> **Loading rule:** Load only the modules relevant to your current task. Each file is self-contained — you do not need to load the entire section. Start with the section `index.md` to find the right module, then load only that file.
