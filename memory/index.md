---
id: memory-index-main
type: memory-index
status: promoted
version: 1.0.0
---

# Memory Index

This file indexes memory sources for the AI workflow repository.

No persistent memory is defined yet. Imported memory should be staged, reviewed, and promoted before it becomes active source-of-truth material.

## Current Sources

| Source | Status | Notes |
| --- | --- | --- |
| Copilot | Raw imported | `imports/legacy/ai-core/workflows/copilot/` |
| Claude | Raw imported | `imports/legacy/ai-core/workflows/claude/` |
| Antigravity CLI | Raw imported | `imports/legacy/ai-core/workflows/antigravity-cli/` |

## Imported Memory References

Claude project memory files exist in the raw AI-core import under `imports/legacy/ai-core/workflows/claude/projects/`.

Those files are inactive references. Do not use them as active persistent memory until each item is reviewed and promoted with a clear intended use.

## Promotion Requirements

A memory item should include:

- Source tool or system
- Original path or location
- Import date
- Intended use
- Promotion decision

Do not add behavioral instructions to memory unless they are traceable to an import or explicit repository decision.
