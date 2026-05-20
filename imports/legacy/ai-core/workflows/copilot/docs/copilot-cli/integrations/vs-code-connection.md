# VS Code Connection

Label: **Official reference** with **generic adaptation** notes

Copilot CLI can connect to VS Code so the terminal runtime and the editor share context, trust, and review flow.

## What the connection provides

Official docs list four core benefits:

- editor selection can be used as prompt context
- proposed file edits can be reviewed as side-by-side diffs in VS Code
- live diagnostics from VS Code can be surfaced to the CLI
- session transcripts can be viewed in VS Code and resumed in the integrated terminal

## How connection happens

### Automatic connection

At startup, Copilot CLI checks whether the current working directory matches a workspace folder that is already open in VS Code in trusted mode.

If it finds a match, it connects automatically and reports the IDE connection in the startup environment message.

Important limits:

- it connects to only one VS Code window at a time
- if the same workspace is open in multiple windows, the CLI picks one automatically
- you can switch later with `/ide`

### Manual connection

Use `/ide` during an interactive session if you opened the workspace after the CLI started or if auto-connect did not find a match.

## Using editor context

When connected, Copilot CLI receives your current selection as it changes in VS Code. That allows prompts such as:

- `Debug this`
- `Explain this file`

without restating file paths by hand.

## Reviewing edits as diffs

When the CLI proposes file changes, VS Code can display them as a side-by-side diff for approval.

Important exception:

- if you already allowed unrestricted editing with `--allow-all`, `--yolo`, `/allow-all`, or `/yolo`, the CLI can apply changes directly without showing the diff view

The `/ide` menu also lets you disable IDE diff review if you prefer terminal-only review.

## Session continuity

Official docs describe a session bridge inside the Copilot Chat sidebar:

- view recent CLI sessions for the current workspace
- read the same transcript that appeared in the terminal
- resume a CLI session in VS Code's integrated terminal

## Related configuration surfaces

The configuration-directory reference documents:

- the `ide/` state directory
- `ide.autoConnect`
- `ide.openDiffOnEdit`

These settings control how aggressively the CLI tries to connect to VS Code and whether file-edit approvals open in the editor.

## Generic adaptation guidance

When translating from another ecosystem, use the VS Code connection as the bridge when the foreign workflow assumes:

- editor selections as implicit context
- graphical diff review instead of terminal-only review
- IDE diagnostics as part of the agent loop
- cross-tool session continuity between chat and terminal

## Sources

- [Connecting GitHub Copilot CLI to VS Code](https://docs.github.com/en/copilot/how-tos/copilot-cli/use-copilot-cli/connecting-vs-code)
- [GitHub Copilot CLI configuration directory](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference)
- [GitHub Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)