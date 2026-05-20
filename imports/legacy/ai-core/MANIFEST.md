# AI-core Legacy Import Manifest

## Source

- Source repository: `/home/theoodawara/Projetos/AI-core`
- Source path: `/home/theoodawara/Projetos/AI-core/workflows`
- Import date: `2026-05-20`
- Import status: `raw import`
- Activation status: inactive reference material

## Scope

Imported workflows:

- `claude`
- `copilot`
- `antigravity-cli`

Not imported in this snapshot:

- `codex`
- `opencode`
- Direct local state from `~/.claude`, `~/.copilot`, or `~/.gemini`

## Expected Counts

| Workflow | Expected files |
| --- | ---: |
| Claude | 91 |
| Copilot | 94 |
| Antigravity CLI | 106 |
| Total | 291 |

## Audit Notes

- The source is the existing AI-core workflow tree, not the live local tool directories.
- The import preserves file structure, including Copilot `.github` prompt files.
- Imported agents, hooks, commands, skills, rules, memory, and documentation remain inactive until reviewed and promoted.
- No symlinks were present in the source inspection before import.

