# VS Code Chat Documentation Atlas

This directory is a generic, official-source-backed base for understanding GitHub Copilot Chat in VS Code and for composing confirmed VS Code Chat workflows without assuming this repository's private setup as an upstream default.

It has two jobs:

- document canonical GitHub Copilot Chat behavior in VS Code from official GitHub Docs and VS Code docs
- provide reusable guidance for designing new workflow pieces and translating flows from other AI tools into confirmed VS Code Chat constructs

## Content labels

Every page in this atlas should declare one primary label from this set:

- **Official reference**: factual behavior or supported configuration documented by GitHub or VS Code
- **Generic adaptation**: reusable guidance for combining official features into a repeatable pattern
- **Repo example**: a repository-specific example, clearly marked as local and never treated as an upstream default

Some pages can also include clearly marked **generic adaptation notes** when the page remains primarily a source-backed reference.

## Stability markers

Use these markers when a page or section needs extra scoping:

- **Core baseline**: a first-line VS Code Chat surface backed cleanly by official sources
- **VS Code-documented compatibility surface**: documented by VS Code, but not necessarily listed as a GitHub support-matrix baseline
- **Discovery surface**: editor discovery or sync surface, not the same as a core runtime construct
- **Preview**: explicitly documented as preview
- **Version-sensitive**: likely to drift across VS Code or Copilot releases

## Reading paths

### 1. Official VS Code Chat coverage

Start here when you want the sourced capability map first:

1. [Source policy](reference/source-policy.md)
2. [Source ledger](reference/source-ledger.md)
3. [Atlas coverage matrix](reference/atlas-coverage-matrix.md)
4. [Surface coverage matrix](reference/surface-coverage-matrix.md)
5. [Glossary](reference/glossary.md)
6. [Scope and capability model](reference/scope-and-capability-model.md)
7. [Chat surfaces and context](reference/chat-surfaces-and-context.md)
8. [Instructions and prompt assets](constructs/instructions-and-prompt-assets.md)
9. [Modes, participants, and tools](constructs/modes-participants-and-tools.md)
10. [MCP and models](constructs/mcp-and-models.md)
11. [Context and review flow](reference/context-and-review-flow.md)
12. [Review, debug, and sessions](integrations/review-debug-and-sessions.md)

### 2. Workflow design and translation

Start here when you already trust the reference layer and want to build or translate workflows:

1. [Workflow composition playbook](composition/workflow-composition-playbook.md)
2. [Construct selection matrix](translation/construct-selection-matrix.md)
3. [Workflow translation playbook](translation/workflow-translation-playbook.md)

## What this atlas covers

This atlas covers the confirmed VS Code Chat surface needed to understand, design, and translate workflows:

- chat entry points and chat locations
- Ask, Plan, and Agent roles plus agent targets and permission levels
- context items, participants, browser context, context-window usage, and compaction
- repository instructions, path-specific instructions, compatibility and discovery instruction surfaces, prompt files, custom agents, and agent skills
- tools, tool sets, MCP servers, model selection, and thinking controls
- sessions, pending edits, checkpoints, handoff, export, notifications, and debug surfaces

## Current modules

### Provenance and scope

- [Source policy](reference/source-policy.md)
- [Source ledger](reference/source-ledger.md)
- [Atlas coverage matrix](reference/atlas-coverage-matrix.md)
- [Surface coverage matrix](reference/surface-coverage-matrix.md)
- [Glossary](reference/glossary.md)
- [Scope and capability model](reference/scope-and-capability-model.md)

### Official reference layer

- [Chat surfaces and context](reference/chat-surfaces-and-context.md)
- [Instructions and prompt assets](constructs/instructions-and-prompt-assets.md)
- [Modes, participants, and tools](constructs/modes-participants-and-tools.md)
- [MCP and models](constructs/mcp-and-models.md)
- [Context and review flow](reference/context-and-review-flow.md)
- [Review, debug, and sessions](integrations/review-debug-and-sessions.md)

### Workflow composition

- [Workflow composition playbook](composition/workflow-composition-playbook.md)

### Translation guidance

- [Construct selection matrix](translation/construct-selection-matrix.md)
- [Workflow translation playbook](translation/workflow-translation-playbook.md)

## How to use this atlas

Use it in one of three ways:

1. **Native VS Code Chat reference**: read the provenance layer first, then the official reference pages for the surface you need.
2. **Workflow design**: verify the official surface, then use the composition playbook to decide where to encode behavior.
3. **Cross-tool translation**: verify the official surface, map the foreign flow with the translation pages, and record gaps instead of assuming parity.

## Scope guardrails

- GitHub Docs are canonical for product-level Copilot concepts, support boundaries, repository-instruction policy, MCP policy, and model policy.
- VS Code docs are canonical for VS Code-native UX and inventories such as chat locations, tools, sessions, prompt-file locations, and debug surfaces.
- GitHub.com personal instructions are not a VS Code Chat construct in this atlas.
- VS Code user-level instruction files are editor-native surfaces and should not be confused with GitHub.com personal instructions.
- Compatibility and discovery surfaces such as `CLAUDE.md`, `.claude/rules`, organization instructions, custom agents, and agent skills must be marked clearly when they are not baseline runtime constructs.
- When a direct VS Code Chat equivalent does not exist, the atlas must say so explicitly instead of implying parity.

## Version note

Last checked against official sources on `2026-05-20`.

Chat locations, agent targets, slash-command inventories, participant lists, tool behavior, MCP management UX, prompt-file metadata, customizations discovery, and debug surfaces are version-sensitive and should be revalidated after VS Code or Copilot extension upgrades.
