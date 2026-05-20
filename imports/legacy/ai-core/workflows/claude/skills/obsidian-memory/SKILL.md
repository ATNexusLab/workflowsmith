---
name: obsidian-memory
description: "Use to read from or write to the Obsidian vault as cross-project memory only when local context is insufficient or there is real continuity value."
when_to_use: >
  Use when reading from or writing to the Obsidian vault, persisting cross-project knowledge, or recovering context from previous sessions or projects.
---

# Obsidian Memory

Personal **cross-project** memory — not a log of everything. Invoke it **on demand**, with judgment.

It comes **after** local context and relevant repository docs; it does not replace `README.md`, `docs/`, ADRs, runbooks, or other canonical project sources.
It also does not replace the active domain skill. Treat memory as an additive context layer that can
compose with other skills when historical continuity is genuinely needed.

## Prerequisite

Vault access uses the **Obsidian Local REST API plugin** via two channels, both configured in `~/.copilot/mcp-config.json`:

| Channel | Use | How |
|---|---|---|
| MCP `obsidian` server | Reads and searches | Tool calls below |
| REST API (curl) | Writes, directory listing | HTTP to `https://127.0.0.1:27124`; `-k` required (self-signed cert) |

**Reads and searches** — MCP tool calls:

| Tool | Purpose |
|---|---|
| `obsidian-get_note_content(filePath)` | Read a note by vault-relative path |
| `obsidian-obsidian_search(query)` | Keyword search across the vault |
| `obsidian-obsidian_semantic_search(query)` | Conceptual / semantic search |

**Write template** (create or overwrite a note):

```bash
OBSIDIAN_API_KEY=$(python3 -c "import json; print(json.load(open('/home/theo/.copilot/mcp-config.json'))['mcpServers']['obsidian']['env']['API_KEY'])")

curl -s -k -X PUT \
  -H "Authorization: Bearer $OBSIDIAN_API_KEY" \
  -H "Content-Type: text/markdown" \
  --data-binary @- \
  "https://127.0.0.1:27124/vault/{vault-relative-path}" <<'EOF'
{markdown content}
EOF
```

If the API is unavailable, use **graceful degradation** — continue without memory and do not block the task.

---

## Philosophy: Lean Vault > Bloated Vault

A vault with 50 dense, well-linked notes is more valuable than one with 5,000 disposable session logs. This skill exists to **add durable value** to long-term knowledge, not to record everything.

**Before writing, ask:**
1. Does this information matter **beyond this task**?
2. Does it cross **multiple projects**, or is it specific to one repository?
3. Six months from now, will I want to find this again?

If the answer is "no" to any of them: **do not write to the vault**.

---

## Documentation Mirroring Rule (Critical)

> Important documentation for a **project** belongs in the **project repository** — never only in Obsidian.

| Information type | Correct home | Why |
|---|---|---|
| README, CONTRIBUTING, API docs | **Repo** (`README.md`, `docs/`) | Anyone who clones the repo needs it |
| Project ADRs / Tech Specs | **Repo** (`docs/decisions/`, `docs/adr/`) | The decision belongs to the codebase |
| Runbooks, CHANGELOG | **Repo** | Team members and CI rely on them |
| Project onboarding | **Repo** | New contributors clone the repo, not your vault |
| Cross-project learned patterns | **Obsidian** (`knowledge/patterns/`) | Useful across repositories |
| Personal stack preferences | **Obsidian** (`knowledge/preferences/`) | Personal and cross-project |
| Cross-project decisions (for example, "always use Bun") | **Obsidian** (`knowledge/decisions/`) | Not owned by a single repo |
| Significant task session log | **Obsidian** (`sessions/`) | Personal continuity memory |

**Golden rule:** if the information is useful to anyone who clones the repo, it belongs in the **repo**. If it only makes sense as personal continuity across repos, it belongs in **Obsidian**. **Do not duplicate content.**

When project documentation is about to be written into the vault: stop and redirect it to the repository. If there is still genuine cross-project discovery value, add only a minimal note in the vault that points to the repository path.

---

## Observability and Composition

When the memory decision materially affects the task, make it inspectable with a compact line such
as:

```text
Memory: used <scope/reason> | skipped — <reason>
```

