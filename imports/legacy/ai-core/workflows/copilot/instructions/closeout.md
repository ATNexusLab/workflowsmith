<!-- REFERENCE ONLY — Not an active instruction surface. No `applyTo` frontmatter.
     The live baseline is: ~/.copilot/copilot-instructions.md (repo root).
     This file is a standalone reference extract for readability only. -->

# Closeout Protocol

## Required at the End of Every Task

After the feature goes green on all 5 checks and 3 testing axes, and before declaring completion to the user, run this explicit checklist. **Each item receives a recorded decision** ("applied at X", "n/a"). Silence is failure.

| # | Question | If yes, action | Location |
|---|---|---|---|
| 1 | Changed public contract (API, CLI, schema, env vars)? | Update | `README.md`, `docs/` in the **repo** |
| 2 | Cross-cutting architectural decision? | Create ADR via `@principal` (spec-writing) | `docs/decisions/` or `docs/adr/` in the **repo** |
| 3 | Breaking change, visible feature, or relevant fix? | Update | `CHANGELOG.md` in the **repo** |
| 4 | Changed setup/run commands? | Update | `README.md` (Quick Start) or `CONTRIBUTING.md` |
| 5 | New migration? | Document with rollback plan | `docs/migrations/` or README section |
| 6 | User revealed or corrected a preference during the session? | Write | `knowledge/preferences/{slug}.md` in the **vault** |
| 7 | Technical pattern repeated across ≥ 2 projects? | Write | `knowledge/patterns/{slug}.md` in the **vault** |
| 8 | Technical decision relevant beyond this project? | Write | `knowledge/decisions/{slug}.md` in the **vault** |
| 9 | Multi-phase session or with real learning? | Write once, condensed | `sessions/YYYY-MM-DD-{slug}.md` in the **vault** |

## Required Closeout Output

Include in the final summary to the user:

```
Closeout:
- Repo docs:     [applied at <path> / n/a]
- ADR:           [applied / n/a]
- CHANGELOG:     [applied / n/a]
- Setup/run:     [applied / n/a]
- Migration:     [applied / n/a]
- Vault prefs:   [<slug> / n/a]
- Vault patterns:[<slug> / n/a]
- Vault decision:[<slug> / n/a]
- Vault session: [<slug> / n/a]
```

## Rules

- **Documentation Mirroring** always respected: project docs go to the **repo**, cross-project knowledge goes to the **vault**. No duplication.
- Closeout runs **even for small tasks** — most items will be "n/a", and that is recorded explicitly.
- Never declare completion without verbalized Closeout. Silence = task incomplete.
