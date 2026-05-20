<!-- topic: runtime-surfaces | section: antigravity-cli -->
# Runtime and Plugin Surfaces

This repository contains both **editable workflow assets** and **live runtime state**. Keeping that boundary explicit is critical when you want to improve the client without creating drift or documenting accidental local state as if it were product behavior.

## Surface classification

| Surface | Path | Category | Editing policy |
|---|---|---|---|
| Documentation | `docs/` | Curated knowledge | Edit directly when you are improving guidance |
| Instructions | `GEMINI.md` | Persistent workflow contract | Edit deliberately; this changes future behavior |
| Skills | `skills/` | Reusable workflow playbooks | Edit when adding or refining procedures |
| Agents | `agents/` | Specialist execution wrappers | Edit when changing delegation behavior |
| Commands | `commands/` | Local reusable prompt flows | Edit when creating command shortcuts |
| Antigravity client surface | `antigravity-cli/` | Mixed authored workflow assets and local client state | Version curated assets; ignore local runtime exhaust and do not treat it as authoritative documentation |
| Plugin assets | `config/plugins/` | Installed integration packages | Treat as implementation surface, not narrative docs |
| Project metadata | `config/projects/` | Trusted project/runtime registry | Treat as runtime implementation surface |
| MCP registry | `config/mcp_config.json` | Integration configuration | Treat as configuration, then document separately |

## Why this boundary matters

Without this distinction, three mistakes become likely:

1. documenting cached or accidental local state as if it were stable product behavior
2. editing implementation artifacts when the real change belongs in `docs/`, `skills/`, or `agents/`
3. copying plugin internals into human-facing docs instead of writing a stable explanation

## Observed local runtime surfaces

The current audit found these notable runtime surfaces:

- `antigravity-cli/settings.json`
- `antigravity-cli/log/`
- `antigravity-cli/cache/`
- `config/plugins/google-antigravity-sdk/`
- `config/projects/*.json`

These files are useful for **understanding the local install**, but they should support documentation rather than replace it. They also do not define the full policy for `antigravity-cli/`: authored workflow assets can be versioned there, while generated runtime artifacts should remain ignored.

## Where new workflow work should go

| Goal | Put the implementation here | Document it here |
|---|---|---|
| New reusable procedure | `skills/` | `docs/antigravity-cli/` and skill docs as needed |
| New specialist worker | `agents/` | `docs/antigravity-cli/` or related reference docs |
| New external integration | MCP or plugin config | `docs/antigravity-cli/` plus deeper reference if needed |
| New user-facing guidance | `docs/` | `docs/` |

If workflow assets are intentionally migrated into `antigravity-cli/`, treat those authored subpaths as portable repo content rather than runtime exhaust. The ignore policy should exclude only the generated local state that sits beside them.

## Phase-one migration rule

For the docs-first migration, phase one should:

- document runtime and plugin surfaces clearly,
- cross-link to deeper reference where needed,
- avoid broad edits inside runtime state and plugin assets,
- and keep human-facing truth inside curated docs.
