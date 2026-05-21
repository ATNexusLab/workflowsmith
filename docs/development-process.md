# Development Process

WorkflowSmith changes move through explicit gates so the product stays coherent as it grows.

## Required Flow

1. Open or select a GitHub issue.
2. Define the problem and acceptance criteria.
3. Create a branch for the change.
4. Use an ADR when the change affects architecture, governance, lifecycle, schema, compiler behavior, or harness strategy.
5. Implement the smallest coherent change.
6. Run `sh scripts/validate.sh`.
7. Open a pull request linked to the issue.
8. Merge only after the PR explains the decision, validation result, and remaining risk.

## RFC Gate

Use an RFC-style issue for exploratory product decisions. An RFC issue should state:

- problem
- target milestone
- proposed direction
- alternatives considered
- acceptance criteria

An RFC can close by becoming an ADR, a scoped implementation issue, or a rejected proposal.

## ADR Gate

Use an ADR for decisions that future contributors must not rediscover.

ADRs are required for:

- architecture changes
- workflow lifecycle changes
- compiler contract changes
- harness target changes
- governance changes
- validation responsibility changes

Accepted ADRs are append-only. Supersede them with a later ADR instead of rewriting history.

## Pull Request Standard

Every meaningful PR must include:

- what changed
- why it changed
- linked issue
- validation result
- known follow-up work

Direct commits to `main` are reserved for exceptional repository maintenance.
