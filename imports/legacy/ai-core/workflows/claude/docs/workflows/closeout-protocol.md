# Closeout Protocol

The 9-item checklist that runs after all 5 quality checks pass and before declaring a task complete. Enforced by `~/.claude/rules/closeout.md`. Triggerable with the `/closeout` custom command.

---

## When It Runs

After all 5 checks pass (lint → typecheck → format → build → tests) and the three testing axes are covered: run Closeout before telling the user the task is done.

Closeout runs even for small tasks. Most items will be "n/a" — that's fine. The requirement is that every item receives an explicit recorded decision.

**Silence = failure.** If an item has no answer, the task is not complete.

---

## The Checklist

### 1. Changed public contract?

Did the task change any public-facing API, CLI interface, database schema, or environment variables?

**If yes:** Update `README.md` and/or `docs/` in the project repo with the new contract.
**If no:** n/a

---

### 2. Cross-cutting architectural decision?

Was there a significant architectural decision that affects more than one module, service, or team?

**If yes:** Create an ADR via `@principal` (spec-writing skill). Save to `docs/decisions/` or `docs/adr/` in the project repo.
**If no:** n/a

---

### 3. Breaking change, visible feature, or relevant fix?

Is this a change that users or downstream consumers would care about?

**If yes:** Update `CHANGELOG.md` in the project repo.
**If no:** n/a

---

### 4. Changed setup or run commands?

Did the task modify how to install, configure, or run the project?

**If yes:** Update `README.md` (Quick Start section) or `CONTRIBUTING.md`.
**If no:** n/a

---

### 5. New migration?

Was a new database or schema migration created?

**If yes:** Document the migration with a rollback plan. Location: `docs/migrations/` or a README section.
**If no:** n/a

---

### 6. User preference revealed or corrected?

Did the user correct an approach, state a preference, or confirm a non-obvious choice?

**If yes:** Write to `knowledge/preferences/{slug}.md` in the Obsidian vault. Update `knowledge/user-preferences.md` with the consolidated preference.
**If no:** n/a

---

### 7. Cross-project technical pattern?

Did a technical pattern emerge that applies to ≥ 2 projects?

**If yes:** Write to `knowledge/patterns/{slug}.md` in the Obsidian vault.
**If no:** n/a

---

### 8. Technical decision relevant beyond this project?

Was there a significant technical decision (library choice, architecture pattern, tradeoff) that would be valuable to remember across projects?

**If yes:** Write to `knowledge/decisions/{slug}.md` in the Obsidian vault.
**If no:** n/a

---

### 9. Unresolved pending items?

Are there blockers, deferred work items, or context that future sessions need and that can't be captured in a preference/pattern note?

**If yes:** Run the session cleanup protocol (review existing sessions, delete resolved ones), then write a condensed note to `sessions/YYYY-MM-DD-{slug}.md` in the Obsidian vault.
**If no:** n/a

---

## Required Output Format

The final summary must include this block verbatim:

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

**Examples:**

Small bugfix — most items n/a:
```
Closeout:
- Repo docs:      n/a
- ADR:            n/a
- CHANGELOG:      applied in CHANGELOG.md (Fixed: timezone bug in token expiry)
- Setup/run:      n/a
- Migration:      n/a
- Vault prefs:    n/a
- Vault patterns: n/a
- Vault decision: n/a
- Vault session:  n/a
```

Large feature with multiple outcomes:
```
Closeout:
- Repo docs:      applied in README.md (env vars section, new API endpoints)
- ADR:            applied (docs/decisions/2026-05-20-jwt-auth-strategy.md)
- CHANGELOG:      applied in CHANGELOG.md (Added: JWT authentication)
- Setup/run:      n/a
- Migration:      applied in docs/migrations/0042-add-token-blacklist.md
- Vault prefs:    n/a
- Vault patterns: jwt-token-rotation-pattern
- Vault decision: n/a
- Vault session:  n/a
```

---

## Documentation Mirroring Rule

This rule determines where information goes:

| Information type | Destination |
|---|---|
| README, API docs, runbooks, CHANGELOG | **Project repo** |
| ADRs, Tech Specs, repo-scoped decisions | `docs/decisions/` or `docs/adr/` in **project repo** |
| Personal preferences | **Obsidian** `knowledge/preferences/` |
| Cross-project patterns | **Obsidian** `knowledge/patterns/` |
| Session notes (personal continuity) | **Obsidian** `sessions/` |

Never duplicate between the two. If the information is useful to anyone who clones the repo → repo. If it only makes sense as personal cross-project memory → Obsidian.

---

## Why the Protocol Exists

Documentation and vault hygiene degrade without an explicit checklist. Without Closeout:
- API changes ship without README updates
- Architectural decisions go undocumented
- Preferences must be re-stated in every session
- Unresolved items get lost

The protocol makes these decisions explicit at the end of every task. "n/a" is a valid recorded decision. Silence is not.

---

## Related

- [commands/custom-commands.md](../commands/custom-commands.md) — `/closeout` command
- [memory/obsidian-vault.md](../memory/obsidian-vault.md) — vault write targets
- [rules/rules-catalog.md](../rules/rules-catalog.md) — `closeout.md` global rule
