# Copilot CLI Documentation Atlas

This directory is a generic, official-source-backed base for understanding what GitHub Copilot CLI can do and how to compose its customization surfaces safely.

It has two jobs:

- document canonical Copilot CLI behavior from official GitHub Docs
- provide reusable guidance for translating patterns from other agent or configuration ecosystems into Copilot CLI constructs without assuming this repository's private workflow

## Content labels

Every page in this atlas should fit one of these labels:

- **Official reference**: factual behavior or supported configuration documented by GitHub
- **Generic adaptation**: reusable guidance for combining official features to solve a class of problems
- **Repo example**: an example taken from this `~/.copilot` repository, clearly marked as an example and never treated as an upstream default

## Reading paths

Start with these pages:

- [Source policy](reference/source-policy.md)
- [Source ledger](reference/source-ledger.md)
- [Glossary](reference/glossary.md)
- [Installation, getting started, and authentication](reference/installation-getting-started-and-authentication.md)
- [Runtime modes, sessions, and permissions](reference/runtime-modes-sessions-and-permissions.md)
- [Commands and official command surface](reference/commands-and-official-command-surface.md)
- [Tools, permissions, and safety controls](reference/tools-permissions-and-safety-controls.md)
- [Programmatic use and automation](reference/programmatic-use-and-automation.md)
- [Responsible use, security, and enterprise administration](reference/responsible-use-security-and-enterprise-administration.md)
- [Customization taxonomy](constructs/customization-taxonomy.md)
- [Custom instructions](constructs/custom-instructions.md)
- [Skills](constructs/skills.md)
- [Hooks](constructs/hooks.md)
- [Hooks reference](constructs/hooks-reference.md)
- [MCP servers](constructs/mcp-servers.md)
- [MCP governance](constructs/mcp-governance.md)
- [Custom agents and subagents](constructs/custom-agents-and-subagents.md)
- [Plugins](constructs/plugins.md)
- [Configuration directory and settings cascade](reference/configuration-directory-and-settings.md)
- [Command surface index](reference/command-surface-index.md)
- [Models, automation, and observability](reference/models-automation-and-observability.md)
- [VS Code connection](integrations/vs-code-connection.md)
- [LSP, ACP, and remote control](integrations/lsp-acp-and-remote-control.md)
- [Native workflow design playbook](translation/native-workflow-design-playbook.md)
- [Workflow translation method](translation/workflow-translation-method.md)
- [Construct selection matrix](translation/construct-selection-matrix.md)
- [Coverage matrix](reference/atlas-coverage-matrix.md)

## What this atlas covers

The full documentation set is organized around the official Copilot CLI capability model:

- CLI modes, sessions, commands, slash commands, and shortcuts
- custom instructions
- skills
- tools and permission controls
- MCP servers
- hooks
- custom agents and subagents
- plugins
- configuration directory, settings cascade, environment variables, and logs
- VS Code connection, LSP servers, and ACP integration
- automation, enterprise administration, and responsible use
- native workflow design from official capabilities
- translation of foreign workflow inputs into supported Copilot CLI patterns

## Current modules

### Foundation

- [Source policy](reference/source-policy.md)
- [Source ledger](reference/source-ledger.md)
- [Glossary](reference/glossary.md)
- [Installation, getting started, and authentication](reference/installation-getting-started-and-authentication.md)
- [Customization taxonomy](constructs/customization-taxonomy.md)

### Official runtime, safety, and automation owners

- [Runtime modes, sessions, and permissions](reference/runtime-modes-sessions-and-permissions.md)
- [Commands and official command surface](reference/commands-and-official-command-surface.md)
- [Tools, permissions, and safety controls](reference/tools-permissions-and-safety-controls.md)
- [Programmatic use and automation](reference/programmatic-use-and-automation.md)
- [Configuration directory and settings cascade](reference/configuration-directory-and-settings.md)
- [Models, automation, and observability](reference/models-automation-and-observability.md)
- [Responsible use, security, and enterprise administration](reference/responsible-use-security-and-enterprise-administration.md)

### Confirmed customization surfaces

- [Custom instructions](constructs/custom-instructions.md)
- [Skills](constructs/skills.md)
- [Hooks](constructs/hooks.md)
- [Hooks reference](constructs/hooks-reference.md)
- [MCP servers](constructs/mcp-servers.md)
- [MCP governance](constructs/mcp-governance.md)
- [Custom agents and subagents](constructs/custom-agents-and-subagents.md)
- [Plugins](constructs/plugins.md)

### Integrations and navigation

- [Command surface index](reference/command-surface-index.md)
- [VS Code connection](integrations/vs-code-connection.md)
- [LSP, ACP, and remote control](integrations/lsp-acp-and-remote-control.md)

### Provenance

- [Coverage matrix](reference/atlas-coverage-matrix.md)

### Translation and workflow design

- [Native workflow design playbook](translation/native-workflow-design-playbook.md)
- [Workflow translation method](translation/workflow-translation-method.md)
- [Construct selection matrix](translation/construct-selection-matrix.md)

## How to use this atlas

Use it in one of two ways:

1. **Native Copilot CLI design**: start with [Native workflow design playbook](translation/native-workflow-design-playbook.md), then use the taxonomy and owner pages.
2. **Cross-tool translation**: start with [Workflow translation method](translation/workflow-translation-method.md), then use the construct matrix and owner pages.

## Scope guardrails

- GitHub Docs are the canonical source of truth.
- Repository files under `~/.copilot` are used only as examples and divergence notes.
- When a direct Copilot CLI equivalent does not exist, the atlas must say so explicitly instead of inventing parity.

## Version note

Last checked against official GitHub Docs on `2026-05-20`.

Command inventories, settings keys, built-in agents, built-in MCP servers, and integration details are version-sensitive and should be revalidated after Copilot CLI upgrades.