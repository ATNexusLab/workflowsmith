# Obsidian Vault

The Obsidian vault is personal cross-project memory. It stores preferences, patterns, decisions, and session notes that span projects. It is accessed via the `obsidian` MCP server.

---

## Vault Location and Access

**Vault URL:** `https://127.0.0.1:27124` (Obsidian Local REST API)
**MCP server:** `obsidian` (configured in `~/.claude/mcp.json`)
**Key tool:** `obsidian-get_note_content(path)` — reads a note by path

If the vault is unavailable, Claude continues without it — vault access is support, not a blocker.

---

## Vault Structure

```
knowledge/
├── user-preferences.md   ← Tier 1: loaded before every non-trivial task
├── preferences/
│   └── {slug}.md         ← Individual preference notes
├── patterns/
│   └── {slug}.md         ← Cross-project technical patterns
├── decisions/
│   └── {slug}.md         ← Technical decisions relevant beyond one project
└── stacks/
    └── {tech}.md         ← Stack insights that change how a tech is used
sessions/
└── YYYY-MM-DD-{slug}.md  ← Session notes with unresolved items
```

---

## Two-Tier Read Gate

### Tier 1 — Preference Gate (Mandatory)

Before any non-trivial task, call:

```
obsidian-get_note_content("knowledge/user-preferences.md")
```

This is not optional. `user-preferences.md` accumulates all confirmed user preferences across sessions. It informs routing decisions, code style choices, tool selections, and communication style.

**Skip only for:** trivial fast-path work — single-line edits, quick lookups, pure explanations.

### Tier 2 — Context Gate (Lazy)

After loading preferences, access project context, sessions, patterns, or stacks only if at least one trigger applies:

| Trigger | Read target |
|---|---|
| Local context + repo docs still insufficient | Relevant project session notes |
| Recurring work on a project with a history gap | `sessions/YYYY-MM-DD-{project}.md` |
| Technical decision needing prior art | `knowledge/decisions/{slug}.md` |
| User explicitly asks ("remember what we did in X") | Whichever note is relevant |

If none apply: skip Tier 2 entirely.

---

## When to Write to the Vault

Write **only** at these moments:

| Event | Target path |
|---|---|
| User corrected an approach or stated a preference | `knowledge/preferences/{slug}.md` |
| Technical pattern emerged across ≥ 2 projects | `knowledge/patterns/{slug}.md` |
| Technical decision relevant beyond this project | `knowledge/decisions/{slug}.md` |
| Stack insight that changes how a technology is used | `knowledge/stacks/{tech}.md` |
| Session has unresolved items (blockers, deferred work, handoffs) | `sessions/YYYY-MM-DD-{slug}.md` |

**Do not write:** intra-task progress, subagent returns, plans, status updates, "what I did today", logs for trivial tasks.

---

## Note Format

All vault notes follow this structure:

```markdown
---
name: kebab-case-slug
description: one-line summary for relevance matching
metadata:
  type: user | feedback | project | reference
---

Note body.

**Why:** Reason this matters.
**How to apply:** When and where to use this.

[[related-note-slug]]
```

Link to related notes with `[[slug]]` — Wiki-link style. Broken links are fine (mark what to write later).

---

## `knowledge/user-preferences.md`

The single most important vault file. Accumulates all confirmed preferences:

```markdown
# User Preferences

- Terse responses — no trailing summaries
- No emojis unless explicitly requested
- No database mocks in integration tests
- Always use real `bun test` groups per file with unique mocks
- Comments only when the WHY is non-obvious
```

This file grows over time as preferences are confirmed. Claude reads it before every non-trivial task so learned preferences are applied without re-stating them.

---

## Session Cleanup Protocol

Sessions directory should stay lean — maximum 8 session files. Before writing a new session note:

1. Review existing `sessions/` files
2. Delete any that are fully resolved (work is done, blockers are cleared)
3. Merge notes about the same project if multiple exist
4. Write the new note only if there are genuine unresolved items

A session note is not a log. It is a handoff document — write only what a future session needs to continue without losing context.

**Session note format:**

```markdown
---
name: 2026-05-20-auth-rewrite
description: Auth middleware rewrite — stalled on rate-limit design decision
metadata:
  type: project
---

## Context
Rewriting auth middleware to comply with legal's session token requirements.

## Status (2026-05-20)
- Completed: JWT validation, token refresh, logout flow
- Blocked: rate-limit approach — Redis vs in-memory, decision pending stakeholder input

## Next session
- Get rate-limit decision from tech lead
- Implement chosen approach in src/middleware/rate-limit.ts
- Test: apply test-contract three axes on rate-limit surface
```

---

## Documentation Mirroring Rule

This rule prevents vault inflation and duplication:

| Information type | Where it goes |
|---|---|
| README, API docs, runbooks, CHANGELOG | **Project repo** |
| ADRs, Tech Specs, repo-scoped decisions | `docs/decisions/` in **project repo** |
| Personal preferences | **Obsidian** `knowledge/preferences/` |
| Cross-project patterns | **Obsidian** `knowledge/patterns/` |
| Session notes (personal continuity) | **Obsidian** `sessions/` |

**Golden rule:** If it would be useful to anyone who clones the repo → repo. If it only makes sense to you remembering across projects → Obsidian. Never duplicate between the two.

If important project documentation has been written only to Obsidian, redirect it to the repo and leave a minimal reference link in Obsidian.

---

## WikiLink Cross-Linking

Link between vault notes using `[[slug]]`:

```markdown
This pattern builds on the approach from [[testing-bun-isolation]].
See also [[user-preferences]] for the no-mock preference.
```

Link liberally. A `[[slug]]` that doesn't exist yet marks something worth writing — it's not an error.

---

## Graceful Degradation

If the vault is not configured or the Obsidian Local REST API is unreachable:

1. Skip Tier 1 and Tier 2 reads silently
2. Continue working from repo docs and session context
3. Do not block or error — vault is enhancement, not requirement
4. Note in the session output: "vault unavailable — working from local context only"

---

## Related

- [memory/memory-system.md](memory-system.md) — per-project MEMORY.md system
- [mcp/mcp-servers-catalog.md](../mcp/mcp-servers-catalog.md) — obsidian MCP server config
- [core/scope-layers.md](../core/scope-layers.md) — where vault fits in the scope model
- [workflows/closeout-protocol.md](../workflows/closeout-protocol.md) — when to write vault notes (items 6-9)
