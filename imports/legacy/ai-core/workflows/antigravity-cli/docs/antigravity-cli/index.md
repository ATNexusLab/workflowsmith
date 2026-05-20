<!-- topic: antigravity-cli | section: antigravity-cli -->
# Antigravity CLI Atlas

This is the **Antigravity-first** entry point for this repository's CLI documentation.

Use this section to understand what Antigravity CLI offers in this environment, where new workflow behavior belongs, how the planning lifecycle works, and how to adapt patterns from other AI tools into this setup without copying them blindly.

## Quick Reference

> - Antigravity CLI is the **canonical user-facing term** for this repository.
> - `docs/` is the canonical user-facing source of truth; runtime state is not.
> - Legacy Gemini-named docs remain available as detailed implementation reference during migration.
> - Start here for capability discovery, workflow design, and lifecycle guidance, then jump to legacy deep-reference modules only when you need low-level details.
> - `antigravity-cli/` can contain both portable workflow assets and local implementation state; `docs/` remains the primary documentation source of truth.

## Load by task

| I want to… | Load this page |
|---|---|
| Understand what Antigravity CLI offers here | [fundamentals.md](fundamentals.md) |
| Understand configuration and instruction surfaces in this repo | [configuration.md](configuration.md) |
| Decide where new workflow behavior belongs | [workflow-authoring.md](workflow-authoring.md) |
| Understand the plan -> approval -> execution lifecycle | [planning-approval-execution.md](planning-approval-execution.md) |
| Distinguish docs, runtime state, plugins, and editable workflow assets | [runtime-and-plugin-surfaces.md](runtime-and-plugin-surfaces.md) |
| Adapt workflows from other AI tools into Antigravity CLI constructs | [workflow-adaptation.md](workflow-adaptation.md) |
| Understand the Gemini-to-Antigravity migration contract | [migration-map.md](migration-map.md) |

## Content labels

Every page in this section should fit one of these labels:

- **Canonical local guidance**: the preferred user-facing explanation for this repository
- **Legacy implementation reference**: deeper Gemini-era docs that still describe lower-level behavior accurately
- **Migration guidance**: naming policy, transition boundaries, and compatibility notes

## Deep reference modules

Use the existing detailed modules when you need leaf-level reference:

| Topic | Detailed reference |
|---|---|
| Persistent instruction files, imports, settings, Auto Memory | [configuration.md](configuration.md) |
| Agents and subagents | [../agents/index.md](../agents/index.md) |
| Skills | [../skills/index.md](../skills/index.md) |
| Hooks | [../hooks/index.md](../hooks/index.md) |
| MCP | [../mcp/index.md](../mcp/index.md) |
| Extensions | [../extensions/index.md](../extensions/index.md) |
| Settings | [../settings/index.md](../settings/index.md) |
| CLI flags, built-in tools, slash commands | [../reference/index.md](../reference/index.md) |
| Plan mode, headless mode, checkpointing, sandbox, auth | [../advanced/index.md](../advanced/index.md) |
| Architectural rationale | [../decisions/index.md](../decisions/index.md) |

## Scope guardrails

- `docs/antigravity-cli/` is the single source of truth for both high-level navigation and technical detail on instruction files, imports, settings, Auto Memory, and `.geminiignore`.
- Do not use local runtime files, plugin assets, or caches as the only documentation source of truth, even when `antigravity-cli/` also hosts versioned workflow assets.
- For the Gemini-to-Antigravity migration contract, see [migration-map.md](migration-map.md), [ADR-005](../decisions/adr-005-antigravity-first-documentation-migration.md), and [ADR-006](../decisions/adr-006-gemini-cli-discontinuation.md).
