# Workflow Composition Playbook

Label: **Generic adaptation**

Last checked: `2026-05-20`

Use this page when you want to build a new workflow from confirmed VS Code Chat constructs.

Do **not** use this page as a source-of-truth inventory page. For that, start with the official reference layer. Do **not** use this page for foreign-tool translation. For that, use [workflow-translation-playbook.md](../translation/workflow-translation-playbook.md).

## Composition building blocks

| Workflow need | Primary VS Code Chat construct |
| --- | --- |
| always-on project rules | `.github/copilot-instructions.md` |
| conditional rules | `*.instructions.md` |
| personal reusable guidance | user-level instructions |
| named reusable task | `.prompt.md` prompt file |
| persistent persona, tool restrictions, or handoffs | custom agent |
| portable multi-step capability with scripts or resources | agent skill |
| domain routing | `@` participant |
| action capability | tool, tool set, or MCP server |
| plan-first stage | Plan |
| autonomous execution stage | Agent |
| per-task model control | model picker, prompt file, or custom agent |
| review and rollback | pending changes, checkpoints, edit previous request |
| audit and troubleshooting | Agent Debug Log panel and Chat Debug view |

## Encode behavior in the right layer

| Put it here... | When the behavior is... |
| --- | --- |
| `.github/copilot-instructions.md` | always-on and repository-wide |
| `*.instructions.md` | conditional by file type, folder, or task |
| prompt file | a named task you want to invoke intentionally |
| custom agent | a role with a stable persona, restricted tools, model preference, or handoffs |
| skill | a portable capability that may need scripts, examples, or forked-context execution |
| prompt text and explicit context | ad hoc and specific to the current request |
| MCP server | external service or system access |

## Common composition patterns

### Plan -> implement -> review

Use:

1. **Plan** to shape the solution
2. **Agent** or a custom implementation agent to execute
3. pending-change review and checkpoints to decide what to keep
4. debug surfaces if behavior is unclear

### Repo guidance plus named task

Use:

- repository instructions for always-on rules
- path-specific instructions for specialization
- a prompt file for the named reusable workflow

This is a good default when the workflow is stable but does not need a persistent persona.

### Persona with explicit handoff

Use:

- a custom planning agent
- a handoff button into an implementation agent
- a review agent or review-oriented prompt file afterward

Choose this pattern when the workflow has clearly different phases and you want each phase to stay legible.

### Portable capability pack

Use:

- an agent skill when the behavior should work across VS Code, Copilot CLI, and cloud agent
- optional `context: fork` when the capability needs a focused subagent context

Choose this when the reusable asset is a capability rather than only a prompt or persona.

### External-tool workflow

Use:

- MCP for external actions or resources
- tool sets to group related actions
- prompt files or custom agents to package the workflow entrypoint

### Long-running execution with operator awareness

Use:

- a dedicated chat session
- queueing or steering when the agent is still running
- notifications when you want to work elsewhere while the task continues
- debug surfaces if the runtime does not behave as expected

## Workflow design checklist

1. Choose the chat surface and session shape.
2. Decide whether the workflow starts with Ask, Plan, Agent, or a custom agent.
3. Add only the context and tools the task actually needs.
4. Put reusable behavior in the right layer: instructions, prompt file, custom agent, or skill.
5. Decide the review and rollback boundary before you run the workflow.
6. Decide how you will inspect the workflow if it misbehaves.

## Sources

- [Use custom instructions in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
- [Use prompt files in VS Code](https://code.visualstudio.com/docs/copilot/customization/prompt-files)
- [Create custom agents in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [Use agent skills in VS Code](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [Use tools with agents](https://code.visualstudio.com/docs/copilot/agents/agent-tools)
- [Manage chat sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)
- [Review AI-generated code edits](https://code.visualstudio.com/docs/copilot/chat/review-code-edits)
- [Debug chat interactions](https://code.visualstudio.com/docs/copilot/chat/chat-debug-view)
