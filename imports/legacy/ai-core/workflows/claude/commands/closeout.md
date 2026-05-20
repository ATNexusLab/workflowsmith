---
description: Run the mandatory Closeout Protocol — validates docs, ADR, CHANGELOG, migrations, and vault before declaring the task complete.
---

Run the Closeout Protocol for the work completed in this session, as defined in `~/.claude/CLAUDE.md`.

Go through all 9 checklist items. Every item must have a recorded decision — either the action taken and its location, or an explicit "n/a". Silence on any item is a failure.

1. Did the public contract change (API, CLI, schema, env vars)? → Update `README.md` or `docs/`
2. Was there a cross-cutting architectural decision? → Create an ADR via @principal saved to `docs/decisions/`
3. Is there a breaking change, visible feature, or relevant fix? → Update `CHANGELOG.md`
4. Did setup or run commands change? → Update `README.md` Quick Start or `CONTRIBUTING.md`
5. Is there a new migration? → Document with a rollback plan in `docs/migrations/`
6. Was a user preference revealed or corrected during the session? → Write to vault `knowledge/preferences/`
7. Did a technical pattern appear across ≥ 2 projects? → Write to vault `knowledge/patterns/`
8. Was there a technical decision relevant beyond this project? → Write to vault `knowledge/decisions/`
9. Was this a multi-phase session with real learning? → Write a condensed note to vault `sessions/`

Output the result in this exact format:

```
Closeout:
- Repo docs:      [applied in <path> / n/a]
- ADR:            [applied / n/a]
- CHANGELOG:      [applied / n/a]
- Setup/run:      [applied / n/a]
- Migration:      [applied / n/a]
- Vault prefs:    [<slug> / n/a]
- Vault patterns: [<slug> / n/a]
- Vault decision: [<slug> / n/a]
- Vault session:  [<slug> / n/a]
```
