<!-- topic: commands-reference | section: skills -->
# Skills Commands Reference

## Quick Reference

> - Use `/skills` or `/skills list` to inspect discovered skills inside the current session.
> - Use `/skills activate <name>` and `/skills deactivate <name>` to manage the current session's active skill set.
> - Use terminal `gemini skills ...` commands to install, update, list, or remove installed skills.
> - There is no `/skills install` slash command; installation is a terminal CLI operation.
> - Workspace skills still require `/trust` before Gemini CLI can activate them.

## In-Session Slash Commands

Use these commands inside an active Gemini CLI session.

| Command | Description |
|---|---|
| `/skills` or `/skills list` | Show all discovered skills with names and descriptions |
| `/skills activate <name>` | Manually activate a skill by name |
| `/skills deactivate <name>` | Remove a skill from current context |

### `/skills` and `/skills list`

These commands list the skills Gemini CLI has discovered and show their descriptions. Use them to confirm that a skill is available and to inspect the text Gemini CLI may use for auto-activation decisions.

### `/skills activate <name>`

This command manually loads a skill into the current session's context by name.

```text
/skills activate web-research
```

### `/skills deactivate <name>`

This command removes an active skill from the current session context without uninstalling it from disk.

```text
/skills deactivate web-research
```

## Terminal CLI Commands

Use these commands in your terminal, outside the in-session slash-command interface.

| Command | Description |
|---|---|
| `gemini skills install <source>` | Install a skill from GitHub or local path |
| `gemini skills list` | List all installed skills |
| `gemini skills uninstall <name>` | Remove an installed skill |
| `gemini skills update <name>` | Update an installed skill |

### Installation and Management Scope

Skill installation and lifecycle management happen through the terminal CLI, not through slash commands. That is why Gemini CLI provides `gemini skills install`, `gemini skills uninstall`, and `gemini skills update` as terminal commands.

There is no `/skills install` slash command.

## Auto-Activation

Gemini CLI may activate a skill automatically when the model decides a skill's `description` matches the user's task. Manual activation is optional when auto-activation already selects the correct skill, but manual activation remains useful when you want to force a specific playbook into context.

## Trust Requirement for Workspace Skills

If the skill you want to activate lives in the current workspace, `/trust` must be granted first. Without workspace trust, Gemini CLI will not activate workspace-defined skills.
