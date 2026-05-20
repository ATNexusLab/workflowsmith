---
name: spec-writing
description: Use to produce ADRs, tech specs, architecture notes, or other persistent technical analysis before important changes are implemented.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
  - write_file
  - create_file
---

# Spec Writing

## When to Use

- Before implementing a significant architectural change
- When a decision has non-obvious trade-offs that need to be recorded
- When multiple approaches exist and the choice needs justification
- When a feature requires alignment across teams or stakeholders before work begins
- When onboarding will be faster if the rationale for a system structure is documented

## Core Principle

Specs exist to align understanding and record decisions — not to justify work already done. Write them before implementation. A spec written after the fact is a changelog, not a decision record.

## Document Types

### ADR (Architecture Decision Record)

Use when: a significant architectural or design decision needs to be recorded with its context, options considered, and rationale for the chosen option.

**When to write an ADR:**
- Choosing between materially different technical approaches
- Adopting or replacing a significant dependency
- Defining a cross-cutting pattern (authentication, error handling, data access)
- Making a decision that would be surprising to a future team member

**ADR Template:**

```markdown
# ADR-{number}: {Short, imperative title}

Date: {YYYY-MM-DD}
Status: Proposed | Accepted | Deprecated | Superseded by ADR-{N}
Deciders: {names or teams}

## Context

What is the situation that requires a decision? Include:
- Current state
- Forces driving the decision (technical, business, team)
- Constraints that limit the option space

## Decision

State the decision in one or two sentences.

## Options Considered

### Option A: {Name}
{Description}

**Pros:**
- {advantage}

**Cons:**
- {disadvantage}

### Option B: {Name}
...

## Rationale

Why was Option {X} chosen over the alternatives? Address the specific pros and cons that tipped the decision.

## Consequences

### Positive
- {expected benefit}

### Negative
- {accepted trade-off or cost}

### Risks
- {what could go wrong, and how it will be mitigated}

## Implementation Notes

Key points for the team implementing this decision.
```

### Tech Spec

Use when: a non-trivial feature or system change needs to be designed before implementation begins.

**When to write a Tech Spec:**
- The feature touches more than two systems or two teams
- The implementation plan is not obvious to someone familiar with the codebase
- There is meaningful risk that needs to be evaluated before writing code
- The feature requires API or schema changes that affect other consumers

**Tech Spec Template:**

```markdown
# Tech Spec: {Feature or System Name}

Date: {YYYY-MM-DD}
Author: {name}
Status: Draft | In Review | Approved | Implemented
Stakeholders: {names or teams}

## Summary

One paragraph: what is being built, why, and what it replaces or adds to.

## Background

Context needed to understand this spec. Link to related ADRs, previous specs, or incidents.

## Goals

- {What this spec intends to achieve}
- {Measurable where possible}

## Non-Goals

- {What is explicitly out of scope for this work}

## Proposed Design

### Overview

High-level description. Include a diagram if it reduces ambiguity.

### API Changes

Detail new or modified endpoints, request/response shapes, and versioning strategy.

### Data Model Changes

Schema additions, modifications, and migration plan.

### Service Interactions

Which services are called, how, and what the failure modes are.

### Error Handling

How errors are classified, surfaced, and handled across layers.

## Alternatives Considered

Why was this design chosen over the alternatives?

## Implementation Plan

Phased approach if applicable. Identify the highest-risk steps.

## Rollout and Rollback

How will this be deployed safely? What is the rollback plan?

## Observability

What metrics, logs, and alerts will validate this change in production?

## Open Questions

Questions that must be resolved before implementation can begin.
```

### Architecture Note

Use when: a system behavior, constraint, or pattern needs to be documented but does not require a full decision record or spec.

**Architecture Note Template:**

```markdown
# Architecture Note: {Topic}

Date: {YYYY-MM-DD}
Author: {name}

## Summary

One to three sentences: what this note documents and why it exists.

## Details

{The observation, constraint, or pattern being documented}

## Why This Matters

{What goes wrong if this is ignored or misunderstood}

## References

{Links to related code, ADRs, or external documentation}
```

## Writing Quality Standards

### Clarity Rules

- Write for someone who is smart but unfamiliar with the current decision context
- Use active voice: "The service validates the token" not "The token is validated"
- State the decision before the rationale — do not make the reader infer the conclusion
- Define acronyms and domain terms on first use

### Structure Rules

- One claim per sentence
- Bullets for lists of three or more items; prose for fewer
- Tables for comparisons across options
- Code blocks for any technical reference: SQL, API shapes, config
- Never use "obviously," "clearly," or "simply" — these dismiss the reader's legitimate questions

### Scope Rules

- Constrain the option space: eliminate options that do not meet the constraints before comparing
- Separate constraints (non-negotiable) from preferences (negotiable)
- Include non-goals explicitly — they prevent scope creep during review
- State open questions rather than leaving ambiguity hidden in prose

## Review Checklist

Before sharing a spec for review:

**ADR:**
- [ ] Context explains why the decision was necessary now
- [ ] At least two options are compared with explicit pros and cons
- [ ] Decision is stated before rationale
- [ ] Consequences include both positive and negative

**Tech Spec:**
- [ ] Goals are specific enough to determine whether they were met
- [ ] Non-goals are explicit
- [ ] API and schema changes are fully specified
- [ ] Rollout and rollback are addressed
- [ ] Open questions are listed

**All documents:**
- [ ] No jargon without definition
- [ ] Active voice throughout
- [ ] Decision or conclusion stated up front, not at the end
- [ ] Links to related decisions, code, or context

## File Location Conventions

```
docs/adr/
  ADR-001-database-choice.md
  ADR-002-authentication-strategy.md

docs/specs/
  2024-01-payment-service.md
  2024-02-notification-redesign.md

docs/architecture/
  event-bus-patterns.md
  multi-tenancy-model.md
```

## Never Do

- Write a spec after the implementation as a historical record — this is documentation, not a spec
- Omit non-goals — unconstrained scope is not a spec, it is a wish list
- Record only the chosen option without the alternatives — future readers need to understand what was rejected and why
- Use a spec to advocate for a decision already made — the options evaluation must be honest
- Leave open questions unanswered before the spec is used to begin implementation
