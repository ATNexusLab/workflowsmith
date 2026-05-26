# Authoring Modularity

## Metadata

- id: `authoring-modularity`
- kind: `instruction`
- status: `draft`
- version: `0.1.0`
- owner: `WorkflowSmith`

## Purpose

WorkflowSmith source units must stay small enough to review, translate, and
maintain without repeated cleanup passes.

## Size Budget

Canonical units should stay within these budgets:

- most workflow units: 200 lines;
- checklists: 120 lines.

The budget applies to authored canonical source units. Harness distributions may
use the native structure required by the target harness, but they must preserve
traceability to the canonical source.

## Split Rule

Split a unit when it contains more than one responsibility, mixes concepts from
different unit types, or needs a table of contents to be usable.

Do not place reusable procedures inside instructions. Do not place broad
behavior rules inside skills. Do not place unrelated operating guidance inside
agents.

## Exceptions

An oversized unit must include a `size-budget-exception:` metadata entry or line
that explains why the unit is intentionally not split.

Exceptions should be rare and must preserve a clear review boundary.
