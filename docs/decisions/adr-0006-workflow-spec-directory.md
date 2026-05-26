# ADR-0006: Workflow Spec Directory

## Status

Accepted

## Context

`workflow/source/` is the canonical workflow home. As the workflow develops, it
will contain agents, skills, hooks, commands, rules, and top-level instruction
files.

After ADR-0004 and ADR-0005 established the canonical harness resource model and
the instruction/agent/skill unit types, four files were placed in
`workflow/source/`:

- `harness-resources.md` — canonical contract for harness capabilities
- `instruction-agent-skill-model.md` — defines canonical unit types
- `authoring-modularity.md` — size budgets and authoring rules for workflow units
- `automation-policy.md` — policy for automatic fixes during workflow authoring

These files define the framework for writing the workflow. They are
pre-requisites and specifications, not the workflow itself. Placing them in
`workflow/source/` alongside future agents and skills would mix
meta-specification with workflow content, making the source directory harder to
navigate and harder to interpret.

## Decision

WorkflowSmith introduces `workflow/spec/` as the home for canonical framework
specifications: documents that define how the workflow is structured, what
harnesses must provide, and how workflow units are authored.

The four files above are relocated from `workflow/source/` to `workflow/spec/`.

`workflow/source/` is left with only its `README.md`, ready to receive the
canonical workflow content in milestone 0.1.0 and beyond.

## Consequences

- `workflow/spec/` is an authoritative layer alongside `workflow/source/` and
  `workflow/schema/`.
- `workflow/source/` contains the live workflow: agents, skills, hooks, commands,
  rules, and top-level instruction files. It does not contain framework or
  authoring specifications.
- `compiler/contracts/harness-target.md` references `workflow/spec/harness-resources.md`
  as the canonical harness capability source of truth.
- `scripts/validate.sh` is updated to check `workflow/spec/` for the four files.
- ADR-0004 noted that `harness-resources.md` lives in `workflow/source/`; this
  ADR supersedes that placement decision without changing the canonical resource
  model itself.
- Future framework specifications belong in `workflow/spec/`, not
  `workflow/source/`.
