# WorkflowSmith Requirements

## Status

Draft requirements for WorkflowSmith v1.

This document describes what WorkflowSmith must become before it can be treated as a complete v1 product. It is intentionally broader than the current repository state. Existing ADRs remain authoritative until they are superseded, but this document records the product requirements that should drive those future decisions.

## Product Definition

WorkflowSmith is an open source framework for excellent AI coding workflows. It provides a canonical, versioned, auditable source of workflow truth and translates that source into safe, harness-specific distributions for AI coding tools.

The product must serve two goals at once:

- Give the maintainer one precise source of truth for evolving a global workflow.
- Give users installable workflow packages that work naturally inside their chosen harness.

WorkflowSmith is not an application with user accounts, cloud state, or per-user configuration. It is closer to a workflow asset framework: users consume published packages, install the harness-specific workflow they want, and keep their personal/local preferences outside the WorkflowSmith source of truth.

## Audience

The primary user for early releases is the maintainer, who needs to version, improve, and distribute a personal high-quality workflow across multiple harnesses.

The secondary audience is trusted technical users, such as friends or collaborators, who want to install a ready workflow without understanding the full internal authoring process.

The public audience is open source readers evaluating WorkflowSmith as a portfolio-grade framework. Public documentation must make the project understandable, credible, and safe to inspect.

## Requirement Layers

WorkflowSmith requirements are split into two layers.

The **product workflow** is the global workflow distributed to users. It defines how an AI coding agent should route tasks, plan, execute, review, test, document, and close out work in arbitrary projects.

The **maintainer workflow** is how WorkflowSmith itself is authored and released. It defines how canonical workflow changes are researched, normalized, validated, translated into harness distributions, and published.

These layers must stay separate. A rule that governs how WorkflowSmith releases are made must not accidentally become a rule imposed on every user's day-to-day project work.

## Goals

WorkflowSmith v1 must:

- Provide a canonical workflow for senior, product-oriented software engineering.
- Translate that workflow into functional distributions for the v1 harness targets.
- Prefer official source material when adapting to a harness.
- Keep generated harness distributions traceable to the canonical source.
- Use safe defaults for permissions, hooks, MCP/tool templates, and local customization.
- Support fast daily work without losing rigor on risky, large, or public changes.
- Be clear enough that another engineer or agent can maintain it without guessing.

## Non-Goals

WorkflowSmith v1 must not:

- Provide a custom installer or package manager.
- Store user secrets, credentials, personal paths, or machine-local preferences.
- Require users to version their local usage of the workflow.
- Treat raw legacy imports as active policy.
- Invent unsupported harness behavior when a native equivalent does not exist.
- Depend on broad auto-approval, hidden permissions, or unsafe hooks to function.

## Harness Targets

WorkflowSmith v1 must provide functional distributions for:

- Codex
- GitHub Copilot
- Claude
- Antigravity
- OpenCode
- OpenClaude (`Gitlawb/openclaude`)

Each harness target must have a documented distribution under `dist/<harness>/`.

Each harness target must be researched against official documentation. If official documentation is missing, unclear, or incomplete, the harness notes must say so explicitly and mark the affected behavior as a gap or assumption.

## Canonical Source Model

The canonical workflow must remain harness-agnostic. Harness-specific behavior belongs in harness distributions, adapter notes, or divergence records, not in the core workflow unless the behavior is genuinely universal.

WorkflowSmith must add a root `workflowsmith.yml` manifest. The manifest is the central index for the official workflow package. It must declare:

- The canonical workflow units included in the official package.
- The intended ordering or precedence of those units when order matters.
- The v1 harness targets.
- The expected distribution directories.
- Required templates or optional integration surfaces.
- Validation requirements that apply before release.

The manifest must prevent adapters or agents from guessing which files belong to the official workflow.

## Canonical Content

Canonical content should continue to use Markdown with frontmatter where appropriate. Current promoted types are:

