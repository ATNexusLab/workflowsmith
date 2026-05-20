#!/usr/bin/env bash
# preToolUse hook — blocks git commit, git push, and git tag without user review.
#
# Copilot CLI delivers the tool invocation as JSON on stdin.
# Blocking is achieved by outputting {"permissionDecision":"deny",...} to stdout
# with exit 0.  Non-zero exits are fail-OPEN, not fail-closed.
#
# JSON parsing: jq primary, python3 fallback. If neither is available, fail-open.
# Matcher in git-write-policy.json: bash|powershell

INPUT=$(cat)

# ── JSON field extractor ──────────────────────────────────────────────────────
# Usage: _json_get <json> <dotted.path> [default]
_json_get() {
  local json="$1" path="$2" default="${3:-}"
  if command -v jq >/dev/null 2>&1; then
    echo "$json" | jq -r --arg d "$default" "($path) // \$d" 2>/dev/null || echo "$default"
  elif command -v python3 >/dev/null 2>&1; then
    echo "$json" | python3 -c "
import json, sys, re
try:
    d = json.load(sys.stdin)
    keys = [k for k in re.sub(r'^\.', '', sys.argv[1]).split('.') if k]
    v = d
    for k in keys:
        v = v.get(k) if isinstance(v, dict) else None
    print(v if v is not None else sys.argv[2])
except Exception:
    print(sys.argv[2])
" "$path" "$default"
  else
    echo "$default"
  fi
}

# ── JSON deny output ──────────────────────────────────────────────────────────
_deny() {
  local reason="$1"
  if command -v jq >/dev/null 2>&1; then
    jq -n --arg r "$reason" '{"permissionDecision":"deny","permissionDecisionReason":$r}'
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c "import json,sys; print(json.dumps({'permissionDecision':'deny','permissionDecisionReason':sys.argv[1]}))" "$reason"
  else
    printf '{"permissionDecision":"deny","permissionDecisionReason":"%s"}\n' \
      "$(printf '%s' "$reason" | sed 's/\\/\\\\/g; s/"/\\"/g')"
  fi
  exit 0
}

CMD=$(_json_get "$INPUT" ".toolArgs.command" "")

# Normalise: collapse multiple spaces, lowercase
CMD_NORM=$(echo "$CMD" | tr '[:upper:]' '[:lower:]' | tr -s ' ')

DENY_MSG='Git write blocked. Before committing or pushing: (1) run '"'"'git diff --staged'"'"' or '"'"'git status'"'"', (2) present the diff to the user, (3) wait for explicit user approval. Then retry.'

# ── git commit ───────────────────────────────────────────────────────────────
if echo "$CMD_NORM" | grep -qE '(^|;|&&|\|\||[|&([[:space:]])[[:space:]]*git[[:space:]]+commit([[:space:]]|--|$)'; then
  _deny "$DENY_MSG"
fi

# ── git push (including --force / -f / --tags) ───────────────────────────────
if echo "$CMD_NORM" | grep -qE '(^|;|&&|\|\||[|&([[:space:]])[[:space:]]*git[[:space:]]+push([[:space:]]|$)'; then
  _deny "$DENY_MSG"
fi

# ── git tag ───────────────────────────────────────────────────────────────────
if echo "$CMD_NORM" | grep -qE '(^|;|&&|\|\||[|&([[:space:]])[[:space:]]*git[[:space:]]+tag([[:space:]]|-|$)'; then
  _deny "$DENY_MSG"
fi

# No match — allow
echo '{}'
exit 0
