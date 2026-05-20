# Chat Surfaces and Context

Label: **Official reference**

Last checked: `2026-05-20`

This page covers the user-facing places where VS Code Chat runs and the context controls that shape what the model sees.

## Chat entry points and working surfaces

VS Code provides multiple ways to start a chat conversation:

| Surface | Best for | Notes |
| --- | --- | --- |
| **Chat view** | multi-turn conversations, agent workflows, multi-file edits | Main chat surface in the sidebar |
| **Inline chat** | in-place code edits and terminal suggestions | Works close to the active editor or terminal |
| **Quick Chat** | quick questions without leaving the current view | Lightweight overlay surface |
| **Editor tab** | giving chat more space or comparing sessions side by side | Opened as a chat editor |
| **Separate window** | multi-monitor or detached chat work | Same session can move between views |
| **Maximized chat** | focus on the current session | Uses the full editor area |
| **Agents window** | agent-first orchestration across projects | Preview surface |
| **Command line** | starting chat from outside VS Code | `code chat` entrypoint |

The main VS Code window and the Agents window share the same sessions, settings, and keybindings. They are different working surfaces, not separate products.

## Session-shaping controls in the chat input

When you start a session in the Chat view, several controls shape the request:

- **Agent target**: where the agent runs, such as local, background, cloud, or a third-party target
- **Agent role**: Ask, Plan, Agent, or a custom agent
- **Permission level**: Default Approvals, Bypass Approvals, or Autopilot
- **Model**: the selected language model or Auto

These controls are session-level runtime choices, not substitutes for instructions or prompt files.

## Context sources

VS Code Chat can use both implicit and explicit context.

### Implicit context

VS Code can automatically include:

- the active file
- the current selection
- the file name
- additional workspace context chosen by the agent

### Explicit context with `#`

Type `#` in chat to add explicit context items such as:

- files, folders, and symbols
- the full workspace with `#codebase`
- terminal output
- source-control changes
- tools

Use explicit context when the request could otherwise be interpreted as a generic question.

### URLs and web fetch

You can:

- paste a URL directly into the prompt
- use the `#fetch` tool to retrieve web content

URL access is approval-sensitive. VS Code can cache fetched content briefly, and URL approvals have separate request and response review steps.

### Participants with `@`

Use `@` participants when you need domain routing instead of an action capability. Built-in examples include:

- `@github`
- `@terminal`
- `@vscode`

Participants are different from tools. A participant routes the conversation. A tool performs work.

### Images and browser context

VS Code docs also confirm:

- images as prompt context for vision-capable chat
- browser elements from the integrated browser
- browser tools that let an agent read and interact with pages directly
- sharing an already-open browser tab with an agent so it can use the existing session state

Browser elements are context. Browser tools are action capabilities. Keep those concepts separate.

## Monitor context window usage

The chat input can show a context-window control that helps you track how much context space is in use.

The control can show:

- a visual fill indicator
- total token usage and a breakdown on hover

Use it to judge when the session is getting noisy enough that a new session or compaction is better than continuing to append more history.

## Context compaction

When the context window fills up, VS Code can compact the conversation by summarizing earlier messages.

### Automatic compaction

- happens when the context window fills
- runs in the background
- can be disabled with the relevant setting

### Manual compaction

You can compact a conversation manually by:

- typing `/compact`
- selecting the context-window control and choosing **Compact Conversation**

Manual compaction is useful when the conversation still matters, but the older detail has become noise.

If you want a truly clean reset, start a new chat session instead of compacting.

## Practical chooser

| Need | Primary surface |
| --- | --- |
| multi-turn task with edits and review | Chat view |
| local code change close to the cursor | Inline chat |
| quick question without leaving the editor | Quick Chat |
| long-running or detached chat workspace | Editor tab, separate window, or Agents window |
| explicit code or tool context | `#` context items |
| domain routing | `@` participant |
| web or browser context | URL, `#fetch`, images, browser elements, or browser tools |
| recover from a noisy session without losing everything | `/compact` |
| start clean because the topic changed | new chat session |

## Boundaries

- A chat surface is not the same as an agent target.
- A participant is not the same as a tool.
- Browser elements are not the same as browser tools.
- Context compaction is not the same as starting a new session.

## Sources

- [Chat overview](https://code.visualstudio.com/docs/copilot/copilot-chat)
- [Manage context for AI](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context)
- [Manage chat sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)
- [Using agents in Visual Studio Code](https://code.visualstudio.com/docs/copilot/agents/overview)
