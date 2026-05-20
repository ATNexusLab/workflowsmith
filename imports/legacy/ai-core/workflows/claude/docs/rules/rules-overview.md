# Rules — Overview

Rules are instruction files that apply only to files matching a specific path pattern. They inject additional context when Claude Code touches those files, without affecting the rest of the project.

---

## What a Rule Is

A rule file lives at `<repo-root>/.claude/rules/<topic>.md`. It contains:
- A `paths:` frontmatter field with a glob pattern
- A body with conventions, constraints, or instructions for that file type

When Claude Code reads or edits a file that matches the glob pattern, the rule's body is injected as additional context.

---

## File Format

```yaml
---
paths: "<glob-pattern>"
---

[Rule body — conventions and instructions for matching files]
```

### `paths:` syntax

Standard glob patterns:
```yaml
paths: "**/*.test.ts"          # All TypeScript test files
paths: "db/migrations/**"      # All migration files
paths: "src/routes/**"         # All route handlers
paths: "**/*.md"               # All markdown files
paths: "prisma/schema.prisma"  # A specific file
```

Multiple patterns can be separated by commas or use brace expansion where supported.

---

## Difference Between Rules and Skills

| | Rules | Skills |
|---|---|---|
| Trigger | Automatic — when a matching file is touched | Manual — invoked via the `Skill` tool, or automatic per routing |
| Scope | Path-specific (only matching files) | Domain-specific (loaded for a category of work) |
| Content | Context injection (what applies to these files) | Procedural knowledge (how to do X in domain Y) |
| Location | `<repo>/.claude/rules/<topic>.md` | `~/.claude/skills/<name>/SKILL.md` |

Rules and skills complement each other: a skill defines how to write migrations in general; a rule defines the specific migration conventions for this project.

---

## Global Rules in `~/.claude/rules/`

The global configuration uses rules in a slightly different way: they are loaded via `@-imports` in `~/.claude/CLAUDE.md` rather than through `paths:` matching. These 4 rules apply to every session:

```
@rules/routing.md
@rules/task-completion.md
@rules/test-contract.md
@rules/closeout.md
```

They lack `paths:` frontmatter because they apply globally. This is an exception — project rules should always use `paths:`.

---

## Creating a Rule

1. Create the file at `<repo-root>/.claude/rules/<topic>.md`:

```yaml
---
paths: "db/migrations/**"
---

# Migration File Conventions

- Every migration must have a matching rollback (`-- rollback --` section)
- Use `ALTER TABLE ... ADD COLUMN` before `NOT NULL` constraints
- Never use `DROP TABLE` without a data backup step
- Migration file names: `YYYYMMDD_HHMMSS_<description>.sql`
- Test each migration against the staging database before merging
```

2. The rule activates automatically when Claude touches any file matching `db/migrations/**`.

---

## What Goes in a Rule vs CLAUDE.md

| Content | Where it goes |
|---|---|
| Conventions that apply to all files | `CLAUDE.md` |
| Conventions specific to a file type or path | `.claude/rules/<topic>.md` with `paths:` |
| Framework for working in a domain (how to design APIs, etc.) | `~/.claude/skills/<name>/SKILL.md` |

---

## Common Rule Examples

**Test file conventions:**
```yaml
---
paths: "**/*.test.ts"
---
- Use `describe` blocks — one per exported function or class
- Never mock the database — use the test transaction wrapper in `test/helpers/db.ts`
- Every test with I/O must be inside a transaction that rolls back
- Import test fixtures from `test/fixtures/` only
```

**Route handler conventions:**
```yaml
---
paths: "src/routes/**"
---
- Route handlers contain no business logic — delegate to service layer in `src/services/`
- Authentication is handled by the `authMiddleware` from `src/middleware/auth.ts`
- All responses use the `respond()` helper from `src/helpers/respond.ts`
- Parameter validation at the top of each handler using the schema from `src/schemas/`
```

**Generated file protection:**
```yaml
---
paths: "src/generated/**"
---
- These files are auto-generated. Do NOT edit manually.
- To regenerate: `bun run codegen`
- Changes here will be overwritten on the next codegen run
```

---

## Validation Checklist

- [ ] `paths:` pattern is as specific as possible (avoid `**` when a more targeted path works)
- [ ] Body contains actionable conventions, not vague principles
- [ ] Does not duplicate global `CLAUDE.md` rules
- [ ] Rule content is relevant to the files it matches

---

## Related

- [core/scope-layers.md](../core/scope-layers.md) — how rules layer on top of CLAUDE.md
- [core/claude-md-format.md](../core/claude-md-format.md) — global rule loading via `@-imports`
- [rules/rules-catalog.md](rules-catalog.md) — the 4 mandatory global rules
