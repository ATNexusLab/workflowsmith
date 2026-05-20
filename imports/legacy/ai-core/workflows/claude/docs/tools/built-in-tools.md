# Built-in Tools

All tools available to Claude Code in the main session. Agents receive a subset (see [agents/agents-overview.md](../agents/agents-overview.md)). MCP tools are additive and named `servername-toolname`.

---

## File System Tools

### `Read`

Read a file from the local filesystem.

```
Read(file_path, limit?, offset?)
```

| Parameter | Type | Description |
|---|---|---|
| `file_path` | string | Absolute path to file |
| `limit` | number | Max lines to read (optional) |
| `offset` | number | Start line number (optional, 0-indexed) |

**Supports:** Text files, images (PNG/JPG/etc.), PDFs (use `pages` parameter for large PDFs — max 20 pages per call), Jupyter notebooks (`.ipynb`).

**Output format:** `cat -n` style with line numbers. Line number prefix is stripped when using in Edit's `old_string`.

**Notes:**
- Use `limit` + `offset` for large files to avoid context overflow
- Reading an image shows the image visually (multimodal)
- PDFs: use `pages: "1-5"` for page ranges; reading a large PDF without pages fails

---

### `Write`

Write a file to the local filesystem. Creates parent directories if needed.

```
Write(file_path, content)
```

**Overwrites** any existing file at the path. Must `Read` the file first if it exists (enforced by the harness).

**When to use:** Creating new files, or complete rewrites. For partial edits, prefer `Edit`.

---

### `Edit`

Replace a specific string in an existing file.

```
Edit(file_path, old_string, new_string, replace_all?)
```

| Parameter | Type | Description |
|---|---|---|
| `file_path` | string | Absolute path |
| `old_string` | string | Exact text to replace |
| `new_string` | string | Replacement text |
| `replace_all` | boolean | Replace every occurrence (default: false) |

**Requirements:**
- `old_string` must be unique in the file, or `replace_all: true` must be set
- Must `Read` the file first (at least once in the conversation)
- Preserves exact indentation — match whitespace exactly as shown in Read output

**When to use:** Targeted edits to existing files. More efficient than Write for partial changes (sends only the diff).

---

### `Glob`

Find files matching a glob pattern.

```
Glob(pattern, path?)
```

| Parameter | Type | Description |
|---|---|---|
| `pattern` | string | Glob pattern (e.g., `**/*.ts`, `src/routes/**`) |
| `path` | string | Base directory to search from (default: cwd) |

Returns matching file paths. Respects `.gitignore` by default.

---

### `Grep`

Search file contents for a pattern.

```
Grep(pattern, path?, include?, flags?)
```

| Parameter | Type | Description |
|---|---|---|
| `pattern` | string | Regex or literal search pattern |
| `path` | string | Directory or file to search |
| `include` | string | File glob filter (e.g., `*.ts`) |
| `flags` | string | Grep flags (e.g., `-i` for case-insensitive) |

Returns file paths with matching lines and line numbers.

---

## Shell Tool

### `Bash`

Execute a shell command.

```
Bash(command, timeout?, run_in_background?)
```

| Parameter | Type | Description |
|---|---|---|
| `command` | string | Shell command to run |
| `timeout` | number | Milliseconds before kill (max: 600000 / 10 min) |
| `run_in_background` | boolean | Run without waiting for output |

**Notes:**
- Working directory persists between calls, but shell state does not (no `export` between calls)
- `run_in_background: true` — Claude is notified when the command completes; do not poll
- Shell is initialized from the user's profile (zsh or bash)
- Quote paths with spaces: `"path with spaces/file.txt"`

**Sandbox mode:** When enabled (via `/sandbox` or `--sandbox`), Bash runs in a restricted container. Some commands are unavailable.

---

## Agent Tool

### `Agent`

Spawn a sub-agent to handle a task.

```
Agent(description, prompt, subagent_type?, isolation?, model?, run_in_background?)
```

| Parameter | Type | Description |
|---|---|---|
| `description` | string | 3-5 word summary of the task |
| `prompt` | string | Full task briefing for the agent |
| `subagent_type` | string | `engine`, `creative`, `principal`, `claude`, `Explore`, etc. |
| `isolation` | string | `"worktree"` to run in an isolated git worktree |
| `model` | string | Override the model (`sonnet`, `opus`, `haiku`) |
| `run_in_background` | boolean | Run without blocking the main session |

**Isolation modes:**
- No isolation (default): agent shares the working directory
- `"worktree"`: agent gets its own git worktree; branch and path returned on completion; automatically cleaned up if no changes made

Agents do not share context with the parent session — their prompt must be self-contained.

See [agents/agents-overview.md](../agents/agents-overview.md) for agent usage patterns.

---

## Web Tools

### `WebFetch`

Fetch content from a URL.

```
WebFetch(url, prompt?)
```

| Parameter | Type | Description |
|---|---|---|
| `url` | string | URL to fetch |
| `prompt` | string | What to extract from the page |

Returns page content as text. Follows redirects. For large pages, `prompt` helps extract just the relevant portion.

---

### `WebSearch`

Search the web.

```
WebSearch(query)
```

Returns search results with titles, URLs, and excerpts.

---

## Notebook Tools

### `NotebookRead`

Read a Jupyter notebook (`.ipynb`). Returns all cells with outputs, combining code, text, and visualizations. Also available via the `Read` tool on `.ipynb` files.

---

### `NotebookEdit`

Edit a Jupyter notebook cell.

```
NotebookEdit(file_path, cell_index, new_source, cell_type?)
```

| Parameter | Type | Description |
|---|---|---|
| `file_path` | string | Path to `.ipynb` file |
| `cell_index` | number | 0-based cell index |
| `new_source` | string | New cell content |
| `cell_type` | string | `code` or `markdown` |

---

## Tool Selection Guide

| Task | Preferred tool |
|---|---|
| Read a known file | `Read` |
| Find files by name/pattern | `Glob` |
| Search for a string in files | `Grep` |
| Edit a specific section | `Edit` |
| Create a new file | `Write` |
| Run a build/test/lint command | `Bash` |
| Fetch official documentation | `WebFetch` |
| Look up an API or library | `WebSearch` |
| Delegate a complex sub-task | `Agent` |

**Prefer dedicated tools over Bash:** `Read` > `cat`, `Edit` > `sed`, `Grep` > `grep via Bash`, `Write` > `echo >`. Dedicated tools provide better user-facing display and permission handling.

---

## Related

- [tools/task-tools.md](task-tools.md) — TaskCreate, Monitor, CronCreate, ScheduleWakeup, and other session management tools
- [agents/agents-overview.md](../agents/agents-overview.md) — how the Agent tool works, sub-agent types
- [mcp/mcp-overview.md](../mcp/mcp-overview.md) — MCP tools added by external servers
