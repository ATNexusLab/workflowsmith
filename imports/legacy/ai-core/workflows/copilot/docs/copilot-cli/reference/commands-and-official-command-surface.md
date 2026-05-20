# Commands And Official Command Surface

Label: **Official reference**
Owner: `Canonical command, shortcut, and flag inventory`
Last checked: `2026-05-20`
Version note: Command, shortcut, and option inventories are version-sensitive.

This page is the single owner for the official GitHub Copilot CLI command surface inventory.

Adjacent owner pages:

- tool names and approval semantics: [Tools, permissions, and safety controls](tools-permissions-and-safety-controls.md)
- runtime interpretation of modes and sessions: [Runtime modes, sessions, and permissions](runtime-modes-sessions-and-permissions.md)
- prompt-mode workflow guidance: [Programmatic use and automation](programmatic-use-and-automation.md)

## Top-level command-line commands

| Command | Purpose |
| --- | --- |
| `copilot` | Launch the interactive user interface |
| `copilot completion SHELL` | Print shell completion for `bash`, `zsh`, or `fish` |
| `copilot help [TOPIC]` | Display help information |
| `copilot init` | Initialize Copilot custom instructions for the repository |
| `copilot login` | Authenticate with Copilot via OAuth device flow |
| `copilot mcp` | Manage MCP server configuration from the command line |
| `copilot plugin` | Manage plugins and plugin marketplaces |
| `copilot update` | Download and install the latest version |
| `copilot version` | Display version information and check for updates |

### Documented help topics

`copilot help [TOPIC]` officially lists these topics:

- `config`
- `commands`
- `environment`
- `logging`
- `monitoring`
- `permissions`
- `providers`

### Documented subcommand inventory

#### `copilot login`

| Option | Purpose |
| --- | --- |
| `--host HOST` | Authenticate against a GitHub Enterprise Cloud hostname that uses data residency |

#### `copilot mcp`

| Subcommand | Purpose |
| --- | --- |
| `list [--json]` | List configured MCP servers grouped by source |
| `get <name> [--json]` | Show configuration and tools for one server |
| `add <name>` | Add a server to user config |
| `remove <name>` | Remove a user-level server |

## Interactive shortcuts

### Global shortcuts

| Shortcut | Purpose |
| --- | --- |
| `@ FILENAME` | Include file contents in context |
| `# NUMBER` | Include a GitHub issue or pull request in context |
| `! COMMAND` | Run a local shell command directly |
| `?` | Open quick help on an empty prompt |
| `Esc` | Cancel the current operation |
| `Ctrl+C` | Cancel the current operation or clear input; press twice to exit |
| `Ctrl+D` | Shut down |
| `Ctrl+G` | Edit the prompt in an external editor |
| `Ctrl+L` | Clear the screen |
| `Ctrl+Enter` or `Ctrl+Q` | Queue a message while the agent is busy |
| `Ctrl+R` | Reverse search through command history |
| `Ctrl+V` | Paste from the clipboard as an attachment |
| `Ctrl+X` then `/` | Run a slash command after you have already started typing a prompt |
| `Ctrl+X` then `e` | Edit the prompt in an external editor |
| `Ctrl+X` then `b` | Promote the running task or shell command to the background |
| `Ctrl+X` then `o` | Open the most recent link from the timeline |
| `Ctrl+Z` | Suspend the process to the background on Unix |
| `Shift+Enter` or `Option+Enter` (Mac) / `Alt+Enter` (Windows/Linux) | Insert a newline in the input |
| `Shift+Tab` | Cycle between standard, plan, and autopilot mode |

### Timeline shortcuts

| Shortcut | Purpose |
| --- | --- |
| `Ctrl+F` | Open timeline search |
| `Ctrl+O` | Expand recent timeline items when prompt input is empty |
| `Ctrl+E` | Expand all timeline items when prompt input is empty |
| `Ctrl+T` | Expand or collapse reasoning display |
| `Page Up` / `Page Down` | Scroll the timeline by one page |

### Session picker shortcuts

| Shortcut | Purpose |
| --- | --- |
| `↑` / `↓` | Move selection |
| `Enter` | Open the selected session |
| `s` | Cycle sort order |
| `Tab` | Switch between local and remote tabs |
| `d` | Delete the selected session |
| `Esc` | Close the picker |

Documented session-picker sort orders:

| Mode | Meaning |
| --- | --- |
| `relevance` | Match current working directory |
| `last used` | Most recently modified first |
| `created` | Most recently created first |
| `name` | Alphabetical by session name |

### Navigation shortcuts

| Shortcut | Purpose |
| --- | --- |
| `Ctrl+A` | Move to the beginning of the line |
| `Ctrl+B` | Move to the previous character |
| `Ctrl+E` | Move to the end of the line |
| `Ctrl+F` | Move to the next character |
| `Ctrl+H` | Delete the previous character |
| `Ctrl+K` | Delete from the cursor to the end of the line |
| `Ctrl+U` | Delete from the cursor to the beginning of the line |
| `Ctrl+W` | Delete the previous word |
| `Home` | Move to the start of the text |
| `End` | Move to the end of the text |
| `Alt+←/→` (Windows/Linux), `Option+←/→` (Mac) | Move by word |
| `↑` / `↓` | Navigate the command history |
| `Tab` / `Ctrl+Y` | Accept the current inline completion suggestion |

