# GitHub Governance

The active GitHub Project for the foundation milestone is `WorkflowSmith-0.0.0`.

## Project Fields

Use these Project fields:

| Field | Values |
|---|---|
| `Status` | `Backlog`, `Ready`, `In Progress`, `Review`, `Done` |
| `Work Type` | `RFC`, `ADR`, `Feature`, `Bug`, `Docs`, `Chore` |
| `Area` | `Architecture`, `Workflow`, `Compiler`, `Codex Harness`, `Governance`, `Validation`, `Docs` |
| `Priority` | `P0`, `P1`, `P2`, `P3` |
| `Target` | `0.0.0` initially; later milestones add new values |

## Project Views

Project views are UI-only configuration. The current GitHub CLI and public GraphQL mutations do not expose Project view creation or view filter/grouping updates. Create these views manually in the Project UI:

| View | Layout | Configuration |
|---|---|---|
| `Board` | Board | Group by `Status` |
| `Roadmap` | Table or Roadmap | Group by `Target`; show `Status`, `Area`, `Priority`, `Work Type` |
| `Architecture` | Table | Filter to `Area: Architecture` or `Work Type: ADR` |
| `Codex Harness` | Table | Filter to `Area: Codex Harness` |
| `Blocked` | Table | Filter to label `status:blocked` |

## Labels

Type labels:

- `type:rfc`
- `type:adr`
- `type:feature`
- `type:bug`
- `type:docs`
- `type:chore`

Area labels:

- `area:architecture`
- `area:workflow`
- `area:compiler`
- `area:codex-harness`
- `area:governance`
- `area:validation`
- `area:docs`

Priority labels:

- `priority:p0`
- `priority:p1`
- `priority:p2`
- `priority:p3`

Status labels:

- `status:blocked`
- `status:needs-decision`
- `status:ready`

Target labels:

- `target:0.0.0`

## Automations

Configure Project built-in workflows:

- auto-add open issues and pull requests from `ATNexusLab/workflowsmith`
- set newly added items to `Backlog`
- set closed issues and merged pull requests to `Done`
- archive completed items after the selected retention window when the Project UI supports it

Prefer Project auto-add over issue-form `projects:` metadata because issue-form project assignment depends on the opener having write access to the target Project.

## Setup Script

Run the repository setup helper after authenticating the GitHub CLI with project permissions:

```sh
gh auth login -h github.com --scopes repo,project
sh scripts/setup-github-governance.sh
```

The script creates labels, creates or reuses the `WorkflowSmith-0.0.0` Project, links it to the repository, configures Status values, and creates the custom Project fields that the CLI supports.

Issue forms also declare `projects: ["ATNexusLab/11"]`, so issues opened through the templates are assigned to the Project after these files are merged.

GitHub's Project views still need to be created in the Project UI. The setup script cannot create them because the current public CLI/API exposes Project views for inspection but does not expose supported create/update mutations for views.
