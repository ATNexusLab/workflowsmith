# Glossary

Label: **Official reference**

Last checked: `2026-05-20`

This glossary normalizes the core terms used throughout the atlas.

## Core runtime terms

### VS Code Chat

GitHub Copilot Chat as experienced inside Visual Studio Code, including chat surfaces, context controls, modes, tools, workflow customizations, edit review, and debug surfaces.

### Chat surface

One of the user-visible places where you interact with chat, such as the Chat view, inline chat, Quick Chat, an editor tab, a separate window, or the Agents window.

### Chat view

The main multi-turn chat surface in VS Code, optimized for conversations, agent sessions, and multi-file edits.

### Inline chat

The in-place chat surface used inside the editor or terminal for local edits and suggestions.

### Quick Chat

A lightweight question surface that opens without moving away from the current editor context.

### Agents window

A dedicated, agent-first window for orchestrating agent sessions across projects. It is documented as preview.

### Agent target

The session type that determines where the agent runs, such as local, background, or cloud.

### Ask mode

The conversational role used for questions, explanations, and targeted suggestions.

### Plan mode

The planning role used to create an implementation plan before editing or autonomous execution.

### Agent mode

The autonomous role in which Copilot can decide which files to edit, which tools to invoke, and how to iterate toward completion.

### Custom agent

A reusable `.agent.md` persona with its own instructions, tools, models, and optional handoffs.

### Agent skill

A reusable skill directory with a `SKILL.md` file plus optional scripts and resources. Skills are portable across multiple Copilot agent surfaces and can be loaded automatically or invoked manually.

### Subagent

An isolated agent execution delegated from a main agent session for focused research, analysis, review, or implementation work.

### Handoff

A guided transition from one agent to another with carried context and an optional pre-filled prompt.

### Chat session

A single conversation timeline in VS Code, including prompts, responses, context, and session-level runtime controls.

### Context compaction

The process of summarizing earlier conversation history to free space in the model's context window.

## Interaction terms

### Participant

A domain-specific chat assistant invoked with `@`, such as `@github`, `@terminal`, or `@vscode`. Participants are different from tools.

### Slash command

A chat shortcut invoked with `/` for a known task or reusable prompt, such as `/fix`, `/tests`, `/plan`, `/compact`, or `/<prompt name>`.

### Tool

An action capability available to an agent, such as reading workspace content, editing files, running terminal commands, fetching web content, or calling MCP-provided tools.

### Tool set

A named collection of tools that can be enabled, referenced, or packaged together as one reusable action bundle.

### Context item

An explicit piece of prompt context added with `#`, such as a file, symbol, folder, tool, terminal output, source-control changes, or `#codebase`.

## Customization terms

### Repository instructions

Always-on repository-wide instructions stored in `.github/copilot-instructions.md`.

### Path-specific instructions

One or more `*.instructions.md` files, typically under `.github/instructions`, that apply conditionally through `applyTo` globs or task matching.

### Agent instructions

Always-on compatibility instruction files such as `AGENTS.md` that GitHub support references explicitly call out for VS Code Chat.

### User-level instructions

Instruction files stored in VS Code-supported user locations such as `~/.copilot/instructions` or user-profile instruction storage. These are editor-native VS Code instruction surfaces.

### Claude compatibility instructions

Instruction files such as `CLAUDE.md` or `.claude/rules` that VS Code documents for Claude-oriented interoperability. Treat them as VS Code-documented compatibility surfaces, not as baseline GitHub support-matrix constructs.

### Organization instructions

Instructions defined at the GitHub organization level and discovered by VS Code when that discovery surface is enabled. Treat this as a discovery surface, not as the same thing as repository instructions.

### Prompt file

A reusable `.prompt.md` asset that can be run from chat and can optionally declare a description, name, agent, model, and tool list in frontmatter.

## Extension and model terms

### MCP server

An external tool and context provider exposed through the Model Context Protocol.

### MCP resource

Read-only data exposed by an MCP server that you can attach as context to a chat request.

### Tool approval

The confirmation model that governs whether an agent must ask before invoking tools or terminal commands.

### Sensitive file approval

The extra review step that VS Code can require before applying AI-generated edits to files matched as sensitive.

### Autopilot

A preview permission level in which the agent auto-approves tool calls, auto-responds to clarifying questions, and keeps working autonomously until the task is complete.

### Thinking effort

The adjustable reasoning level available for supported reasoning models in the model picker.

### Auto model selection

A mode in which VS Code chooses a model automatically instead of requiring a manual model pick.

## Review and observability terms

### Pending changes

AI-generated file edits that have been applied and saved, but still await accept-or-discard review.

### Auto-accept edits

A VS Code option that accepts AI-generated edits automatically after a configured delay.

### Checkpoint

A workspace snapshot created around a chat request so you can restore an earlier state or fork from it.

### Edit previous request

The workflow that resends an earlier prompt after reverting changes made by that request and all later requests.

### Debug view

The raw request-and-response inspection surface for chat interactions in VS Code.

### Agent Debug Log panel

A preview event log for chat sessions that shows chronological tool calls, prompt discovery, model requests, cache behavior, and errors.

## Scope terms

### Official reference

Atlas content that states behavior supported by official GitHub Docs or VS Code docs.

### Generic adaptation

Atlas content that explains how to combine official features into reusable patterns.

### Repo example

Atlas content that uses this repository as a local illustration and does not claim upstream default behavior.

### Core baseline

A first-line VS Code Chat construct or runtime surface backed cleanly by official docs.

### VS Code-documented compatibility surface

A surface that VS Code documents for interoperability or discovery but that should not be silently treated as a GitHub-wide default.

### Discovery surface

A configuration or discovery mechanism that helps VS Code find assets, such as organization instructions or parent-repository customizations, without itself being the main runtime construct.

## Sources

- [Asking GitHub Copilot questions in your IDE](https://docs.github.com/en/copilot/how-tos/chat-with-copilot/chat-in-ide)
- [Support for different types of custom instructions](https://docs.github.com/en/copilot/reference/custom-instructions-support)
- [GitHub Copilot in VS Code cheat sheet](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features)
- [Use custom instructions in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)
- [Use prompt files in VS Code](https://code.visualstudio.com/docs/copilot/customization/prompt-files)
- [Create custom agents in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-agents)
- [Use agent skills in VS Code](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [Use subagents in VS Code](https://code.visualstudio.com/docs/copilot/agents/subagents)
- [Manage chat sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions)
- [Review AI-generated code edits](https://code.visualstudio.com/docs/copilot/chat/review-code-edits)
- [Revert changes with checkpoints and editing requests](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints)
- [Debug chat interactions](https://code.visualstudio.com/docs/copilot/chat/chat-debug-view)
