<!-- topic: migration-map | section: antigravity-cli -->
# Gemini-to-Antigravity Migration Map

This repository is in a **docs-first migration** from Gemini CLI language to Antigravity CLI language.

## Canonical rule

Use **Antigravity CLI** as the canonical user-facing term for new documentation and navigation.

## What remains legacy in phase one

The following surfaces remain in place during the first migration phase:

- Gemini-named deep-reference docs under `docs/`
- `GEMINI.md` as the instruction filename used by the current lower-level context system
- Gemini-oriented examples inside legacy reference pages

These are retained because phase one is about **documentation architecture and navigation**, not broad mechanical renaming.

## Reading order during migration

1. Start with [index.md](index.md) in this Antigravity section
2. Use Antigravity pages for capability discovery, workflow design, and lifecycle guidance
3. Drop into Gemini-named deep reference only when you need low-level detail not yet lifted here

## Coverage matrix

| User journey | Canonical Antigravity page(s) | Legacy deep reference if needed |
|---|---|---|
| Understand what Antigravity offers in this repo | [fundamentals.md](fundamentals.md) | Section indexes under `docs/` |
| Choose where new workflow behavior belongs | [workflow-authoring.md](workflow-authoring.md), [runtime-and-plugin-surfaces.md](runtime-and-plugin-surfaces.md) | [../agents/index.md](../agents/index.md), [../skills/index.md](../skills/index.md), [../hooks/index.md](../hooks/index.md), [../mcp/index.md](../mcp/index.md), [../extensions/index.md](../extensions/index.md), [../settings/index.md](../settings/index.md), [../reference/slash-commands.md](../reference/slash-commands.md) |
| Create a reusable command, skill, or agent in this environment | [workflow-authoring.md](workflow-authoring.md) | [../reference/slash-commands.md](../reference/slash-commands.md), [../skills/index.md](../skills/index.md), [../agents/index.md](../agents/index.md) |
| Translate a workflow from another tool into local constructs | [workflow-adaptation.md](workflow-adaptation.md), [workflow-authoring.md](workflow-authoring.md) | Surface-specific indexes above |
| Understand the full plan -> approval -> execution lifecycle | [planning-approval-execution.md](planning-approval-execution.md) | [../advanced/plan-mode.md](../advanced/plan-mode.md) |
| Understand configuration and instruction surfaces | [configuration.md](configuration.md) | [../settings/index.md](../settings/index.md) |

## Out of scope for phase one

Phase one does **not** attempt to:

- rename every Gemini-era leaf page
- rewrite every example command that still says `gemini`
- mass-rename runtime directories or plugin assets
- treat observed runtime state as if it were the final product contract

Those changes may happen later, but only after the documentation boundary is stable.

## Why this matters

Without a migration map, the repository would present two equally authoritative stories:

- a Gemini-first deep-reference tree
- and a new Antigravity-first navigation layer

This page prevents that ambiguity by making the relationship explicit.
