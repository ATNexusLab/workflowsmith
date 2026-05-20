<!-- topic: configuration | section: antigravity-cli -->
# Antigravity CLI Configuration Surfaces

This page explains the configuration and state surfaces that matter when you are customizing Antigravity CLI in this repository during the docs-first migration.

## The important distinction

There are two different categories of surface in this workspace:

1. **Curated configuration and workflow assets** that you intentionally edit
2. **Runtime state and implementation artifacts** that exist because the client runs locally

Do not treat them as the same thing.

Inside `antigravity-cli/`, these categories can now coexist. Keep intentionally authored workflow assets versionable, but continue to ignore live local state such as caches, logs, machine identifiers, lock files, and user-specific settings.

## Local surfaces map

| Surface | Observed path | Role | How to treat it |
|---|---|---|---|
| Global instruction baseline | `~/.gemini/GEMINI.md` | Cross-project instruction layer | Canonical editable workflow surface |
| Custom agents | `~/.gemini/agents/` | Specialist workers | Canonical editable workflow surface |
| Custom skills | `~/.gemini/skills/` | Reusable procedural workflows | Canonical editable workflow surface |
| Local prompt commands | `~/.gemini/commands/` | Repo-local command workflows | Canonical editable workflow surface |
| Human documentation | `~/.gemini/docs/` | Curated reference and migration docs | Canonical documentation surface |
| Antigravity client surface | `~/.gemini/antigravity-cli/` | Mixed authored workflow assets and local runtime state | Keep curated assets portable; ignore live local state |
| Plugin assets | `~/.gemini/config/plugins/` | Installed plugin packages and references | Implementation surface |
| Project registry | `~/.gemini/config/projects/` | Trusted workspace/project metadata | Runtime implementation surface |
| MCP registry | `~/.gemini/config/mcp_config.json` | MCP server configuration surface | Runtime implementation surface |

## Configuration rule of thumb

Use this decision rule when changing the system:

| If you need to change… | Preferred surface |
|---|---|
| Behavior across all sessions | `GEMINI.md`, `skills/`, `agents/`, or `commands/` |
| Human understanding and future adaptation | `docs/antigravity-cli/` or another curated doc page |
| External capability integration | MCP config and corresponding docs |
| Local runtime preferences or client state | Ignored runtime subpaths inside `antigravity-cli/` |

## Known local observations

The migration audit observed:

- mixed authored and runtime surfaces under `antigravity-cli/`
- plugin packages under `config/plugins/`, including `google-antigravity-sdk/`
- project metadata under `config/projects/`

---

## Settings

### Settings file locations and precedence

Antigravity CLI resolves settings from four locations. Higher-precedence files override lower-precedence values.

| Precedence | Path | Role |
|---|---|---|
| 1 (lowest) | `/etc/gemini-cli/system-defaults.json` | System-provided baseline defaults |
| 2 | `~/.gemini/settings.json` | User-level defaults |
| 3 | `.gemini/settings.json` | Project-level overrides |
| 4 (highest) | `/etc/gemini-cli/settings.json` | System-enforced override |

### Context discovery settings

These settings control how Antigravity CLI finds and loads `GEMINI.md` context files.

| Setting | Type | Default | Purpose |
|---|---|---|---|
| `context.fileName` | `string` or `string[]` | `"GEMINI.md"` | Filenames treated as context files; accepts a single string or array |
| `context.includeDirectoryTree` | `boolean` | `true` | Includes a directory tree summary in context discovery output |
| `context.discoveryMaxDirs` | `number` | `200` | Limits how many directories discovery scans |
| `context.memoryBoundaryMarkers` | `string[]` | `[".git"]` | Stops upward traversal when any marker is found |
| `context.includeDirectories` | `string[]` | not set | Adds extra directories to the discovery set |
| `context.loadMemoryFromIncludeDirectories` | `boolean` | `false` | Lets `/memory reload` scan `includeDirectories` for context files |

`context.memoryBoundaryMarkers` defaults to `[".git"]`, which keeps discovery inside a repository boundary. Set it to an empty array only when you intentionally want the CLI to scan upward past repository roots.

`context.includeDirectories` is useful when important context lives outside the current workspace tree. `context.loadMemoryFromIncludeDirectories` must be `true` for those directories to also participate in `/memory reload` refreshes.

### File filtering settings

The `context.fileFiltering` block controls ignore files, file watching, and search behavior. Every setting in this block requires a restart to take effect.

| Setting | Type | Default | Purpose |
|---|---|---|---|
| `context.fileFiltering.respectGitIgnore` | `boolean` | `true` | Honors `.gitignore` during supported file operations |
| `context.fileFiltering.respectGeminiIgnore` | `boolean` | `true` | Honors `.geminiignore` during supported file operations |
| `context.fileFiltering.enableFileWatcher` | `boolean` | `false` | Enables file watching for supported discovery behavior |
| `context.fileFiltering.enableRecursiveFileSearch` | `boolean` | `true` | Enables recursive file search |
| `context.fileFiltering.enableFuzzySearch` | `boolean` | `true` | Enables fuzzy search over candidate files |
| `context.fileFiltering.customIgnoreFilePaths` | `string[]` | not set | Adds extra ignore files to the filtering set |

