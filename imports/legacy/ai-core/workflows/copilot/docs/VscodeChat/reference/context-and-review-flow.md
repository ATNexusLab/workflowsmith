# Context and Review Flow

Label: **Official reference**

Last checked: `2026-05-20`

This page is the lifecycle map for VS Code Chat. It tells you which canonical page owns each stage of a request so the atlas stays readable without redefining the same surface in multiple places.

## 1. Choose where and how the chat runs

Start by deciding the chat surface and session shape:

- chat location or entry point
- agent target and built-in agent role
- permission level
- model

Canonical pages:

- [Chat surfaces and context](chat-surfaces-and-context.md)
- [Modes, participants, and tools](../constructs/modes-participants-and-tools.md)
- [MCP and models](../constructs/mcp-and-models.md)

## 2. Add the right context and guidance

Next, decide what should shape the request:

- implicit workspace context
- explicit `#` context items
- `@` participants
- instruction files
- prompt files
- custom agents or agent skills when the workflow needs a reusable persona or capability pack

Canonical pages:

- [Chat surfaces and context](chat-surfaces-and-context.md)
- [Instructions and prompt assets](../constructs/instructions-and-prompt-assets.md)
- [Workflow composition playbook](../composition/workflow-composition-playbook.md)

## 3. Let the agent act

During execution, the key runtime controls are:

- Ask, Plan, and Agent roles
- tool enablement and explicit tool references
- tool approvals, terminal behavior, and tool sets
- MCP-backed actions
- subagents and nested delegation when enabled

Canonical pages:

- [Modes, participants, and tools](../constructs/modes-participants-and-tools.md)
- [MCP and models](../constructs/mcp-and-models.md)

## 4. Review, rewind, or branch

When a request changes files or goes in the wrong direction, VS Code Chat gives you several decision layers:

- pending-change review
- source-control acceptance and discard behavior
- auto-accept or sensitive-file approval
- edit a previous request
- restore a checkpoint
- fork a conversation or a checkpoint

Canonical page:

- [Review, debug, and sessions](../integrations/review-debug-and-sessions.md)

## 5. Debug and iterate

When the visible result does not match the expected workflow, use the debug surfaces to inspect:

- prompt and context payloads
- tools that were available or invoked
- prompt discovery
- token usage, cache behavior, and exported sessions

Canonical page:

- [Review, debug, and sessions](../integrations/review-debug-and-sessions.md)

## Practical routing table

| Need | Canonical page |
| --- | --- |
| Pick the right chat surface or understand context compaction | [Chat surfaces and context](chat-surfaces-and-context.md) |
| Pick the right role, participant, tool, or permission level | [Modes, participants, and tools](../constructs/modes-participants-and-tools.md) |
| Decide between instructions, prompt files, custom agents, and skills | [Instructions and prompt assets](../constructs/instructions-and-prompt-assets.md) |
| Add MCP or tune the model | [MCP and models](../constructs/mcp-and-models.md) |
| Review edits, manage sessions, or debug a request | [Review, debug, and sessions](../integrations/review-debug-and-sessions.md) |
| Build a new workflow from official pieces | [Workflow composition playbook](../composition/workflow-composition-playbook.md) |
| Translate a foreign workflow into VS Code Chat | [Workflow translation playbook](../translation/workflow-translation-playbook.md) |

## Sources

- [Chat overview](https://code.visualstudio.com/docs/copilot/copilot-chat)
- [Manage context for AI](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context)
- [Review AI-generated code edits](https://code.visualstudio.com/docs/copilot/chat/review-code-edits)
- [Revert changes with checkpoints and editing requests](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints)
- [Debug chat interactions](https://code.visualstudio.com/docs/copilot/chat/chat-debug-view)
