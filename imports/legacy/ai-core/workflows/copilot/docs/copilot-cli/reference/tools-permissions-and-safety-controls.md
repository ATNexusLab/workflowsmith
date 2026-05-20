# Tools, Permissions, And Safety Controls

Label: **Official reference**
Owner: `Tool inventory, approval model, and trust controls`
Last checked: `2026-05-20`
Version note: Tool names, permission patterns, and approval controls can change.

This page owns the official tool inventory and permission model for GitHub Copilot CLI.

## Built-in tools

### Shell tools

| Tool name | Description |
| --- | --- |
| `bash` / `powershell` | Execute commands |
| `list_bash` / `list_powershell` | List active shell sessions |
| `read_bash` / `read_powershell` | Read shell-session output |
| `stop_bash` / `stop_powershell` | Terminate a shell session |
| `write_bash` / `write_powershell` | Send input to a shell session |

### File-operation tools

| Tool name | Description |
| --- | --- |
| `apply_patch` | Apply patches |
| `create` | Create new files |
| `edit` | Edit files via string replacement |
| `view` | Read files or directories |

### Agent and task-delegation tools

| Tool name | Description |
| --- | --- |
| `list_agents` | List available agents |
| `read_agent` | Check background-agent status |
| `task` | Run subagents |

### Other tools

| Tool name | Description |
| --- | --- |
| `ask_user` | Ask the user a question |
| `glob` | Find files matching patterns |
| `grep` / `rg` | Search for text in files |
| `skill` | Invoke custom skills |
| `web_fetch` | Fetch and parse web content |

## Permission patterns

The command reference documents these permission-pattern kinds:

| Kind | What it controls | Example patterns |
| --- | --- | --- |
| `memory` | Storing new facts in agent memory | `memory` |
| `read` | File or directory reads | `read`, `read(.env)` |
| `shell` | Shell execution | `shell(git push)`, `shell(git:*)`, `shell` |
| `url` | URL access via web fetch or shell | `url(github.com)`, `url(https://*.api.com)` |
| `write` | File creation or modification | `write`, `write(src/*.ts)` |
| `SERVER-NAME` | MCP server invocation | `MyMCP(create_issue)`, `MyMCP` |

The programmatic reference also gives concrete filter examples:

| Kind | Example | Meaning |
| --- | --- | --- |
| `shell` | `shell(git:*)` | Allow all Git subcommands |
| `shell` | `shell(npm test)` | Allow exactly `npm test` |
| `write` | `write(.github/copilot-instructions.md)` | Allow writing that exact path |
| `write` | `write(README.md)` | Allow files whose path ends with `/README.md` |
| `url` | `url(github.com)` | Allow HTTPS URLs on `github.com` |
| `url` | `url(http://localhost:3000)` | Allow that specific local URL |
| `url` | `url(https://*.github.com)` | Allow GitHub subdomains |
| `url` | `url(https://docs.github.com/copilot/*)` | Allow that path prefix |
| `MCP-SERVER` | `github(create_issue)` | Allow one tool from one MCP server |

## Approval responses

Official approval keys:

| Key | Effect |
| --- | --- |
| `y` | Allow this specific request once |
| `n` | Deny this specific request once |
| `!` | Allow similar requests for the rest of the session |
| `#` | Deny similar requests for the rest of the session |
| `?` | Show detailed information about the request |

Documented persistence levels:

| Option | Scope | Persistence |
| --- | --- | --- |
| Once | Single use | None |
| This location | Current location | Saved to disk per location |
| Always | Permanent | Saved in config |

## Trust and approval model

Responsible-use and product-overview docs state that, by default:

- file access starts at the launch directory and below
- file access outside that scope requires permission
- file modification requires approval
- dangerous command execution requires approval

Official guidance also says you should launch Copilot CLI only from directories you trust.

## Command-line and slash-command controls

The canonical flag inventory lives on the command-surface page. The permission-related controls are:

- `--allow-all`, `--yolo`
- `--allow-all-paths`, `--allow-all-tools`, `--allow-all-urls`
- `--allow-tool`, `--deny-tool`
- `--available-tools`, `--excluded-tools`
- `--allow-url`, `--deny-url`
- `--add-dir`
- `--disallow-temp-dir`
- `/allow-all`, `/yolo`
- `/reset-allowed-tools`
- `/add-dir`, `/list-dirs`

Official docs state that deny rules take precedence over allow rules.

## Prompt-mode safety defaults

The command reference documents prompt-mode environment variables that are off by default to avoid loading repository-controlled extensions during headless use:

| Variable | Default behavior when unset |
| --- | --- |
| `GITHUB_COPILOT_PROMPT_MODE_EXTENSIONS` | Do not load project extensions in prompt mode |
| `GITHUB_COPILOT_PROMPT_MODE_REPO_HOOKS` | Do not load repository hooks in prompt mode |
| `GITHUB_COPILOT_PROMPT_MODE_WORKSPACE_MCP` | Do not load workspace MCP sources in prompt mode |

## High-risk modes

Official docs explicitly warn that broad approval flags give Copilot the same file and command power you have in that environment.

That is why the docs frame these as higher-risk combinations:

- `--allow-all`
- `--allow-all-tools`
- autonomous prompt-mode runs
- autopilot workflows with full permissions

## Sources

- [GitHub Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
- [GitHub Copilot CLI programmatic reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-programmatic-reference)
- [Responsible use of GitHub Copilot CLI](https://docs.github.com/en/copilot/responsible-use/copilot-cli)
- [About GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-copilot-cli)
