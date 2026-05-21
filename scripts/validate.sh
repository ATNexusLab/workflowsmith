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
docs/ai-core-source-of-truth.md
docs/architecture.md
docs/decisions/README.md
docs/decisions/ADR-001-canonical-schema.md
docs/decisions/ADR-002-build-system-model.md
docs/decisions/ADR-003-content-lifecycle.md
docs/decisions/ADR-004-legacy-treatment.md
docs/decisions/ADR-005-versioning-strategy.md
CHANGELOG.md
core/routing-policy.md
core/output-contracts.md
memory/index.md
agents/principal.md
skills/review/review-code.md
checklists/final-answer.md
scripts/validate.sh
build/README.md
build/schema/README.md
build/schema/VERSION
build/schema/workflow-unit.template.md
build/adapters/README.md
agents/README.md
skills/README.md
memory/README.md
checklists/README.md
imports/README.md
imports/legacy/ai-core/MANIFEST.md
imports/legacy/ai-core/workflows/claude/CLAUDE.md
imports/legacy/ai-core/workflows/copilot/copilot-instructions.md
imports/legacy/ai-core/workflows/copilot/.github/copilot-instructions.md
imports/legacy/ai-core/workflows/antigravity-cli/GEMINI.md
REQUIRED_FILES

while IFS= read -r dir; do
  [ -z "$dir" ] && continue
  if [ ! -d "$dir" ]; then
    printf 'missing directory: %s\n' "$dir" >&2
    missing=1
  fi
done <<'REQUIRED_DIRS'
imports/legacy/ai-core/workflows/claude
imports/legacy/ai-core/workflows/copilot
imports/legacy/ai-core/workflows/antigravity-cli
REQUIRED_DIRS

if [ "$missing" -ne 0 ]; then
  exit 1
fi

printf 'WorkflowSmith Phase 1 structure and legacy import markers are present.\n'
