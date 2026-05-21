# AI Core Source Of Truth

This repository is the versioned source of truth for AI workflow instructions used by WorkflowSmith.

It is not the final workflow design. It is the place where existing workflows are imported, compared, normalized, and promoted into a simple shared standard.

## Source Model

Workflow material should move through three states:

1. Raw import: copied from the original tool or repository without rewriting.
2. Normalized draft: converted into repository style while preserving intent.
3. Promoted standard: accepted into `core/`, `agents/`, `skills/`, `memory/`, or `checklists/`.

Promoted standards override drafts. Drafts override raw imports only when explicitly marked as normalized. Raw imports remain useful as audit references.

## Import Targets

The repository is prepared to import existing workflows from:

- Copilot
- Claude
- Antigravity CLI

Each import should keep enough metadata to audit where the workflow came from and why it was promoted.

## Current Raw Imports

| Import | Source | Status |
| --- | --- | --- |
| `imports/legacy/ai-core/` | `/home/theoodawara/Projetos/AI-core/workflows` | Raw, inactive |

## What Belongs Here

- Shared routing rules
- Output contracts
- Agent profiles
- Skills
- Checklists
- Memory indexes
- Import notes and promotion decisions

## What Does Not Belong Here Yet

- Large multi-agent systems
- Tool-specific automation that cannot be audited quickly
- Generated workflow files without source references
- New final workflows invented before existing sources are reviewed

## Promotion Rule

A workflow rule is promoted only when it is clear, reusable, and traceable to either an imported source or an explicit repository decision.

The imported AI-core snapshot is audit evidence. It should not be treated as active routing, memory, agent, skill, or checklist policy until promoted.