`customIgnoreFilePaths` is useful when a team maintains shared ignore policies outside the repository. Restart Antigravity CLI after changing any value in this block.

### Other flags

| Setting | Type | Default | Purpose |
|---|---|---|---|
| `ui.hideContextSummary` | `boolean` | `false` | Hides the context summary shown above the input area — does not disable context loading |
| `experimental.autoMemory` | `boolean` | disabled unless set | Enables Auto Memory proposals and the review inbox |

Enable Auto Memory in `settings.json`:

```json
{
  "experimental": {
    "autoMemory": true
  }
}
```

Restart Antigravity CLI after enabling the feature so the experimental behavior is activated for new sessions.

---

## Imports

`GEMINI.md` files support a lightweight import system. Placing an `@path` directive on its own line causes Antigravity CLI to expand and inline the referenced file before building the final prompt context. This is sometimes called the memport mechanism.

### Active policy effect

An imported file is not passive reference material. Once `GEMINI.md` imports another Markdown file, that file's content becomes part of the same active policy for the session. In this repository, the root `GEMINI.md` imports files from `common/` — those files are active policy alongside the root file.

### Import syntax

An import directive must appear on its own line:

```markdown
@./team-style.md
```

If `@...` appears inline with other text, Antigravity CLI does not treat it as an import directive. Import markers inside fenced code blocks are also ignored, which allows documentation to show literal `@file.md` examples.

### Supported path formats

| Path style | Example |
|---|---|
| Relative, same directory | `@./voice.md` |
| Relative, parent directory | `@../shared/rules.md` |
| Relative, subdirectory | `@./prompts/security.md` |
| Absolute path | `@/home/user/.gemini/common/base.md` |

Path resolution starts from the directory of the file that contains the import directive.

### Nested imports and safety controls

Imported files can themselves import other files. Antigravity CLI recursively expands the import tree with two hard safeguards:

| Safeguard | Behavior |
|---|---|
| Circular import detection | Automatically stops loops such as `a.md -> b.md -> a.md` |
| Maximum depth | Stops after 5 import levels |

### Error handling

| Error case | Result |
|---|---|
| Missing file | Import fails and is reported as unresolved |
| Permission error | Import fails and records the filesystem error |
| Circular chain | Cycle is blocked automatically |
| Depth overflow | Expansion stops at the maximum allowed depth |

Failed imports do not silently become empty content. Treat them as configuration problems to fix in the source file tree.

---

## Auto Memory

Auto Memory is an experimental feature that mines completed sessions, extracts candidate long-term facts, and places proposed updates into a review inbox. It never writes directly into memory files.

### How to enable

Set `experimental.autoMemory` to `true` in `settings.json` and restart Antigravity CLI (see the Settings section above for the JSON snippet).

### Session eligibility rules

| Requirement | Threshold |
|---|---|
| Idle time | At least 3 hours |
| Conversation size | At least 10 user messages |

The idle-time rule avoids mining sessions still in progress. The message threshold skips short or low-signal conversations.

### Safety boundaries

Auto Memory is intentionally conservative. It can propose updates only to private project memory, `~/.gemini/GEMINI.md`, and new or existing `SKILL.md` files. It cannot edit active memory files, settings files, credentials, or shared project `GEMINI.md` files in a workspace.

### Inbox review flow

1. Antigravity CLI identifies an eligible past session.
2. The feature mines the session for durable candidate facts.
3. It generates proposed updates within allowed target surfaces.
4. It places those proposals in the review inbox.
5. You open the inbox with `/memory inbox` and review each proposal before accepting or rejecting it.

The inbox is the control point. Auto Memory proposes; you decide.

---

## .geminiignore

`.geminiignore` is a project-level ignore file for Antigravity CLI tools that support Gemini ignore filtering. It is **not** a Git feature and does not affect Git tracking, status, or `.gitignore` behavior.

### Location

Store `.geminiignore` at the root of the project directory. It is evaluated when `context.fileFiltering.respectGeminiIgnore` is enabled (the default).

### Syntax

`.geminiignore` uses `.gitignore` syntax: blank lines are ignored, comments start with `#`, wildcards and recursive wildcards work, and negation with `!` re-includes a previously excluded path.

```gitignore
# Generated output
dist/
coverage/

# Local secrets
.env
secrets/*.json

# Ignore all generated docs except one kept reference
docs/generated/**
!docs/generated/README.md
```

### What it does not affect

- Git tracking — Git still follows `.gitignore`, `.git/info/exclude`, and Git configuration
- Repository contents on disk
- Antigravity CLI tools that do not honor Gemini ignore filtering

### Restart requirement

Changes to `.geminiignore` require an Antigravity CLI restart before updated rules take effect. Treat ignore-file edits the same way as other restart-gated file-filtering settings.
