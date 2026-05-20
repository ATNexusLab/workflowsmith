# ADR 0004: Per-Project Memory in `~/.claude/projects/`, Not in the Repo

**Status:** Accepted
**Date:** 2026-05-20
**Authors:** Theo Odawara

---

## Context

Across repeated work sessions on the same project, Claude accumulates knowledge that is genuinely useful to retain but does not belong in the project repository. Examples: a user correction ("in this codebase, always use `bun test --watch` rather than the script in package.json"), an idiosyncrasy discovered at runtime ("bun test mock.module leaks state between files in the same test group in this repo"), external resource locations ("the Linear board for this project is at board.linear.app/team/xyz"), or a structural note ("the `src/lib/` directory is the shared utilities layer — do not add feature code there").

This memory needs to persist across sessions for the same project. Without it, Claude re-discovers the same facts, makes the same corrected mistakes, and asks the same clarifying questions session after session.

Two candidate storage strategies presented themselves: store the memory inside the project repository (e.g., `.claude/memory/`), or store it in the user's home directory keyed by project root path. The distinction matters because of what this memory contains: it is personal, machine-specific, and often includes observations that would be noise or confusion to other contributors. A note like "user prefers `bun` over `npm` for this project" is a personal configuration fact, not a project fact. Committing it would require every contributor to add `.claude/memory/` to `.gitignore` and would expose personal workflow preferences to anyone who clones the repo.

A third candidate — the Obsidian vault — exists for cross-project memory, but is explicitly not appropriate for narrow project-specific minutiae that would pollute cross-project knowledge searches.

## Decision

Per-project memory lives at `~/.claude/projects/<encoded-path>/memory/` on the local machine, outside any project repository.

The `<encoded-path>` is derived from the project's root directory path by replacing each `/` with `-` and stripping the leading `/`. This encoding is deterministic and reversible given the original path: `/mnt/storage/dev/logbox` becomes `-mnt-storage-dev-logbox`. The encoding is intentionally simple — no hashing, no database — so the directory structure is human-readable and directly navigable.

The `memory/` subdirectory contains two kinds of files:

**`MEMORY.md`** is a pointer index — one line per memory entry, in natural language, that is auto-loaded at every session start for that project. Its role is to give Claude a lightweight summary of what has been remembered without loading every individual memory file. It is kept under 200 lines; when it grows beyond that, older entries are summarized or removed.

**Individual memory files** carry YAML frontmatter with a `type` field classifying the entry: `user` (explicit user instruction), `feedback` (a correction the user made), `project` (a structural fact about the codebase), or `reference` (an external URL, ID, or resource pointer). The type classification determines how much weight to give the entry — `user` and `feedback` entries override Claude's defaults; `project` entries inform context; `reference` entries are looked up when relevant.

This mechanism is specific to Claude Code. It is intentionally not mirrored to Copilot or Gemini configuration — the specificity of the format and the trigger semantics are tied to how Claude Code loads context at session start.

## Alternatives Considered

### Alternative A: Store memory inside the project repo at `.claude/memory/`

Place the memory directory within the project's own file tree, co-located with the code it describes.

**Pros:**
- Memory and code live together — navigating to the project is sufficient to find its memory.
- No path encoding required; the location is always `.claude/memory/` relative to the project root.
- Memory is automatically available on all machines that clone the repo.

**Cons:**
- Contaminates the project git history with personal and machine-specific notes. Every `git log` and `git blame` includes memory updates alongside code changes.
- Forces every project to add `.claude/memory/` to `.gitignore`, creating a permanent maintenance burden and a risk of accidental commits.
- Personal workflow preferences become visible to all contributors and code reviewers.
- Memory conflicts arise when the same project is open on two machines simultaneously and both write to the same `.claude/memory/` files — git merges of personal notes are wasteful and confusing.

**Why rejected:**
- The contamination of project history is the decisive factor. Personal memory is personal — it has no place in a shared repository. The `.gitignore` workaround is an admission that the data does not belong there.

### Alternative B: Use only the Obsidian vault for all project-specific memory

Route project-specific memory to the same vault used for cross-project patterns, preferences, and decisions.

**Pros:**
- Single storage system for all persistent memory — simpler mental model.
- Vault is already configured and access is already established.
- Memory is available across machines that sync the vault.

