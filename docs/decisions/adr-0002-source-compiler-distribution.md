# ADR-0002: Canonical Source, Compiler Contracts, and Distributions

## Status

Accepted

## Context

WorkflowSmith must support multiple AI coding harnesses without letting any single harness define the product. At the same time, the first validated target must be concrete enough to prove that the workflow can compile into a usable runtime.

## Decision

WorkflowSmith uses three product layers:

- canonical workflow source in `workflow/`
- compiler contracts in `compiler/`
- compiled harness distributions in `dist/`

Codex is the first compiled and validated harness distribution.

## Consequences

- Canonical workflow content must remain harness-agnostic.
- Harness-specific differences are recorded in compiler contracts and distribution notes.
- Distribution outputs are product artifacts and must be traceable to canonical source.
- Other harnesses are deferred until Codex validates the model.
