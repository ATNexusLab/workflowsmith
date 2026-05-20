# Scope Layers

Claude Code resolves instructions from five layers, applied in order from most general to most specific. Layers are **cumulative by default** — each layer adds to or narrows the one below it. An upper layer replaces the base only when the contract explicitly says so.

---

## The 5 Layers

```
1. Personal-home baseline    ~/.claude/CLAUDE.md + ~/.claude/skills/
2. Project repo-wide         <repo-root>/CLAUDE.md
3. Project path-specific     <repo-root>/.claude/rules/<topic>.md  (paths: frontmatter)
4. Project-local skills      <repo-root>/skills/
5. Runtime-config            MCP server wiring, settings.json
```

### Layer 1 — Personal-Home Baseline

**Files:** `~/.claude/CLAUDE.md` and `~/.claude/skills/`

The global foundation that applies to every session across every project. Defines:
- Language rules (English by default)
- Agent behavior and routing protocol
- Code conventions and engineering principles
- Mandatory planning protocol
- The 19 global skills available everywhere

This layer is always active. It cannot be disabled by project config.

### Layer 2 — Project Repo-Wide

**File:** `CLAUDE.md` at the repository root (project-scoped)

Added when Claude is working inside a specific project. It narrows, extends, or overrides parts of Layer 1 for that repo — without resetting the global baseline.

Typical contents:
- Project-specific stack (package manager, language version)
- Exact lint/typecheck/format/build/test commands
- Module boundaries and naming conventions
- Project-specific never-dos

**Rule:** Do not duplicate what is already in `~/.claude/CLAUDE.md`. The project CLAUDE.md is additive.

### Layer 3 — Project Path-Specific

**Files:** `<repo-root>/.claude/rules/<topic>.md` with `paths:` frontmatter

Rules that apply only to files matching a glob pattern. Always additive — they narrow context further for specific file types without affecting others.

Example frontmatter:
```yaml
---
paths: "**/*.test.ts"
---
```
The body injects as additional context whenever Claude touches a matching file.

Use this for: test-file-specific conventions, migration file rules, API handler naming.

### Layer 4 — Project-Local Skills

**Directory:** `<repo-root>/skills/`

Project-specific skills that add vocabulary, workflow steps, or constraints relevant only to this repo. They layer on top of the matching global skill — they do not replace it unless the repo contract explicitly says so.

Example: a `skills/database-migrations/SKILL.md` that adds project-specific migration checklist steps on top of the global `database-design` skill.

### Layer 5 — Runtime-Config

**Files:** `mcp.json`, `settings.json`

MCP server wiring (what external tool servers are available) and runtime settings (permission modes, hooks, statusLine). This layer affects what tools and integrations are available but does not change the semantic instruction contract.

---

## Precedence Rules

| Situation | Behavior |
|---|---|
| Project CLAUDE.md adds a new rule | Both global + project rules are active |
| Project CLAUDE.md repeats a global rule | Duplication — remove from project |
| Project CLAUDE.md contradicts a global rule | Project wins (explicit override) |
| Project-local skill on the same name as a global skill | Both active, local adds on top |
| Path rule matches the current file | Injected as additional context |
| Path rule does not match | Ignored |

---

## The `~/.claude` Special Case

The `~/.claude` directory is simultaneously:
- The personal-home baseline (Layer 1)
- A git repository (`TheoOdawara/.claude`)

When Claude Code is opened **inside** `~/.claude`, Layer 2 (project repo-wide) also activates for that repo. Files in `~/.claude` are then repo-scoped to that repository and should not be generalized to other repositories.

---

## Visual Summary

```
Project: logbox
├── Layer 1 (always)     ~/.claude/CLAUDE.md
│                        ~/.claude/skills/database-design/
│                        ~/.claude/skills/testing-patterns/
│                        ... (19 global skills)
│
├── Layer 2 (repo)       logbox/CLAUDE.md
│                        (stack: Node.js, bun; test: bun test)
│
├── Layer 3 (path)       logbox/.claude/rules/migrations.md
│                        (paths: "db/migrations/**")
│
├── Layer 4 (skills)     logbox/skills/log-schema/SKILL.md
│                        (project-specific logging conventions)
│
└── Layer 5 (runtime)    logbox/.claude/mcp.json
                         logbox/settings.json
```

---

## Common Mistakes

**Duplicating global rules in project CLAUDE.md.** The global rules always apply. Duplication creates drift — the global gets updated, but the copy in the project does not.

**Creating a project-local skill that fully replaces the global one.** The global skill is still active. Either mark the local as explicit replacement in the repo contract, or keep it additive.

**Writing global-applicable knowledge in a path-specific rule.** Path rules only activate when the `paths:` pattern matches. Don't put general rules in them.

---

## Related

- [core/claude-md-format.md](claude-md-format.md) — structure of CLAUDE.md files at each layer
- [rules/rules-overview.md](../rules/rules-overview.md) — path-specific rules in detail
- [skills/skills-overview.md](../skills/skills-overview.md) — global vs local skill layering
