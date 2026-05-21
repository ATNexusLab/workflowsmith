# Architecture Decision Records

This directory contains Architecture Decision Records (ADRs) for WorkflowSmith.

An ADR is a short document that captures an important architectural decision: the context that led to it, the decision itself, and its consequences. ADRs are immutable once accepted — superseded decisions get a new ADR that references the old one.

## Format

Each ADR follows this four-section template:

```markdown
# ADR-NNN: Title

**Status:** Draft | Accepted | Superseded by ADR-NNN

## Context

What situation or constraint made this decision necessary?

## Decision

One clear sentence stating the decision. Followed by elaboration if needed.

## Consequences

What becomes true after this decision? What is now easier, harder, or constrained?
```

## Numbering

Use zero-padded three-digit numbers: `ADR-001`, `ADR-002`, and so on. File names follow the pattern `ADR-NNN-kebab-case-title.md`.

## Adding a New ADR

1. Pick the next available number.
2. Create `docs/decisions/ADR-NNN-your-title.md` using the template above.
3. Set `Status: Draft` until the decision is reviewed and accepted.
4. Reference the ADR from the relevant canonical files once accepted.

## Current Records

| ADR | Title | Status |
|---|---|---|
| [ADR-001](ADR-001-canonical-schema.md) | Canonical Schema Definition | Accepted |
| [ADR-002](ADR-002-build-system-model.md) | Build System Model | Accepted |
| [ADR-003](ADR-003-content-lifecycle.md) | Content Lifecycle | Accepted |
| [ADR-004](ADR-004-legacy-treatment.md) | Legacy Treatment | Accepted |
| [ADR-005](ADR-005-versioning-strategy.md) | Versioning Strategy | Accepted |
