---
name: technical-writing
description: Use to write clear technical documentation for humans: README, CONTRIBUTING, API docs, runbooks, onboarding guides, and changelogs.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
  - write_file
  - create_file
---

# Technical Writing

## When to Use

- Write or improve a README, CONTRIBUTING, or ARCHITECTURE document
- Create API documentation, runbooks, or onboarding guides
- Write a changelog or release notes
- Audit existing documentation for clarity, accuracy, or completeness
- Establish documentation conventions for a project

## Core Principles

1. **Write for the reader, not the author** — documentation is for someone who does not already know what you know
2. **State the most important thing first** — readers scan before they read
3. **Concrete over abstract** — examples and commands outperform descriptions of commands
4. **Accurate or silent** — outdated documentation is worse than no documentation; it actively misleads
5. **Every document has one job** — a README is not a tutorial, a runbook is not an API reference

## Document Types and Their Jobs

| Document | Primary reader | Primary job |
|---|---|---|
| README | Developer evaluating or getting started | Answer "What is this and how do I run it?" |
| CONTRIBUTING | Developer making a contribution | Explain how to contribute correctly |
| ARCHITECTURE | Developer making significant changes | Explain structural decisions and constraints |
| API Reference | Developer integrating with the API | Describe every endpoint, field, and behavior |
| Runbook | On-call engineer during an incident | Step-by-step resolution for a specific failure mode |
| Onboarding guide | New team member | Get from zero to productive without asking questions |
| Changelog | User upgrading to a new version | What changed and whether it affects me |
| Tutorial | Developer learning the product | Build something real and understand why it works |

## README Structure

```markdown
# Project Name

One sentence: what this is.

## What it does

Two to five sentences: the problem it solves and who it is for.

## Quick start

The shortest path from zero to running. Must work on a fresh machine.

\`\`\`bash
git clone https://github.com/org/repo
cd repo
cp .env.example .env
docker compose up
\`\`\`

Open http://localhost:3000

## Prerequisites

- Node.js 20+
- Docker and Docker Compose
- PostgreSQL 16 (or use Docker)

## Installation

Detailed setup for development. Do not repeat Quick Start — link to it.

## Configuration

Document every environment variable:

| Variable | Required | Default | Description |
|---|---|---|---|
| DATABASE_URL | Yes | — | PostgreSQL connection string |
| JWT_SECRET | Yes | — | Minimum 32-character random string |
| PORT | No | 3000 | HTTP server port |

## Development

How to run the dev server, run tests, and use the linter.

## Deployment

Production deployment instructions or link to the deployment runbook.

## Contributing

Link to CONTRIBUTING.md or brief contribution instructions.

## License

SPDX identifier and link.
```

**README rules:**
- The Quick Start must work — test it on a clean machine before publishing
- Do not document the obvious; document what is non-obvious or will trip people up
- Link out to deeper documents rather than embedding everything
- Keep it short enough that someone reads it instead of skipping it

## API Documentation

### Endpoint Documentation Template

```markdown
### POST /orders

Create a new order.

**Authentication:** Bearer token required

**Request Body**

| Field | Type | Required | Description |
|---|---|---|---|
| user_id | string (UUID) | Yes | ID of the user placing the order |
| items | array | Yes | One or more order items |
| items[].product_id | string (UUID) | Yes | ID of the product |
| items[].quantity | integer | Yes | Must be ≥ 1 |

**Example Request**

\`\`\`http
POST /api/v1/orders
Content-Type: application/json
Authorization: Bearer {token}

{
  "user_id": "usr_123",
  "items": [
    { "product_id": "prod_456", "quantity": 2 }
  ]
}
\`\`\`

**Response: 201 Created**

\`\`\`json
{
  "data": {
    "id": "ord_789",
    "status": "pending",
    "total_cents": 3000,
    "created_at": "2024-01-15T10:30:00Z"
  }
}
\`\`\`

**Error Responses**

| Code | Condition |
|---|---|
| 400 | Missing required field or invalid value |
| 401 | Missing or invalid authentication token |
| 404 | user_id or product_id not found |
| 422 | Insufficient inventory |
```

