<!-- type: adr | section: decisions -->
# ADR-006: Gemini CLI Discontinuation — Final Content Migration

**Status:** Accepted  
**Date:** 2026-05-20

## Context

Google discontinued gemini-cli. Antigravity CLI is the active successor tool.

The `docs/gemini-md/` section (7 files) was a legacy technical reference that documented `GEMINI.md` format internals, imports, settings, Auto Memory, memory commands, and `.geminiignore`. At the time of ADR-005, that content was kept in place as "legacy implementation reference" to avoid risky duplication and mass renaming. The `docs/antigravity-cli/` section existed as a high-level navigation layer that deliberately delegated to `gemini-md/` for technical details.

With gemini-cli discontinued, the `gemini-md/` reference is no longer a transitional bridge to a living upstream tool. Keeping it as a separate section creates unnecessary indirection and cross-linking overhead.

## Decision

Migrate all unique technical content from `docs/gemini-md/` into `docs/antigravity-cli/`, then delete `docs/gemini-md/`.

Specific migrations performed:

1. **`docs/antigravity-cli/fundamentals.md`** — added a new "How the instruction layer works" section covering the 3-tier hierarchy, just-in-time discovery mechanics, how prompt context is built, the UI loaded-context indicator, and memory routing.

2. **`docs/antigravity-cli/configuration.md`** — replaced the delegation note ("The detailed settings reference still lives under Gemini-named docs") with the actual content, organized into four subsections: Settings (file locations, precedence, context discovery fields, file filtering fields, UI and experimental flags), Imports (`@path` directives, syntax, path formats, nesting, safety controls, error handling), Auto Memory (what it does, how to enable, eligibility rules, safety boundaries, inbox review flow), and `.geminiignore` (purpose, location, syntax, what it does not affect, restart requirement).

3. **`docs/reference/slash-commands.md`** — added a "Memory commands in detail" section covering the `/memory` command family, natural-language memory saves (`Remember that...` syntax), and the persistent vs. session memory distinction.

### The `GEMINI.md` filename stays unchanged

`GEMINI.md` is the native instruction file format recognized by Antigravity CLI. Renaming it would break the tool's context discovery mechanism. All documentation continues to use `GEMINI.md` as the filename while framing the surrounding context around "Antigravity CLI" as the user-facing term.

### Other files updated

- `docs/index.md` — removed the `## gemini-md/` section, updated the Quick orientation table row for injecting instructions to point only to `antigravity-cli/configuration.md`, added a routing protocol row, and added a `## common/` section.
- `docs/decisions/index.md` — added ADR-006 entry.

## Consequences

- `docs/antigravity-cli/` is now the single source of truth for both high-level navigation and technical detail.
- `docs/gemini-md/` has been deleted; there are no remaining cross-references to it.
- All content that was unique to `gemini-md/` is preserved and reachable from `antigravity-cli/`.
- Future documentation work has one fewer section to maintain.
- Readers no longer need to mentally navigate a two-tier split between an "Antigravity navigation layer" and a "Gemini deep reference layer" for the subjects covered in `gemini-md/`.

## Alternatives Considered

### Keep `docs/gemini-md/` as permanent reference with `antigravity-cli/` as navigation only

Rejected because gemini-cli is discontinued, making the "legacy implementation reference" framing permanently accurate rather than transitional. Permanent double indirection adds maintenance cost with no benefit.

### Delete `docs/gemini-md/` without migrating content

Rejected because the technical detail in those files (import syntax, safety controls, settings schema, Auto Memory eligibility rules) is operationally necessary and not available elsewhere in the documentation set.
