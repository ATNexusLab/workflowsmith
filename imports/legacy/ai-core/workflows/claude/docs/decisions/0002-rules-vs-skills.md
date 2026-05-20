# ADR 0002: Rules and Skills as Distinct Primitives

**Status:** Accepted
**Date:** 2026-05-20
**Authors:** Theo Odawara

---

## Context

Both rules (`<repo>/.claude/rules/*.md`) and skills (`~/.claude/skills/*/SKILL.md`) are markdown files that inject procedural knowledge into a Claude session. From the outside, they look nearly identical: both have YAML frontmatter, both contain instructional prose, and both end up in the model's context window during a session.

The question arose naturally during the design of the rule system: why maintain two separate mechanisms when one unified "context file" format could handle both cases? The argument for unification was practical — fewer file types, simpler mental model, one format to learn.

The answer lies in trigger semantics. A rule is triggered by the *files being touched* in a given task. A skill is triggered by the *domain of the task itself*. These are orthogonal axes. A developer editing a database migration is touching a specific set of files (path event) and performing a specific type of task (domain event). Both triggers can fire simultaneously, and both should — but the mechanism that activates each one is different in kind, not just in degree.

Conflating them into a single format would require a single mechanism to maintain two separate indices and respond to two separate event types. The abstraction would become a leaky dual-purpose file, harder to reason about, harder to validate, and harder to test than two clean primitives with well-defined contracts.

## Decision

Rules and skills remain separate primitives with distinct trigger contracts and distinct storage locations.

**Rules** live at `<repo>/.claude/rules/<topic>.md` and carry `paths:` frontmatter containing one or more glob patterns. They are injected into the session context automatically when files matching those patterns are touched during a task. Rules answer the question: "given that these particular files are in scope, what additional context applies?" A rule at `paths: ["db/migrations/**"]` fires whenever a migration file is in scope, regardless of what the user asked Claude to do with it.

**Skills** live at `~/.claude/skills/<name>/SKILL.md` (globally) or `skills/<name>/SKILL.md` (project-local). They are activated by explicit invocation through the `Skill` tool, driven by routing heuristics in the planning protocol or by explicit user request. Skills answer the question: "given that this type of task is being performed, what procedural knowledge applies?" The `database-design` skill fires when the task involves modeling data, regardless of which specific files are touched.

The two compose naturally without conflict. The `database-design` skill defines how to design migrations in general — type conventions, reversibility requirements, the up/down contract, naming patterns. A `db/migrations/**` rule defines this specific repository's migration conventions — which framework is in use, the team's naming prefix, the rollback policy for this codebase. Both can be active simultaneously for the same task and contribute complementary, non-overlapping knowledge.

## Alternatives Considered

### Alternative A: Merged "context file" with both `paths:` and `domains:` frontmatter fields

A single file format where each context file optionally specifies a `paths:` glob (for file-touch activation), a `domains:` list (for task-domain activation), or both.

**Pros:**
- Single format to learn.
- Fewer directories to navigate.
- A piece of knowledge that is both path-triggered and domain-triggered can live in one file.

**Cons:**
- The routing system must maintain two separate activation indices (a path-glob trie and a domain-keyword index) against the same file set, making the activation logic more complex.
- Validating a file becomes ambiguous: is a file missing `paths:` intentionally (domain-only) or is it a mistake?
- The file has dual responsibility — it is simultaneously a path hook and a task-domain knowledge base — which violates the single-responsibility principle.
- Debugging "why did this context fire?" becomes harder when a file might have activated via either mechanism.

**Why rejected:**
- The composability benefit of two clean primitives outweighs the convenience of one flexible format. The activation mechanisms are genuinely different in nature; merging them saves lines of YAML but costs reasoning clarity.

### Alternative B: Keep only skills, add a `paths:` field to `SKILL.md`

Eliminate rules entirely. Allow skills to declare `paths:` alongside their existing frontmatter. The skill loader would handle both domain-invocation and path-triggered injection.

**Pros:**
- Only one primitive type to understand and maintain.
- Existing skill infrastructure is reused.

**Cons:**
- Skills are loaded at task-start via the routing protocol, which runs before any specific files are examined. Path-triggered injection happens at a different point in the session lifecycle — when files come into scope during tool calls.
- Making the skill loader path-aware would require it to monitor file access events throughout the session, which is a fundamentally different execution model from "invoke once at task start."
- Skills are domain knowledge — reusable procedural guides. Rules are context injectors — file-type-specific reminders. Forcing both into `SKILL.md` conflates knowledge with triggers.

**Why rejected:**
- The execution lifecycle mismatch is the decisive factor. Path-triggered injection is hook-like; skill invocation is tool-like. These are not the same operation with different parameters — they are different mechanisms. Merging them would produce an inconsistent execution model.

## Consequences

### Positive

- The placement decision for any new piece of knowledge is clear: ask "does this apply to files, or to tasks?" If files, it is a rule; if tasks, it is a skill. The answer is almost always unambiguous.
- The two primitives compose cleanly for the common case (task involves specific files of a known type) — both fire, both contribute, neither overrides the other.
- Each primitive can be validated independently: a rule file without `paths:` frontmatter is immediately detectable as malformed; a skill file with `paths:` frontmatter is immediately detectable as misplaced.

### Negative / Tradeoffs

- Contributors must learn two file formats. The `rules-overview.md` and `skills-overview.md` documents exist specifically to reduce this cost, but the overhead is real.
- When a piece of knowledge could plausibly belong to either (e.g., "when writing TypeScript, prefer explicit return types"), the placement decision requires judgment. In practice this specific example goes into a skill (`refactoring` or a TypeScript-specific skill), not a rule, because it is task-driven rather than file-driven.

### Risks

- A contributor writes path-specific knowledge as a skill with no `paths:` trigger. The knowledge is only activated when explicitly invoked, not automatically when the relevant files are touched. This is a silent defect — the skill works, but not in the context where it was most needed. Mitigated by the "Difference Between Rules and Skills" table in `rules-overview.md`.
- A contributor writes general domain knowledge as a rule (no `paths:` frontmatter, or an overly broad glob). The knowledge fires on file-touch events that may not need it, adding noise to the context. Mitigated by requiring specific, narrow `paths:` globs in rule files.

## Implementation Notes

The canonical question for placement: "Does this knowledge belong to a *file type* or a *task type*?" File type → rule in `<repo>/.claude/rules/`. Task type → skill in `~/.claude/skills/` (global) or `skills/` (project-local).

Rules exist only at project scope (Layer 3 in the five-layer hierarchy — see ADR 0001). There is no global rules directory because path-triggered injection is always project-specific: the paths `db/migrations/**` only mean something in the context of a specific repository's directory structure.

Skills exist at both global scope (`~/.claude/skills/`) and project scope (`skills/`). A project-local skill extends the corresponding global skill by default; it does not replace it unless the project contract explicitly says so.

---

## Related

- [`docs/rules/rules-overview.md`](/home/theo/.claude/docs/rules/rules-overview.md) — operational rules format, `paths:` frontmatter syntax, and the "Difference Between Rules and Skills" quick-reference table.
- [`docs/skills/skills-overview.md`](/home/theo/.claude/docs/skills/skills-overview.md) — operational skill format, invocation model, and global vs project-local skill composition.
- [`docs/decisions/0001-scope-layers.md`](/home/theo/.claude/docs/decisions/0001-scope-layers.md) — the five-layer hierarchy that gives rules (Layer 3) and skills (Layer 4) their respective positions.

---

*ADR based on Michael Nygard's format.*
