# Commands Catalog

All built-in slash commands available in Claude Code. Custom commands appear in `/help` alongside these.

---

## Quick Reference

| Command | Category | Purpose |
|---|---|---|
| `/help` | Meta | Show all available commands |
| `/clear` | Session | Clear conversation history |
| `/compact` | Session | Compress history to save context |
| `/exit` | Session | End the session |
| `/model` | Config | Switch the model |
| `/effort` | Config | Set effort level (low/medium/high/max) |
| `/fast` | Mode | Toggle Fast mode (Opus with faster output) |
| `/plan` | Mode | Enter plan mode (ExitPlanMode required to proceed) |
| `/loop` | Mode | Enter autonomous dynamic loop |
| `/ultrareview` | Mode | Launch multi-agent cloud review |
| `/ultraplan` | Mode | Launch multi-agent planning |
| `/diff` | Git | Show diff vs base branch |
| `/rewind` | Git | Undo last change |
| `/resume` | Session | Resume a previous session |
| `/agents` | Agents | List or manage running agents |
| `/background` | Agents | Run current task in background |
| `/skills` | Config | List available skills |
| `/memory` | Config | View or edit memory |
| `/hooks` | Config | View or manage hooks |
| `/mcp` | Config | View or manage MCP servers |
| `/permissions` | Config | View or change permission settings |
| `/sandbox` | Config | Toggle sandboxed execution |
| `/doctor` | Diagnostics | Check Claude Code installation health |
| `/init` | Project | Initialize Claude Code in a project |
| `/review` | Code | Request a code review |
| `/security-review` | Code | Run a security-focused review |
| `/simplify` | Code | Simplify selected or described code |
| `/run` | Execution | Execute a command or script |
| `/verify` | Testing | Verify tests pass |
| `/debug` | Diagnostics | Debug an issue |
| `/schedule` | Automation | Schedule a future task |
| `/teleport` | Navigation | Jump to a file or symbol |
| `/context` | Context | Show or set context |
| `/goal` | Context | Set or view the current goal |
| `/btw` | Communication | Add a note alongside the main task |
| `/export` | Output | Export conversation or output |
| `/copy` | Output | Copy output to clipboard |
| `/rename` | Session | Rename the current session |
| `/keybindings` | Config | View or customize keybindings |
| `/batch` | Execution | Run multiple tasks in batch |

---

## Bundled Skills (Slash-Invocable)

These commands are implemented as bundled skills rather than hardcoded built-ins. They appear as `/command` but are defined in the Claude Code distribution as skill files:

| Command | What it does |
|---|---|
| `/batch` | Runs multiple Claude Code tasks in parallel |
| `/claude-api` | Helper for building with the Claude API |
| `/debug` | Step-by-step debugging workflow |
| `/fewer-permission-prompts` | Guidance on reducing permission interruptions |
| `/loop` | Dynamic autonomous loop with ScheduleWakeup |
| `/run` | Execute a file, script, or shell command |
| `/run-skill-generator` | Generate a new skill from a description |
| `/simplify` | Simplify code, reducing complexity |
| `/verify` | Verify that tests pass and behavior is correct |

---

## Mode Commands

### `/fast`

Toggles Fast mode. In Fast mode, Claude Code uses Claude Opus with faster response generation. Does not downgrade to a smaller model — this is a latency optimization, not a capability reduction.

Toggle with `/fast`. Current mode is shown in the status line.

---

### `/plan`

Enters plan mode. In plan mode:
1. Claude analyzes the task and writes a plan
2. Claude calls `ExitPlanMode` to surface the plan for approval
3. You review and approve (or provide feedback)
4. Claude executes only after your approval

Plan files are saved at `~/.claude/plans/` for the duration of the session. See [context-management.md](../core/context-management.md) for plan mode mechanics.

---

### `/loop`

Enters the autonomous dynamic loop. Claude uses `ScheduleWakeup` to self-pace between iterations. The loop continues until explicitly stopped or until the sentinel condition resolves.

Pass a task description: `/loop refactor all tests to use the new fixture pattern`

See [context-management.md](../core/context-management.md) for the `<<autonomous-loop-dynamic>>` sentinel.

---

### `/ultrareview`

Launches a multi-agent cloud review. Works on the current branch or a PR:
- `/ultrareview` — reviews the current local branch against main
- `/ultrareview 42` — reviews GitHub PR #42

Requires a git repository. For the no-arg form, a GitHub remote is not required (local branch is bundled). This is user-triggered and billed separately.

---

### `/ultraplan`

Launches a multi-agent planning workflow for complex, multi-domain tasks. Produces a comprehensive execution plan with agent assignments and skill stacks per sub-task.

---

## Git Commands

### `/diff`

Shows the diff between the current branch and the base branch. Useful for reviewing what changed before committing or creating a PR.

---

### `/rewind`

Undoes the most recent change made in the session. For file edits: restores the previous version. For shell commands: reports what was run (cannot undo shell side effects).

---

## Diagnostic Commands

### `/doctor`

Checks Claude Code installation health:
- Node.js and npm version compatibility
- CLI binary integrity
- MCP server connectivity
- Hook script permissions and syntax
- Settings file validity

Run this when Claude Code is behaving unexpectedly.

---

## Session Commands

### `/compact`

Compresses the current conversation history. Claude summarizes prior context to free up the context window while preserving the essential state. The summary replaces the raw transcript in the active context.

Use when the context gauge (`ctx:N%`) in the status line is approaching 100%.

---

### `/resume`

Resume a previous session. Shows a list of recent sessions and lets you select one to continue. Session state includes the conversation transcript and any pending tasks.

---

## Project Commands

### `/init`

Initialize Claude Code in a project. Creates `.claude/` directory structure and optionally runs the bootstrap flow (equivalent to `/bootstrap-project`). Safe to run on existing projects — does not overwrite existing files.

---

## Related

- [commands/commands-overview.md](commands-overview.md) — command format, discovery, `$ARGUMENTS`
- [commands/custom-commands.md](custom-commands.md) — the 4 global custom commands
- [core/context-management.md](../core/context-management.md) — plan mode, /loop, /compact internals
- [skills/skills-catalog.md](../skills/skills-catalog.md) — skills invocable as commands