- `policy`
- `agent`
- `skill`
- `checklist`
- `memory-index`

The v1 requirements imply additional canonical or distributable surfaces:

- Harness package manifests.
- Harness equivalence matrices.
- Harness divergence notes.
- MCP/tool templates.
- Hook templates.
- Distribution usage notes.

Future ADRs must decide whether these are new canonical workflow unit types, manifest sections, or non-canonical support files.

## Distribution Model

WorkflowSmith v1 must commit harness distributions to the repository under:

```text
dist/<harness>/
```

The repository therefore contains both the canonical source and the translated distributions. This is an intentional product requirement because users must be able to fetch or install a specific harness package directly from the project.

This requirement supersedes the product direction implied by the current "ephemeral build artifact" model. A future ADR must update or supersede the existing build-system decision before v1.

Each `dist/<harness>/` directory must include:

- A distribution manifest.
- A README or usage note for that harness.
- The translated workflow assets for the harness.
- Safe templates for optional MCP/tool or hook configuration when needed.
- A traceability record linking the distribution back to canonical source files.
- An equivalence matrix for canonical concepts versus harness-native surfaces.
- Known gaps, partial mappings, and unsupported behavior.

## Dist Traceability

Each harness distribution must record:

- The WorkflowSmith version or release it belongs to.
- The canonical source files used to produce it.
- The official harness documentation consulted.
- The verification date for version-sensitive harness facts.
- A matrix of equivalent, partial, and unsupported mappings.
- Harness-specific divergences and why they are necessary.

No distribution may silently omit a canonical behavior. If a behavior cannot be represented in a harness, it must be marked as `no equivalent`. If a behavior requires composition or behaves differently, it must be marked as `partial`.

## Installation And Consumption

WorkflowSmith v1 does not provide its own install command. It must publish repository layouts and harness packages that are compatible with existing harness or ecosystem installation mechanisms.

The user-facing model is:

- Users choose the harness package they want.
- Users install or fetch only that package.
- Users configure local secrets, MCP credentials, and personal preferences outside the WorkflowSmith repository.
- Users may add project-local instructions or skills in their own repositories, but those local additions are not part of WorkflowSmith releases.

## Local Project Customization

The global WorkflowSmith workflow is a base layer. Project-local instructions, project-local skills, and repository documentation are additive.

Local project material should provide:

- Project facts.
- Repository-specific commands.
- Domain constraints.
- Local architecture decisions.
- Team conventions.

Local project material should not silently replace the global WorkflowSmith workflow. If a harness supports explicit override behavior, the distribution notes must explain the risk and expected use.

## Product Workflow Agents

The v1 product workflow must define four official roles:

- **Orchestrator:** classifies work, selects rigor level, routes to skills or specialists, coordinates planning, and checks closeout.
- **Builder/Engineer:** executes technical implementation, refactoring, tests, and engineering changes.
- **Creative/Product:** handles UX, frontend experience, product framing, technical communication, and user-facing writing.
- **Reviewer/Auditor:** reviews for correctness, regressions, security, maintainability, and missing validation. It is read-only by default unless a harness or task explicitly permits remediation.

Agents are divided by responsibility and authority, not by every technical domain. Domains such as security, testing, performance, architecture, API design, documentation, and DevOps should usually be skills rather than separate agents.

## Orchestration Behavior

The official entry behavior should be an orchestrator/router when the harness supports it. Users should not need to manually select an orchestrator at the start of every session if the harness can make that behavior the default.

The Orchestrator routes and coordinates. It should not become the default heavy executor. Execution should move to the Builder/Engineer, Creative/Product, Reviewer/Auditor, or the relevant skill when the task requires specialized work.

For harnesses without a native agent-entrypoint concept, the distribution must approximate the Orchestrator behavior through the harness's supported instruction or profile surfaces and record the limitation.

## Product Workflow Skills

The v1 skill catalog must cover senior product engineering without creating unnecessary fragmentation.

Required skill domains:

