---
name: architecture-reading
description: Use to understand the current architecture before deciding or implementing, mapping the stack, boundaries, flows, patterns, and existing decisions.
when_to_use: >
  Use when understanding the architecture of a project before acting, starting work in an unfamiliar codebase before implementation, or mapping the stack, boundaries, and existing patterns.
---

# Architecture Reading

## When to Use

- Before making any architectural decision in an existing project
- When you need to understand the current technical context before acting
- When starting work in an unfamiliar codebase
- To validate whether a new decision conflicts with previous ones
- When routing or implementation depends on project docs and you need a visible reading pass before
  choosing the next skill stack or agent

## Steps

### 1. Locate existing context documentation

Search for architecture and project documentation that may constrain the task. Treat repository docs as first-class context before inferring behavior from code. Common places:
- `docs/` and subdirectories (`architecture`, `decisions`, `adr`, `context`)
- Root `README.md`
- `docs/lessons.md` and equivalent learnings or retrospective files
- `CONTRIBUTING.md`, onboarding guides, and project conventions
- Decision files (ADRs) in `docs/decisions/`, `docs/adr/`, `architecture/decisions/`, or similar
- Operational runbooks and migration documentation
- Any repository-specific convention or pattern files

> **Tip:** Search by file names such as `architecture`, `adr`, `decisions`, `stack`, `conventions`, `lessons`, `runbook`, and `migration` to discover the documentation layout quickly.

If nothing exists, record that the project **has no documented context** and recommend creating it.
If this documentation pass materially affects the task, record which repo-relative paths were
checked — or why the doc gate was skipped. Keep it lightweight: trivial fast-path tasks do not need
extra ceremony.

### 2. Map the technology stack

Read the project configuration files:
```
package.json / pom.xml / build.gradle / Cargo.toml / go.mod / pyproject.toml
docker-compose.yml / Dockerfile
.env.example
```

Extract the language, frameworks, databases, external services, and major versions.

### 3. Identify system boundaries

Map:
- Which modules or services are primary?
- How do they communicate (HTTP, events, queues, RPC)?
- Which external dependencies exist?
- Where are the domain boundaries?

### 4. Identify architectural patterns in use

Check for evidence of:
- Layered architecture, MVC, Clean Architecture, or Hexagonal Architecture
- Separation of responsibilities (repositories, services, controllers)
- Communication patterns (REST, GraphQL, events)
- Data patterns (CQRS, Event Sourcing)

### 5. Consolidate the reading report

Produce a structured summary:

```markdown
## Stack
[language, frameworks, databases]

## Boundaries
[modules and how they communicate]

## Identified Patterns
[architectural patterns currently in use]

## Relevant Previous Decisions
[ADRs or specs that affect the current task]

## Documentation Gaps
[what is missing and should be documented]
```

## When Documentation Does Not Exist

If the project has no architecture documentation, record it clearly:

> "Project has no architecture documentation. Analysis is based on code inference. Recommend creating an architecture document from this reading."

## Composition Guidance

`architecture-reading` is often a preparatory skill, not the whole task. After the reading report,
continue with the relevant global baseline domain skill(s) for implementation or review, then add
repo-local skills or path-specific instructions when they materially narrow the work. Do not treat
this skill as an exclusive replacement for the rest of the skill stack.

## References

- Canonical summary template: use `### 5. Consolidate the reading report` in this skill
- Example output: use `## Examples` below as a filled reference

## Examples

### Architecture reading output

```markdown
## Architecture Reading — Project X

**Stack:** Node.js 20 + TypeScript, Express, PostgreSQL 15, Redis, Docker
**Pattern:** Layered Architecture (handler → service → repository)
**Tests:** Jest + Supertest (integration), current coverage 73%

### Boundaries
- **External:** Stripe (payments), SendGrid (email), S3 (files)
- **Internal:** REST API → Worker queue (BullMQ) → Email service

### Conventions Found
- Files use `kebab-case`, classes use `PascalCase`
- Typed errors: `AppError extends Error` with `code` and `status`
- Migrations live in `db/migrations/` and run with `npm run db:migrate`

### Attention Points
- No rate limiting on public endpoints (abuse risk)
- `UserRepository` has 3 N+1 queries around lines 45, 67, and 89
```

## Validation Checklist

- [ ] The technology stack is mapped completely (language, frameworks, database, infrastructure)
- [ ] System boundaries are identified (internal vs external)
- [ ] Communication patterns are mapped (REST, gRPC, queues, events)
- [ ] Existing architectural decisions are located (ADRs, Tech Specs)
- [ ] Project conventions are identified (naming, folder structure)
- [ ] Risks, weak spots, or technical debt are noted
- [ ] The summary is delivered before implementation starts
- [ ] Doc-check outcomes are visible when this reading materially affected the task
- [ ] Follow-on skill or agent implications are clear when this reading is only the first step