If the same task also involved repo-doc checks or routed domain skills, keep those visible in the
shared observability note rather than inventing a separate ritual. For trivial fast-path work, skip
the note and skip the vault.

This skill composes with other skills; it is normal to load `obsidian-memory` alongside the
baseline domain skill when local docs were not enough. Do not force a one-skill-only interpretation
of the task.

---

## Read Protocol

Two-tier gate. Execute in this order and stop as soon as sufficient context is available.

**Tier 1 (Preference Gate — MANDATORY for non-trivial tasks):**
Load `knowledge/user-preferences.md` before any non-trivial task — implementation, architecture decisions, multi-file changes, technical choices. This is not conditional. It is how agent behavior stays aligned with accumulated user preferences every session. Skip only for trivial fast-path work (single-line edits, quick lookups, pure explanations).

**Tier 2 (Context Gate — LAZY):**
Load project context, sessions, patterns, or stacks only when at least one condition is true after preferences are loaded:

1. Local context and repo docs are **still insufficient** after reading preferences
2. The work is in a **recurring project** and the repo does not explain the needed rationale or continuity
3. A technical decision needs **history** from previous choices or learned patterns not in the repo
4. The user **explicitly asks** for memory ("remember what we did in X")

If none apply for Tier 2: skip it. Work from preferences + available context.

### Read Hierarchy (stop when sufficient)

Execute in order and stop as soon as enough context is available.

#### Step 1 — User preferences (MANDATORY for non-trivial tasks)

Call `obsidian-get_note_content("knowledge/user-preferences.md")`.

Load this at the start of ANY non-trivial task — implementation, architecture decisions, multi-file changes, technical choices. This is not conditional on recognizing a specific decision moment. It is how agent behavior stays aligned with accumulated preferences every session. Skip only for trivial fast-path work.

#### Step 2 — Project context (for recurring projects)

Call `obsidian-get_note_content("projects/{project-name}/context.md")`.

If the tool returns an error (file not found), skip this step. Reach this step only after consulting the relevant repository docs. Do not create project context casually — most project context belongs in the **repo**, not in the vault.

#### Step 3 — Keyword search (for a specific technical topic)

Call `obsidian-obsidian_search("{keyword}")`.

For each result, call `obsidian-get_note_content(filePath)` and load the full note only if it is relevant.

#### Step 4 — Recent session (for explicit continuation)

Call `obsidian-obsidian_search("{project-name} OR {topic}")` to find the most recent sessions about the project or topic.

For each matching path in `sessions/`, call `obsidian-get_note_content(filePath)`. Use this only when the user signals continuation or the current task clearly extends previous work.

---

## Write Protocol (High Value Only)

### Write only in these situations

| Event | Where | When |
|---|---|---|
| A user preference is identified (correction, explicit rule, "always do X") | `knowledge/preferences/{slug}.md` | Immediately — do not forget |
| A technical pattern repeats across multiple projects | `knowledge/patterns/{slug}.md` | Once the pattern is recognized |
| A technical decision matters beyond the current project (for example, "always use Bun", "avoid X with Y") | `knowledge/decisions/{slug}.md` | When the cross-project decision is made |
| A stack insight changes how a technology should be used | `knowledge/stacks/{tech}.md` | When discovered |
| A session has **unresolved pending items** (blocker, deferred work, multi-machine handoff) that cannot be captured in a preference/pattern/stack note | `sessions/YYYY-MM-DD-{slug}.md` | **Once** at the end, condensed — only if pending items exist |

### Do not write to the vault

- In-task status updates ("started X", "agent Y returned")
- Task plans (use the session `plan.md`)
- Individual helper outputs
- Logs for trivial tasks
- Sessions that completed cleanly with all learnings in permanent notes — write to preferences/patterns/stacks instead
- Documentation that belongs in the **repo** (see Documentation Mirroring Rule)
- Full code, large diffs, or file dumps
- Compiled, generated, or build artifacts

---

## Cleanup Protocol — Sessions

Run **before writing a new session log**. Delete any session in `sessions/` that meets ALL of:

1. All pending items listed in the session are now resolved
2. All learnings are captured in stable notes (`preferences/`, `patterns/`, `stacks/`)
3. No active project references it as a required continuation point

**Delete** (do not archive) — git history preserves the content if ever needed.

