# Workflow Unit Schema

This file records the initial shape of future canonical workflow units.

Required metadata:

- `id`
- `kind`
- `status`
- `version`
- `owner`

Initial allowed `kind` values:

- `policy`
- `role`
- `procedure`
- `checklist`
- `contract`

Initial allowed `status` values:

- `draft`
- `reviewed`
- `stable`

The schema is not final in 0.0.0. Changes to this shape require an ADR.
