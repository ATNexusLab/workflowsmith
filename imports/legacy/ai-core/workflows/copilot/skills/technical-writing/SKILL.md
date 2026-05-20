---
name: technical-writing
description: "Use to write clear technical documentation for humans: README, CONTRIBUTING, API docs, runbooks, onboarding guides, and changelogs."
user-invocable: true
disable-model-invocation: false
triggers:
  - "write or update README, CONTRIBUTING, or CHANGELOG"
  - "create API docs, runbooks, or onboarding guides"
  - "write human-facing technical documentation"
license: MIT
---

# Technical Writing

## When to Use

- Write or update a project README
- Create contribution guides
- Document APIs for consumers
- Write changelogs and release notes
- Create onboarding documentation for new developers
- Write runbooks for operations and support

## Principles

1. **Audience first** — Know who is reading: senior engineer, new contributor, operator, or end user.
2. **Clarity over completeness** — Short and clear beats long and confusing.
3. **Concrete examples** — Working examples are worth more than explanatory prose.
4. **Maintainable docs** — Outdated documentation is worse than missing documentation.
5. **Scannable structure** — Use headings, lists, and tables because most people scan first.

## Language Rule

- Documentation and UI language should follow the project contract in `copilot-instructions.md`
- Code, commands, routes, filenames, and identifiers stay in English
- Examples below keep executable snippets and versioned artifact names in English to avoid hardcoded language assumptions

## README.md — Recommended Structure

```markdown
# Project Name

[One sentence explaining what it is and who it is for.]

## Quick Start

[3-5 steps to run the project. Keep them executable.]

## Installation

[Detailed setup with prerequisites.]

## Usage

[Examples of common workflows. Use working code.]

## Configuration

[Environment variables, config files, runtime options.]

## Development

[How to run tests, lint, build, and any project conventions.]

## Contributing

[Link to CONTRIBUTING.md or minimal contribution notes.]

## License

[License type and link.]
```

**Rules:**

- Keep Quick Start to 5 steps or fewer
- Test every code example before documenting it
- Use top badges only when they add real value
- Link to deeper docs instead of duplicating them

## CONTRIBUTING.md — Recommended Structure

```markdown
# Contributing

## Prerequisites
[Required tools and versions.]

## Environment Setup
[How to clone and configure the project.]

## Workflow
1. Create a branch from `main`
2. Make changes with descriptive commits
3. Run tests: `npm test`
4. Open a PR explaining what changed and why

## Conventions
[Commit messages, naming, coding style.]

## Review Process
[What contributors should expect, SLA, approval criteria.]
```

## API Documentation

### Endpoint Format

```markdown
### POST /users

Creates a new user.

**Request:**
| Field | Type | Required | Description |
|---|---|---|---|
| name | string | ✅ | Full name |
| email | string | ✅ | Valid email address |
| role | string | ❌ | Default: "user" |

**Response 201:**
{
  "id": "uuid",
  "name": "John Doe",
  "email": "john@example.com",
  "role": "user",
  "created_at": "2024-01-01T00:00:00Z"
}

**Errors:**
| Status | Code | When |
|---|---|---|
| 400 | VALIDATION_ERROR | Required field is missing |
| 409 | DUPLICATE_EMAIL | Email is already registered |
```

**Rules:**

- Include request and response examples for every endpoint
- List all expected error cases
- Keep API docs close to the code when possible
- Generate docs from code or schema when the stack supports it

## Changelog Format

Follow [Keep a Changelog](https://keepachangelog.com/):

```markdown
# Changelog

## [1.2.0] - 2024-03-15

### Added
- Endpoint POST /users/reset-password

### Changed
- Pagination now uses cursor-based navigation on /orders

### Fixed
- Timezone bug in token expiration calculation

### Removed
- Deprecated endpoint GET /users/list (use GET /users)
```

**Default categories:** Added, Changed, Deprecated, Removed, Fixed, Security

## Runbooks — Recommended Structure

```markdown
# Runbook: [Procedure Name]

## When to Use
[Symptom or trigger that starts this procedure.]

## Prerequisites
[Required access, tools, and permissions.]

## Steps
1. [Concrete step with command]
2. [Verification that it worked]
3. [Next step]

## Rollback
[How to undo the change if needed.]

## Escalation
[Who to contact if the runbook does not solve the issue.]
```

## Writing Practices

- **Active voice** — "Run the command," not "the command should be run"
- **Imperative verbs** — "Install", "Configure", "Run"
- **Short sentences** — keep instructions tight
- **Lists for procedures** — prefer steps over dense paragraphs
- **Tables for structured data** — parameters, statuses, compatibility
- **Language-tagged code blocks** — improve readability and copy/paste confidence
- **Internal links over duplication** — cross-reference instead of repeating

## Documentation Checklist

- [ ] README includes a working Quick Start
- [ ] All code examples have been validated
- [ ] No unexplained jargon for the target audience
- [ ] Structure supports fast scanning
- [ ] Internal and external links work
- [ ] Last-update context is visible or inferable through version control

## Examples

### Functional README example

Use a compact structure like this:

> # Project Name  
> One-line description — what it does and for whom.
>
> ## Quick Start

```bash
npm install
npm run dev
```

Then continue with:

- `Open http://localhost:3000`
- `## Documentation`
- `- [Full installation guide](docs/installation.md)`
- `- [API reference](docs/api.md)`
- `- [Contributing](CONTRIBUTING.md)`

### Changelog entry example

```markdown
## [1.3.0] - 2024-02-01

### Added
- OAuth2 authentication with Google and GitHub (#123)
- Endpoint `GET /users/me` for the authenticated user profile

### Fixed
- Race condition in concurrent uploads (#145)

### Changed
- `POST /orders` now returns 201 instead of 200 (breaking change)
```

## Validation Checklist

- [ ] The document targets a clearly identified audience
- [ ] The most important workflow appears near the top
- [ ] Commands and examples are executable
- [ ] Linked files and URLs are valid
- [ ] Structure supports fast scanning
- [ ] Redundant content was replaced with links where appropriate

## Never Do

- Do not write docs without a clear audience
- Do not bury Quick Start or operational steps under long narrative prose
- Do not publish untested commands or stale examples
- Do not duplicate repository docs when a cross-link is enough
- Do not let wording drift away from the repository language contract
