# Routing — Skill-First Protocol and Skills Table

### Skill-First Execution Protocol

Before any textual output in an implementation task **outside the objective exceptions**:

0. **Mandatory Planning Gate (non-trivial tasks only):**
   - **Create a GitHub issue** in the current repo (`gh issue create`) — BEFORE planning or implementation.
   - **Invoke `@principal`** to write the execution plan, assigning agents and skills per sub-task.
   - Only after issue is open and plan is written: proceed to step 1.

1. Apply the **local fast path**: if the task is local, simple, and does not depend on history, proceed without the vault.
2. If the task may be constrained by project documentation, apply the **Project Documentation Gate**; if `README.md`, `docs/`, ADRs, `docs/lessons.md`, `CONTRIBUTING.md`, runbooks, or migration docs are relevant, read the minimum necessary before routing.
3. **Preference Gate (Tier 1 — mandatory for non-trivial tasks):** Invoke the `obsidian-memory` skill and call `obsidian-get_note_content("knowledge/user-preferences.md")` before building the skill stack. Skip only on trivial fast-path work (single-line edits, quick lookups, pure explanations). Then, if there is still a historical or continuity gap after loading preferences, apply the **Context Gate (Tier 2 — lazy)** for project context, sessions, and patterns.
4. Build the **skill stack** in this order: identify the global base skill(s) in `~/.claude/skills`, then add local repo skill(s) and path-specific instructions that genuinely narrow the problem.
5. **Repo-local is additive by default.** Only treat a local skill as a substitution/override of a global skill if the repo contract explicitly says so.
6. **Composition is the default when needed.** If more than one relevant concern is active, combining multiple skills is the expected behavior; do not artificially reduce the task to a single skill.
7. **Mandatory verbalization:** when the task is non-trivial (docs/memory/skill/routing decisions were actually considered), emit the decision trail in this fixed order:
   ```
   Docs: checked <repo-relative paths> | skipped — <reason>
   Memory: used <scope/reason> | skipped — <reason>
   Skills: global=<comma list or none>; local=<comma list or none>
   Route: main session | @engine | @creative | @principal | @engine + @creative
   ```
   Skip in trivial fast-path reads, quick explanations, and tiny local edits. `global=` = skills from `~/.claude/skills`; `local=` = repo-local skills. `Route:` = final owner, not every option considered. If this block does not appear on non-trivial tasks, the protocol was violated.
8. If one or more skills exist → **invoke each relevant skill via the `skill` tool before generating any response**.
9. If the task is implementation (code, config, infra): the main session is **prohibited** from generating code — invoke the specialist agent: `@agent [CONTEXT] [TASK]`.

**The main session does not generate implementation code directly** — except for tasks that fall within the objective exceptions listed above.

### Routing Table — Skills

These are the **global baseline skills**. In repositories with local skills, load them as an additional layer when relevant to the domain, workflow, or project constraints. If more than one row applies, skill composition is normal.

| When the request involves… | `skill` | `agent` |
|---|---|---|
| Understanding architecture before acting | `architecture-reading` | — |
| Designing or reviewing REST/GraphQL/gRPC APIs | `api-design` | `@engine` |
| Modeling data, migrations, queries, SQL/NoSQL schema | `database-design` | `@engine` |
| CI/CD, Docker, infrastructure as code, deploy, environments | `devops-patterns` | `@engine` |
| Auditing code, dependencies, or configs for vulnerabilities | `security-audit` | `@engine` |
| Test strategy, writing tests, coverage | `testing-patterns` | `@engine` |
| Refactoring existing code without changing behavior | `refactoring` | `@engine` |
| Writing or reviewing test contracts (3 axes, threat model) | `testing-contract` | `@engine` |
| Analyzing performance bottlenecks, profiling, benchmarks | `performance-analysis` | `@engine` |
| Writing technical documentation (README, CONTRIBUTING, runbook, changelog) | `technical-writing` | `@creative` |
| Producing ADR, Tech Spec, or Architecture Notes | `spec-writing` | `@principal` |
| Creating or updating `CLAUDE.md`, `SKILL.md`, agent `.md` files | `claude-instructions` | — |
| UX spec, user flows, accessibility criteria | `ux-specification` | `@creative` |
| Brand identity, design system, visual tokens | `brand-identity` | `@creative` |
| Implementing or reviewing visual frontend against a design system | `ux-specification` + `brand-identity` | `@creative` |
| Site/app structure for conversion, landing page, CRO copy | `growth-marketing` | `@creative` |
| Mobile features (React Native, Flutter, Swift, Kotlin), builds, platform | `mobile-patterns` | `@creative` |
| Creating issues, PRs, releases, managing branches/labels on GitHub | `github-operations` | — |
| Searching official documentation, validating technical information on the web | `web-research` | — |
| Reading or writing to the Obsidian vault (cross-project memory) | `obsidian-memory` | — |
