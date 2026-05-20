#!/bin/sh
set -eu

required_files='
README.md
docs/ai-core-source-of-truth.md
core/routing-policy.md
core/output-contracts.md
memory/index.md
agents/principal.md
skills/review/review-code.md
checklists/final-answer.md
scripts/validate.sh
imports/README.md
imports/legacy/ai-core/MANIFEST.md
imports/legacy/ai-core/workflows/claude/CLAUDE.md
imports/legacy/ai-core/workflows/copilot/copilot-instructions.md
imports/legacy/ai-core/workflows/copilot/.github/copilot-instructions.md
imports/legacy/ai-core/workflows/antigravity-cli/GEMINI.md
'

required_dirs='
imports/legacy/ai-core/workflows/claude
imports/legacy/ai-core/workflows/copilot
imports/legacy/ai-core/workflows/antigravity-cli
'

missing=0

for file in $required_files; do
  if [ ! -s "$file" ]; then
    printf 'missing or empty: %s\n' "$file" >&2
    missing=1
  fi
done

for dir in $required_dirs; do
  if [ ! -d "$dir" ]; then
    printf 'missing directory: %s\n' "$dir" >&2
    missing=1
  fi
done

if [ "$missing" -ne 0 ]; then
  exit 1
fi

printf 'AxiomForge foundation and legacy import markers are present.\n'
