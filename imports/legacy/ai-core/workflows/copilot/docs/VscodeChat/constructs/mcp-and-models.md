# MCP and Models

Label: **Official reference** with **generic adaptation** notes

Last checked: `2026-05-20`

This page covers the two main ways to expand or tune VS Code Chat beyond its default runtime: adding external tools through MCP and changing the model used for chat.

## Choose by intent

| If you need... | Primary surface | Why |
| --- | --- | --- |
| new tools, resources, or external system access | MCP server | expands what the agent can do |
| a different reasoning profile or provider | model picker | changes which model powers the conversation |
| automatic balancing across available models | Auto | lets VS Code choose the model |

## MCP in VS Code Chat

GitHub Docs define MCP as the open protocol for sharing tools and context with LLM-powered applications. VS Code docs define how MCP is configured, trusted, and managed inside VS Code.

### Confirmed MCP workflow

VS Code docs confirm:

- adding servers through `mcp.json`
- installing servers from the MCP server gallery
- configuring servers in workspace or user-profile scope
- adding servers through guided commands
- discovering MCP configurations from other tools when discovery is enabled
- using MCP tools in chat after the server is configured
- managing servers from VS Code

### Scope and locations

`mcp.json` can exist in:

- `.vscode/mcp.json` for workspace scope
- the user profile for cross-workspace scope

Workspace scope is the right place when the team should share the server configuration in version control. User scope is the right place when the server is personal and reused across workspaces.

### Trust, policy, and start behavior

VS Code docs also describe:

- an MCP trust confirmation flow before starting a server
- enable and disable states separate from the configuration file
- central organization policy over MCP access
- experimental auto-start behavior when configuration changes
- Settings Sync support for MCP server configurations

### Other MCP capabilities

Beyond tools, VS Code docs also describe:

- **resources** as read-only MCP context
- **prompts** exposed by an MCP server
- **MCP Apps** for richer interactive UI in chat

Treat MCP Apps and some registry features as especially version-sensitive.

### Sandboxing and troubleshooting

VS Code docs confirm:

- sandboxing for local stdio MCP servers on macOS and Linux
- server logs and output views for debugging
- configuration from dev containers

GitHub Docs remain canonical for product-level MCP policy and enterprise access boundaries.

## Models in VS Code Chat

VS Code docs confirm a model picker in chat for selecting the model used for chat conversations and code editing.

Confirmed model controls include:

- changing the model in the chat input area
- configuring thinking effort for supported reasoning models
- using Auto model selection
- managing model visibility from the language-models editor
- bringing your own model key for chat-only model extension in VS Code

### Boundaries to keep straight

- GitHub Docs are canonical for product-level model availability, premium-request implications, and broader policy.
- VS Code docs are canonical for model picker UX, thinking effort, model management, and BYOK behavior in the editor.
- BYOK in VS Code is a chat-focused surface and does not imply the same behavior for inline suggestions or every other Copilot feature.

### Auto model selection

Both GitHub Docs and VS Code docs describe auto model selection as a way to optimize model choice dynamically. In VS Code, it is chosen from the model picker as **Auto**.

### Thinking effort

For supported reasoning models, VS Code lets you change the thinking-effort level directly from the model picker. The setting persists per model.

### Manage models and BYOK

VS Code also documents:

- the language-models editor
- filtering by capabilities such as tools, vision, and agent support
- model visibility in the picker
- BYOK providers for chat

For agent workflows, tool-calling support matters. A model that lacks tool-calling support is not suitable for many Agent-mode tasks.

## Prompt, agent, and model interaction

Prompt files and custom agents can influence model and tool choice:

- prompt files can declare a model and tools
- custom agents can declare a model and tools
- prompt-file tools override a referenced custom agent's tool list

This makes prompt files and custom agents the main reusable surfaces for packaging model and tool choices with a workflow.

## Practical guidance

### Reach for MCP when:

- the chat needs tools or data outside the built-in runtime
- the workflow depends on service-specific actions
- you want external resources or prompts exposed to chat

### Reach for model controls when:

- a task needs more or less reasoning effort
- a task class works better with a different model family
- you want Auto to balance model choice dynamically

## Sources

- [Extending GitHub Copilot Chat with Model Context Protocol (MCP) servers](https://docs.github.com/en/copilot/how-tos/context/model-context-protocol/extending-copilot-chat-with-mcp)
- [Using the GitHub MCP Server in your IDE](https://docs.github.com/en/copilot/how-tos/context/model-context-protocol/using-the-github-mcp-server)
- [Changing the AI model for GitHub Copilot Chat](https://docs.github.com/en/copilot/using-github-copilot/ai-models/changing-the-ai-model-for-copilot-chat)
- [About Copilot auto model selection](https://docs.github.com/en/copilot/concepts/auto-model-selection)
- [Add and manage MCP servers in VS Code](https://code.visualstudio.com/docs/copilot/customization/mcp-servers)
- [AI language models in VS Code](https://code.visualstudio.com/docs/copilot/customization/language-models)
