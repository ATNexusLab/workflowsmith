# Workflow Unit Schema

Every canonical workflow unit must carry the following metadata fields:

- `id` — unique identifier within the canonical source
- `kind` — the unit type (see allowed values below)
- `status` — lifecycle stage (see allowed values below)
- `version` — semver string matching the milestone that introduced the unit
- `owner` — the team or role responsible for the unit

## Allowed `kind` values

| Kind          | Definition                                                                      |
|---------------|---------------------------------------------------------------------------------|
| `instruction` | Durable behavior guidance with broad or high-precedence effect. Governs how work is performed across many tasks, agents, or skills. |
| `agent`       | An execution role with a defined responsibility, scope, available resources, handoff obligations, and completion criteria. Follows applicable instructions and may invoke skills. |
| `skill`       | A specialized capability invoked by a clear trigger. Defines when to use it, required inputs, the procedure, expected output, and validation or closeout requirements. |
| `contract`    | A framework-level agreement that binds canonical source to harness distributions or compiler behavior. Used for resource models, mapping specifications, and gap declarations. |

Retired kinds (`policy`, `role`, `procedure`, `checklist`) were removed in ADR-0007.
Map any legacy content to `instruction`, `agent`, or `skill` as appropriate.

Future kind additions (e.g., `rule`, `hook`, `command`) require a new ADR before
any units of that kind may be authored.

## Allowed `status` values

| Status     | Meaning                                                   |
|------------|-----------------------------------------------------------|
| `draft`    | Work in progress; not yet reviewed or stable              |
| `reviewed` | Has passed review; may still change before stabilization  |
| `stable`   | Finalized; changes require a new version or ADR           |

## Schema changes

Any addition, removal, or redefinition of a field or allowed value requires an ADR.