Hard limit: `sessions/` holds at most **8 sessions**. At the limit, cleanup is mandatory before adding a new one.

If after cleanup the new session also has no pending items → **skip writing it entirely**. Stable notes are sufficient.

---

## Pre-Write Deduplication

**Required before creating a cross-project `preference`, `pattern`, `stack-node`, or `decision`.**

Call `obsidian-obsidian_search("{keyword1} {keyword2}")`.

For each result returned, call `obsidian-get_note_content(filePath)` to read the frontmatter and confirm relevance.

| Situation | Action |
|---|---|
| A file already covers the **same topic** | **Update** it — never create a duplicate |
| A file is **related but distinct** | Create a new one and add cross-links |
| Nothing related exists | Create it normally |

> When in doubt, **updating is safer than creating**. Duplicates fragment the knowledge graph.

---

## WikiLink Protocol

Every note written here should include WikiLinks to related notes. That is what turns the vault into a graph instead of a folder of isolated text files.

### Syntax

```markdown
[[file-name-without-extension]]
```

Obsidian resolves links by file name, regardless of directory.

### Minimum links by note type

| File | Required links |
|---|---|
| `sessions/` | Involved project, main technologies, generated preferences or decisions |
| `knowledge/preferences/` | Related technology, origin session |
| `knowledge/patterns/` | Involved technologies, projects where the pattern appears |
| `knowledge/stacks/` | Related patterns and preferences |
| `knowledge/decisions/` | Involved technologies, related preferences |

**Do not link to files that do not exist.** Create the target note first.

---

## Templates

### Session log (significant task only)

`sessions/YYYY-MM-DD-{slug}.md`

```yaml
---
type: session
status: completed
summary: "{one line — what was done and what knowledge changed}"
tags: [{tags}]
date: YYYY-MM-DD
---
```

Content (short, condensed):
- What was done (1-3 lines)
- Decisions, preferences, or patterns generated (with WikiLinks)
- Blockers or pending continuation

### Preference

`knowledge/preferences/{slug}.md`

```yaml
---
type: preference
status: active
summary: "Rule: {one clear line}"
tags: [{tech-or-domain}]
date: YYYY-MM-DD
origin-session: [[YYYY-MM-DD-slug]]
---
```

```markdown
# {Title}

## Rule
{What to ALWAYS or NEVER do — without ambiguity}

## Origin
{What produced it — correction, conscious decision, observed pattern}

## Related
- [[stack-node]]
- [[related-pattern]]
```

After creating it, add `[[{slug}]]` to `knowledge/user-preferences.md` (the central MOC).

### Technical pattern

`knowledge/patterns/{slug}.md`

```yaml
---
type: pattern
status: active
summary: "{one-line description}"
tags: [{techs}]
date: YYYY-MM-DD
origin-session: [[YYYY-MM-DD-slug]]
---
```

### Cross-project decision

`knowledge/decisions/{slug}.md`

```yaml
---
type: decision
status: active
summary: "{one-line decision}"
tags: [{techs}]
date: YYYY-MM-DD
---
```

> A decision **inside** one project belongs in the **repo** (`docs/decisions/`), not here.

### Stack node

`knowledge/stacks/{tech}.md`

```yaml
---
type: stack-node
status: active
summary: "{tech} — versions, patterns, known gotchas"
tags: [{tech}]
date: YYYY-MM-DD
---
```

---

## Frontmatter Schema

```yaml
---
type: session | preference | pattern | decision | stack-node | moc
status: active | archived | completed
summary: "One line — enough to discover the note without opening it"
tags: [tag1, tag2]
date: YYYY-MM-DD
origin-session: [[session-slug]]   # required for preference and pattern; optional elsewhere
---
```

---

## Graceful Degradation

If any vault operation fails (vault unavailable, file missing, permission denied):

1. Log: `obsidian-memory: [operation] failed — [reason]`
2. Continue without blocking the task
3. Never surface a fatal task failure because memory failed

The vault is support infrastructure. It does not block the work.

## Validation Checklist

- [ ] Repo docs were checked before reading the vault when they could constrain the task
- [ ] The vault was skipped silently on trivial fast-path work
- [ ] Any memory use stopped as soon as enough context was available
- [ ] Memory was treated as additive context, not as a replacement for the active domain skill
- [ ] The memory decision is visible when material and omitted when trivial
