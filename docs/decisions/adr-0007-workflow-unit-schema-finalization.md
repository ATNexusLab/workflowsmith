# ADR-0007: Workflow Unit Schema Finalization

## Status

Accepted

## Context

`workflow/schema/workflow-unit.md` was written during the 0.0.0 foundation phase
as a placeholder. It listed eight `kind` values:

- `instruction`, `agent`, `skill` — established as canonical core types by ADR-0005
- `contract` — introduced organically in `workflow/spec/` to describe framework-level
  agreements between canonical source and harness distributions
- `policy`, `role`, `procedure`, `checklist` — inherited from the initial 0.0.0 draft,
  predating ADR-0005, with no precise definitions and no current usage in any file

As `workflow/source/` begins to receive real units in milestone 0.1.0, the schema
must be unambiguous. Contributors need to know which `kind` to use when authoring
a new unit. The four legacy kinds (`policy`, `role`, `procedure`, `checklist`) create
unnecessary ambiguity because each overlaps with a core ADR-0005 type:

- `policy` overlaps with `instruction` (both are durable behavior guidance)
- `role` overlaps with `agent` (both describe an execution responsibility)
- `procedure` overlaps with `skill` (both describe a reusable specialized capability)
- `checklist` overlaps with `skill` (a checklist is a skill with list-style output)

`contract` does not overlap with any core type. It addresses a distinct concept:
a framework-level agreement that binds canonical source to harness distributions or
compiler behavior. It is already used in `workflow/spec/harness-resources.md` and
`workflow/spec/instruction-agent-skill-model.md` and must be retained.

RFC #11 opened the decision and recorded the proposed resolution and alternatives
considered.

## Decision

The allowed `kind` values in `workflow/schema/workflow-unit.md` are finalized as:

| Kind          | Role                                                                 |
|---------------|----------------------------------------------------------------------|
| `instruction` | Durable behavior guidance with broad or high-precedence effect       |
| `agent`       | An execution role with responsibility, scope, and completion criteria|
| `skill`       | A specialized capability invoked by a trigger                        |
| `contract`    | A framework-level agreement binding canonical source and harnesses   |

The four legacy kinds are retired:

| Retired kind | Reason                                     | Maps to       |
|--------------|--------------------------------------------|---------------|
| `policy`     | Redundant with `instruction`               | `instruction` |
| `role`       | Redundant with `agent`                     | `agent`       |
| `procedure`  | Redundant with `skill`                     | `skill`       |
| `checklist`  | Redundant with `skill`                     | `skill`       |

No existing files use the retired kinds, so no migration is required.

Future `kind` additions (e.g., `rule`, `hook`, `command`) are explicitly deferred.
Each will be decided through its own RFC and, if adopted, recorded in a subsequent
ADR before any units of that kind are authored.

## Consequences

- `workflow/schema/workflow-unit.md` is updated to list only the four finalized kinds,
  each with an explicit definition.
- Any future `kind` addition or removal requires a new ADR.
- The `workflow/spec/` files that already use `kind: contract` remain valid.
- Validation may enforce that only the four allowed kinds appear in canonical units
  once unit-level validation is added.
- RFC #11 closes as resolved by this ADR.
