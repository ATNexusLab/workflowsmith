# WorkflowSmith Architecture

WorkflowSmith is organized as a canonical workflow product with compiled harness distributions.

## Architectural Goal

The product goal is a complete, enterprise-grade AI workflow for senior software engineering. The workflow must be precise enough to guide real implementation work, reviews, validation, release decisions, and handoffs.

Codex is the first harness target, but Codex does not define the product. The canonical workflow defines the product.

## Layers

### Canonical Source

`workflow/` stores the harness-agnostic workflow source. This layer defines behavior, responsibilities, quality bars, lifecycle rules, and reusable operating procedures.

Canonical content must avoid tool-specific assumptions unless the behavior is universal across harnesses.

### Compiler Contracts

`compiler/` stores the contracts that describe how canonical workflow concepts are mapped into harness-native surfaces.

A compiler contract defines:

- accepted canonical input
- target harness surfaces
- mapping rules
- unsupported or partial mappings
- validation expectations

### Distributions

`dist/` stores compiled harness outputs. `dist/codex/` is the first target.

Distribution files are product artifacts. They should be derived from canonical source and compiler contracts, not hand-authored as independent workflows.

### Governance

`docs/` and `.github/` define how the product evolves. Architectural choices use ADRs. Work is tracked through issues, pull requests, and the `WorkflowSmith-0.0.0` Project.

## Directory Contract

| Directory | Purpose |
|---|---|
| `workflow/source/` | Canonical workflow source, initially structural in 0.0.0 |
| `workflow/schema/` | Canonical workflow unit shape and authoring expectations |
| `compiler/contracts/` | Harness target and compilation contracts |
| `dist/codex/` | First compiled harness target, not complete in 0.0.0 |
| `docs/decisions/` | Accepted ADRs |
| `docs/governance/` | GitHub and project operating model |
| `.github/` | Issue and pull request templates |
| `scripts/` | Structural validation |

## 0.0.0 Boundary

The 0.0.0 milestone defines the foundation. It intentionally does not complete:

- the full canonical workflow
- compiler implementation
- production Codex distribution
- additional harness targets

Those belong to later milestones.
