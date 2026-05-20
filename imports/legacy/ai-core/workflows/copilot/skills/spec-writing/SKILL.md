---
name: spec-writing
description: Use to produce ADRs, tech specs, architecture notes, or other persistent technical analysis before important changes are implemented.
user-invocable: true
disable-model-invocation: false
triggers:
  - "document an architectural decision (ADR)"
  - "write a tech spec, design doc, or architecture notes for a new component"
  - "record a decision or cross-cutting technical impact analysis"
license: MIT
---

# Spec Writing

## When to Use

- To record important architectural decisions (ADR)
- To specify a new component or significant redesign (Tech Spec)
- To document analyses, clarifications, or smaller decisions (Architecture Notes)
- Whenever a decision must be communicated clearly to the relevant reviewers or the team

## Choosing the Format

| Format | When to use it | Impact threshold |
|--------|----------------|------------------|
| **ADR** | Cross-cutting decision, difficult to reverse, long-term effect | Affects multiple modules or the whole system |
| **Tech Spec** | New component, significant redesign, external integration | Affects one module or service deeply |
| **Architecture Notes** | Analysis, clarification, patterns, smaller decisions | Affects a localized area |

**Rule of thumb:** if the decision took more than five minutes of real hesitation, it is probably an ADR or a Tech Spec.

## Steps

### 1. Determine the format

Choose ADR, Tech Spec, or Architecture Notes based on the criteria above.

### 2. Determine where to save it

Identify how the project organizes technical documentation. Common conventions:
- ADRs: `docs/decisions/`, `docs/adr/`, `architecture/decisions/` (often numbered, for example `0001-decision-name.md`)
- Tech Specs and Architecture Notes: `docs/`, `docs/architecture/`, or an equivalent directory

If no documentation structure exists, create one and document the convention you adopt.

### 3. Draft the document

Use the matching template in `references/`:
- `adr-template.md` → ADRs
- `tech-spec-template.md` → Tech Specs
- `architecture-notes-template.md` → Architecture Notes

### 4. Record rejected alternatives

**Required for every format:** document the alternatives considered and why they were rejected.
Without this, the decision loses historical context and is more likely to be revisited incorrectly later.

### 5. Communicate the output

Report back to the document owner or requester:
- Which file was created or updated
- What changed
- Whether other architecture documents should also be updated
- Which next steps now depend on this document

## References

- `references/adr-template.md` — ADR template
- `references/tech-spec-template.md` — Tech Spec template
- `references/architecture-notes-template.md` — Architecture Notes template
- Inline examples in this skill — use `## Examples` below as a filled reference
- `patterns/common-patterns.md` — catalog of architectural patterns for reference

## Validation Checklist

- [ ] The correct document type was chosen: ADR for architectural decisions, Tech Spec for new components, Architecture Notes for focused analysis
- [ ] The problem is stated clearly (what, why now)
- [ ] Alternatives are documented (at least 2-3 evaluated options when reasonable)
- [ ] The decision is justified with explicit trade-offs
- [ ] Acceptance criteria are written and verifiable
- [ ] Dependencies and risks are mapped
- [ ] Relevant stakeholders reviewed it before publication
- [ ] The document is stored in the correct repository location

## Examples

### ADR — Authentication decision

```markdown
# ADR-001: Authentication via JWT with refresh tokens

**Status:** Accepted
**Date:** 2024-01-15
**Deciders:** technical leadership, document owner

## Context

The application must authenticate users across multiple clients (web, mobile, CLI).
Server-side sessions would increase coupling and make horizontal scaling harder.

## Decision

Use short-lived JWTs (15 minutes) plus long-lived refresh tokens (30 days)
stored in HttpOnly cookies.

## Alternatives Considered

| Alternative | Pros | Cons |
|-------------|------|------|
| Server-side session | Simple to implement | Harder horizontal scaling |
| External OAuth2 | Does not manage credentials internally | Third-party dependency |
| **JWT + refresh** | Stateless, multi-client | More implementation complexity |

## Consequences

- ✅ Horizontal scaling without sticky sessions
- ✅ Works for web, mobile, and CLI
- ⚠️ Token revocation requires a blocklist (Redis)
```
