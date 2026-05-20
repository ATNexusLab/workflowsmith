---
name: github-operations
description: Use to operate GitHub through the CLI or API: create issues and PRs, manage branches, labels, and milestones, publish releases, and inspect workflows.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
---

# GitHub Operations

## When to Use

- Create, review, or merge pull requests
- Manage issues: create, assign, label, close, link
- Publish a release or manage tags
- Inspect CI/CD workflow status and logs
- Set up or manage labels, milestones, and branch protection
- Automate repository operations from the CLI

## Prerequisites

```bash
# Verify gh CLI is authenticated
gh auth status

# Verify current repository context
gh repo view --json name,defaultBranch,url
```

## Issue Management

### Create an Issue

```bash
gh issue create   --title "Short, imperative title"   --body "## Context

What is happening and why it matters.

## Steps to reproduce

1. 
2. 

## Expected behavior

## Actual behavior"   --label "bug,priority:high"   --assignee "@me"   --milestone "v1.2"
```

### List and Filter Issues

```bash
# Open issues assigned to me
gh issue list --assignee "@me" --state open

# Issues with specific labels
gh issue list --label "bug" --label "priority:high"

# Search issues
gh issue list --search "memory leak in text:"

# JSON output for scripting
gh issue list --json number,title,labels,assignees --limit 50
```

### Close and Link Issues

```bash
# Close with comment
gh issue close 42 --comment "Fixed in PR #58"

# View a specific issue
gh issue view 42

# Add a comment
gh issue comment 42 --body "Confirmed on staging. Monitoring for recurrence."
```

## Pull Request Management

### Create a Pull Request

```bash
gh pr create   --title "feat: add order cancellation endpoint"   --body "## Summary

Adds POST /orders/{id}/cancel.

## Changes

- New endpoint
- Service method
- Unit tests

## Testing

- [ ] Unit tests pass
- [ ] Manual test on staging

Closes #42"   --base main   --head feat/order-cancellation   --reviewer "teammate1,teammate2"   --label "feature,ready-for-review"
```

### Review and Merge

```bash
# List open PRs
gh pr list --state open

# View a PR with diff
gh pr view 58 --web

# Check PR status (CI, reviews)
gh pr status

# Check out PR branch locally
gh pr checkout 58

# Approve a PR
gh pr review 58 --approve --body "LGTM. Verified on staging."

# Request changes
gh pr review 58 --request-changes --body "See inline comments."

# Merge strategies
gh pr merge 58 --squash --delete-branch
gh pr merge 58 --merge --delete-branch
gh pr merge 58 --rebase --delete-branch
```

### PR Merge Strategy Guide

| Strategy | When to use |
|---|---|
| `--squash` | Feature branches; keeps main history linear and clean |
| `--merge` | Preserving branch history is important (integration branches) |
| `--rebase` | Linear history; individual commits have independent value |

### Draft PRs

```bash
# Create as draft
gh pr create --draft --title "WIP: refactor auth middleware"

# Mark ready for review
gh pr ready 58
```

## Branch Management

### Branching Conventions

```
main            — production-ready, protected
develop         — integration branch (if using gitflow)
feat/{name}     — new features
fix/{name}      — bug fixes
chore/{name}    — maintenance, deps, tooling
docs/{name}     — documentation changes
release/{v}     — release preparation
hotfix/{v}      — emergency production fix
```

### Common Branch Operations

```bash
# Create and switch to branch
git checkout -b feat/order-cancellation

# Push branch and set upstream
git push -u origin feat/order-cancellation

# Delete local and remote branch after merge
git branch -d feat/order-cancellation
git push origin --delete feat/order-cancellation

# Or let gh do it on merge
gh pr merge 58 --squash --delete-branch
```

### Branch Protection (via gh CLI)

```bash
# View current branch protection
gh api repos/{owner}/{repo}/branches/main/protection

# Set branch protection rules (requires admin)
gh api repos/{owner}/{repo}/branches/main/protection   --method PUT   --field required_status_checks='{"strict":true,"contexts":["ci/lint","ci/test"]}'   --field enforce_admins=true   --field required_pull_request_reviews='{"required_approving_review_count":1}'
```

## Label Management

### Create a Consistent Label Set

