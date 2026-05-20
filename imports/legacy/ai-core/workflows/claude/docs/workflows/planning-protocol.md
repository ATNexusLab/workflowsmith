# Planning Protocol

The mandatory 3-step workflow that applies to every non-trivial task. This protocol is enforced by the `plan-first.js` hook, which injects it as context on every user prompt.

---

## When It Applies

**Non-trivial tasks** (all three steps required):
- Multi-file change
- New feature
- Bug investigation
- Architectural work
- Configuration change
- Anything spanning more than one file or requiring a decision

**Trivial fast path** (skip steps 1–2):
- Pure conversation or explanation
- Quick lookups
- Single-file change ≤ 3 lines
- Diagnostics

When in doubt, treat as non-trivial. The cost of one extra GitHub issue is lower than the cost of unplanned implementation.

---

## Step 1 — GitHub Issue (First)

Before any planning or implementation, create a GitHub issue in the current repo:

```bash
gh issue create \
  --title "feat: user authentication with JWT" \
  --body "Add JWT-based auth to the API. Scope: login endpoint, token validation middleware, logout. Out of scope: OAuth, MFA."
```

**Title format:** `<type>: <task name>`
- `feat:` — new feature
- `fix:` — bug fix
- `refactor:` — code improvement without behavior change
- `chore:` — tooling, config, dependency updates
- `docs:` — documentation only

**Body format:**
- What changes (specific scope)
- What doesn't change (explicit boundaries)
- Any known constraints

The issue is the source of truth for what is being built and why. It also serves as the integration point for PRs: `gh pr create` will link to it automatically if the branch name or PR body references it.

**Never proceed to Step 2 before the issue exists.** The issue number provides accountability and makes the work traceable.

---

## Step 2 — @principal Plan (Before Implementation)

Invoke `@principal` to write the execution plan:

```
@principal Write an execution plan for issue #42: JWT authentication.
Plan must include:
- Sub-tasks with agent assignment (@engine or @creative)
- Skills each sub-task requires
- Dependency order (what must complete before what)
- Acceptance criteria per sub-task
```

The plan must:
- Use all applicable skills from `~/.claude/skills/` and any repo-local `skills/`
- Assign each sub-task to the responsible agent (`@engine` or `@creative`)
- List the skills each sub-task requires (so they are passed to the sub-agent correctly)
- Be saved to a plan file at `~/.claude/plans/` for the session

**Example plan structure:**

```markdown
# Plan: JWT Authentication (#42)

## Sub-tasks

### 1. Database schema (dependency: none)
Agent: @engine
Skills: database-design, testing-contract
Acceptance: user table has password_hash column; token_blacklist table exists with index

### 2. Auth middleware (dependency: 1)
Agent: @engine
Skills: api-design, security-audit, testing-contract
Acceptance: POST /auth/login returns signed JWT; middleware validates on protected routes; all OWASP auth cases covered in tests

### 3. Logout endpoint (dependency: 2)
Agent: @engine
Skills: api-design, testing-contract
Acceptance: POST /auth/logout blacklists token; subsequent requests with that token return 401
```

**Plan mode option:** Instead of manually invoking @principal, enter `/plan` mode. Claude uses `EnterPlanMode` + `ExitPlanMode` to surface the plan for explicit approval before any action.

---

## Step 3 — Execute

Only after the issue is open and the plan is written: delegate implementation to the appropriate agents.

**Sequential sub-tasks** (one depends on the other):
```
1. Invoke @engine for sub-task 1 → wait for completion
2. Invoke @engine for sub-task 2 (depends on 1)
```

**Parallel sub-tasks** (independent):
```
Invoke @engine (backend) + @creative (frontend) simultaneously
```

The main session is the orchestration layer. It does not generate implementation code — it delegates to `@engine` and `@creative` and assembles results.

---

## Why This Protocol Exists

Without a planning gate, non-trivial work starts without clear scope boundaries, skill selection happens ad-hoc, and there is no audit trail for what was decided and why. The three-step protocol prevents scope creep, ensures the right skills are loaded, and makes every non-trivial task traceable to an issue.

The `plan-first.js` hook injects this protocol as `additionalContext` on every user prompt — Claude always has it in context even if not explicitly mentioned.

---

## Common Mistakes

**Skipping the issue:** "This is a small change" — if it spans multiple files, it is non-trivial. Create the issue.

**Writing the plan yourself:** The plan must come from `@principal`. The main session's role is to brief @principal, not to plan.

**Starting implementation before plan approval:** In `/plan` mode, `ExitPlanMode` surfaces the plan. Do not proceed before the user approves.

**Under-specifying sub-tasks:** Each sub-task must name an agent, list required skills, and have acceptance criteria. A vague sub-task creates ambiguity at execution time.

---

## Related

- [workflows/routing-protocol.md](routing-protocol.md) — skill selection and agent dispatch
- [agents/agent-roster.md](../agents/agent-roster.md) — @principal's three modes
- [core/context-management.md](../core/context-management.md) — /plan mode, plan files
- [hooks/hooks-patterns.md](../hooks/hooks-patterns.md) — how plan-first.js injects the protocol
