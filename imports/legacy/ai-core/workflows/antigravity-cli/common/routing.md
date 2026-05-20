<!-- common fragment: routing — loaded via @import or read_file -->

## Mandatory Planning Gate

**Applies to every non-trivial task** (multi-file change, new feature, bug investigation, architectural work, configuration change). Not optional.

**Step 1 — GitHub Issue (FIRST):** before any planning or implementation, create a GitHub issue in the current repo.

```
gh issue create --title "<task name>" --body "<scope summary>"
```

**Step 2 — @principal Plan (BEFORE implementation):** invoke `@principal` to write the execution plan. The plan must assign each sub-task to the responsible agent (`@engine` or `@creative`), list the skills each sub-task requires, and be saved to the session plan file.

**Step 3 — Execute:** only after the issue is open and the plan is written, delegate implementation to the appropriate agents.

**Skip steps 1–2 only for:** pure conversation, quick lookups, single-file changes ≤ 3 lines, diagnostics.

---

## Skill-First Execution Protocol

Before any output on an implementation task, outside the exceptions below:

0. Apply the **Mandatory Planning Gate** above for non-trivial tasks.
1. **Local fast path** — if the task is local, simple, and requires no history: proceed directly without vault or docs overhead.
2. **Project Documentation Gate** — if `README.md`, `docs/`, ADRs, `docs/lessons.md`, `CONTRIBUTING.md`, runbooks, or migration docs could change the answer: read the minimum necessary before routing. Stop when sufficient.
3. **Preference Gate (Tier 1 — mandatory for non-trivial tasks)** — load `~/.gemini/skills/obsidian-memory/SKILL.md` and call `obsidian-get_note_content("knowledge/user-preferences.md")`. Skip only on trivial fast-path work.
4. **Context Gate (Tier 2 — lazy)** — after loading preferences, invoke `obsidian-memory` for project context, sessions, or patterns only when at least one trigger applies: local context is still insufficient; recurring work with a historical gap; a decision needs prior rationale; user explicitly asks. Stop as soon as sufficient context is found.
5. **Build the skill stack** — identify global base skill(s) from `~/.gemini/skills/`, then layer in any repo-local skills that genuinely narrow the problem.
6. **Composition is the default.** If more than one domain is active, combine skills. Do not reduce to a single skill when composition is more faithful to the problem.
7. **Mandatory verbalization** — when routing decisions were actually made (non-trivial task), emit the decision trail before any implementation output:

   ```
   Docs: checked <repo-relative paths> | skipped — <reason>
   Memory: used <scope/reason> | skipped — <reason>
   Skills: global=<comma list or none>; local=<comma list or none>
   Route: main session | @engine | @creative | @principal | @engine + @creative
   ```

   Omit on trivial fast-path reads, quick explanations, and small local edits. `global=` = skills from `~/.gemini/skills`; `local=` = repo-local skills. `Route:` = final owner, not every option considered.

8. **Activate each skill** before generating any response. In the main session, prefer `activate_skill` (native). In subagents, use `read_file ~/.gemini/skills/{name}/SKILL.md`. Mentioning a skill by name is not activation.
9. **Delegate implementation.** If the task is code, config, or infra: invoke the specialist agent — `@agent [CONTEXT] [TASK]`. The main session does not generate implementation code directly, except under the exceptions below.

---

## Exceptions — Main Session Executes Directly

- Purely conversational or explanatory responses (no implementation)
- Searches, file reads, quick diagnostics
- Single-file change, ≤ 3 lines total, no new file created, no structural impact

---

## Routing Matrix — Level 0 (Deterministic)

Tasks with explicit domain semantics follow mandatory skill-first routing from the corresponding global base skill. Generic implementation or local change without domain semantics: choose agent by change locus; load skills only when the task truly requires that framework.

| Input Domain | `specialist_agent` | `baseline_skill(s)` |
|---|---|---|
| Architecture / Specs | `@principal` | `spec-writing` |
| Backend / DB | `@engine` | `database-design` |
| Infra / Docker / Ops | `@engine` | `devops-patterns` |
| Security / Audit | `@engine` | `security-audit` |
| UX / UI / Copy / Mobile | `@creative` | `ux-specification` |
| Performance / Profiling | `@engine` | `performance-analysis` |

**Cross-domain tasks** (e.g., full-stack feature): load skills from each domain; launch `@engine` and `@creative` in parallel with separate scopes when there is domain-divided execution.

**Visual frontend work composes by default:** for UI implementation, restyling, or design-system conformance, load `ux-specification` + `brand-identity` together. Use `ux-specification` alone only when the task is purely behavioral with no visual-system impact.

---

## Routing Table — Skills

Global baseline skills. In repositories with local skills, load them as an additional layer when relevant to the project's domain, workflow, or constraints. If more than one row applies, skill composition is normal.

| When the request involves… | `skill` | `agent` |
|---|---|---|
| Understanding architecture before acting | `architecture-reading` | — |
| Designing or reviewing REST/GraphQL/gRPC APIs | `api-design` | `@engine` |
| Modeling data, migrations, queries, SQL/NoSQL schema | `database-design` | `@engine` |
| CI/CD, Docker, infrastructure as code, deployment, environments | `devops-patterns` | `@engine` |
| Auditing code, dependencies, or configs for vulnerabilities | `security-audit` | `@engine` |
| Test strategy, writing tests, coverage | `testing-patterns` | `@engine` |
| Writing or reviewing the Test Contract (3 axes, threat model) | `testing-contract` | `@engine` |
| Refactoring existing code without altering behavior | `refactoring` | `@engine` |
| Analyzing performance bottlenecks, profiling, benchmarks | `performance-analysis` | `@engine` |
| Writing technical documentation (README, CONTRIBUTING, runbook, changelog) | `technical-writing` | `@creative` |
| Producing ADR, Tech Spec, or Architecture Notes | `spec-writing` | `@principal` |
| Creating or updating `GEMINI.md`, `SKILL.md`, agent `.md` files | `gemini-instructions` | — |
| UX spec, user flows, accessibility criteria | `ux-specification` | `@creative` |
| Brand identity, design system, visual tokens | `brand-identity` | `@creative` |
| Implementing or reviewing visual frontend against a design system | `ux-specification` + `brand-identity` | `@creative` |
| Site/app structure for conversion, landing pages, CRO copy | `growth-marketing` | `@creative` |
| Mobile feature (React Native, Flutter, Swift, Kotlin), builds, platform | `mobile-patterns` | `@creative` |
| Creating issues, PRs, releases, managing branches/labels on GitHub | `github-operations` | — |
| Searching official docs, validating technical information on the web | `web-research` | — |
| Reading or writing to the Obsidian vault (cross-project memory) | `obsidian-memory` | — |
