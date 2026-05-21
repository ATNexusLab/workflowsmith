#!/bin/sh
set -eu

OWNER=${OWNER:-ATNexusLab}
REPO_NAME=${REPO_NAME:-workflowsmith}
REPO_FULL="$OWNER/$REPO_NAME"
PROJECT_TITLE=${PROJECT_TITLE:-WorkflowSmith-0.0.0}

require_gh() {
  if ! command -v gh >/dev/null 2>&1; then
    printf 'GitHub CLI is required: https://cli.github.com/\n' >&2
    exit 1
  fi

  if ! gh auth status >/dev/null 2>&1; then
    printf 'GitHub CLI is not authenticated.\n' >&2
    printf 'Run: gh auth login -h github.com --scopes repo,project\n' >&2
    exit 1
  fi
}

create_label() {
  name=$1
  color=$2
  description=$3

  gh label create "$name" \
    --repo "$REPO_FULL" \
    --color "$color" \
    --description "$description" \
    --force >/dev/null
}

project_number_by_title() {
  gh project list --owner "$OWNER" --limit 100 --format json --jq '.projects[] | [.number,.title] | @tsv' |
    awk -F '	' -v title="$PROJECT_TITLE" '$2 == title { print $1; exit }'
}

field_exists() {
  project_number=$1
  field_name=$2

  gh project field-list "$project_number" --owner "$OWNER" --format json --jq '.fields[] | .name' |
    grep -Fx "$field_name" >/dev/null 2>&1
}

create_single_select_field() {
  project_number=$1
  field_name=$2
  options=$3

  if field_exists "$project_number" "$field_name"; then
    printf 'Project field exists: %s\n' "$field_name"
    return
  fi

  gh project field-create "$project_number" \
    --owner "$OWNER" \
    --name "$field_name" \
    --data-type SINGLE_SELECT \
    --single-select-options "$options" >/dev/null

  printf 'Created Project field: %s\n' "$field_name"
}

update_status_field() {
  project_number=$1

  status_field_id=$(gh project field-list "$project_number" --owner "$OWNER" --format json --jq '.fields[] | select(.name == "Status") | .id')
  if [ -z "$status_field_id" ]; then
    printf 'Status field not found in Project #%s\n' "$project_number" >&2
    exit 1
  fi

  gh api graphql \
    -f query='mutation($fieldId: ID!, $singleSelectOptions: [ProjectV2SingleSelectFieldOptionInput!]) { updateProjectV2Field(input: { fieldId: $fieldId, singleSelectOptions: $singleSelectOptions }) { projectV2Field { ... on ProjectV2SingleSelectField { name options { name } } } } }' \
    -F fieldId="$status_field_id" \
    -F 'singleSelectOptions[][name]=Backlog' \
    -F 'singleSelectOptions[][color]=GRAY' \
    -F 'singleSelectOptions[][description]=Captured, not ready' \
    -F 'singleSelectOptions[][name]=Ready' \
    -F 'singleSelectOptions[][color]=BLUE' \
    -F 'singleSelectOptions[][description]=Ready for implementation' \
    -F 'singleSelectOptions[][name]=In Progress' \
    -F 'singleSelectOptions[][color]=YELLOW' \
    -F 'singleSelectOptions[][description]=Currently being worked' \
    -F 'singleSelectOptions[][name]=Review' \
    -F 'singleSelectOptions[][color]=PURPLE' \
    -F 'singleSelectOptions[][description]=Awaiting review' \
    -F 'singleSelectOptions[][name]=Done' \
    -F 'singleSelectOptions[][color]=GREEN' \
    -F 'singleSelectOptions[][description]=Complete' >/dev/null

  printf 'Updated Project Status options.\n'
}

require_gh

create_label type:rfc 5319E7 "RFC and decision exploration"
create_label type:adr 5319E7 "Architecture Decision Record"
create_label type:feature 1D76DB "Feature or product change"
create_label type:bug D73A4A "Defect or incorrect behavior"
create_label type:docs 0075CA "Documentation change"
create_label type:chore C5DEF5 "Repository maintenance"

create_label area:architecture 0E8A16 "Architecture and product structure"
create_label area:workflow 0E8A16 "Canonical workflow source"
create_label area:compiler 0E8A16 "Compiler contracts and mapping"
create_label area:codex-harness 0E8A16 "Codex harness distribution"
create_label area:governance 0E8A16 "Project governance and process"
create_label area:validation 0E8A16 "Validation scripts and checks"
create_label area:docs 0E8A16 "Documentation area"

create_label priority:p0 B60205 "Immediate blocking priority"
create_label priority:p1 D93F0B "High priority"
create_label priority:p2 FBCA04 "Normal priority"
create_label priority:p3 FEF0B3 "Low priority"

create_label status:blocked B60205 "Blocked by an external dependency or decision"
create_label status:needs-decision FBCA04 "Needs maintainer decision"
create_label status:ready 0E8A16 "Ready for implementation"

create_label target:0.0.0 0052CC "WorkflowSmith 0.0.0 foundation milestone"

project_number=$(project_number_by_title || true)
if [ -z "$project_number" ]; then
  project_number=$(gh project create --owner "$OWNER" --title "$PROJECT_TITLE" --format json --jq '.number')
  printf 'Created Project: %s (#%s)\n' "$PROJECT_TITLE" "$project_number"
else
  printf 'Project exists: %s (#%s)\n' "$PROJECT_TITLE" "$project_number"
fi

gh project edit "$project_number" \
  --owner "$OWNER" \
  --description "WorkflowSmith 0.0.0 clean foundation milestone" \
  --visibility PRIVATE >/dev/null

gh project link "$project_number" --owner "$OWNER" --repo "$REPO_NAME" >/dev/null || true

update_status_field "$project_number"

create_single_select_field "$project_number" "Work Type" "RFC,ADR,Feature,Bug,Docs,Chore"
create_single_select_field "$project_number" Area "Architecture,Workflow,Compiler,Codex Harness,Governance,Validation,Docs"
create_single_select_field "$project_number" Priority "P0,P1,P2,P3"
create_single_select_field "$project_number" Target "0.0.0"

printf '\nManual Project UI step still required:\n'
printf '1. Open the %s Project.\n' "$PROJECT_TITLE"
printf '2. Create Project views manually; GitHub CLI/API does not support view creation.\n'
printf '   - Board: board layout grouped by Status\n'
printf '   - Roadmap: grouped by Target\n'
printf '   - Architecture: filter Area = Architecture or Work Type = ADR\n'
printf '   - Codex Harness: filter Area = Codex Harness\n'
printf '   - Blocked: filter label status:blocked\n'
