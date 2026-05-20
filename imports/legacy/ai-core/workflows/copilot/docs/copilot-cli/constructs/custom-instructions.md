# Custom Instructions

Label: **Official reference** with **generic adaptation** notes

Custom instructions give Copilot persistent guidance so you do not have to restate project context, conventions, and preferences in every prompt.

## Official instruction surfaces

GitHub Copilot CLI supports four practical instruction surfaces:

| Surface | Official location | Scope |
| --- | --- | --- |
| Repository-wide instructions | `.github/copilot-instructions.md` | Applies to all requests in the repository |
| Path-specific instructions | `.github/instructions/**/*.instructions.md` | Applies only when matched files are in scope |
| Agent instructions | `AGENTS.md` in the repository root, current working directory, or a directory listed in `COPILOT_CUSTOM_INSTRUCTIONS_DIRS` | Agent-focused guidance |
| Local instructions | `~/.copilot/copilot-instructions.md` | Personal defaults across repositories |

Official docs also note root-level `CLAUDE.md` and `GEMINI.md` as alternative agent-instruction files.

## Repository-wide instructions

Use `.github/copilot-instructions.md` when the guidance should shape work across the whole repository.

Typical content:

- build, test, and validation commands
- coding conventions and review expectations
- high-level architecture guidance
- repository-specific workflow rules

Whitespace is ignored, so the file can be written as normal Markdown prose.

## Path-specific instructions

Use `.instructions.md` files when the guidance should apply only to certain files or directories.

Requirements:

- the file name must end with `.instructions.md`
- the frontmatter must include `applyTo`
- `applyTo` uses glob syntax and can contain multiple comma-separated patterns

Example pattern classes from official docs:

- `**/*.ts`
- `**/*.tsx`
- `src/**/*.py`
- `**/subdir/**/*.py`

Optional frontmatter:

- `excludeAgent: "code-review"`
- `excludeAgent: "cloud-agent"`

## Merging behavior and conflicts

When path-specific instructions match a file and repository-wide instructions also exist, Copilot uses both. Official docs warn that conflicting instructions are a bad idea because the outcome is non-deterministic.

That implies a clean split:

- put broad defaults in repository-wide instructions
- put narrow, file-class-specific rules in path-specific instructions
- avoid repeating the same rule with slightly different wording in both places

## Reload behavior

Custom instructions become available as soon as the file is saved. If you edit them during a CLI session, the new content is available on the next prompt in the current or future sessions.

## Generic adaptation guidance

Use custom instructions when the rule should feel like environmental law, not an optional workflow.

Good fits:

- always use a specific package manager
- always run certain checks before declaring work complete
- always keep a changelog or repo-specific document in sync

Poor fits:

- a workflow that only matters sometimes
- a specialist procedure for one domain
- an external integration that requires new tools

Those cases usually fit a skill, custom agent, or MCP server better.

## Repo example

This repository is a special case because it is also the personal `~/.copilot` home. The file [copilot-instructions.md](../../copilot-instructions.md) is acting as a personal-home instruction surface, not as the repository-level `.github/copilot-instructions.md` pattern documented by GitHub.

Treat that as a local example of a user-level instruction surface, not as a general repository convention.

## Sources

- [Adding custom instructions for GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions)
- [Comparing GitHub Copilot CLI customization features](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features)
- [GitHub Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)