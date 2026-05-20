# Installation, Getting Started, And Authentication

Label: **Official reference**
Owner: `CLI setup, first run, and authentication`
Last checked: `2026-05-20`
Version note: Installation methods, supported token types, and authentication behavior can change.

This page owns the official setup path for GitHub Copilot CLI.

Related owner pages:

- runtime and session behavior: [Runtime modes, sessions, and permissions](runtime-modes-sessions-and-permissions.md)
- full command inventory: [Commands and official command surface](commands-and-official-command-surface.md)
- prompt mode and CI/CD usage: [Programmatic use and automation](programmatic-use-and-automation.md)

## Prerequisites

Official installation guidance lists these prerequisites:

- an active GitHub Copilot subscription
- on Windows, PowerShell v6 or later
- if your access comes from an organization or enterprise, Copilot CLI must be enabled there

## Supported installation methods

| Method | Platforms | Official notes |
| --- | --- | --- |
| npm | All platforms | Requires Node.js 22 or later; `npm install -g @github/copilot` |
| WinGet | Windows | `winget install GitHub.Copilot` |
| Homebrew | macOS and Linux | `brew install copilot-cli` |
| Install script | macOS and Linux | `curl -fsSL https://gh.io/copilot-install \| bash` |
| Direct download | Platform-specific executables | Download from the `github/copilot-cli` repository on GitHub.com |

## First launch

The official getting-started flow is:

1. move into the project directory where you want to use Copilot CLI
2. start the interactive interface with `copilot`
3. run `/login` if prompted
4. confirm that you trust the current directory for AI-assisted work
5. start with a prompt or enter `/help`

The getting-started guide also points new users to:

- `Esc` to cancel the current operation
- `Ctrl+C` to cancel, clear input, or exit
- `@` to include files in context
- `/` and `?` to discover commands and help

Use the command-surface page for the full shortcut inventory.

## Authentication methods

Official docs describe four authentication paths:

| Method | Best for | Official behavior |
| --- | --- | --- |
| OAuth device flow via `/login` or `copilot login` | Interactive use | Default and recommended path; opens a browser-based device flow |
| Environment variables | CI/CD, containers, headless automation | Uses a supported token from `COPILOT_GITHUB_TOKEN`, `GH_TOKEN`, or `GITHUB_TOKEN` |
| GitHub CLI fallback | Developer machines already authenticated with `gh` | Lowest-priority fallback when no environment variable or stored OAuth token is available |
| BYOK without GitHub authentication | Custom-provider-only usage | GitHub authentication is not required, but GitHub-hosted features stay unavailable |

For GitHub Enterprise Cloud with data residency, the docs explicitly support `copilot login --host HOST`.

## Supported token types

The authentication guide documents this support matrix:

| Token type | Prefix | Supported? | Notes |
| --- | --- | --- | --- |
| OAuth token | `gho_` | Yes | Default device-flow method |
| Fine-grained PAT | `github_pat_` | Yes | Must be user-owned and have the **Copilot Requests** account permission |
| GitHub App user-to-server token | `ghu_` | Yes | Supported via environment variable |
| Classic PAT | `ghp_` | No | Not supported |

For PAT-based authentication, the official guidance says the token must belong to your personal account, not to an organization-owned token definition.

## Authentication precedence

When a command runs, official docs say Copilot CLI checks credentials in this order:

1. `COPILOT_GITHUB_TOKEN`
2. `GH_TOKEN`
3. `GITHUB_TOKEN`
4. stored OAuth token in the system keychain
5. GitHub CLI fallback (`gh auth token`)

An environment variable silently overrides a stored OAuth token.

## Credential storage

Official credential-storage behavior:

- preferred storage is the operating system keychain under the service name `copilot-cli`
- macOS uses Keychain Access
- Windows uses Credential Manager
- Linux uses `libsecret`-compatible keychains
- if no system keychain is available, the CLI can store the token in plaintext at `~/.copilot/config.json`

## Account switching and sign-out

The authentication guide documents these account controls:

- `/user list` to list known accounts
- `/user switch` to switch accounts
- `/logout` to remove the locally stored token

The guide also notes that `/logout` does not revoke the OAuth authorization on GitHub; revocation must be done from GitHub account settings.

## Unauthenticated and offline use

Official docs make these boundaries explicit:

- BYOK-only usage does not require GitHub authentication
- without GitHub authentication, `/delegate`, the GitHub MCP server, and GitHub Code Search are unavailable
- with `COPILOT_OFFLINE=true`, Copilot CLI does not contact GitHub and telemetry is disabled

## Sources

- [Installing GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/install-copilot-cli)
- [Getting started with GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-getting-started)
- [Authenticating GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/authenticate-copilot-cli)
