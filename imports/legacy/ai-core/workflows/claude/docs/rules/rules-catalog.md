# Rules Catalog

The 4 global rules in `~/.claude/rules/` are loaded via `@-imports` in `~/.claude/CLAUDE.md` and apply to every session. They define the mandatory execution contracts that govern all work.

```
@rules/routing.md
@rules/task-completion.md
@rules/test-contract.md
@rules/closeout.md
```

---

## `routing.md`

**Purpose:** Skill-first execution protocol — how to select skills, invoke them, route to agents, and verbalize decisions.

**Key provisions:**

### Mandatory Planning Gate

For non-trivial tasks (multi-file change, new feature, bug investigation, architectural work, configuration change), BEFORE any implementation:
1. Create a GitHub issue: `gh issue create --title "..." --body "..."`
2. Invoke `@principal` to write the execution plan
3. Execute only after issue is open and plan is written

Skip only for: pure conversation, quick lookups, single-file changes ≤ 3 lines, diagnostics.

### Skill-First Flow (8 steps)

```
1. Local fast path: if simple and local, proceed
2. Project Documentation Gate: read README.md, docs/, ADRs if constraining
3. Preference Gate (Tier 1, mandatory): load user-preferences.md from vault
4. Context Gate (Tier 2, lazy): load vault context only if still insufficient
5. Build skill stack: global skill(s) + local repo skill(s)
6. Verbalize decisions (required for non-trivial tasks)
7. Invoke each relevant skill via the Skill tool
8. Dispatch to specialist agent (@engine / @creative / @principal)
```

### Mandatory Verbalization

For non-trivial tasks, emit this block before any output:
```
Docs: checked <paths> | skipped — <reason>
Memory: used <scope/reason> | skipped — <reason>
Skills: global=<comma list or none>; local=<comma list or none>
Route: main session | @engine | @creative | @principal | @engine + @creative
```

Missing this block on a non-trivial task = protocol violation.

### Routing Table

| Domain | Agent | Skill(s) |
|---|---|---|
| Architecture / Specs | @principal | spec-writing |
| Backend / DB | @engine | database-design |
| Infra / Docker / Ops | @engine | devops-patterns |
| Security / Audit | @engine | security-audit |
| UX / UI / Copy / Mobile | @creative | ux-specification |
| Performance / Profiling | @engine | performance-analysis |
| Technical documentation | @creative | technical-writing |

---

## `task-completion.md`

**Purpose:** Five checks that must all pass before any task is declared complete.

### Command Discovery

Before running any check, read the project manifest (`package.json`, `pyproject.toml`, `Cargo.toml`, etc.) and map available scripts:

| Check | Expected script examples |
|---|---|
| lint | `lint`, `lint:check`, `biome:lint`, `eslint`, `ruff check`, `cargo clippy` |
| typecheck | `typecheck`, `tsc`, `mypy`, `pyright`, `cargo check` |
| format | `format`, `format:check`, `biome:format`, `prettier --check`, `ruff format --check` |
| build | `build`, `build:prod`, `compile`, `cargo build` |
| tests | `test`, `test:run`, `test:ci`, `pytest`, `cargo test` |

If a command is not found: **pause**, tell the user what's missing, ask for the right command. Never invent commands.

### Execution Order

```
lint → typecheck → format → build → tests
```

Run strictly in this order. Each check must pass before proceeding to the next.

### Failure Loop

If any check fails:
1. Analyze the error
2. Fix the problem
3. Re-run that check and all subsequent ones
4. Repeat until all pass

### Zero Tolerance

Any file touched during the task must have **all** its errors resolved — not just errors introduced by the task. Pre-existing errors in modified files become the agent's responsibility.

### Completion Criteria

All 5 checks at exit code 0, plus:
- Test Contract (three axes) covered on the touched feature
- Mandatory Closeout executed

---

## `test-contract.md`

**Purpose:** Three mandatory testing axes that every implemented feature must satisfy.

### Threat Modeling (Required BEFORE Implementation)

Before writing code, enumerate touched surfaces and map each to test cases:
```
Threat surfaces:
- [authenticated endpoint] POST /api/x → tests: anon, cross-user, expired-token, mass-assign
- [user input] body.name → tests: SQLi, XSS, length, unicode
- [secrets] uses OPENAI_API_KEY → tests: not logged, not returned in error
- [n/a] read-only endpoint with no user data
```

