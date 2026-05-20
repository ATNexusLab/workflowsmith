# Memory System

Claude Code's memory system uses per-project MEMORY.md files to persist knowledge across conversations within a project. This is separate from the Obsidian vault (cross-project personal memory).

---

## Structure

Each project gets a memory directory at:

```
~/.claude/projects/<encoded-project-path>/memory/
```

The path encoding converts `/` to `-` and removes leading `/`:
- Project at `/mnt/storage/dev/logbox` → `~/.claude/projects/-mnt-storage-dev-logbox/memory/`
- Project at `/home/user/my-app` → `~/.claude/projects/-home-user-my-app/memory/`

---

## `MEMORY.md` — The Index

`MEMORY.md` is a pointer index, not a memory store. Each line links to a detail file:

```markdown
# Memory Index — ProjectName

- [Short title](filename.md) — one-line hook that answers: "why would I care about this?"
- [Backend Test Isolation](feedback-backend-test-isolation.md) — bun test runs files in same group in-process; mock.module leaks across files in a group.
- [Lucide-react Bun CJS Issue](feedback-lucide-bun-cjs.md) — certain icons cause SyntaxError in bun test via CJS chain.
```

**Rules for `MEMORY.md`:**
- One line per memory, under ~150 characters per entry
- Lines after 200 are truncated (keep the index lean)
- Content goes in linked files, never directly in `MEMORY.md`
- No frontmatter on `MEMORY.md` itself

`MEMORY.md` is loaded automatically at the start of every session for that project.

---

## Memory File Types

Each detail file has YAML frontmatter that categorizes it:

```markdown
---
name: kebab-case-slug
description: one-line summary for relevance matching
metadata:
  type: user | feedback | project | reference
---

Memory body here.
```

### `user`

Information about the user's role, goals, expertise, and preferences that are project-specific.

```markdown
---
name: user-is-data-scientist
description: user is a data scientist investigating logging infrastructure
metadata:
  type: user
---

The user is a data scientist. Their primary focus is observability and logging.
Frame technical explanations in data terms (pipelines, transforms) rather than pure software engineering terms.
```

---

### `feedback`

Corrections and confirmations about how to approach work in this project.

```markdown
---
name: feedback-backend-test-isolation
description: bun test mock.module leaks between files in the same group
metadata:
  type: feedback
---

Do not share test groups for files with unique mocks.

**Why:** bun test runs files in the same group in-process; mock.module leaks between them.
**How to apply:** Each file with unique mock.module calls needs its own group in run-tests.ts.
```

Body structure for `feedback` type:
1. The rule (what to do or not do)
2. **Why:** the reason the user gave
3. **How to apply:** when and where this kicks in

---

### `project`

Facts about ongoing work, goals, decisions, or context that are not visible from the code.

```markdown
---
name: project-auth-rewrite
description: auth middleware rewrite is driven by legal/compliance — not tech debt
metadata:
  type: project
---

Auth middleware rewrite is driven by a legal compliance requirement around session token storage.

**Why:** Legal flagged the old middleware for non-compliant session token handling.
**How to apply:** Scope decisions should favor compliance over developer ergonomics. This is not a refactor — do not propose shortcuts.
```

---

### `reference`

Pointers to where information lives in external systems.

```markdown
---
name: reference-linear-pipeline-bugs
description: pipeline bugs are tracked in Linear project "INGEST"
metadata:
  type: reference
---

Pipeline bugs → Linear project "INGEST".
Oncall Grafana dashboard → grafana.internal/d/api-latency
```

---

## When Claude Reads Memory

- **Automatically:** `MEMORY.md` is loaded at session start for the current project
- **On access:** Detail files are read when their content is needed (not all at once)
- **On explicit request:** "check your memory for X" or "remember what we discussed about Y"

Memory files can become stale. Before acting on a remembered fact, verify it against current code. If a memory conflicts with what's in the code now, trust the code and update or remove the stale memory.

---

## When Claude Writes Memory

Write a new memory file when:
- The user corrects an approach (feedback memory)
- A non-obvious pattern specific to this project emerges
- Project context is revealed that isn't in the code (project memory)
- An external resource is identified (reference memory)

Do **not** write memory for:
- Things derivable from reading the code
- Git history or recent changes (`git log` is the source of truth)
- Ephemeral task state from the current conversation
- Things already in CLAUDE.md

---

## Adding a Memory

**Step 1** — create the detail file:

```markdown
---
name: feedback-no-database-mocks
description: integration tests must hit real database, not mocks
metadata:
  type: feedback
---

Never mock the database in integration tests.

**Why:** In Q1, mocked tests passed while prod migration failed — mock/prod divergence masked the bug.
**How to apply:** Always use the test transaction wrapper in test/helpers/db.ts. Never mock db calls in files under test/integration/.
```

**Step 2** — add a pointer to `MEMORY.md`:

```markdown
- [No Database Mocks](feedback-no-database-mocks.md) — integration tests must hit real DB; mocks hid a broken migration in Q1.
```

---

## Real Examples

From `~/.claude/projects/-mnt-storage-dev-logbox/memory/MEMORY.md`:

```markdown
# Memory Index — LogBox

- [Backend Test Isolation](feedback-backend-test-isolation.md) — bun test runs files in same group in-process; mock.module leaks. Each file with unique mocks needs its own group in run-tests.ts.
- [Lucide-react Bun CJS Issue](feedback-lucide-bun-cjs.md) — Certain lucide-react icons cause SyntaxError in bun test when loaded via CJS chain; use only icons already proven to work in that test context.
```

---

## Memory vs Obsidian Vault

| Information type | Goes to |
|---|---|
| Project-specific pattern or preference | `~/.claude/projects/.../memory/` |
| Cross-project pattern (applies to ≥ 2 projects) | Obsidian vault `knowledge/patterns/` |
| Personal preference that applies everywhere | Obsidian vault `knowledge/preferences/` |
| Session notes with multi-machine handoff | Obsidian vault `sessions/` |

See [memory/obsidian-vault.md](obsidian-vault.md) for the vault protocol.

---

## The `projects/` Directory

All per-project data lives under `~/.claude/projects/`. This includes memory files and session transcripts.

```
~/.claude/projects/
└── <encoded-project-path>/
    ├── MEMORY.md           ← pointer index (auto-loaded at session start)
    ├── <memory-file>.md    ← typed memory detail files
    └── <session-id>.jsonl  ← session transcripts (read-only, managed by Claude Code)
```

The encoded path convention: replace `/` with `-`, strip the leading `/`.
Example: `/mnt/storage/dev/logbox` → `-mnt-storage-dev-logbox`

The `projects/` directory is machine-local — it is never committed to any project repo.
There is no built-in sync mechanism. For knowledge that must follow you across machines,
use the Obsidian vault (see [obsidian-vault.md](obsidian-vault.md)).

See [decisions/0004-per-project-memory.md](../decisions/0004-per-project-memory.md) for the architectural rationale behind this design.

---

## Related

- [memory/obsidian-vault.md](obsidian-vault.md) — cross-project Obsidian memory
- [core/scope-layers.md](../core/scope-layers.md) — where memory fits in the scope model
