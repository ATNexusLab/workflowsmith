<!-- topic: discovery-and-precedence | section: skills -->
# Discovery and Precedence

## Quick Reference

> - Antigravity CLI discovers skills across four tiers: built-in, extension, user-global, and workspace.
> - Higher tiers win over lower tiers: workspace overrides user, user overrides extension, extension overrides built-in.
> - Within user and workspace tiers, `.agents/skills/` overrides `.gemini/skills/`.
> - Discovery only makes a skill available for use; activation/loading is separate, and mentioning a skill by name is not activation.
> - Workspace skills are untrusted by default and require `/trust` before activation.
> - Trust is session-scoped, so you must re-grant it in each new session.

## Discovery Tiers

Antigravity CLI resolves skills from four discovery tiers. Higher tiers override lower tiers when they define the same skill name.

| Precedence | Tier | Location |
|---|---|---|
| 1 (lowest) | Built-in | Bundled with the Antigravity CLI binary |
| 2 | Extension | `~/.gemini/extensions/<ext>/skills/<name>/SKILL.md` |
| 3 | User-global | `~/.gemini/skills/<name>/SKILL.md` or `~/.agents/skills/<name>/SKILL.md` |
| 4 (highest) | Workspace | `.gemini/skills/<name>/SKILL.md` or `.agents/skills/<name>/SKILL.md` |

## Tier Precedence Rules

The main precedence rule is simple: higher tier wins.

| Conflict | Winner |
|---|---|
| Workspace vs. user-global | Workspace |
| User-global vs. extension | User-global |
| Extension vs. built-in | Extension |

If two tiers define a skill with the same `name`, Antigravity CLI uses the higher-tier version.

## Precedence Within the Same Tier

User-global and workspace tiers each support two directory roots. Within those tiers, the `.agents/skills/` variant has higher precedence than the `.gemini/skills/` variant.

| Tier | Lower-precedence path | Higher-precedence path |
|---|---|---|
| User-global | `~/.gemini/skills/` | `~/.agents/skills/` |
| Workspace | `.gemini/skills/` | `.agents/skills/` |

That means these rules apply:

- Within the user-global tier, `~/.agents/skills/` takes precedence over `~/.gemini/skills/`.
- Within the workspace tier, `.agents/skills/` takes precedence over `.gemini/skills/`.
- Cross-tier conflicts still follow the main rule that the higher tier wins first.

## Name Collisions

Discovery is resolved by skill `name`, not just by directory path. If multiple discovered files publish the same skill name, Antigravity CLI selects the version from the highest-precedence location.

This lets you intentionally override a built-in or user-global skill with a workspace-specific implementation, as long as the overriding file declares the same `name`.

## Discovery vs. Activation

Discovery answers **where Antigravity CLI can find a skill**. Activation/loading answers **whether that skill is actually brought into the current session**.

A discovered skill can remain inactive for the whole session. Antigravity CLI must still activate or load it before the skill affects behavior, and mentioning the skill by name in conversation is not activation.

## Workspace Trust

Workspace skills are untrusted by default. Antigravity CLI will not activate them until the current workspace has been trusted.

### What `/trust` Does

The `/trust` command marks the current workspace as trusted for the active session. After that, Antigravity CLI may activate workspace skills from `.gemini/skills/` or `.agents/skills/` in that workspace.

`/trust` only removes the workspace trust gate. It does not load any skill by itself.

### Trust Scope

Trust is per session. When you start a new Antigravity CLI session, you must run `/trust` again before workspace skills in that repository can be activated.

This rule applies only to workspace skills. Built-in, extension, and user-global skills do not depend on workspace trust.
