# ADR 0001: Five-Layer Instruction Hierarchy

**Status:** Accepted
**Date:** 2026-05-20
**Authors:** Theo Odawara

---

## Context

The earliest version of this configuration used a single `~/.claude/CLAUDE.md` that was expected to govern all Claude Code sessions universally. That worked for one machine and one owner, but broke down quickly across three pressure points.

First, personal preferences — coding language defaults, Obsidian vault credentials, preferred code style — were mixed in the same file as project conventions. Sharing a project meant either leaking personal settings into the repo or duplicating them. Neither was acceptable.

Second, there was no way to narrow behavior for a specific project without overriding the global baseline entirely. A project using Python had no clean path to say "prefer `ruff` over `eslint`" without forking the entire global file.

Third, some rules only make sense for particular file types or directories. Migration files need different context from test files, which need different context from application source. A flat global file can only approximate this with prose ("when you see a migration file, remember…"), which is not reliably triggered.

Three forces shaped the decision: (1) portability — project repos must stay clean of personal secrets and machine-specific settings; (2) additive narrowing — a project should be able to restrict or extend the global baseline without resetting it; (3) path-scoped precision — rules for migration files should activate automatically when migration files are in scope, not rely on the model noticing the file type.

## Decision

We use a five-layer instruction hierarchy, evaluated from most-general to most-specific, cumulative by default:

1. **`~/.claude/CLAUDE.md`** — global personal baseline. Applies to every session, on every project, on every machine. Contains personal preferences, global code conventions, the memory protocol, and the planning protocol. Never committed to any project repo.
2. **Project `CLAUDE.md`** (repo root) — project-wide additions or restrictions. Adds stack-specific commands, project conventions, and local agent overrides. It does not reset the global layer; it extends it.
3. **`.claude/rules/*.md` with `paths:` frontmatter** — path-scoped context injectors. A rule file activates automatically when files matching its `paths:` glob pattern are touched. They apply to files, not tasks.
4. **Project-local `skills/`** — domain knowledge additions specific to this repository. These add project vocabulary and workflow constraints on top of the global skill definitions in `~/.claude/skills/`. They do not replace the global skill by default; they specialize it.
5. **Runtime config (`settings.json`, `mcp.json`)** — machine and environment wiring. Tool permissions, hook registrations, MCP server endpoints. This layer affects execution context, not the semantic instruction contract.

"Cumulative" is the operative word. An upper layer replaces a lower one only when the project contract explicitly declares a substitution. The default assumption is always additive narrowing, not reset.

## Alternatives Considered

### Alternative A: Single global CLAUDE.md with inline conditional blocks

One file containing blocks like `<!-- IF project == logbox -->` or runtime-evaluated conditionals to handle per-project behavior.

**Pros:**
- Single file to maintain; no layering model to learn.
- All instructions visible in one place.

**Cons:**
- Grows into a 500+ line monolith as projects accumulate.
- Every project contributor must read and understand the entire file to know what applies to them.
- Machine-specific secrets and personal preferences live in the same file — no safe way to share per-project sections without sharing the whole thing.
- Conditional logic in markdown is fragile and model-dependent.

**Why rejected:**
- The file becomes unmaintainable at scale and cannot be shared safely. The contamination problem — personal settings bleeding into project commits — is not solvable with conditional blocks.

### Alternative B: Three layers only (global / project / runtime), no path rules or local skills

A simpler hierarchy with only a global baseline, a project override, and runtime config.

**Pros:**
- Fewer files; easier mental model for contributors new to the system.
- Three layers maps cleanly onto a familiar precedence chain.

**Cons:**
- No mechanism to scope migration conventions separately from test conventions within the same project CLAUDE.md.
- Project-specific domain extensions (e.g., a custom skill for a proprietary API) must either live globally (polluting all projects) or be embedded inline (bloating the project CLAUDE.md).
- Path-scoped injection cannot be approximated reliably with prose in a flat file.

**Why rejected:**
- The absence of path-scoped rules means the model must infer file-type context from filenames in the prompt, which is unreliable. The absence of local skills forces domain knowledge into the wrong layer.

## Consequences

### Positive

- Each layer is independently version-controlled and independently readable. A contributor can understand the project layer without reading the global layer.
- Project repos remain completely free of personal preferences, vault credentials, and machine-specific settings.
- Path-scoped rules activate automatically — no prose reminders needed inside CLAUDE.md for "remember, migration files work differently."
- The additive contract means global improvements (new global skill, updated planning protocol) propagate to all projects without any project-level changes.

### Negative / Tradeoffs

- New contributors to the system must learn the layering model before contributing effectively. "Which layer does this belong in?" is a non-trivial question until the model is internalized.
- Debugging an unexpected behavior requires checking all five layers for potential sources. There is no single file to inspect.

### Risks

- **Duplication drift:** a project CLAUDE.md copy-pastes global rules instead of relying on them, then the global rule is updated but the copy is not. Mitigated by the explicit "additive by default" contract and periodic audits.
- **Layer misplacement:** a contributor puts a path-scoped rule into the project CLAUDE.md as prose, where it has no automatic trigger. Mitigated by documentation of the `paths:` frontmatter mechanism.

## Implementation Notes

The `~/.claude/` repository itself is a special case and must be understood clearly: it is simultaneously Layer 1 (the global baseline for all projects) and a git repository in its own right. Path-specific rules inside `~/.claude/.claude/rules/` apply only to work done within the `~/.claude/` directory, not globally. The global instruction surface is `~/.claude/CLAUDE.md` and `~/.claude/rules/*.md` (the latter included via `@rules/` directives in CLAUDE.md) — these are distinct from files that are path-scoped to the repository itself.

When deciding which layer a piece of knowledge belongs to, apply this question sequence: Is it personal and cross-project? → Layer 1. Is it project-wide and safe to commit? → Layer 2. Is it triggered by specific file types? → Layer 3. Is it domain-specific procedural knowledge for this project? → Layer 4. Is it machine/environment wiring? → Layer 5.

---

## Related

- [`docs/core/scope-layers.md`](/home/theo/.claude/docs/core/scope-layers.md) — operational how-to: what each layer contains, file placement rules, and the precedence resolution algorithm.
- [`docs/rules/rules-overview.md`](/home/theo/.claude/docs/rules/rules-overview.md) — Layer 3 in detail: `paths:` frontmatter syntax and rule file format.
- [`docs/skills/skills-overview.md`](/home/theo/.claude/docs/skills/skills-overview.md) — Layer 4 in detail: skill format, invocation model, and local vs global skill composition.

---

*ADR based on Michael Nygard's format.*
