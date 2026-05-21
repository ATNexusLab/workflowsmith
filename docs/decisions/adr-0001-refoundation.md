# ADR-0001: Refoundation Around Clean Product Architecture

## Status

Accepted

## Context

WorkflowSmith needs to become a complete, enterprise-grade AI workflow product. The previous repository direction mixed product design with legacy workflow imports and early promoted fragments. That made the active context noisy and encouraged future work to preserve old structure instead of designing the product deliberately.

## Decision

WorkflowSmith is re-founded as a clean product architecture.

The repository removes legacy import material and old import-first documentation. The new foundation starts at milestone `0.0.0`, with `1.0.0` reserved for the first complete enterprise workflow release.

## Consequences

- Git history remains the archive for the old foundation.
- Active files must not depend on legacy import directories.
- Future workflow content must be authored intentionally through the new development process.
- Codex is the first compiled harness target, not the source of product truth.