```bash
# Bug and issue type labels
gh label create "bug" --color "d73a4a" --description "Something is not working"
gh label create "feature" --color "0075ca" --description "New feature or enhancement"
gh label create "chore" --color "e4e669" --description "Maintenance, refactor, or tooling"
gh label create "docs" --color "0075ca" --description "Documentation changes"
gh label create "security" --color "e11d48" --description "Security-related issue or fix"

# Priority labels
gh label create "priority:critical" --color "b91c1c" --description "Must fix before next release"
gh label create "priority:high"     --color "ef4444" --description "Important, fix soon"
gh label create "priority:medium"   --color "f97316" --description "Normal priority"
gh label create "priority:low"      --color "84cc16" --description "Nice to have"

# Status labels
gh label create "needs-triage"      --color "6b7280" --description "Awaiting initial review"
gh label create "ready-for-review"  --color "22c55e" --description "PR ready for review"
gh label create "in-progress"       --color "3b82f6" --description "Actively being worked on"
gh label create "blocked"           --color "7c3aed" --description "Blocked by a dependency"
```

### List and Delete Labels

```bash
gh label list
gh label delete "wontfix"
```

## Milestone Management

```bash
# Create a milestone with due date
gh api repos/{owner}/{repo}/milestones   --method POST   --field title="v1.2.0"   --field description="Order management improvements"   --field due_on="2024-03-01T00:00:00Z"

# List milestones
gh api repos/{owner}/{repo}/milestones

# Assign issue to milestone
gh issue edit 42 --milestone "v1.2.0"
```

## Release Management

### Create a Release

```bash
# Tag the commit first
git tag -a v1.2.0 -m "Release v1.2.0"
git push origin v1.2.0

# Create release with auto-generated notes
gh release create v1.2.0   --title "v1.2.0 — Order Management"   --generate-notes   --latest

# Create release with manual notes
gh release create v1.2.0   --title "v1.2.0 — Order Management"   --notes "## What'''s new

- Order cancellation endpoint
- Refunded status tracking

## Bug fixes

- Fixed race condition in payment processing"   --latest

# Draft release (review before publishing)
gh release create v1.2.0 --draft --title "v1.2.0"

# Publish a draft
gh release edit v1.2.0 --draft=false
```

### Upload Release Assets

```bash
gh release upload v1.2.0 dist/app-linux-amd64 dist/app-darwin-amd64
```

### List and Delete Releases

```bash
gh release list
gh release delete v1.1.0 --yes
```

## Workflow and CI Inspection

```bash
# List workflows
gh workflow list

# View recent workflow runs
gh run list --workflow="CI" --limit 10

# View a specific run
gh run view 1234567890

# Watch a run in progress
gh run watch 1234567890

# Re-run failed jobs
gh run rerun 1234567890 --failed-only

# Download artifacts from a run
gh run download 1234567890

# View workflow logs
gh run view 1234567890 --log
gh run view 1234567890 --log-failed
```

## Repository Inspection

```bash
# View repository metadata
gh repo view --json name,description,defaultBranch,isPrivate,stargazerCount

# List collaborators
gh api repos/{owner}/{repo}/collaborators

# View open PRs with CI status
gh pr list --json number,title,statusCheckRollup --jq '.[] | {pr: .number, title: .title, ci: .statusCheckRollup[].state}'

# Search across issues and PRs
gh search issues "auth error" --repo {owner}/{repo} --limit 20

# Repository traffic
gh api repos/{owner}/{repo}/traffic/views
```

## Scripting Patterns

### Batch Label Assignment

```bash
# Add a label to all open issues without triage label
gh issue list --state open --json number,labels   | jq '.[] | select(.labels | map(.name) | contains(["needs-triage"]) | not) | .number'   | xargs -I {} gh issue edit {} --add-label "needs-triage"
```

### Close Stale PRs

```bash
# List PRs with no activity in 30 days and close with comment
gh pr list --state open --json number,updatedAt   | jq --arg cutoff "$(date -d "30 days ago" --iso-8601)"     '.[] | select(.updatedAt < $cutoff) | .number'   | xargs -I {} gh pr close {} --comment "Closing due to inactivity. Reopen if still relevant."
```

### Create Issues from a File

```bash
while IFS='|' read -r title body labels; do
  gh issue create --title "$title" --body "$body" --label "$labels"
done < issues.txt
```

## Never Do

- Force-push to `main` or any protected branch
- Delete a branch that has an open PR
- Merge a PR with failing required status checks
- Create a release tag on an unreviewed commit
- Assign `priority:critical` without a linked issue and owner
- Close an issue without a resolution comment
- Use personal access tokens stored in plaintext in scripts — use `gh auth` instead
