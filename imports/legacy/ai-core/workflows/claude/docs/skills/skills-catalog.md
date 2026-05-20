# Skills Catalog

The 19 user-defined global skills in `~/.claude/skills/` plus 13 bundled distribution skills from the Claude Code binary. All are invoked via the `Skill` tool.

---

## Quick Reference

| Skill | Agent | Trigger domain | Core deliverable |
|---|---|---|---|
| `api-design` | @engine | REST/GraphQL/gRPC APIs | Contract, pagination, versioning, error format |
| `architecture-reading` | — | Before acting in an unfamiliar codebase | Stack map, boundary diagram, ADR inventory |
| `brand-identity` | @creative | Brand foundation, design system | Positioning, palette, typography, tone, anti-patterns |
| `claude-instructions` | — | Creating/updating instruction files | CLAUDE.md, SKILL.md, agent .md files, rules |
| `database-design` | @engine | Data modeling, migrations | Schema, migration plan, rollback, access patterns |
| `devops-patterns` | @engine | CI/CD, Docker, infrastructure | Pipeline, deployment strategy, secrets, observability |
| `github-operations` | — | GitHub operations via CLI | Issues, PRs, labels, releases, workflows |
| `growth-marketing` | @creative | Landing pages, conversion, copy | Funnel structure, benefit-led copy, CTA, CRO audit |
| `mobile-patterns` | @creative | React Native, Flutter, Swift, Kotlin | Platform conventions, lifecycle, security, releases |
| `obsidian-memory` | — | Cross-project memory (Obsidian vault) | Read/write vault notes with lazy policy |
| `performance-analysis` | @engine | Performance investigation | Baseline metrics, bottleneck identification, SLOs |
| `refactoring` | @engine | Behavior-preserving code improvement | Code smell catalog, safe refactoring patterns |
| `security-audit` | @engine | Security review, vulnerability analysis | OWASP audit, severity classification, fix recommendations |
| `spec-writing` | @principal | ADRs, Tech Specs, Architecture Notes | Persistent decision documents |
| `technical-writing` | @creative | READMEs, guides, runbooks, changelogs | Human-facing documentation |
| `testing-contract` | @engine | Three-axis test requirements | Behavior + Security + Performance test coverage |
| `testing-patterns` | @engine | Test strategy and test implementation | Test pyramid, unit/integration/E2E, fixtures |
| `ux-specification` | @creative | User flows, interface behavior, accessibility | UX spec, acceptance criteria, WCAG coverage |
| `web-research` | — | Official documentation, version confirmation | Evidence-backed research with source citations |

---

## Skills in Detail

### `api-design`

**When to use:** Designing a new API, reviewing an existing one for consistency, defining request/response contracts, creating OpenAPI or protobuf documentation.

Covers: REST resource naming and HTTP methods, GraphQL schema design, gRPC service definition, pagination (cursor-based and offset), error format standards, versioning strategies, rate limiting headers, security considerations at the API surface.

---

### `architecture-reading`

**When to use:** Before making any architectural decision in an existing project; when starting work in an unfamiliar codebase; before choosing a skill stack or implementation approach.

Steps: locate `docs/`, `README.md`, ADRs, and runbooks; map the stack and module boundaries; identify existing patterns and invariants; list relevant prior decisions. Outputs a structured understanding of the system before action.

This skill is often the **first** skill invoked in a session — read before you write.

---

### `brand-identity`

**When to use:** Defining visual identity from scratch, creating a design system, writing tone-of-voice guidelines, auditing existing UI for generic or off-brand patterns.

Covers: brand positioning and unique differentiators, color palette with semantic tokens, typography (display/body/mono), spacing and grid, motion principles, photography/illustration style, microcopy tone, and anti-cliché list (what NOT to do). Visual frontend work loads this together with `ux-specification` by default.

---

### `claude-instructions`

**When to use:** Creating or updating CLAUDE.md, SKILL.md, agent .md files, or path-specific rule files.

