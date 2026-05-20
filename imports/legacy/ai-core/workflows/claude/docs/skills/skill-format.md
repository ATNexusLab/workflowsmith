# Skill Format

A skill is a markdown file named `SKILL.md` with YAML frontmatter. It lives in `~/.claude/skills/<name>/` (global) or `<repo>/skills/<name>/` (project-local).

---

## Frontmatter Schema

```yaml
---
name: <string>           # Short identifier — must be unique globally
description: <string>    # One-line summary — used for routing decisions and listings
when_to_use: >           # Multi-line trigger description — when should this skill be invoked?
  <text>
---
```

All three fields are required.

### `name`

Must match the directory name. Used when invoking the skill:
```
Skill({ skill: "api-design" })
```

### `description`

One line. Used in catalogs, routing decisions, and the skills listing. Be specific — vague descriptions lead to wrong routing.

Good: `"Use to design or review REST, GraphQL, and gRPC APIs, including contracts, versioning, pagination, errors, rate limiting, and API documentation."`

Bad: `"For API stuff."`

### `when_to_use`

A paragraph (or list) describing the conditions under which this skill is appropriate. This is used by the routing system to decide whether to load the skill automatically.

Good:
```yaml
when_to_use: >
  Use when designing a new REST, GraphQL, or gRPC API, reviewing an existing API
  for versioning, pagination, or error handling, or defining API contracts and
  producing OpenAPI or protobuf documentation.
```

---

## Body Structure

The skill body follows this order. All sections are conventions — use what applies.

```markdown
# Skill Name

## When to Use

[List of specific scenarios where this skill should be invoked.
More concrete than the frontmatter when_to_use field.]

## Core Principles / Concepts

[Foundational mental model for this domain.
What to think about before doing anything.]

## Steps / Workflow

[The main procedural content.
Numbered steps, decision trees, checklists.]

## Patterns / Examples

[Concrete examples, templates, and code snippets.
Working examples are worth more than explanatory prose.]

## Validation Checklist

[Quick checklist to verify the work meets domain standards.
Used at the end of a task using this skill.]

## Never Do

[Domain-specific anti-patterns and hard prohibitions.
Do not repeat global CLAUDE.md rules here.]
```

---

## Minimal Valid SKILL.md

```yaml
---
name: log-analysis
description: "Use to analyze structured logs for patterns, errors, and performance anomalies."
when_to_use: >
  Use when investigating application logs for recurring errors, tracing request
  failures, or identifying performance regressions from log output.
---

# Log Analysis

## When to Use

- Investigating a recurring error pattern in production
- Tracing a failed request end-to-end through distributed logs
- Identifying the source of a performance spike from access logs

## Steps

1. Identify the log format (structured JSON, nginx, syslog, etc.)
2. Filter to the time window of the incident
3. Group by error type or endpoint — find the highest-frequency patterns
4. Trace one representative instance end-to-end
5. Report: what happened, when, how frequently, and the root cause hypothesis

## Patterns

**Filter JSON logs by level and time:**
```bash
jq 'select(.level == "error" and .timestamp > "2024-01-01T00:00:00Z")' app.log
```

**Count errors by type:**
```bash
jq -r '.error_type' app.log | sort | uniq -c | sort -rn | head -20
```

## Validation Checklist

- [ ] Time window is bounded to the relevant incident
- [ ] Root cause hypothesis is stated, not just symptoms
- [ ] False positives (expected errors) are excluded

## Never Do

- Do not treat all log output as equally important — filter to signal
- Do not report symptoms without a root cause hypothesis
```

---

## Real Examples

### `api-design`

```yaml
---
name: api-design
description: "Use to design or review REST, GraphQL, and gRPC APIs, including contracts, versioning, pagination, errors, rate limiting, and API documentation."
when_to_use: >
  Use when designing a new REST, GraphQL, or gRPC API, reviewing an existing API
  for versioning, pagination, or error handling, or defining API contracts and
  producing OpenAPI or protobuf documentation.
---
```

### `obsidian-memory`

```yaml
---
name: obsidian-memory
description: "Use to read from or write to the Obsidian vault as cross-project memory only when local context is insufficient or there is real continuity value."
when_to_use: >
  Use when reading from or writing to the Obsidian vault, persisting cross-project
  knowledge, or recovering context from previous sessions or projects.
---
```

---

## Subdirectory Support

A skill can include supporting files in subdirectories:

```
skills/spec-writing/
├── SKILL.md
├── patterns/
│   └── common-patterns.md
└── references/
    ├── adr-template.md
    ├── arch-notes-template.md
    └── tech-spec-template.md
```

The main `SKILL.md` can instruct the model to read specific files from these subdirectories:
```markdown
## Steps
1. Choose the format (ADR/Tech Spec/Architecture Notes) — see patterns/common-patterns.md
2. Use the matching template from references/
```

---

## Validation Checklist

- [ ] `name` matches the directory name exactly
- [ ] `description` is one line and specific enough for routing
- [ ] `when_to_use` describes the trigger conditions clearly
- [ ] Body has at minimum: When to Use, Steps, Never Do
- [ ] Contains at least one concrete example or code snippet
- [ ] Does not duplicate rules from `CLAUDE.md`
- [ ] Does not contain agent behavior (identity, escalation, routing)
- [ ] Steps are actionable without external resources

---

## Related

- [skills/skills-overview.md](skills-overview.md) — how skills work and when they're invoked
- [skills/skills-catalog.md](skills-catalog.md) — all 19 global skills
- [agents/agent-format.md](../agents/agent-format.md) — how agents reference skills
