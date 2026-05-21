# ADR-0003: GitHub Governance for 0.0.0

## Status

Accepted

## Context

WorkflowSmith needs a disciplined development process. The repository should not evolve through ad hoc edits, especially while the product architecture and workflow model are being established.

## Decision

The active foundation Project is `WorkflowSmith-0.0.0`.

Meaningful work uses:

- issue
- branch
- pull request
- validation
- merge

Project fields, labels, issue forms, and pull request templates are documented in `docs/governance/github.md`.

## Consequences

- All substantial changes should be traceable to issues and PRs.
- Architectural changes require ADRs.
- Project automation should route open issues and PRs into the active Project.
