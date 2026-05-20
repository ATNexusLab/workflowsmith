---
name: memory-index
description: Auto-loaded index of cross-project preferences and vault pointers. Always applied.
metadata: 
  node_type: memory
  type: reference
  originSessionId: f1dbf96c-1799-4c2a-aee4-32df7c73460c
---

# Memory Index — Cross-Project Preferences

**ACTION REQUIRED on any non-trivial task:** Invoke `obsidian-memory` skill and call
`obsidian-get_note_content("knowledge/user-preferences.md")` to load the full 43-rule preference MOC.

---

## Critical Preferences (inline — always apply without MCP)

**Tooling**
- Always use `bun` / `bunx` — never `npx`, `npm`, or `yarn`
- Pin exact dependency versions (e.g., `"2.4.6"`) — never `^`, `~`, or `latest`
- Run frontend tests with `bun run test`, not Jest CLI directly

**Architecture**
- Feature-based folder structure: `src/modules/{feature}/index.ts` + `service.ts` + `model.ts` — not horizontal layers (`controllers/`, `services/`)
- Services return `Result<T, E>` for business errors — `throw` reserved for unexpected infrastructure failures only
- Guard clauses + early returns to reduce nesting — no unnecessary `else`

**Workflow**
- Prefer production-ready increments over MVP — always build with prod contracts and patterns, even at small scope
- When pausing a front that may continue on another machine: commit, push, and record blockers/next steps in the remote before stopping
- Preserve the local fast path for trivial tasks — do not dispatch agents or load memory when current context already suffices
- Avoid silent agent failures — always check git state before dispatching background agents

**Quality**
- No `any` in TypeScript — use typed alternatives
- Validate user-provided official links before using them in documentation or code

---

## Vault Index

| Path | Content |
|---|---|
| `home.md` | Vault dashboard — links to all major areas, active projects, recent sessions |
| `conventions.md` | Global conventions: language, naming, module structure |
| `knowledge/user-preferences.md` | MOC — 43 active preferences (full index) |
| `knowledge/preferences/` | 43 individual preference files |
| `knowledge/patterns/index.md` | Patterns MOC — 35 patterns grouped by domain (Auth, Backend, Mobile, SSR, Infra, API, Workflow) |
| `knowledge/patterns/` | 35 individual pattern files |
| `knowledge/stacks/index.md` | Stacks MOC — 21 profiles grouped by role (Runtime, Backend, Frontend, Mobile, Infra) |
| `knowledge/stacks/` | 21 tech stack profiles: elysia, prisma, expo, nextjs, postgresql, docker, bun… |
| `knowledge/decisions/` | Cross-project architectural decisions |
| `projects/` | Context bridges for: logbox, LARGO, SIGA, Vultra, ajurdy-custodia-shop |
| `sessions/` | Session logs for multi-phase significant work |

---

## When to Go Deeper

- **Any implementation task** → Tier 1: load `knowledge/user-preferences.md` (mandatory)
- **Recurring project work** → Tier 2: load `projects/{name}/context.md`
- **Specific technical question** → Tier 2: search `knowledge/patterns/` or `knowledge/stacks/{tech}.md`
- **Continuing prior session** → Tier 2: search `sessions/` for recent context
