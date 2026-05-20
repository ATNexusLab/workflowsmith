# Review, Debug, and Sessions

Label: **Official reference**

Last checked: `2026-05-20`

This page covers the operational layer of VS Code Chat after a request has started: how work is grouped into sessions, how edits are reviewed, how requests are rewound, and how the runtime is inspected.

## Sessions are the runtime container

A **chat session** is one conversation with its own prompts, responses, and context.

Confirmed session behavior in VS Code includes:

- starting new sessions
- opening sessions in different chat locations
- moving a session between views
- running multiple sessions in parallel
- archiving or deleting sessions
- forking sessions
- sending messages while a request is still running
- exporting a session
- saving a session as a reusable prompt

## Where sessions can live

VS Code docs describe sessions in:

- the Chat view
- an editor tab
- a separate window
- a maximized layout
- the Agents window

The sessions list gives one management view across these surfaces.

## Sessions list and session controls

The sessions list can show:

- status
- type
- file changes
- time grouping
- filters
- pinned sessions

VS Code docs also describe:

- compact and side-by-side sessions-list layouts
- a session status indicator in the title bar
- workspace-scoped or global session-list behavior depending on whether a workspace is open

## Queueing, steering, and notifications

When a request is running, VS Code lets you:

- **Add to Queue**
- **Steer with Message**
- **Stop and Send**

Queued and steering messages can be reordered.

VS Code can also send OS notifications for:

- a response arriving
- a confirmation or input request

## Session branching and export

VS Code docs confirm:

- `/fork` to fork a full session
- forking from a checkpoint
- exporting a chat session as JSON
- `/savePrompt` to turn a session into a reusable prompt file
- copying individual messages, the whole session, or only the final response as Markdown

## Session handoff

Agent handoff creates a new session while carrying over the conversation history and context. The original session is archived after handoff.

Handoff is different from subagent execution. Handoff changes which session you continue in. A subagent performs delegated work as part of a broader workflow.

## Review flow for edits

When chat produces file edits, VS Code tracks them as **pending changes**.

Confirmed review surfaces include:

- changed-file list in the Chat view
- indicators in the Explorer and editor tabs
- inline diff and editor overlay controls to keep or undo edits
- Source Control integration
- review from the sessions list

VS Code docs also confirm:

- remembering pending-edit state across a VS Code restart
- auto-navigation between edits
- auto-accept edits after a configurable delay
- sensitive-file approval before applying edits to matched file patterns

## Recovery flow for whole batches

Use the checkpoint system when you need something broader than per-file review.

### Edit a previous request

This resends an earlier prompt after reverting changes from that request and all subsequent requests.

### Restore a checkpoint

This restores the workspace to the state captured for a prior request.

### Redo after restoring

This reapplies a restoration you just reversed accidentally.

### Fork from a checkpoint

This keeps the old path intact while creating a new branch in the conversation from that earlier state.

## Debug and inspection surfaces

VS Code documents two complementary debugging surfaces.

### Agent Debug Log panel

Use it for chronological operational tracing:

- tool calls
- model requests
- prompt discovery
- grouped subagent event views
- flow chart
- summary metrics
- cache explorer

This panel is documented as preview and persists logs locally for current and historical sessions.

VS Code docs also confirm:

- attaching debug events back into chat
- exporting a debug session
- importing a previously exported debug session

### Chat Debug view

Use it for raw payload inspection:

- system prompt
- user prompt
- context
- response details
- tool invocation payloads and responses

### Troubleshooting patterns

The debug docs explicitly support troubleshooting for:

- missing workspace context
- expected MCP tools not being invoked
- truncated or incomplete responses
- prompt files or instruction files not loading

The `/troubleshoot` slash command is also documented for session analysis when the required logging setting is enabled.

## Recommended operational sequence

1. Keep topic-specific work in its own session.
2. Review pending edits before treating them as accepted.
3. Use checkpoints when you need to revert a whole request boundary.
4. Use handoff when the next phase deserves its own session.
5. Use debug surfaces when the visible result does not match the intended workflow.

## Sources

- [Manage chat sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)
- [Review AI-generated code edits](https://code.visualstudio.com/docs/copilot/chat/review-code-edits)
- [Revert changes with checkpoints and editing requests](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints)
- [Debug chat interactions](https://code.visualstudio.com/docs/copilot/chat/chat-debug-view)
- [Using agents in Visual Studio Code](https://code.visualstudio.com/docs/copilot/agents/overview)
