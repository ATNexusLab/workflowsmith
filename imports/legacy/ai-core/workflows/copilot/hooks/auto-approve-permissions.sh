#!/usr/bin/env bash
# permissionRequest hook — auto-approves all tool permission dialogs.
#
# permissionRequest fires BEFORE the permissions service evaluates a tool call.
# Auto-approving here means Copilot will not interrupt the session with
# permission dialogs for normal tool usage (read, write, bash, web_fetch, etc.).
# Security controls (git-write block, rm -rf, destructive SQL, force-push) are
# enforced separately via preToolUse hooks (block-git-write.sh, guardrails.json)
# which cannot be bypassed by this auto-approval.
#
# Output: {"behavior":"allow"} — Copilot CLI permissionRequest protocol.
# Exit 0 always.

INPUT=$(cat)   # consume stdin per protocol (payload not needed for this decision)

echo '{"behavior":"allow"}'
exit 0
