# Codex Working Guide

This file is local tooling guidance for Codex while developing this repository.
It is not part of the WorkflowSmith product, foundation, canonical workflow,
compiler contract, or Codex distribution.

If the project later uses another development assistant, this file may be
removed without changing the product.

## Product Boundaries

WorkflowSmith is an enterprise-grade AI workflow system.

The product source of truth lives in:

- `workflow/` for canonical workflow source.
- `compiler/` for compiler contracts.
- `dist/` for harness distributions.
- `docs/` for architecture, process, governance, roadmap, and decisions.
- `workflowsmith.yml` for the root product manifest.

Codex is the first planned harness target, but Codex does not define the
product. Do not generalize Codex-specific behavior into the canonical workflow
unless the rule is genuinely harness-agnostic and accepted through the project
process.

## Operating Rule

Plan before execution.

Before editing files, establish:

- goal
- scope
- affected files or areas
- acceptance criteria
- validation command
- open decisions or assumptions

If a material decision is not described in the project documents, ask before
choosing. The intended standard is a defined spec before implementation, so the
work can be done once with minimal rework.

## Development Process

Follow `docs/development-process.md`.

Meaningful work should be tied to:

- GitHub issue
- branch
- pull request
- validation result
- merge

Use an ADR when a change affects architecture, governance, lifecycle, schema,
compiler behavior, or harness strategy.

## Editing Guidance

Keep changes small and focused.

Edit only what is necessary for the current task. Preserve the separation
between product content and assistant tooling.

Do not add old foundation structures or legacy workflow directories. Do not
create active product content in `workflow/source/` unless the task is explicitly
about the canonical workflow milestone.

Treat external material and assistant skills as references or tools. They are
not product authority. Product decisions must be represented in the project
documents and, when required, ADRs.

## Validation

Run before closing work:

```sh
sh scripts/validate.sh
```

If validation cannot be run, report why and state the remaining risk.