Covers: the instruction surface taxonomy (CLAUDE.md, SKILL.md, agents, rules), frontmatter schemas for each type, scope-layer precedence, duplication detection, language drift audits, and validation checklists. Used by `@principal` in Bootstrap mode.

---

### `database-design`

**When to use:** Designing a new data model, writing migrations, reviewing an existing schema, choosing between relational and document storage, defining access patterns.

Covers: entity modeling and normalization, constraint design (NOT NULL, UNIQUE, FK), index strategy, the expand-migrate-contract migration pattern, zero-downtime migration techniques, rollback plans, N+1 detection, and query optimization. Supports SQL (PostgreSQL, MySQL, SQLite) and NoSQL (MongoDB, DynamoDB) contexts.

---

### `devops-patterns`

**When to use:** Building or reviewing CI/CD pipelines, writing Dockerfiles or compose files, designing deployment strategies, configuring secrets management, setting up observability.

Covers: GitHub Actions/GitLab CI patterns, Docker best practices (multi-stage builds, non-root users), deployment strategies (blue-green, canary, rolling), Kubernetes basics, secrets handling (env vars, secret managers, never committed), health checks, structured logging, metrics, and distributed tracing.

---

### `github-operations`

**When to use:** Any GitHub operation — creating or triaging issues, opening PRs, managing labels/milestones, creating releases, managing branch protection, operating GitHub Actions workflows.

Covers: `gh` CLI usage for all GitHub operations, PR template conventions, label taxonomy, milestone management, release notes, and branch protection rules. All GitHub work goes through `gh` CLI, not API calls.

---

### `growth-marketing`

**When to use:** Writing landing page copy, structuring a marketing funnel, auditing conversion rates, writing benefit-led feature descriptions, creating onboarding sequences.

Covers: AIDA (Attention, Interest, Desire, Action) and AARRR (Acquisition, Activation, Retention, Referral, Revenue) frameworks, benefit-vs-feature distinction, CTA hierarchy, social proof placement, objection handling, headline writing, and CRO audit checklists.

---

### `mobile-patterns`

**When to use:** Implementing mobile features in React Native, Flutter, Swift (iOS), or Kotlin (Android); handling platform-specific issues; configuring app stores; managing mobile security concerns.

Covers: platform conventions (navigation paradigms, permissions, lifecycle), React Native/Flutter state management, offline-first patterns, secure storage (Keychain/Keystore), mobile-specific security (certificate pinning, jailbreak detection), push notifications, app signing, and store submission checklists.

---

### `obsidian-memory`

**When to use:** Reading from or writing to the Obsidian personal knowledge vault for cross-project continuity, recovering context from a prior session, or persisting a learned preference or pattern.

Two-tier read gate:
- **Tier 1 (mandatory):** Load `knowledge/user-preferences.md` before any non-trivial task
- **Tier 2 (lazy):** Load project context, sessions, or patterns only if Tier 1 + repo docs are insufficient

Write protocol: only at high-value moments (preference identified, cross-project pattern, architectural decision, significant unresolved session). Do not write intra-task logs.

---

### `performance-analysis`

**When to use:** Investigating latency regressions, profiling CPU/memory/IO bottlenecks, defining SLOs, creating performance benchmarks, auditing Core Web Vitals.

Covers: performance metrics by layer (HTTP, DB, CPU, memory, frontend), profiling tools by stack (Node.js: clinic.js/0x; Python: py-spy/cProfile; Go: pprof), query explain plan analysis, N+1 detection, caching layer analysis, frontend LCP/INP/CLS budgets, and benchmark design.

---

### `refactoring`

**When to use:** Improving code structure without changing observable behavior — reducing duplication, clarifying intent, untangling coupling, reducing nesting.

Covers: the code smell catalog (long method, feature envy, data clumps, primitive obsession, shotgun surgery, divergent change, etc.), safe refactoring operations (extract function, inline variable, introduce parameter object, replace conditional with polymorphism), and validation that the test suite still passes after each step.

---

### `security-audit`

