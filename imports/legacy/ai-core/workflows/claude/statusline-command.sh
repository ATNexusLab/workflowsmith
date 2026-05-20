#!/usr/bin/env bash
# Claude Code statusLine command — mirrors Powerlevel10k lean prompt segments
# Segments: dir | git branch+status | model | context usage

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# --- dir segment ---
if [ -n "$cwd" ]; then
  home_dir="$HOME"
  dir_display="${cwd/#$home_dir/~}"
else
  dir_display="~"
fi

# --- git segment (skip optional locks) ---
git_part=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.hooksPath=/dev/null symbolic-ref --short HEAD 2>/dev/null \
           || git -C "$cwd" -c core.hooksPath=/dev/null rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    # check for dirty state
    if ! git -C "$cwd" -c core.hooksPath=/dev/null diff --quiet 2>/dev/null \
       || ! git -C "$cwd" -c core.hooksPath=/dev/null diff --cached --quiet 2>/dev/null; then
      git_part=" $branch*"
    else
      git_part=" $branch"
    fi
  fi
fi

# --- context segment ---
ctx_part=""
if [ -n "$used_pct" ]; then
  printf -v ctx_int "%.0f" "$used_pct"
  ctx_part=" ctx:${ctx_int}%"
fi

# --- model segment ---
model_part=""
if [ -n "$model" ]; then
  model_part=" $model"
fi

printf "%s%s%s%s\n" "$dir_display" "$git_part" "$model_part" "$ctx_part"
