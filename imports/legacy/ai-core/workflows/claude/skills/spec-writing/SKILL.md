---
name: spec-writing
description: Use to produce ADRs, tech specs, architecture notes, or other persistent technical analysis before important changes are implemented.
when_to_use: >
  Use when documenting an architectural decision (ADR), writing a tech spec or architecture notes for a new component, or recording cross-cutting technical impact analysis.
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

## Operating Model

### 1. Determine the format
Choose ADR, Tech Spec, or Architecture Notes per the table above.

### 2. Determine where to save
- ADRs: `docs/decisions/` or `docs/adr/` — numbered, e.g. `0001-decision-name.md`
- Tech Specs / Architecture Notes: `docs/` or `docs/architecture/`

If no documentation structure exists, create one and note the convention adopted.

### 3. Draft using the inline template

#### ADR template
```markdown
# ADR-NNN: [Decision Title]
**Status:** Proposed | Accepted | Deprecated | Superseded by ADR-NNN
**Date:** YYYY-MM-DD
**Deciders:** [names or roles]

## Context
[Situation, constraint, or problem forcing a decision. Include technical and organizational pressures.]

## Decision
[The chosen option, stated clearly and directly.]

## Rationale
[Why this option over the alternatives. Reference evidence, not opinion.]

## Alternatives Considered
| Option | Pros | Cons |
|--------|------|------|
| [A]    | ...  | ...  |
| [B]    | ...  | ...  |

## Consequences
**Positive:** [what improves]
**Negative:** [what gets harder or costs more]
**Risks:** [what could go wrong]

## References
- [links, specs, prior ADRs]
```

#### Tech Spec template
```markdown
# Tech Spec: [Feature or System Name]
**Status:** Draft | Review | Approved | Implemented
**Author(s):** [names or roles]  **Date:** YYYY-MM-DD  **Linked ADRs:** ADR-NNN

## Problem Statement
[What is broken, missing, or needs to change. One paragraph max.]

## Goals
- [Measurable outcome]

## Non-Goals
- [Explicitly out of scope]

## Proposed Solution
[Implementation approach. Include Mermaid/ASCII diagrams if helpful.]

### Key Components
[Main modules/services and their responsibilities; schema diffs and rollback strategy; endpoint definitions and error codes.]

## Alternatives Considered
| Option | Pros | Cons |
|--------|------|------|

## Implementation Plan
| Phase | Scope | Owner |
|-------|-------|-------|

## Open Questions
- [ ] [Must resolve before implementation]

## References
```

#### Architecture Notes template
```markdown
# Architecture Notes: [System or Component Name]
**Last updated:** YYYY-MM-DD  **Scope:** [What this covers]

## Overview
[1-3 paragraphs: purpose and boundaries of the system.]

## Component Map
[Mermaid diagram or ASCII art showing components and relationships.]

## Key Data Flows
[Numbered steps describing the main request/event flows.]

## Technology Choices
| Layer | Technology | Rationale |
|-------|-----------|-----------|

## Known Constraints
[Performance limits, compliance requirements, legacy dependencies.]

## References
```

### 4. Record rejected alternatives
**Required for every format.** Without this, the decision loses historical context and is more likely to be revisited incorrectly later.

### 5. Communicate the output
Report: file created/updated, what changed, whether other architecture docs need updating, which next steps depend on this document.

## Validation Checklist
- [ ] Correct format chosen; problem stated clearly (what, why now)
- [ ] ≥ 2 alternatives documented with explicit trade-offs
- [ ] Consequences/Risks present; dependencies mapped
- [ ] Stored in the correct repository location; stakeholders notified

## Examples
### ADR
```markdown
# ADR-001: Authentication via JWT with refresh tokens
**Status:** Accepted  **Date:** 2024-01-15  **Deciders:** tech lead, document owner

## Context
Multi-client app (web, mobile, CLI); server-side sessions complicate horizontal scaling.

## Decision
Short-lived JWTs (15 min) + long-lived refresh tokens (30 days) in HttpOnly cookies.

## Alternatives Considered
| Option | Pros | Cons |
|--------|------|------|
| Server-side session | Simple | Sticky sessions required |
| JWT + refresh | Stateless, multi-client | Token revocation needs blocklist |

## Consequences
**Positive:** stateless scaling, works all clients  **Risks:** Redis blocklist required
```

### Tech Spec
```markdown
# Tech Spec: Notification Service
**Status:** Draft  **Author(s):** backend team  **Date:** 2024-03-10  **Linked ADRs:** ADR-004

## Problem Statement
Emails sent synchronously inside the request cycle cause timeouts under load.

## Goals
- Deliver notifications within 5 s of the triggering event (p99)
- Decouple notification dispatch from the request path

## Proposed Solution
Publish events to a queue (Redis Streams); a dedicated worker consumes and dispatches.
```

### Architecture Notes
```markdown
# Architecture Notes: Order Processing Pipeline
**Last updated:** 2024-05-01  **Scope:** order creation → fulfillment handoff

## Overview
Orders enter via REST API, are validated, persisted, and enqueued for the fulfillment
service. No synchronous calls cross the service boundary.

## Component Map
API → OrderService → Postgres
                  → Redis Queue → FulfillmentWorker → FulfillmentAPI
```

## Never Do
- Write a spec before understanding the problem — Context/Problem Statement must reflect real investigation, not assumptions
- Propose a solution without listing alternatives considered
- Mark an ADR "Accepted" without identifying who the deciders are
- Skip the Consequences/Risks section — it is the highest-value part of an ADR
- Use a Tech Spec for a trivial change (< 1 day, no architectural impact) — prefer a PR description instead
- Write Architecture Notes that describe what *should* be, not what *is* — they must reflect current reality
- Omit the rollback or migration strategy when the spec includes schema or data changes