**Cons:**
- The vault is a cross-project knowledge base. Project-specific minutiae — runtime idiosyncrasies, user corrections specific to one codebase — are too narrow for the vault and accumulate as noise that degrades the quality of cross-project knowledge searches.
- Loading vault context at session start for a specific project requires a search query ("what do I know about project X?"), which is slower and less reliable than loading a known file at a known path.
- The vault's "high value only" write policy (see CLAUDE.md memory guidelines) explicitly excludes the kind of frequent, granular corrections that per-project memory needs to capture.

**Why rejected:**
- Vault inflation with project-specific minutiae destroys the vault's value as a cross-project knowledge base. The two storage systems are complementary, not interchangeable: the vault stores patterns that generalize across projects; per-project memory stores facts that are specific to one codebase.

### Alternative C: Keep all memory in session transcripts with no persistent store

Rely on conversation history alone. Claude reads past transcripts when it needs to recall a previous session.

**Pros:**
- No additional infrastructure — transcripts already exist.
- Nothing to maintain, encode, or clean up.

**Cons:**
- Transcripts are not indexed. Finding a relevant correction from three months ago requires scanning unbounded conversation history.
- Transcripts grow without bound. A project worked on regularly accumulates gigabytes of history that must be traversed to surface a single remembered fact.
- There is no summary mechanism — Claude cannot distinguish "user corrected me on this" from "user and I were discussing a hypothesis" without reading the full context.

**Why rejected:**
- Unbounded transcript search is not a viable recall mechanism. Memory requires indexing, summarization, and classification — none of which transcript history provides.

## Consequences

### Positive

- Project repositories remain completely clean. No `.gitignore` entries, no memory files in git history, no personal notes visible to contributors.
- Memory is isolated per user and per machine. Multiple contributors working on the same project maintain independent memory stores — there are no merge conflicts on personal notes.
- The path encoding makes the memory store directly navigable: `ls ~/.claude/projects/` shows all projects Claude has accumulated memory for, with readable directory names.
- Deletion of a project's memory is a single `rm -rf ~/.claude/projects/<encoded-path>/` — no repository surgery required.

### Negative / Tradeoffs

- Memory is not portable between machines without explicit sync. A fact learned on one workstation is not available on another. This is a deliberate trade-off: machine-specific notes should stay on that machine. Cross-machine continuity for patterns that generalize uses the Obsidian vault.
- The path encoding is reversible but not immediately obvious. A directory named `-mnt-storage-dev-logbox` requires knowing the convention to interpret it. The encoding is documented in `docs/memory/memory-system.md`.

### Risks

- **Stale memory:** the codebase changes but memory is not updated. A remembered fact ("the auth module lives in `src/auth/`") becomes incorrect after a refactor. Mitigated by the rule "trust code over memory; verify before acting on a remembered fact." Memory files with `project` and `reference` types should be treated as hints, not ground truth.
- **Memory accumulation:** the `MEMORY.md` index grows beyond 200 lines without pruning. Mitigated by the explicit size limit and the expectation that older, lower-confidence entries are removed when the limit is approached.

## Implementation Notes

The 200-line limit on `MEMORY.md` is not a hard technical constraint — it is a context economy heuristic. A larger index consumes more context window at session start without proportional benefit. When the index approaches the limit, prefer summarizing multiple related entries into one rather than simply deleting older ones.

The `~/.claude/` special case noted in ADR 0001 applies here as well. The `~/.claude/` repository is itself a project, and its per-project memory lives at `~/.claude/projects/-home-theo-.claude/memory/` using the standard encoding. This is consistent with how all other projects are handled.

Cross-machine continuity for knowledge that does generalize — a pattern in how this project structures migrations, a recurring architectural preference revealed across sessions — belongs in the Obsidian vault under `knowledge/patterns/` or `knowledge/decisions/`. The per-project memory store and the vault are complementary layers: local and specific vs. synced and general.

---

## Related

- [`docs/memory/memory-system.md`](/home/theo/.claude/docs/memory/memory-system.md) — operational protocol: how to read, write, maintain, and prune memory files. Includes the YAML frontmatter schema, the `MEMORY.md` format, and the path encoding algorithm.
- [`docs/memory/obsidian-vault.md`](/home/theo/.claude/docs/memory/obsidian-vault.md) — the complementary cross-project memory system; clarifies when to use the vault vs per-project memory.
- [`docs/decisions/0001-scope-layers.md`](/home/theo/.claude/docs/decisions/0001-scope-layers.md) — the five-layer hierarchy and the `~/.claude/` special case referenced in Implementation Notes.

---

*ADR based on Michael Nygard's format.*
