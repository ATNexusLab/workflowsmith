# Modes, Participants, and Tools

Label: **Official reference** with **generic adaptation** notes

Last checked: `2026-05-20`

This page covers the primary runtime control surfaces for VS Code Chat.

## Choose the right runtime control

| If your goal is... | Primary surface | Why |
| --- | --- | --- |
| ask a question, explain code, or get targeted suggestions | Ask | lowest-overhead conversational role |
| produce a structured implementation plan before acting | Plan | separates planning from editing |
| let Copilot work through a task, edit files, and invoke tools | Agent | best for multi-step autonomous work |
| route the request to a domain specialist | `@` participant | conversation routing surface |
| constrain what actions are available | tools and tool sets | action surface |

## Distinguish the runtime layers

| Construct | What it changes |
| --- | --- |
| **Agent target** | where the agent runs |
| **Agent role** | how the agent approaches the task |
| **Participant** | who handles the conversation |
| **Tool** | what the agent can do |
| **Permission level** | how much autonomy the agent has |

## Agent targets and built-in roles

VS Code docs distinguish where the agent runs from which role it uses.

### Agent targets

Examples documented by VS Code include:

- **Local**: interactive work in the editor with full workspace, tool, and model access
- **Copilot CLI**: background work on your machine
- **Cloud agent**: remote execution integrated with GitHub workflows
- **Third-party**: external providers such as Anthropic or OpenAI through the third-party agent harness

### Built-in roles

The built-in agent roles documented in VS Code are:

- **Ask**
- **Plan**
- **Agent**

These roles can also be replaced or extended with custom agents.

## Participants

Participants are the domain-routing layer. Built-in examples documented by VS Code include:

- `@github`
- `@terminal`
- `@vscode`

Use a participant when the main problem is domain routing rather than tool execution.

## Slash commands

Slash commands are shortcuts to specific chat actions. Confirmed examples in the VS Code references include:

- `/explain`
- `/fix`
- `/tests`
- `/new`
- `/plan`
- `/compact`
- `/savePrompt`
- `/startDebugging`
- `/troubleshoot`
- `/<prompt name>`

Built-in inventories are version-sensitive, and extensions can add more.

## Tools

Tools are the action layer. VS Code docs describe tool usage for tasks such as:

- listing or reading workspace content
- editing files
- running terminal commands
- fetching web content
- calling MCP-provided tools
- using tools contributed by extensions

### Enable tools for a request

In Agent mode, use the tools picker to enable or disable tools for the current request. This is the quickest way to narrow the action surface to what the task actually needs.

### Explicit tool references

By default, the agent chooses tools automatically from the enabled set. You can also explicitly reference a tool by typing `#` followed by its name.

### Tool approvals

VS Code documents three permission levels:

- **Default Approvals**
- **Bypass Approvals**
- **Autopilot** (Preview)

Approvals can apply to both tool invocation and, for some tools, review of the tool output before it is added back into context. URL fetching uses separate request and response approvals.

### Tool sets

Tool sets are named collections of related tools that you can reference as a single entity, such as `#search` or a custom set defined in a tool-sets file.

### Terminal behavior

When the agent runs terminal commands, VS Code can show:

- the command in chat
- inline output
- the corresponding integrated terminal

VS Code docs also describe:

- continuing long-running terminal commands in the background
- command auto-approval rules
- best-effort protections and their limits
- preview sandboxing for agent commands

## Subagents

Subagents extend agent workflows when isolated research, analysis, or parallel delegation is useful.

Key boundaries:

- a **subagent** is usually agent-initiated, not directly user-invoked
- a **subagent** stays inside the broader workflow instead of becoming a separate manual work thread
- a **custom agent** can be used as a subagent
- nested subagents are disabled by default and documented as experimental

Use subagents for:

- isolated research before implementation
- parallel code analysis
- comparing multiple solutions
- multi-model consensus

## Handoff versus subagent

- **Handoff** creates a new session and moves the workflow to another agent target or role.
- **Subagent** performs delegated work inside the broader workflow and returns a result.

Use handoff when the next step should become its own session. Use a subagent when the work should stay part of the current task.

## Permission-level guidance

| Permission level | What changes |
| --- | --- |
| **Default Approvals** | safe defaults, approval dialogs for protected actions |
| **Bypass Approvals** | auto-approves tool calls but may still ask clarifying questions |
| **Autopilot** | auto-approves tool calls, auto-responds to clarifying questions, and keeps iterating |

Higher autonomy can improve speed but reduces human review. Use it only when the workspace, tools, and task risk justify it.

## Important distinctions

### Participant vs tool

- A **participant** changes who handles the conversation.
- A **tool** changes what the agent can do.

### Agent target vs agent role

- **Agent target** changes where the agent runs.
- **Agent role** changes how it approaches the work.

### Handoff vs subagent

- A **handoff** creates a new session with carried context.
- A **subagent** performs delegated work as part of the broader workflow.

### Slash command vs prompt file

- A **slash command** is the runtime invocation surface.
- A **prompt file** can become one slash-invoked item, but is authored separately as a file asset.

## Practical usage pattern

1. Pick the **agent target** first if execution environment matters.
2. Pick **Ask**, **Plan**, or **Agent** for the role.
3. Add a **participant** only when domain routing matters.
4. Enable only the **tools** the task actually needs.
5. Raise the **permission level** only when the extra autonomy is worth the risk.
6. Use a **subagent** for isolated or parallel work and a **handoff** when the next step deserves its own session.

## Sources

- [Asking GitHub Copilot questions in your IDE](https://docs.github.com/en/copilot/how-tos/chat-with-copilot/chat-in-ide)
- [GitHub Copilot in VS Code cheat sheet](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features)
- [Using agents in Visual Studio Code](https://code.visualstudio.com/docs/copilot/agents/overview)
- [Use subagents in VS Code](https://code.visualstudio.com/docs/copilot/agents/subagents)
- [Use tools with agents](https://code.visualstudio.com/docs/copilot/agents/agent-tools)