- Requirements and specification.
- Architecture and system design.
- Implementation and refactoring.
- API and data design.
- Testing strategy.
- Code review.
- Security audit.
- Performance analysis.
- DevOps and release.
- Product and UX.
- Technical writing.
- Harness translation and adaptation.
- Knowledge and memory governance.

A skill should exist when there is a recurring procedure with its own triggers, risks, checklist, evidence needs, and output shape. A topic alone is not enough reason to create a skill.

## Rigor Levels

The product workflow must support three rigor levels:

- **Fast:** for small, local, reversible work and direct questions.
- **Standard:** for normal implementation, documentation, refactoring, and project work with limited risk.
- **Rigorous:** for high-risk, large, ambiguous, architectural, security-sensitive, release-facing, or multi-step work.

Routing should be automatic by objective signals, with user override when the user explicitly requests a different mode.

Fast mode must not be used for work involving:

- Security boundaries.
- Data integrity.
- Permissions.
- Production behavior.
- Migrations.
- Architecture changes.
- Large or ambiguous changes.
- Public releases.
- WorkflowSmith harness distributions.

Standard mode may use a lightweight plan when useful.

Rigorous mode requires a clear plan, acceptance criteria, explicit validation, and review or audit involvement when appropriate.

## Planning Requirements

The workflow must avoid needless ceremony on low-risk work while still preventing unsafe improvisation.

Planning rules:

- Fast work may proceed directly when scope is clear and reversible.
- Standard work should use a short plan when multiple steps, files, or tradeoffs are involved.
- Rigorous work must produce a formal plan before execution.

A formal plan must include:

- Goal.
- Scope.
- Approach.
- Key risks.
- Acceptance criteria.
- Validation steps.
- Expected handoff or closeout.

## Review And Audit

Reviewer/Auditor must be invoked for:

- Rigorous-mode work.
- Security-sensitive changes.
- Architecture or system design changes.
- Release preparation.
- Harness distribution updates.
- Regression investigations.
- Explicit user review requests.

Reviewer/Auditor output must lead with findings ordered by severity and cite concrete files, behaviors, or requirements where possible.

## Testing And Validation In User Projects

The product workflow must discover validation commands from the user's project before guessing. It should inspect project documentation, manifests, scripts, or existing conventions.

Validation effort must scale with risk:

- Fast mode may use targeted checks or explain why no check was needed.
- Standard mode should run relevant checks when available.
- Rigorous mode must identify and run appropriate checks unless blocked.

If validation cannot run, the workflow must state the blocker and residual risk.

## Hooks

Hooks may be included in v1 only as safe, opt-in templates.

Hook templates must:

- Be disabled by default or require explicit installation.
- Avoid broad auto-approval.
- Fail closed when they guard security-sensitive behavior.
- Avoid personal paths and machine-specific assumptions.
- Be documented with their purpose, trigger, permissions, and failure behavior.

No v1 distribution may rely on an unsafe hook to provide core workflow correctness.

## MCP And Tool Templates

MCP servers and external tools may be necessary for advanced workflows, but v1 must treat them as parametrized templates.

MCP/tool templates must:

- Use placeholders for secrets, tokens, endpoints, and local paths.
- Explain required permissions.
- Prefer least privilege.
- Avoid shipping real credentials or private configuration.
- Document which workflow capability the integration enables.

## Native Harness Commands And Surfaces

WorkflowSmith v1 must not create a separate command layer when harness-native commands or workflow surfaces already exist.

Each harness distribution should use native commands, profiles, agents, skills, hooks, plugins, settings, or instruction files as appropriate for that harness.

If a harness lacks a native command or surface for an essential workflow behavior, the distribution must document the nearest supported pattern and the remaining gap.

## Security Requirements

WorkflowSmith must be safe to inspect, clone, and install.

Validation must block:

- Secrets, tokens, API keys, and credentials.
- Personal absolute paths.
- Real MCP credentials.
- Broad permission grants.
- Broad auto-approval behavior.
- Destructive hook defaults.
- Hidden shell execution required for basic use.