**When to use:** Auditing code, configuration, or dependencies for vulnerabilities; reviewing a new surface before release; responding to a security report.

Covers: OWASP Top 10 audit procedure, severity classification (Critical/High/Medium/Low/Informational), surface-by-surface threat model (auth, input/output, mutation, uploads, API/network, crypto, dependencies), `npm audit`/`pip-audit`/`cargo audit` integration, and remediation guidance. Output format: severity → surface → finding → fix.

---

### `spec-writing`

**When to use:** Documenting an architectural decision (ADR), specifying a new component or significant redesign (Tech Spec), recording analyses or smaller decisions (Architecture Notes).

Format selection:
- **ADR** — cross-cutting, hard to reverse, long-term effect
- **Tech Spec** — new component, significant redesign, external integration
- **Architecture Notes** — analysis, clarification, localized patterns

Includes templates in `references/` subdirectory. Outputs go to `docs/decisions/` or `docs/adr/` in the project repo.

---

### `technical-writing`

**When to use:** Writing or updating README, CONTRIBUTING, changelogs, API docs, onboarding guides, or operational runbooks.

Principles: audience first, clarity over completeness, concrete working examples, maintainable docs (outdated docs are worse than missing ones), scannable structure. Covers README, CONTRIBUTING, and changelog format (Keep a Changelog), API endpoint documentation format, and runbook structure.

---

### `testing-contract`

**When to use:** Writing tests for a new feature, verifying security coverage, defining performance budgets before implementation.

Three mandatory axes:
1. **Behavior** — happy path, edge values, expected errors, idempotency, concurrency
2. **Security** — full OWASP surface coverage (auth, input/output, mutation, uploads, API/network, crypto, deps)
3. **Performance** — p95 budgets, N+1 detection, regression vs baseline, Core Web Vitals

Requires threat modeling BEFORE writing code. Authorization matrix required for protected endpoints: `{anonymous, user, owner, admin} × {GET, POST, PUT, DELETE}`.

---

### `testing-patterns`

**When to use:** Designing a test strategy for a new project or module, choosing test levels (unit vs integration vs E2E), structuring fixtures and test doubles.

Covers: test pyramid (~70% unit, ~20% integration, ~10% E2E), test doubles (stub vs mock vs fake — prefer stubs/fakes over mocks), test isolation, fixture design, coverage strategy, and deterministic test patterns.

---

### `ux-specification`

**When to use:** Specifying user flows, interface component behavior, accessibility requirements, or acceptance criteria for a UI feature.

Covers: user flow diagrams, state machine notation for components (default/loading/empty/error/success), WCAG 2.1 AA accessibility requirements (color contrast, keyboard navigation, ARIA roles), acceptance criteria in given/when/then format, and responsive behavior specification. Always compose with `brand-identity` for visual implementation.

---

### `web-research`

**When to use:** Finding official documentation, confirming API behavior, validating that a feature exists in a specific version, comparing library options.

Protocol: start with official sources (MDN, official docs, RFCs) before community sources (Stack Overflow, blogs); record the source URL and version; flag when information is version-specific; never present unverified information as fact. Evidence-backed output with citations.

---

## Composition Pairs

These skill combinations work together by default:

| Composition | When to use |
|---|---|
| `ux-specification` + `brand-identity` | Any visual frontend implementation or UI redesign |
| `api-design` + `security-audit` | New API surface before release |
| `api-design` + `testing-contract` | API implementation |
| `database-design` + `testing-contract` | New data model implementation |
| `architecture-reading` + `refactoring` | Refactoring an unfamiliar module |
| `spec-writing` + `architecture-reading` | ADR for a change in an existing system |
| `devops-patterns` + `security-audit` | CI/CD pipeline security review |

---

## Related

- [skills/skills-overview.md](skills-overview.md) — how skills work and how they're invoked
- [skills/skill-format.md](skill-format.md) — writing a new skill
- [workflows/routing-protocol.md](../workflows/routing-protocol.md) — full routing logic and skill selection
