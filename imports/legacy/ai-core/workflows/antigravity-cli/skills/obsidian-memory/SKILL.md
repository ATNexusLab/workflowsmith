---
name: obsidian-memory
description: Use to read from or write to the Obsidian vault as cross-project memory only when local context is insufficient or there is real continuity value.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
---

# Obsidian Memory

## When to Use

- Retrieve context from a previous session that is not available in the current conversation
- Store a decision, architecture note, or constraint that must persist across sessions
- Look up a preference, convention, or project-specific standard that was previously recorded
- Record a significant outcome that will need to be referenced in future work

## When NOT to Use

- For information already present in the current conversation context
- For temporary notes that do not need to persist beyond this session
- For storing code — store code in the repository, not in the vault
- For information that belongs in a project file (README, ADR, CONTRIBUTING)

## Prerequisite

The Obsidian MCP server must be running and connected. Verify connectivity before any read or write operation:

```
Vault path: /mnt/storage/obsidian/brain
MCP config: ~/.copilot/mcp-config.json
```

## Vault Structure

```
brain/
├── projects/       ← Per-project context, decisions, and constraints
├── people/         ← Collaborator preferences and working agreements
├── references/     ← Reusable standards, templates, and guides
├── sessions/       ← Session logs with significant decisions
└── inbox/          ← Quick capture; reviewed and filed regularly
```

## Reading from the Vault

### Look up a project note

```
obsidian-get_note_content
  vault: brain
  path: projects/{project-name}.md
```

### Search for relevant notes

```
obsidian-search_vault
  vault: brain
  query: {relevant terms}
```

### List notes in a directory

```
obsidian-list_notes
  vault: brain
  path: projects/
```

## Writing to the Vault

### Append to an existing note

Use `append` when adding to a log, decision record, or session note that already exists:

```
obsidian-append_to_note
  vault: brain
  path: projects/{project-name}.md
  content: |
    ## {date} — {topic}

    {content}
```

### Create a new note

Use `create` only when no relevant note exists. Check with `list_notes` or `search_vault` first:

```
obsidian-create_note
  vault: brain
  path: projects/{project-name}.md
  content: |
    # {Project Name}

    ## Context

    {description}

    ## Decisions

    ## Constraints

    ## Notes
```

### Update an existing note

Use `update` only when replacing outdated content (not for appending):

```
obsidian-update_note
  vault: brain
  path: projects/{project-name}.md
  content: {full updated content}
```

## What to Store

**Store:**
- Architecture decisions that affect how a project is structured
- Preferences or conventions agreed upon for a project or collaborator
- Constraints (technical, business, legal) that are non-obvious
- Access patterns, tooling notes, or project-specific quirks
- Sessions with **unresolved pending items** (blocker, deferred work, multi-machine handoff) — only when the outcome cannot be captured in a project or preference note

**Do not store:**
- Raw conversation transcripts
- Temporary hypotheses that were rejected
- Code snippets (belong in the repository)
- Information that is already in project documentation
- Sessions that completed cleanly with all learnings captured in project or preference notes

## Cleanup Protocol — Sessions

Run **before writing a new session log** to `brain/sessions/`. Delete any session note that meets ALL of:

1. All pending items listed in the session are now resolved
2. All learnings are captured in stable notes (`projects/`, `references/`, or preference entries)
3. No active project references it as a required continuation point

**Delete** (do not archive) — git history preserves the content if ever needed.

Hard limit: `brain/sessions/` holds at most **8 session notes**. At the limit, cleanup is mandatory before adding a new one.

If after cleanup the new session also has no pending items → **skip writing it entirely**. Stable notes are sufficient.

## Note Format

Notes should be concise and structured for future retrieval, not narrative:

```markdown
# {Project or Topic Name}

## Context
One to three sentences: what this is and why it matters.

## Decisions
- {Decision}: {brief rationale}
- {Decision}: {brief rationale}

## Constraints
- {Constraint and source}

## Notes
- {date}: {observation or update}
```

## Protocol

1. **Before reading:** confirm the information is not already in the current context
2. **Before writing:** confirm this has real continuity value (will it matter in a future session?)
3. **After reading:** summarize what was retrieved and how it affects the current task
4. **After writing:** confirm the path and summarize what was stored

## Never Do

- Write to the vault without verifying the MCP server is connected
- Overwrite an existing note with `update` when `append` is the right operation
- Store information that belongs in the project repository
- Read the entire vault when a targeted search or path lookup is sufficient
