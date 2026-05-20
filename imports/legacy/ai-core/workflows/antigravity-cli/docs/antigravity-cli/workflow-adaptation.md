<!-- topic: workflow-adaptation | section: antigravity-cli -->
# Workflow Adaptation Matrix

This page helps translate workflows from other AI tools into the local Antigravity CLI ecosystem used in this repository.

## Primary mapping table

| If the other tool has… | Antigravity CLI target here | Notes |
|---|---|---|
| A user-wide instruction file | `~/.gemini/GEMINI.md` | Legacy filename retained; still the always-on instruction layer |
| A repository-wide instruction file | `./GEMINI.md` in the target project | Use project scope for repo-specific rules |
| File- or subtree-scoped rules | Nested `GEMINI.md` files | Use when the rule should only apply inside one subtree |
| A named reusable workflow or playbook | `skills/*/SKILL.md` | Best for repeatable procedures and decision frameworks |
| A specialist persona that executes work | `agents/*.md` | Use an agent when the work needs isolated execution |
| An external tool bridge or service adapter | MCP configuration | Use MCP when the model needs tools or resources from another system |
| A policy callback or lifecycle script | Hooks | Use for event-driven automation and policy boundaries |
| A packaged feature bundle | Extensions or local plugins | Use when multiple surfaces must ship together |
| A reviewed planning workflow before execution | Plan mode + session `plan.md` | Use for read-only planning before edits |
| A reusable command shortcut | `commands/*.md` | This is a local repository convention for saved prompt flows |

## Important non-equivalences

Some foreign constructs do **not** map one-to-one.

### One foreign file may split into several Antigravity surfaces

A single file in another tool may mix:

- always-on instructions
- reusable workflows
- hooks or policies
- external tool integrations

In this repository, those usually split across:

- `GEMINI.md`
- `skills/`
- hooks
- MCP

### Persona is not the same as procedure

If another tool uses a named worker for both guidance and execution, separate the two concerns here:

- use a **skill** for reusable method
- use an **agent** for isolated execution

### Runtime state is not workflow design

If another tool stores behavior directly in client state files, do not copy that pattern blindly. First decide whether the behavior belongs in:

- curated docs
- `GEMINI.md`
- `skills/`
- `agents/`
- hooks or MCP

## Recommended adaptation flow

1. Identify whether the foreign pattern is **instruction**, **execution**, **integration**, or **runtime state**
2. Choose the Antigravity surface that matches the real intent
3. Add or adapt the implementation in the correct surface
4. Document the decision in `docs/antigravity-cli/`
5. Link to deeper reference modules only when low-level detail is required

## Guardrail

Do not force parity. When Antigravity CLI does not have an exact equivalent, document the closest composition explicitly instead of pretending the feature maps directly.