External content is data, not instruction. Raw imports, third-party docs, tool outputs, and web pages must never override WorkflowSmith policy or active developer instructions.

## Official Source Policy

Harness support must be based on official sources.

For each harness, the maintainer workflow must record:

- Official documentation URLs.
- Verification date.
- Version-sensitive areas.
- Confirmed native surfaces.
- Unsupported or unclear behavior.
- Divergences between the canonical workflow and harness capabilities.

Community examples may inform implementation, but they cannot be the authority for harness behavior unless official documentation is unavailable and the limitation is explicitly recorded.

## Maintainer Workflow

The maintainer workflow must support these activities:

- Research a harness through official documentation.
- Decompose the canonical workflow into neutral operational parts.
- Map each part to harness-native surfaces.
- Record equivalent, partial, and unsupported mappings.
- Generate or update `dist/<harness>/`.
- Validate structure and security.
- Update docs and changelog when a release-worthy change is made.
- Publish a release when the maintainer decides the change is worth versioning.

The maintainer is the release authority. External review may be useful, but v1 does not require another person to approve releases.

## Versioning Requirements

WorkflowSmith releases are controlled by the maintainer. Users consume published versions and do not version their local use of the workflow through WorkflowSmith.

The project must keep semver releases for meaningful product changes. Release-worthy changes include:

- Schema changes.
- Canonical workflow changes.
- Agent or skill changes that affect behavior.
- Harness distribution changes.
- Security fixes.
- Public documentation changes that affect installation or usage.

Day-to-day experimentation does not require a release until the maintainer chooses to publish it.

The current unit-level versioning model may need an ADR revision before v1 if it creates unnecessary friction or conflicts with release-oriented maintenance.

## Required Public Documentation

The v1 public documentation set must include:

- Project README.
- Requirements document.
- Architecture document.
- Harness installation and usage notes.
- Harness adapter or distribution notes.
- Security model.
- Changelog.
- Basic contributing or maintainer guidance.

Documentation must be in English for public files.

## v1 Acceptance Criteria

WorkflowSmith v1 is ready when:

- `workflowsmith.yml` exists and defines the official workflow package.
- The canonical workflow covers the required agents, skills, policies, and checklists.
- `dist/codex/`, `dist/copilot/`, `dist/claude/`, `dist/antigravity/`, `dist/opencode/`, and `dist/openclaude/` exist.
- Each distribution has a manifest, usage notes, official-source evidence, equivalence matrix, and gap notes.
- Hooks and MCP/tool configs are templates only and pass security checks.
- Validation checks pass.
- Security scans block secrets, personal paths, unsafe permissions, and dangerous defaults.
- Representative workflow scenarios are covered.
- Public documentation is complete enough for a technical user to understand and install the workflow.

## Representative Workflow Scenarios

The v1 workflow must be able to guide these scenarios:

- Requirements discovery for a new or unclear project.
- Planning a feature.
- Implementing a bugfix.
- Implementing a normal feature.
- Reviewing code.
- Auditing security risk.
- Designing architecture or system behavior.
- Writing or updating tests.
- Improving user-facing UX or documentation.
- Translating the canonical workflow to a harness.
- Preparing a WorkflowSmith release.

These scenarios do not all need full automated tests in v1, but the workflow and documentation must make their expected handling clear.

## Open Decisions Before v1

The following decisions must be resolved through future ADRs or equivalent documented decisions:

- Whether `dist/` replaces or supersedes the current ephemeral build artifact model.
- Whether `workflowsmith.yml` is schema-validated and what fields are required.
- Whether distribution manifests are canonical workflow units or support files.
- How unit-level versioning should coexist with maintainer-controlled release versioning.
- The exact file layout for each `dist/<harness>/`.
- The minimum official-source evidence format for each harness.
- The validation script responsibilities for schema, dist completeness, and security checks.