## Slash commands

### Workspace, context, and trust

| Command | Purpose |
| --- | --- |
| `/add-dir PATH` | Add a directory to the allowed list for file access |
| `/allow-all [on\|off\|show]`, `/yolo [on\|off\|show]` | Enable all permissions |
| `/compact` | Summarize conversation history to reduce context usage |
| `/context` | Show context-window token usage and visualization |
| `/cwd`, `/cd [PATH]` | Change or display the current working directory |
| `/env` | Show loaded instructions, MCP servers, skills, agents, plugins, LSPs, and extensions |
| `/instructions` | View and toggle custom instruction files |
| `/keep-alive [on\|off\|busy\|DURATION]`, `/caffeinate [on\|off\|busy\|DURATION]` | Prevent the machine from sleeping |
| `/list-dirs` | Show directories already allowed for file access |
| `/remote [on\|off]` | Show remote-control status, enable remote steering, or end remote access |
| `/reset-allowed-tools` | Reset the allowed-tools list |
| `/statusline`, `/footer` | Configure status-line items |
| `/terminal-setup` | Configure multiline-input terminal support |
| `/theme [default\|dim\|high-contrast\|colorblind]` | View or set color mode |

### Sessions, transcript handling, and history

| Command | Purpose |
| --- | --- |
| `/chronicle <standup\|tips\|improve\|reindex>` | Session-history tools and insights; experimental |
| `/clear [PROMPT]`, `/new [PROMPT]`, `/reset [PROMPT]` | Start a new conversation |
| `/copy` | Copy the last response to the clipboard |
| `/rename [NAME]` | Rename the current session |
| `/resume [SESSION-ID]`, `/continue [SESSION-ID]` | Choose and resume a prior session |
| `/search [QUERY]`, `/find [QUERY]` | Search the conversation timeline; experimental |
| `/session [...]`, `/sessions [...]` | Show session info and manage checkpoints, files, cleanup, pruning, and deletion |
| `/share [file\|html\|gist] [session\|research] [PATH]`, `/export ...` | Share or export a session or research transcript |
| `/undo`, `/rewind` | Rewind the last turn and revert file changes |

### Agents, models, and extensibility

| Command | Purpose |
| --- | --- |
| `/agent` | Browse and select available agents |
| `/ask QUESTION` | Ask a side question without adding to conversation history; experimental |
| `/clikit [COMPONENT]` | Preview CLI business components |
| `/experimental [on\|off\|show]` | Toggle or inspect experimental features |
| `/fleet [PROMPT]` | Enable parallel subagent execution |
| `/ide` | Connect to an IDE workspace |
| `/init` | Initialize Copilot custom instructions and agentic features for the repository |
| `/lsp [show\|test\|reload\|help] [SERVER-NAME]` | Manage language-server configuration |
| `/mcp [show\|add\|edit\|delete\|disable\|enable\|auth\|reload] [SERVER-NAME]` | Manage MCP server configuration |
| `/model`, `/models [MODEL]` | Select the AI model |
| `/plugin [marketplace\|install\|uninstall\|update\|list] [ARGS...]` | Manage plugins and plugin marketplaces |
| `/skills [list\|info\|add\|remove\|reload] [ARGS...]` | Manage skills |

### Planning, review, research, and delivery

| Command | Purpose |
| --- | --- |
| `/delegate [PROMPT]` | Delegate changes to a remote repository with an AI-generated pull request |
| `/diff` | Review changes in the current directory |
| `/plan [PROMPT]` | Create an implementation plan before coding |
| `/pr [view\|create\|fix\|auto]` | Manage pull requests for the current branch |
| `/research TOPIC` | Run a deep research investigation using GitHub search and web sources |
| `/review [PROMPT]` | Run the code-review agent against current changes |
| `/tasks` | View and manage tasks such as subagents and shell commands |

### Account, CLI management, and utility

| Command | Purpose |
| --- | --- |
| `/changelog [summarize] [VERSION\|last N\|since VERSION]`, `/release-notes ...` | Show CLI changelog or release notes |
| `/downgrade <VERSION>` | Download and restart into a specific CLI version |
| `/exit`, `/quit` | Exit the CLI |
| `/feedback`, `/bug` | Provide feedback |
| `/help` | Show interactive help |
| `/login` | Log in to Copilot |
| `/logout` | Log out of Copilot |
| `/restart` | Restart the CLI while preserving the current session |
| `/update`, `/upgrade` | Update the CLI |
| `/usage` | Show usage metrics and statistics |
| `/user [show\|list\|switch]` | Manage the current GitHub user |
| `/version` | Show version information and check for updates |

## Command-line options

### Session entry, resume, and runtime mode

