#!/usr/bin/env bash
# sessionStart hook — injects the Mandatory Planning Protocol as additionalContext.
# Copilot CLI delivers a JSON payload on stdin; this script outputs JSON to stdout.
# Exit 0 always; non-zero exits are fail-open for sessionStart.

INPUT=$(cat)   # consume stdin (required by protocol; payload unused here)

CONTEXT='MANDATORY PLANNING PROTOCOL — applies to every non-trivial task (multi-file change, new feature, bug investigation, architectural work, configuration change).

STEP 1 — GitHub Issue (FIRST):
Create a GitHub issue in the current repo BEFORE any planning or implementation begins.
  - Title: the task name
  - Body: short scope summary
  - Use: gh issue create --title "..." --body "..."

STEP 2 — @principal Plan (BEFORE implementation):
Invoke @principal to write the execution plan. The plan MUST:
  - Use all applicable skills from ~/.copilot/skills/ and any repo-local skills/
  - Assign each sub-task to the responsible agent (@engine or @creative)
  - List the skills each sub-task requires
  - Be saved to the session plan file

STEP 3 — Execute:
Only after the issue is open and the plan is written, delegate implementation to the appropriate agents.

Skip steps 1-2 ONLY for: pure conversation, quick lookups, single-file changes <= 3 lines, diagnostics.'

if command -v jq >/dev/null 2>&1; then
  jq -n --arg ctx "$CONTEXT" '{"additionalContext": $ctx}'
elif command -v python3 >/dev/null 2>&1; then
  python3 -c "import json, sys; print(json.dumps({'additionalContext': sys.argv[1]}))" "$CONTEXT"
else
  # Last-resort fallback: emit empty output (fail-open — context simply not injected)
  echo '{}'
fi

exit 0
