# Construct Selection Matrix

Label: **Generic adaptation**

This matrix is a supporting tool for:

- [Workflow translation method](workflow-translation-method.md)
- [Native workflow design playbook](native-workflow-design-playbook.md)

Use it for fast construct matching after you have already decomposed the workflow. It is not a claim of one-to-one parity.

## Primary mapping table

| If the workflow needs... | Likely Copilot CLI target | Why |
| --- | --- | --- |
| A repository-wide instruction file | `.github/copilot-instructions.md` | Repository-wide custom instructions are the canonical always-on project surface |
| A user-wide instruction file | `~/.copilot/copilot-instructions.md` | Local instructions are the personal always-on surface |
| File-pattern-scoped rules | `.github/instructions/*.instructions.md` | Path-specific instructions are the canonical file-class surface |
| A named reusable workflow or playbook | Skill | Skills are the targeted workflow layer |
| An external tool provider or service bridge | MCP server | MCP adds executable tools and external context |
| A policy callback or event-driven script | Hook | Hooks run at lifecycle events |
| A specialist persona with instructions and tool constraints | Custom agent | Custom agents define specialist profiles |
| Delegated worker processes with isolated context | Subagent | Subagents are the execution-level delegation primitive |
| A distributable bundle of workflows, personas, and integrations | Plugin | Plugins package multiple customization surfaces together |
| An editor bridge with shared selection, diffs, and diagnostics | VS Code connection | `/ide` and the VS Code bridge cover editor-linked operation |
| A language-intelligence backend | LSP server | LSP adds diagnostics and symbol-level intelligence |

## Important non-equivalences

Some foreign constructs do not map one-to-one.

### One file can become multiple Copilot surfaces

A single foreign configuration file often mixes:

- always-on instructions
- file-pattern rules
- reusable task workflows
- external integrations

In Copilot CLI, those usually split across:

- custom instructions
- `.instructions.md` files
- skills
- MCP servers

### Persona is not the same as execution

If the foreign system talks about named workers or assistants, you may need both:

- a **custom agent** for the specialist definition
- a **subagent** for the delegated execution model

### Policy is not the same as prompting

If the foreign system enforces rules at runtime rather than merely suggesting them, map that part to **hooks** or permission settings, not just to custom instructions.

### Runtime shape is not the same as construct choice

You still need to choose how the workflow runs:

- interactive session
- plan mode
- autopilot mode
- prompt mode
- ACP server mode
- remote-controlled interactive session

Use the method or playbook for that decision; this matrix only helps with construct selection.

## Common compositions

### Global conventions plus targeted workflows

Use:

- custom instructions for baseline rules
- skills for named, task-specific procedures

### Specialist workflow with external capability

Use:

- a custom agent for the persona
- one or more MCP servers for extra tools
- hooks if you also need policy or audit boundaries

### Editor-centric workflow

Use:

- standard Copilot CLI runtime
- VS Code connection for selection, diff review, and diagnostics
- optional LSP configuration if language intelligence is part of the design

## Fast translation checks

Before you accept a mapping, confirm:

- is this mapping about guidance, capability, policy, or runtime?
- does one foreign artifact need to be split across multiple Copilot CLI surfaces?
- is the result equivalent, partial, or no-equivalent?

## Use this matrix inside the larger method

- For a full cross-tool procedure, use [Workflow translation method](workflow-translation-method.md).
- For designing directly from official Copilot CLI capabilities, use [Native workflow design playbook](native-workflow-design-playbook.md).
- For the native construct chooser, use [Customization taxonomy](../constructs/customization-taxonomy.md).

## Sources

- [Workflow translation method](workflow-translation-method.md)
- [Native workflow design playbook](native-workflow-design-playbook.md)
- [Customization taxonomy](../constructs/customization-taxonomy.md)
- [Custom instructions](../constructs/custom-instructions.md)
- [Skills](../constructs/skills.md)
- [Hooks](../constructs/hooks.md)
- [MCP servers](../constructs/mcp-servers.md)
- [Custom agents and subagents](../constructs/custom-agents-and-subagents.md)
- [Plugins](../constructs/plugins.md)
- [VS Code connection](../integrations/vs-code-connection.md)