# Commands — Overview

Slash commands are text shortcuts that invoke pre-written prompts. As of Claude Code 1.x, commands and skills are unified: `.claude/commands/deploy.md` and `.claude/skills/deploy/SKILL.md` both create `/deploy` and work identically. The skills format is recommended for new work; commands continue to work as-is.

---

## Discovery Order

Claude Code discovers slash commands from these locations, in load order:

| Location | Scope | Type |
|---|---|---|
| `~/.claude/commands/` | Global (all projects) | Legacy command files |
| `~/.claude/skills/*/` | Global (all projects) | Skills (recommended) |
| `.claude/commands/` | Project-local | Legacy command files |
| `skills/*/` | Project-local | Skills (recommended) |

Project-local commands take precedence over global ones when names collide. All discovered commands appear in `/help`.

---

## File Format

A command file is a Markdown file with optional YAML frontmatter:

```markdown
---
description: One-line description shown in /help and command pickers
---

The prompt body. This is sent to Claude as the user message when the command is invoked.
Use $ARGUMENTS to interpolate anything the user typed after the command name.
```

Minimum viable command (no frontmatter):

```markdown
Show all TODO and FIXME comments in the codebase with their file and line number.
```

---

## `$ARGUMENTS` Interpolation

`$ARGUMENTS` captures everything typed after the command name:

```
/run-audit src/auth/
```

In the command body:
```markdown
Run a security audit on $ARGUMENTS.
```

Resolves to:
```
Run a security audit on src/auth/.
```

If `$ARGUMENTS` is empty (command invoked with no arguments), the empty string is substituted. Handle this by adding a fallback instruction:

```markdown
Run a security audit on $ARGUMENTS.
If no target is provided, ask the user before proceeding.
```

Additional substitutions available in skills (`.claude/skills/*/SKILL.md`):
- `$ARGUMENTS[N]` — Nth space-separated token
- `$N` — shorthand for `$ARGUMENTS[N]`
- `${CLAUDE_SESSION_ID}` — current session ID
- `${CLAUDE_EFFORT}` — current effort level
- `${CLAUDE_SKILL_DIR}` — absolute path to the skill's directory

---

## Behavior at Invocation

When a command is run:
1. The frontmatter is stripped; only the body is sent as the user message
2. `$ARGUMENTS` is substituted with the literal text after the command name
3. The prompt is executed in the current session context

Commands do not start a new session. They run within the existing conversation, with full access to prior context.

---

## Skills vs Commands vs CLAUDE.md

| Need | Where |
|---|---|
| Reusable prompt with `$ARGUMENTS` interpolation | `.claude/commands/` or `skills/*/SKILL.md` |
| Domain-specific procedural knowledge invoked automatically | `~/.claude/skills/*/SKILL.md` |
| Always-on global rule (applies to every session) | `~/.claude/CLAUDE.md` |
| File-type convention (applies when matching files are touched) | `.claude/rules/<topic>.md` |

---

## Special Built-in Modes

These are built-in commands that change Claude Code's execution mode:

| Command | Effect |
|---|---|
| `/fast` | Toggle Fast mode — uses Claude Opus with faster output |
| `/loop` | Enter dynamic autonomous loop with self-paced wakeups |
| `/plan` | Enter plan mode — Claude uses ExitPlanMode to request approval |
| `/compact` | Compact conversation history to save context |
| `/ultrareview` | Launch multi-agent cloud review of the current branch |
| `/ultraplan` | Launch multi-agent planning for complex tasks |

---

## Related

- [commands/custom-commands.md](custom-commands.md) — full annotation of all 4 global custom commands
- [commands/commands-catalog.md](commands-catalog.md) — complete built-in command catalog
- [skills/skills-overview.md](../skills/skills-overview.md) — skills as the recommended replacement
- [skills/skill-format.md](../skills/skill-format.md) — extended frontmatter for skills
