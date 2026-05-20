# Source Ledger

Label: **Official reference**

Last checked: `2026-05-20`

This ledger tracks the official pages that anchor the atlas. Status values:

- `harvested`: already consulted and ready to support writing
- `identified`: official page confirmed, but still reserved for later extraction or deeper refresh

| Topic | Official page | Status | Why it matters |
| --- | --- | --- | --- |
| Product concept | [About GitHub Copilot Chat](https://docs.github.com/en/copilot/concepts/chat) | harvested | Defines the product-level chat model, customization families, models, and extensibility |
| IDE onboarding | [Getting started with prompts for GitHub Copilot Chat in your IDE](https://docs.github.com/en/copilot/how-tos/chat-with-copilot/get-started-with-chat-in-your-ide) | harvested | Confirms prompt keywords, early slash-command examples, and first-use patterns without redefining the full VS Code surface |
| IDE chat modes | [Asking GitHub Copilot questions in your IDE](https://docs.github.com/en/copilot/how-tos/chat-with-copilot/chat-in-ide) | harvested | Confirms Ask, Plan, and Agent modes at the product layer |
| Repository instructions | [Adding repository custom instructions for GitHub Copilot in your IDE](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions-in-your-ide/add-repository-instructions-in-your-ide) | harvested | Canonical repository and path-specific instruction file patterns |
| Custom-instruction support matrix | [Support for different types of custom instructions](https://docs.github.com/en/copilot/reference/custom-instructions-support) | harvested | Cross-surface support boundaries for instruction types |
| Customization taxonomy | [Copilot customization cheat sheet](https://docs.github.com/en/copilot/reference/customization-cheat-sheet) | harvested | High-level comparison of customization families and surface support |
| MCP overview for chat | [Extending GitHub Copilot Chat with Model Context Protocol (MCP) servers](https://docs.github.com/en/copilot/how-tos/context/model-context-protocol/extending-copilot-chat-with-mcp) | harvested | Product-level MCP policy and VS Code configuration entrypoint |
| GitHub MCP server | [Using the GitHub MCP Server in your IDE](https://docs.github.com/en/copilot/how-tos/context/model-context-protocol/using-the-github-mcp-server) | harvested | GitHub-specific MCP example and troubleshooting |
| Model switching | [Changing the AI model for GitHub Copilot Chat](https://docs.github.com/en/copilot/using-github-copilot/ai-models/changing-the-ai-model-for-copilot-chat) | harvested | Product-level model selection rules and limitations |
| Auto model selection | [About Copilot auto model selection](https://docs.github.com/en/copilot/concepts/auto-model-selection) | harvested | Product-level auto-model policy and request implications |
| Response customization concept | [About customizing GitHub Copilot responses](https://docs.github.com/en/copilot/concepts/prompting/response-customization) | harvested | Canonical distinctions between instruction families and prompt assets |
| VS Code chat overview | [Chat overview](https://code.visualstudio.com/docs/copilot/copilot-chat) | harvested | VS Code-native entrypoint for chat usage, surfaces, context, and edit review |
| VS Code context model | [Manage context for AI](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) | harvested | `#` context items, URLs, images, browser context, context-window usage, and compaction |
| VS Code feature cheat sheet | [GitHub Copilot in VS Code cheat sheet](https://code.visualstudio.com/docs/copilot/reference/copilot-vscode-features) | harvested | Slash commands, participants, tool and context inventories |
| VS Code agents overview | [Using agents in Visual Studio Code](https://code.visualstudio.com/docs/copilot/agents/overview) | harvested | Agent targets, built-in agents, permission levels, handoff, and working surfaces |
| VS Code subagents | [Use subagents in VS Code](https://code.visualstudio.com/docs/copilot/agents/subagents) | harvested | Isolated delegation, parallel analysis, nested subagents, and orchestration patterns |
| VS Code agent tools | [Use tools with agents](https://code.visualstudio.com/docs/copilot/agents/agent-tools) | harvested | Tool enablement, approval, URL review, terminal behavior, tool sets, sandboxing, and Autopilot |
| VS Code custom instructions | [Use custom instructions in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-instructions) | harvested | VS Code-native instruction-file authoring, precedence, diagnostics, compatibility files, and organization-level discovery |
| VS Code prompt files | [Use prompt files in VS Code](https://code.visualstudio.com/docs/copilot/customization/prompt-files) | harvested | Canonical prompt-file locations, frontmatter, execution, tool priority, and sync |
| VS Code custom agents | [Create custom agents in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-agents) | harvested | Persona-based workflow packaging, file locations, handoffs, and tool restrictions |
| VS Code agent skills | [Use agent skills in VS Code](https://code.visualstudio.com/docs/copilot/customization/agent-skills) | harvested | Portable capability packs, skill locations, metadata, and forked-context workflow building |
| VS Code MCP management | [Add and manage MCP servers in VS Code](https://code.visualstudio.com/docs/copilot/customization/mcp-servers) | harvested | `mcp.json`, trust, sync, registry, sandboxing, troubleshooting, and management workflow |
| VS Code language models | [AI language models in VS Code](https://code.visualstudio.com/docs/copilot/customization/language-models) | harvested | Model picker UX, thinking effort, auto-model behavior, model management, and BYOK boundaries |
| VS Code sessions | [Manage chat sessions](https://code.visualstudio.com/docs/copilot/chat/chat-sessions) | harvested | Session lifecycle, locations, queueing, fork, notifications, export, and session UI |
| VS Code review flow | [Review AI-generated code edits](https://code.visualstudio.com/docs/copilot/chat/review-code-edits) | harvested | Pending changes, accept/discard, source control, auto-accept, and sensitive-file handling |
| VS Code checkpoints | [Revert changes with checkpoints and editing requests](https://code.visualstudio.com/docs/copilot/chat/chat-checkpoints) | harvested | Request editing, checkpoint restore, redo, and branching from prior state |
| VS Code debug surfaces | [Debug chat interactions](https://code.visualstudio.com/docs/copilot/chat/chat-debug-view) | harvested | Agent Debug Log panel, Chat Debug view, troubleshooting, and session export/import |

## Usage rule

Add a module to the atlas only when it can point back to one or more rows in this ledger.

Use this ledger together with:

- [Atlas coverage matrix](atlas-coverage-matrix.md) to prove page-level provenance
- [Surface coverage matrix](surface-coverage-matrix.md) to prove official-surface completeness
