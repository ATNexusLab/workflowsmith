# LSP, ACP, And Remote Control

Label: **Official reference**
Owner: `Non-VS-Code integration surfaces`
Last checked: `2026-05-20`
Version note: Integration protocols, load order, and remote-control behavior can change.

This page owns the official Copilot CLI integration surfaces that are not the VS Code bridge.

Boundary note:

- VS Code-specific behavior stays on [VS Code connection](vs-code-connection.md)
- local interactive steering stays on [Runtime modes, sessions, and permissions](../reference/runtime-modes-sessions-and-permissions.md)
- workflow-design and translation guidance stays on [Native workflow design playbook](../translation/native-workflow-design-playbook.md) and [Workflow translation method](../translation/workflow-translation-method.md)

## LSP servers

Official LSP benefits:

- more accurate code navigation than text search
- better token efficiency through structured responses
- safer refactors such as rename-across-project
- faster answers because servers index in the background

Officially documented LSP-backed operations:

- go to definition
- find references
- hover
- rename
- document symbols
- workspace symbol search
- go to implementation
- incoming calls
- outgoing calls

### LSP loading and configuration

Official load order is:

1. project config: `.github/lsp.json`
2. plugin configs
3. user config: `~/.copilot/lsp-config.json`

Higher-priority definitions override lower-priority ones with the same server name.

The official setup flow says you must install the language-server software locally and then configure it in one of the files Copilot CLI reads on startup. Plugins can also ship LSP servers.

### LSP management surface

The official how-to also documents `/lsp` for:

- listing available language servers
- confirming that a server is available
- reloading or testing server configuration

## ACP server

The ACP reference defines ACP as a protocol for communication between clients such as IDEs and agent implementations such as Copilot CLI.

Official ACP use cases:

- IDE integrations
- CI/CD pipelines
- custom frontends
- multi-agent systems

### Starting Copilot CLI as an ACP server

| Mode | Official invocation | Notes |
| --- | --- | --- |
| stdio | `copilot --acp --stdio` | Recommended for IDE integration; also the default when `--acp` is used without `--port` |
| TCP | `copilot --acp --port 3000` | Starts a TCP server |

The official reference also shows a TypeScript client example using `@agentclientprotocol/sdk`.

## Remote control of interactive sessions

Official remote control is for active interactive sessions running on another machine you already started.

### When it helps

The remote-control concept page frames it as useful when:

- you step away from your workstation
- a long-running task needs approval or more input
- you want a quick status check from GitHub Mobile or GitHub.com

### Prerequisites

Official prerequisites:

- the seat's organization or enterprise must enable the **Remote Control** policy
- the machine running the CLI session must stay online
- the session must be interactive; prompt mode is not eligible

### What remote control can do

Official remote capabilities include:

- view session output in real time
- answer Copilot questions
- approve or deny permission requests
- approve or reject plans
- submit new prompts
- switch session modes
- end the current operation

Current official limitation:

- slash commands are not available from the remote interface

### Security and privacy

The official security model says:

- only the same authenticated GitHub account can access the remote session
- conversation events and permission requests are sent from the local machine to GitHub
- remote commands are polled by the local CLI session from GitHub
- all shell commands, file operations, and tool execution still happen on the local machine
- the policy is off by default and controlled by enterprise or organization owners

## Sources

- [Using LSP servers with GitHub Copilot CLI](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/lsp-servers)
- [Adding LSP servers for GitHub Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/set-up-copilot-cli/add-lsp-servers)
- [Copilot CLI ACP server](https://docs.github.com/en/copilot/reference/copilot-cli-reference/acp-server)
- [About remote control of GitHub Copilot CLI sessions](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-remote-control)
