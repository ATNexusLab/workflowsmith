# Source Policy

Label: **Official reference**

Last checked: `2026-05-20`

This atlas stays useful only if it separates confirmed VS Code Chat behavior from local convention and from features that belong to other Copilot surfaces.

## Canonical source rule

Use official sources only for claims that change how a reader would use or configure VS Code Chat.

- **GitHub Docs** are canonical for product concepts, cross-surface support boundaries, repository-instruction policy, MCP policy, and model policy.
- **VS Code docs** are canonical for VS Code-native behavior, authoring details, and UX inventories such as chat locations, participants, slash commands, tools, sessions, checkpoints, review flow, prompt-file locations, and debug surfaces.

## Allowed content types

### Official reference

Use this label when a page explains behavior directly supported by official docs.

Requirements:

- cite one or more official GitHub Docs or VS Code docs URLs
- avoid repo-specific assumptions
- distinguish confirmed behavior from version-sensitive or preview behavior
- a page can remain primarily **Official reference** while also including clearly marked generic adaptation notes

### Generic adaptation

Use this label when a page explains how to combine confirmed VS Code Chat features into a reusable pattern.

Requirements:

- every building block in the pattern must exist in official docs
- the page must say when the pattern is a composition, not a first-class named feature
- any gap versus another tool must be explicit

### Repo example

Use this label only when a page borrows material from this repository to illustrate a pattern.

Requirements:

- call out that the example is local to `~/.copilot`
- do not treat the example as an upstream default
- keep the generic explanation separate from the example block

## Boundary rules

- Do not infer GitHub.com-only behavior into VS Code Chat.
- Do not treat GitHub.com personal instructions as a VS Code Chat feature.
- Keep VS Code user-level instruction files separate from GitHub.com personal instructions.
- Do not use GitHub Docs alone to define VS Code-native inventories such as chat locations, participants, slash commands, sessions, debug view, checkpoints, or review workflow.
- When GitHub Docs support matrices and VS Code docs diverge on editor-native surfaces, treat GitHub Docs as the cross-surface baseline and record the VS Code-specific divergence explicitly.
- When prompt-file details differ across sources, prefer the VS Code prompt-files page for authoring and runtime details.
- When custom-agent or skill details come from VS Code docs, keep them scoped as VS Code Chat workflow-building surfaces rather than silently treating them as GitHub-wide defaults.
- If official sources do not confirm parity, document the gap instead of smoothing it over.

## Coverage discipline

This atlas uses two complementary matrices:

- [Atlas coverage matrix](atlas-coverage-matrix.md): proves which official sources justify each atlas page
- [Surface coverage matrix](surface-coverage-matrix.md): proves which official VS Code Chat surfaces are covered, version-sensitive, or intentionally non-baseline

Rules:

- a source being present in the ledger is **not** proof of surface completeness
- every official surface represented in the ledger must be **covered**, **explicitly bounded**, or **explicitly marked version-sensitive**
- if a source page is only used for examples or onboarding and not for a canonical capability boundary, say so explicitly

## Page ownership and non-overlap

Use these ownership rules so pages reference each other instead of redefining the same surface:

| Canonical page | Owns |
| --- | --- |
| `reference/chat-surfaces-and-context.md` | chat entry points, chat locations, context sources, context-window usage, compaction, browser context |
| `reference/context-and-review-flow.md` | request lifecycle and the link path between canonical pages |
| `constructs/instructions-and-prompt-assets.md` | instruction files, prompt files, custom agents, agent skills, compatibility/discovery surfaces, storage, sync |
| `constructs/modes-participants-and-tools.md` | agent roles, agent targets, participants, slash commands, tool enablement, approvals, terminal behavior, tool sets, subagents |
| `constructs/mcp-and-models.md` | MCP configuration and trust plus model selection and reasoning controls |
| `integrations/review-debug-and-sessions.md` | session operations, queueing and notifications, review, checkpoints, debug, export/import, troubleshooting |
| `composition/workflow-composition-playbook.md` | multi-construct workflow design patterns |
| `translation/*.md` | foreign-flow mapping, non-equivalence handling, and translation procedures |

## Version-sensitive areas

Revalidate these sections whenever VS Code or the Copilot extension changes version:

- chat locations and agent-window behavior
- mode names, agent targets, and permission behavior
- slash-command and participant inventories
- tool approval, URL approval, terminal controls, and Autopilot behavior
- prompt-file and custom-agent frontmatter and storage locations
- MCP registry, sandboxing, trust, and management UX
- model picker behavior, thinking effort, BYOK, and auto model selection
- sessions, notifications, checkpoints, and debug export/import surfaces

## Maintenance workflow

1. Update the [source ledger](source-ledger.md) first.
2. Update the [atlas coverage matrix](atlas-coverage-matrix.md) so every page still has official backing.
3. Update the [surface coverage matrix](surface-coverage-matrix.md) so completeness is visible.
4. Update the owning canonical page for the affected surface.
5. Update workflow composition and translation pages after the reference layer is correct.
6. Add repo examples last, and only if they are necessary.

## Acceptance checklist

- Every reference page points to official sources.
- GitHub Docs and VS Code docs are used according to their canonical boundaries.
- The atlas distinguishes provenance proof from completeness proof.
- Personal-instruction behavior is not implied for VS Code Chat.
- Canonical page ownership is respected and duplicate definitions are removed.
- Translation pages do not invent unsupported one-to-one mappings.
- Open questions, version-sensitive areas, and non-baseline surfaces are recorded explicitly.
