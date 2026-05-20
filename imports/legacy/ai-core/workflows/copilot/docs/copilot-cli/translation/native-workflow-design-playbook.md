# Native Workflow Design Playbook

Label: **Generic adaptation**

This playbook is for designing workflows directly in GitHub Copilot CLI from official capabilities, without importing another tool's structure first.

Boundary notes:

- Design from the Copilot CLI runtime and construct model.
- Use repo-local files only as examples, never as defaults.
- If a desired behavior is not supported by the official surface, keep it out of the design or record it as a gap.

## Design sequence

### 1. Define the job shape

Write the workflow in one sentence each for:

- primary outcome
- expected human involvement
- required external capabilities
- review or approval checkpoints
- delivery target such as patch, transcript, PR, or automation output

### 2. Choose the runtime first

| If the workflow is... | Start here |
| --- | --- |
| exploratory, iterative, or approval-heavy | interactive `copilot` session |
| plan-first before implementation | interactive session in plan mode |
| high-autonomy but still session-based | interactive autopilot mode |
| one-shot, scriptable, or machine-consumed | prompt mode with `copilot -p` |
| IDE-driven with editor context | interactive session plus VS Code connection |
| embedded in another client or system | ACP server mode |
| interactive work that may need later remote approval | interactive session with remote control enabled |

Runtime rule of thumb:

- prefer interactive mode for design, review, and negotiation
- prefer prompt mode for deterministic automation envelopes

### 3. Add only the constructs the workflow actually needs

| Need | Construct |
| --- | --- |
| stable baseline behavior | custom instructions |
| targeted reusable procedure | skill |
| specialist profile | custom agent |
| delegated isolated or parallel execution | subagent |
| external tools or service access | MCP server |
| lifecycle enforcement or audit behavior | hook |
| packaged distribution across users or repos | plugin |
| stronger code navigation and symbol operations | LSP server |

Avoid heavier constructs when a lighter surface is enough:

- do not use a custom agent when a skill is only adding procedure
- do not use a hook when the problem is just prompting guidance
- do not use MCP when built-in tools already cover the need

### 4. Decide the execution mode inside the runtime

| Execution choice | Best for | Review implication |
| --- | --- | --- |
| ask/interactive default | collaborative task progress | review can happen continuously |
| plan mode | plan approval before edits | requires a planning checkpoint |
| autopilot | longer autonomous runs | trust model must be tighter and more explicit |
| prompt mode | scripted execution | review happens before and after the run, not during |

### 5. Design the permission envelope

For advanced workflows, define permissions as part of the workflow contract:

- which directories must be readable
- which paths may be written
- which shell commands are acceptable
- which URLs or domains are allowed
- which MCP servers or tools are required
- whether the run may ask the user questions

Prefer least privilege first, then widen only when the workflow proves it needs more.

## Native workflow patterns

### Pattern: interactive implementation with review gates

Use when the user wants negotiation, visible planning, and change inspection.

Recommended stack:

- interactive session
- optional plan mode at the start
- custom instructions for baseline constraints
- skill for the specific task pattern
- `/diff` and `/review` before delivery

### Pattern: specialist workflow with bounded tools

Use when one task class needs its own perspective or narrower authority.

Recommended stack:

- custom agent
- optional skill for the procedure
- constrained tool or MCP access
- subagent delegation only if context isolation helps

### Pattern: programmatic automation lane

Use when the workflow must run from scripts, CI/CD, or Actions.

Recommended stack:

- `copilot -p`
- explicit `--model`
- explicit output format
- explicit allow or deny filters
- `--no-ask-user` only when pauses are unacceptable

Important boundary:

- prompt mode does not automatically load all repository-controlled extensions, hooks, or workspace MCP sources

### Pattern: editor-connected deep code work

Use when selection state, diagnostics, or symbol navigation are central.

Recommended stack:

- interactive session
- VS Code connection for editor context
- LSP configuration for language-aware operations

### Pattern: remotely supervised long-running session

Use when work is interactive and local, but approvals or steering may come from elsewhere later.

Recommended stack:

- interactive session
- remote control enabled
- local machine remains the execution environment

Boundary:

- remote control is not a substitute for prompt-mode automation

## Review and handoff checklist

Before you treat a workflow design as done, confirm:

- the runtime entrypoint is explicit
- the required constructs are explicit
- the permission envelope is explicit
- human approval points are explicit
- the delivery surface is explicit
- any unsupported behavior is called out explicitly

## Design anti-patterns

- starting from a copied foreign file layout instead of the Copilot CLI capability model
- bundling always-on guidance, workflow procedure, and policy enforcement into one surface
- assuming a specialist persona automatically implies delegated execution
- granting `--allow-all` because a narrower permission model was not planned
- treating prompt mode as feature-identical to interactive mode

## Sources

- [Customization taxonomy](../constructs/customization-taxonomy.md)
- [Runtime modes, sessions, and permissions](../reference/runtime-modes-sessions-and-permissions.md)
- [Commands and official command surface](../reference/commands-and-official-command-surface.md)
- [Tools, permissions, and safety controls](../reference/tools-permissions-and-safety-controls.md)
- [Programmatic use and automation](../reference/programmatic-use-and-automation.md)
- [Custom instructions](../constructs/custom-instructions.md)
- [Skills](../constructs/skills.md)
- [Custom agents and subagents](../constructs/custom-agents-and-subagents.md)
- [Hooks](../constructs/hooks.md)
- [MCP servers](../constructs/mcp-servers.md)
- [Plugins](../constructs/plugins.md)
- [VS Code connection](../integrations/vs-code-connection.md)
- [LSP, ACP, and remote control](../integrations/lsp-acp-and-remote-control.md)