**API documentation rules:**
- Every parameter must document: type, whether it is required, and its constraints
- Every response code must be documented
- Examples must be real (they will be copy-pasted)
- Document the behavior on error, not only on success
- Keep in sync with the implementation — stale API docs cause support requests

## Runbook Structure

```markdown
# Runbook: {Failure Mode Title}

**Severity:** P1 / P2 / P3
**Service:** {service name}
**Alert:** {alert name that fires this runbook}
**On-call:** {team or rotation}

## Symptoms

What is observable when this failure is happening:
- Alert fires: {alert name}
- User impact: {what users see}
- Log signal: {relevant log query or pattern}

## Diagnosis

Steps to confirm this is the failure mode described in this runbook:

1. Check {thing}: `{command}`
   Expected: {what normal looks like}
   Abnormal: {what indicates this is the issue}

2. Verify {thing}: `{command or query}`

## Resolution

Steps to resolve. Each step must be independently actionable:

1. {Action}: `{command}`
2. Verify resolution: `{command}` — expected output: `{output}`
3. If unresolved after step 2, escalate to {team/person}

## Rollback

If resolution steps make the situation worse:

1. `{rollback command}`
2. Notify {team} via {channel}

## Post-Incident

- File an incident report in {system}
- Add to next incident review
- Consider: {longer-term fix or preventive measure}

## Related Runbooks

- {link to related runbook}
```

**Runbook rules:**
- Commands must be copy-pasteable — no pseudocode in a runbook
- Every branching point must specify which runbook to go to next
- Write for an engineer encountering this failure at 3am for the first time
- Test runbooks in staging before they are needed in production

## Changelog Format (Keep a Changelog)

```markdown
# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [1.2.0] — 2024-01-15

### Added
- Order cancellation endpoint: `POST /orders/{id}/cancel`
- Webhook notifications for order status changes

### Changed
- Order list now returns items sorted by `created_at DESC` by default

### Fixed
- Race condition in payment processing when two concurrent requests were made

### Security
- Upgraded `jsonwebtoken` to 9.0.2 (CVE-2022-23529)

## [1.1.0] — 2024-01-01

...
```

**Changelog rules:**
- Write for users and integrators, not for developers reading the git log
- Every breaking change is called out explicitly
- Security fixes include the CVE reference
- Unreleased changes accumulate under `[Unreleased]` and are promoted on release

## Writing Quality Checklist

**Clarity:**
- [ ] Every sentence has a clear subject and active verb
- [ ] Acronyms defined on first use
- [ ] No jargon without explanation
- [ ] Complex concepts have an example

**Completeness:**
- [ ] Prerequisites are listed and verified
- [ ] Every command in Quick Start / Installation sections has been tested
- [ ] Error paths and edge cases are documented, not only the happy path
- [ ] Configuration variables are fully documented

**Accuracy:**
- [ ] Output matches the current version of the software
- [ ] Links resolve
- [ ] No placeholder text left in (`TODO`, `FIXME`, `{replace this}`)

**Structure:**
- [ ] Most important information is first
- [ ] Headers create a scannable outline
- [ ] Long sections link to sub-documents rather than growing indefinitely

## Documentation Audit

```bash
# Find unfulfilled placeholder text
grep -rn "TODO\|FIXME\|TBD\|placeholder\|{replace\|INSERT" docs/ --include="*.md"

# Find broken internal links
grep -rn "\]\(\./" docs/ --include="*.md" | sed "s/.*\](\(\.\/[^)]*\)).*//" | while read link; do
  [ ! -f "docs/$link" ] && echo "Broken link: $link"
done

# Check that README references real files
grep -oP '\[.*?\]\(\.\/\K[^)]+' README.md | while read f; do
  [ ! -e "$f" ] && echo "Missing: $f"
done
```

## Follow the Project Contract

Documentation in a project should follow the project contract in `CLAUDE.md` for conventions specific to that project.

## Never Do

- Write documentation for features that do not exist yet (without clearly marking it as a proposal)
- Copy-paste documentation from another project and change the names — contextual details will be wrong
- Document commands without testing that they work
- Use passive voice to avoid stating who is responsible for an action
- Write "simply" or "just" — these words dismiss legitimate difficulty
- Leave placeholder text in published documentation
- Document only the success path; failure paths are where readers actually need help