| Option | Purpose |
| --- | --- |
| `-i PROMPT`, `--interactive=PROMPT` | Start an interactive session and immediately run a prompt |
| `-n NAME`, `--name=NAME` | Set a name for a new session |
| `-p PROMPT`, `--prompt=PROMPT` | Execute a prompt programmatically and exit |
| `--autopilot` | Enable autopilot continuation in prompt mode |
| `--connect[=SESSION-ID]` | Connect directly to a remote session |
| `--continue` | Resume the most recent session in the current working directory, falling back globally |
| `--max-autopilot-continues=COUNT` | Limit autopilot continuation messages |
| `--mode=MODE` | Set the initial mode to `interactive`, `plan`, or `autopilot` |
| `--no-remote` | Disable remote access for the session |
| `--plan` | Start in plan mode |
| `--remote` | Enable remote access to the session |
| `--resume[=VALUE]` | Resume a previous interactive session by picker, ID, prefix, or name |

### Permissions, paths, URLs, and tool visibility

| Option | Purpose |
| --- | --- |
| `--add-dir=PATH` | Add a directory to the allowed file-access list |
| `--allow-all` | Enable all permissions |
| `--allow-all-paths` | Allow access to any path |
| `--allow-all-tools` | Allow all tools to run automatically |
| `--allow-all-urls` | Allow access to all URLs automatically |
| `--allow-tool=TOOL ...` | Pre-approve one or more tools |
| `--allow-url=URL ...` | Pre-approve one or more URLs or domains |
| `--available-tools=TOOL ...` | Restrict the model to only these available tools |
| `--deny-tool=TOOL ...` | Deny one or more tools |
| `--deny-url=URL ...` | Deny one or more URLs or domains |
| `--disallow-temp-dir` | Prevent automatic access to the system temporary directory |
| `--excluded-tools=TOOL ...` | Hide specific tools from the model |
| `--no-ask-user` | Disable the `ask_user` tool |
| `--secret-env-vars=VAR ...` | Redact selected environment-variable values in output |
| `--yolo` | Enable all permissions |

### Models, reasoning, streaming, and output

| Option | Purpose |
| --- | --- |
| `--effort=LEVEL`, `--reasoning-effort=LEVEL` | Set reasoning effort |
| `--enable-reasoning-summaries` | Request reasoning summaries for supported OpenAI models |
| `--model=MODEL` | Select the AI model |
| `--output-format=FORMAT` | Use `text` or `json` output (`json` is JSONL) |
| `-s`, `--silent` | Output only the agent response |
| `--share=PATH` | Write a Markdown session transcript after programmatic completion |
| `--share-gist` | Publish a secret gist transcript after programmatic completion |
| `--stream=MODE` | Turn streaming `on` or `off` |

### Customization, MCP, plugins, and agents

| Option | Purpose |
| --- | --- |
| `--add-github-mcp-tool=TOOL` | Enable extra GitHub MCP tools for the session |
| `--add-github-mcp-toolset=TOOLSET` | Enable extra GitHub MCP toolsets for the session |
| `--additional-mcp-config=JSON` | Add session-only MCP config from JSON or `@file` |
| `--agent=AGENT` | Select a custom agent |
| `--disable-builtin-mcps` | Disable all built-in MCP servers |
| `--disable-mcp-server=SERVER-NAME` | Disable a specific MCP server |
| `--enable-all-github-mcp-tools` | Enable all GitHub MCP server tools |
| `--no-custom-instructions` | Disable loading repository and related custom instructions |
| `--plugin-dir=DIRECTORY` | Load a plugin from a local directory |

### Terminal UX, logging, updates, and miscellaneous

| Option | Purpose |
| --- | --- |
| `--banner`, `--no-banner` | Show or hide the startup banner |
| `--bash-env`, `--no-bash-env` | Enable or disable `BASH_ENV` support |
| `--experimental`, `--no-experimental` | Enable or disable experimental features |
| `-h`, `--help` | Display help |
| `--log-dir=DIRECTORY` | Set the log directory |
| `--log-level=LEVEL` | Set the log level |
| `--mouse[=VALUE]` | Configure mouse capture in alt-screen mode |
| `--no-auto-update` | Disable auto-update downloads |
| `--no-color` | Disable color output |
| `--no-mouse` | Disable mouse support |
| `--plain-diff` | Disable rich diff rendering |
| `--screen-reader` | Enable screen-reader optimizations |
| `-v`, `--version` | Show version information |

## Environment-variable ownership

To avoid duplicating official inventories, environment variables are partitioned across owner pages:

| Environment-variable family | Owner page |
| --- | --- |
| Authentication tokens and login precedence | [Installation, getting started, and authentication](installation-getting-started-and-authentication.md) |
| Prompt-mode trust defaults | [Programmatic use and automation](programmatic-use-and-automation.md) |
| Tool-permission safety toggles | [Tools, permissions, and safety controls](tools-permissions-and-safety-controls.md) |
| Model selection, BYOK, and OpenTelemetry | [Models, automation, and observability](models-automation-and-observability.md) |
| Home-directory relocation and cache paths | [Configuration directory and settings](configuration-directory-and-settings.md) |

## Sources

- [GitHub Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
