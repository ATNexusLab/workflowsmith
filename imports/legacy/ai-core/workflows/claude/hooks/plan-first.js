#!/usr/bin/env node
// UserPromptSubmit hook — injects mandatory planning protocol as additionalContext.
// Runs on every prompt so the model cannot skip @principal delegation on non-trivial tasks.

const chunks = [];
process.stdin.on('data', (chunk) => chunks.push(chunk));
process.stdin.on('end', () => {
  const additionalContext = `
MANDATORY PLANNING PROTOCOL — applies to every non-trivial task (multi-file change, new feature, bug investigation, architectural work, configuration change, anything spanning more than one file or requiring a decision).

STEP 1 — GitHub Issue (FIRST):
Create a GitHub issue in the current repo BEFORE any planning or implementation begins.
  - Title: the task name
  - Body: short scope summary (what changes, what doesn't)
  - Use: gh issue create --title "..." --body "..."

STEP 2 — @principal Plan (BEFORE implementation):
Invoke @principal to write the execution plan. The plan MUST:
  - Use all applicable skills from ~/.claude/skills/ and any repo-local skills/
  - Assign each sub-task to the responsible agent (@engine or @creative)
  - List the skills each sub-task requires (so they can be passed to the sub-agent)
  - Be written by @principal and saved to the session plan file

STEP 3 — Execute:
Only after the issue is open and the plan is written, delegate implementation to the appropriate agents.

Skip steps 1–2 ONLY for: pure conversation, quick lookups, single-file changes ≤ 3 lines, diagnostics.
`.trim();

  const output = {
    hookSpecificOutput: {
      hookEventName: 'UserPromptSubmit',
      additionalContext,
    },
  };

  process.stdout.write(JSON.stringify(output));
});
