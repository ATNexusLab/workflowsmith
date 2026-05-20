#!/usr/bin/env bash
# sessionEnd hook — removes stale copilot-* worktrees after a session closes.
#
# Safety conditions before removal:
#   1. Never removes the main (primary) worktree
#   2. Skips worktrees with uncommitted changes (git status --porcelain non-empty)
#   3. Skips locked worktrees (.git/worktrees/<name>/locked file present)
#   4. Only targets worktrees whose basename starts with "copilot-"
#
# JSON parsing: jq primary, python3 fallback.
# All errors are silently swallowed — this is best-effort cleanup, not a gate.
# Exit 0 always.

INPUT=$(cat)

# ── JSON field extractor ──────────────────────────────────────────────────────
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

CWD=$(_json_get "$INPUT" ".cwd" ".")

# Resolve git root from the session cwd
GIT_ROOT=$(git -C "$CWD" rev-parse --show-toplevel 2>/dev/null)
if [[ -z "$GIT_ROOT" ]]; then
  echo '{}'
  exit 0
fi

# The first entry in --porcelain output is always the main worktree
MAIN_WORKTREE=$(git -C "$GIT_ROOT" worktree list --porcelain 2>/dev/null \
  | awk '/^worktree /{print $2; exit}')

# Iterate every worktree path
while IFS= read -r WT_PATH; do
  [[ -z "$WT_PATH" ]] && continue

  # Skip the main worktree
  [[ "$WT_PATH" == "$MAIN_WORKTREE" ]] && continue

  # Only process copilot-* worktrees
  WT_BASE=$(basename "$WT_PATH")
  [[ "$WT_BASE" != copilot-* ]] && continue

  # Skip if the directory no longer exists (already pruned)
  [[ ! -d "$WT_PATH" ]] && continue

  # Skip locked worktrees
  LOCK_FILE="$GIT_ROOT/.git/worktrees/$WT_BASE/locked"
  [[ -f "$LOCK_FILE" ]] && continue

  # Skip if there are uncommitted changes
  DIRTY=$(git -C "$WT_PATH" status --porcelain 2>/dev/null)
  [[ -n "$DIRTY" ]] && continue

  # All checks passed — safe to remove
  git -C "$GIT_ROOT" worktree remove --force "$WT_PATH" 2>/dev/null || true

done < <(git -C "$GIT_ROOT" worktree list --porcelain 2>/dev/null \
  | awk '/^worktree /{print $2}')

# Prune stale administrative files regardless
git -C "$GIT_ROOT" worktree prune 2>/dev/null || true

echo '{}'
exit 0
