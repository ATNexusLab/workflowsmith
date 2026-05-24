#!/bin/sh
set -eu

cd "$(dirname "$0")/.."

missing=0

while IFS= read -r file; do
  [ -z "$file" ] && continue
  if [ ! -s "$file" ]; then
    printf 'missing or empty: %s\n' "$file" >&2
    missing=1
  fi
done <<'REQUIRED_FILES'
README.md
CHANGELOG.md
workflowsmith.yml
docs/architecture.md
docs/development-process.md
docs/roadmap.md
docs/governance/github.md
docs/decisions/README.md
docs/decisions/adr-0001-refoundation.md
docs/decisions/adr-0002-source-compiler-distribution.md
docs/decisions/adr-0003-github-governance.md
docs/decisions/adr-0004-canonical-harness-resource-model.md
docs/decisions/adr-0005-instructions-agents-skills.md
workflow/README.md
workflow/source/README.md
workflow/source/harness-resources.md
workflow/source/instruction-agent-skill-model.md
workflow/source/automation-policy.md
workflow/source/authoring-modularity.md
workflow/schema/workflow-unit.md
compiler/README.md
compiler/contracts/harness-target.md
dist/README.md
dist/codex/README.md
.github/ISSUE_TEMPLATE/config.yml
.github/ISSUE_TEMPLATE/rfc.yml
.github/ISSUE_TEMPLATE/adr.yml
.github/ISSUE_TEMPLATE/workflow-change.yml
.github/ISSUE_TEMPLATE/bug.yml
.github/pull_request_template.md
scripts/validate.sh
scripts/setup-github-governance.sh
REQUIRED_FILES

while IFS= read -r dir; do
  [ -z "$dir" ] && continue
  if [ ! -d "$dir" ]; then
    printf 'missing directory: %s\n' "$dir" >&2
    missing=1
  fi
done <<'REQUIRED_DIRS'
workflow
workflow/source
workflow/schema
compiler
compiler/contracts
dist
dist/codex
docs
docs/decisions
docs/governance
.github
.github/ISSUE_TEMPLATE
REQUIRED_DIRS

while IFS= read -r path; do
  [ -z "$path" ] && continue
  if [ -e "$path" ]; then
    printf 'removed foundation artifact still exists: %s\n' "$path" >&2
    missing=1
  fi
done <<'REMOVED_PATHS'
imports
core
agents
skills
memory
checklists
build
ROADMAP.md
docs/ai-core-source-of-truth.md
docs/audit-2026-05-20.md
docs/specs
REMOVED_PATHS

stale_import_path='imports''/legacy'
stale_import_first='import ''first'
stale_normalize_second='normalize ''second'
stale_promote_last='promote ''last'
stale_ai_core='ai''-core'

for pattern in "$stale_import_path" "$stale_import_first" "$stale_normalize_second" "$stale_promote_last" "$stale_ai_core"; do
  : > /tmp/workflowsmith-validate-grep.txt
  find . \( -path ./.git -o -path ./scripts/validate.sh \) -prune -o -type f \
    -exec grep -n -i -- "$pattern" {} \; >>/tmp/workflowsmith-validate-grep.txt 2>/dev/null || true

  if [ -s /tmp/workflowsmith-validate-grep.txt ]; then
    printf 'stale foundation concept found: %s\n' "$pattern" >&2
    cat /tmp/workflowsmith-validate-grep.txt >&2
    missing=1
  fi
done

for file in workflow/source/*.md; do
  [ -f "$file" ] || continue

  kind=$(sed -n 's/^- kind: `\([^`]*\)`.*/\1/p' "$file" | sed -n '1p')
  [ -n "$kind" ] || continue

  limit=200
  if [ "$kind" = "checklist" ]; then
    limit=120
  fi

  line_count=$(wc -l <"$file" | tr -d ' ')
  if [ "$line_count" -gt "$limit" ] && ! grep -q 'size-budget-exception:' "$file"; then
    printf 'canonical source unit exceeds size budget: %s (%s lines, limit %s)\n' "$file" "$line_count" "$limit" >&2
    missing=1
  fi
done

rm -f /tmp/workflowsmith-validate-grep.txt

if [ "$missing" -ne 0 ]; then
  exit 1
fi

printf 'WorkflowSmith 0.0.0 foundation structure is valid.\n'
