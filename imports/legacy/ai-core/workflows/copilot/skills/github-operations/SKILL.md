---
name: github-operations
description: "Use to operate GitHub through the CLI or API: create issues and PRs, manage branches, labels, and milestones, publish releases, and inspect workflows."
user-invocable: true
disable-model-invocation: false
triggers:
  - "create, merge, or manage GitHub issues, pull requests, or releases"
  - "manage branches, labels, milestones, or tags"
  - "inspect, dispatch, or rerun GitHub Actions workflows"
license: MIT
---

# GitHub Operations

## When to Use

- Create or manage issues and pull requests
- Create releases and tags
- Manage branches, labels, and milestones
- Check workflow and CI status
- Automate repeatable GitHub operations

## Approval Gate (Critical)

Treat GitHub operations as state changes, not just information lookups.

- If the user explicitly requested a specific create or update action, that request authorizes that exact action.
- **Destructive or irreversible actions require explicit approval before execution.** This includes merging a PR, deleting a remote branch or tag, publishing or editing a release, closing an issue or PR as a decision rather than clerical cleanup, changing branch protection or default-branch settings, force-pushing, and dispatching or rerunning workflows with production impact.
- When approval is missing, gather context, prepare the exact command, and stop short of execution.

## Common Operations

### Issues
```bash
# Create an issue
gh issue create --title "Title" --body "Description" --label "bug"

# List issues
gh issue list --state open --label "bug"

# Close an issue (requires explicit approval if not already requested)
gh issue close <number>
```

### Pull Requests
```bash
# Create a PR
gh pr create \
  --title "feat: describe change" \
  --body "## What changes
..." \
  --base main

# Check status
gh pr checks <number>

# Approve a PR
gh pr review <number> --approve

# Merge a PR (explicit approval required)
gh pr merge <number> --squash --delete-branch
```

### Releases
```bash
# Create a release with a tag (explicit approval required)
gh release create v1.2.3 \
  --title "Release 1.2.3" \
  --notes "## Changelog
..."

# List releases
gh release list
```

### Branches
```bash
# Create and switch to a branch
git switch -c feat/descriptive-name

# List remote branches
git branch -r

# Delete a remote branch after merge (explicit approval required)
git push origin --delete feat/descriptive-name
```

### Workflows (GitHub Actions)
```bash
# List workflow runs
gh run list --workflow ci.yml

# View logs for a run
gh run view <run-id> --log

# Re-run a failed workflow (explicit approval required if it can affect production or external systems)
gh run rerun <run-id>
```

## Naming Conventions

### Branches
```
feat/descriptive-name
fix/bug-name
chore/task-name
docs/doc-name
```

### Commits (Conventional Commits)
```
feat: add JWT authentication
fix: correct discount calculation for out-of-stock products
chore: update security dependencies
docs: add API usage examples
```

### Issue Labels
```
bug         — incorrect behavior
enhancement — improvement to an existing feature
feature     — new functionality
chore       — maintenance, dependencies
security    — vulnerability or hardening work
docs        — documentation
```

## Pre-PR Checklist

- [ ] Current branch is up to date with the base branch (`main`, `develop`, etc.)
- [ ] Commits use descriptive messages (Conventional Commits)
- [ ] Relevant local checks have passed
- [ ] PR description explains what changed, why, and how to test it
- [ ] Related issue is linked (`Closes #123`)
- [ ] No debug commits, stray logging, or temporary files remain

## Steps

### 1. Authenticate with GitHub CLI

```bash
gh auth login
gh auth status
```

### 2. Identify the required operation

Use `## Common Operations` to choose the exact command:
- Issues: `gh issue create/list/view/close`
- PRs: `gh pr create/list/review/merge`
- Releases: `gh release create`
- Workflows: `gh workflow run/list/view`, `gh run list/view/rerun`

### 3. Inspect repository context first

Before mutating state, verify the target repository, branch, labels, milestone names, and current PR or issue state. Do not assume default branch names, existing labels, or release conventions.

### 4. Enforce the approval gate

If the action is destructive or irreversible, confirm that explicit approval already exists. If not, prepare the command and wait rather than executing it.

### 5. Execute with repository conventions

Follow the repository's naming rules for branches, labels, titles, and release notes. Use Conventional Commits when the repository expects them.

### 6. Capture the outcome

Record the resulting URL, number, run ID, or release tag so the requester can verify what changed.

## Never Do

- Never merge, delete, publish, force-push, or change protected settings without explicit approval
- Never assume the default branch, labels, milestones, or merge strategy
- Never use force flags unless they are explicitly approved and justified
- Never hide a state-changing command inside a read-only investigation step

## Examples

### Create an issue from a reusable template

```bash
gh issue create \
  --title "bug: login button does not respond in Safari" \
  --body "## Description
The login button does not trigger submit in Safari 17.

## Reproduction
1. Open the app in Safari
2. Fill in valid credentials
3. Click Sign in

## Expected behavior
The user is authenticated.

## Current behavior
Nothing happens." \
  --label "bug,priority:high" \
  --assignee "my-user"
```

### Full PR workflow

```bash
# Create a branch
git switch -c feat/jwt-authentication

# Work, then commit
git commit -m "feat: implement JWT authentication with refresh tokens"

# Push and open a draft PR
gh pr create --fill --draft

# Mark ready for review
gh pr ready

# Merge only after explicit approval
gh pr merge --squash --delete-branch
```