### Axis 1 — Behavior

Happy path + edge values + expected errors + idempotency (when applicable) + concurrency (when there is shared state).

### Axis 2 — Security

Full OWASP coverage per surface type:

| Surface category | Key test cases |
|---|---|
| **Auth & Session** | anonymous→401, IDOR→403, expired token→401, cross-tenant→403 |
| **Input & Output** | schema validation, SQLi, XSS, SSTI, XXE, SSRF, open redirect |
| **Mutation & State** | CSRF, mass assignment, race conditions, idempotency key |
| **Upload & Files** | MIME validation, path traversal, max size, EXIF strip |
| **API & Network** | CORS allowlist, rate limits, security headers, webhook signature |
| **Crypto & Secrets** | CSPRNG only, timing-safe compare, no secrets in logs/responses |
| **Dependencies** | `npm audit` / `pip-audit` / `cargo audit` — no high/critical |

Authorization matrix required for every protected endpoint: `{anonymous, user, owner, admin} × {GET, POST, PUT, DELETE}`.

Attack payload fixtures versioned in `test/fixtures/security/` (sqli.json, xss.json, ssrf.json, traversal.json).

### Axis 3 — Performance

| Path | Assertion type |
|---|---|
| Critical feature | Fixed numeric budget — p95, query count, payload size. Fail if exceeded. |
| Other features | Regression vs baseline in `test/perf/baseline.json` — cannot worsen > X% |
| List endpoints | N+1 detection — query count with n=1, 10, 100 must be linear |
| Frontend | LCP, INP, CLS, bundle size with budget in Lighthouse CI |

Budgets versioned in `test/perf/budgets.json`. Changing them requires justification in the commit message.

---

## `closeout.md`

**Purpose:** 9-item checklist that runs after all 5 checks pass, before declaring completion to the user.

### The Checklist

| # | Question | If yes, action | Location |
|---|---|---|---|
| 1 | Changed public contract (API, CLI, schema, env vars)? | Update | `README.md`, `docs/` in the repo |
| 2 | Cross-cutting architectural decision? | Create ADR via @principal | `docs/decisions/` or `docs/adr/` in the repo |
| 3 | Breaking change, visible feature, or relevant fix? | Update | `CHANGELOG.md` in the repo |
| 4 | Changed setup/run commands? | Update | `README.md` (Quick Start) or `CONTRIBUTING.md` |
| 5 | New migration? | Document with rollback plan | `docs/migrations/` or README section |
| 6 | User revealed or corrected a preference? | Write | `knowledge/preferences/{slug}.md` in vault |
| 7 | Technical pattern repeated across ≥ 2 projects? | Write | `knowledge/patterns/{slug}.md` in vault |
| 8 | Technical decision relevant beyond this project? | Write | `knowledge/decisions/{slug}.md` in vault |
| 9 | Session has unresolved pending items? | Write condensed note | `sessions/YYYY-MM-DD-{slug}.md` in vault |

### Required Output Format

The final summary must include this block verbatim:
```
Closeout:
- Repo docs:      [applied in <path> / n/a]
- ADR:            [applied / n/a]
- CHANGELOG:      [applied / n/a]
- Setup/run:      [applied / n/a]
- Migration:      [applied / n/a]
- Vault prefs:    [<slug> / n/a]
- Vault patterns: [<slug> / n/a]
- Vault decision: [<slug> / n/a]
- Vault session:  [<slug> / n/a]
```

**Silence = failure.** Every item must have a recorded decision — "n/a" is a valid decision, silence is not.

### Documentation Mirroring Rule

- Info useful to anyone cloning the repo → **project repo**
- Personal cross-project memory → **Obsidian vault**
- Never duplicate between the two

---

## Related

- [workflows/routing-protocol.md](../workflows/routing-protocol.md) — full routing.md walkthrough
- [workflows/planning-protocol.md](../workflows/planning-protocol.md) — mandatory planning gate in detail
- [workflows/closeout-protocol.md](../workflows/closeout-protocol.md) — closeout.md walkthrough
- [skills/skills-catalog.md](../skills/skills-catalog.md) — all skills referenced in the routing table
