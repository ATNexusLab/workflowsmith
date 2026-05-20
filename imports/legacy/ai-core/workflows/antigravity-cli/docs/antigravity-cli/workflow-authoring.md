<!-- topic: workflow-authoring | section: antigravity-cli -->
# Antigravity Workflow Authoring

This is the canonical page for deciding **where new workflow behavior belongs** in this repository.

## Quick Reference

> - Put new user-facing guidance in `docs/`; this is the canonical documentation source of truth.
> - Put saved command shortcuts in `commands/`.
> - Put reusable procedure and judgment in `skills/`.
> - Put isolated specialist execution in `agents/`.
> - Use hooks, MCP, extensions, and settings when the behavior is integration, automation, packaging, or runtime configuration rather than authored workflow content.
> - If workflow assets are intentionally migrated into `antigravity-cli/`, keep them in curated versioned subpaths and keep adjacent local runtime state ignored.

## Choose the right surface

| If you are adding… | Put it here | Use it when… | Deep reference |
|---|---|---|---|
| Canonical user-facing guidance | `docs/` | The behavior needs a stable explanation for humans | [index.md](index.md), [runtime-and-plugin-surfaces.md](runtime-and-plugin-surfaces.md) |
| A reusable command shortcut or kickoff flow | `commands/<name>.md` | A human should be able to start a repeatable flow quickly | [../reference/slash-commands.md](../reference/slash-commands.md) |
| Reusable method, checklist, or judgment | `skills/<skill>/SKILL.md` | The model needs procedure, not a separate worker | [../skills/index.md](../skills/index.md) |
| A specialist worker with isolated execution | `agents/<name>.md` | The work needs its own context, tools, or routing target | [../agents/index.md](../agents/index.md) |
| Event-driven policy or automation | hook configuration + hook program | The behavior should run on session, tool, or notification events | [../hooks/index.md](../hooks/index.md) |
| External tools or resources | MCP configuration and server | The model needs capabilities from another system | [../mcp/index.md](../mcp/index.md) |
| A distributable bundle | extension manifest and packaged assets | Multiple surfaces should ship together | [../extensions/index.md](../extensions/index.md) |
| Runtime preferences or trust/config policy | `settings.json`, env vars, runtime config | You are changing how the client runs, not authoring a workflow asset | [configuration.md](configuration.md), [../settings/index.md](../settings/index.md) |

## Commands vs. skills vs. agents

| Surface | Best for | Not for |
|---|---|---|
| `commands/` | Starting a known flow with a named command | Storing deep method or isolated execution policy |
| `skills/` | Reusable procedure, heuristics, and step-by-step method | Acting as a separate worker |
| `agents/` | Delegated execution with its own context and tools | Passive guidance that the parent session should keep |

## Authoring flow

1. Decide whether the behavior is **guidance, command, procedure, worker, integration, package, or runtime config**.
2. Add it to the matching surface instead of inventing a new one.
3. Update `docs/antigravity-cli/` when the choice affects how future users should navigate or design workflows.
4. Link to the legacy deep-reference module only for the low-level mechanics.

## Guardrails

- Do **not** treat generated local state inside `antigravity-cli/`, `config/plugins/`, or `config/projects/` as the primary place for new workflow authoring; only intentionally curated subpaths under `antigravity-cli/` should hold versioned workflow assets.
- Do **not** turn a skill into an agent just to give it a name; isolate execution only when you need execution isolation.
- Do **not** duplicate the translation guidance in [workflow-adaptation.md](workflow-adaptation.md); use that page when the source workflow comes from another tool.

## Related pages

- Use [workflow-adaptation.md](workflow-adaptation.md) to translate foreign-tool workflows into local constructs.
- Use [planning-approval-execution.md](planning-approval-execution.md) for the canonical planning lifecycle.
- Use [runtime-and-plugin-surfaces.md](runtime-and-plugin-surfaces.md) when you need the editable-assets-versus-runtime-state boundary.
