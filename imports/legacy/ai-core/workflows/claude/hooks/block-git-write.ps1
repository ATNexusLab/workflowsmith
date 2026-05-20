# block-git-write.ps1
# PreToolUse hook — hard-blocks git commit, push, and tag.
# Claude must show the full diff and wait for explicit user approval before retrying.

$decision = @{
    hookSpecificOutput = @{
        hookEventName          = "PreToolUse"
        permissionDecision     = "deny"
        permissionDecisionReason = "Git write operation blocked by hook. Before committing or pushing: (1) run 'git diff --staged' or 'git status' to collect the full diff, (2) present it clearly to the user, (3) wait for the user's explicit approval. Then retry the command."
    }
} | ConvertTo-Json -Compress

Write-Output $decision
