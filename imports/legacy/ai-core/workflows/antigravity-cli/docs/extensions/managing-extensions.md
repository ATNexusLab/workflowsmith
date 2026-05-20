<!-- topic: managing-extensions | section: extensions -->
# Managing Extensions

Managing extensions means placing, installing, enabling, disabling, listing, and removing packaged Gemini CLI functionality under the user extension directory.

## Quick Reference

> - Installed extensions live under `~/.gemini/extensions/`.
> - A valid extension must contain `gemini-extension.json` at its root.
> - `gemini extension install <source>` installs from a local path, git URL, or npm package name.
> - `/extensions` shows loaded extensions inside a running session.
> - Bundled MCP servers still require separate trust configuration in user `settings.json`.

## Extension Directory Structure

```text
~/.gemini/extensions/
  my-extension/
    gemini-extension.json    ← required manifest
    hooks/
      hooks.json
    commands/
    skills/
```

The directory name becomes the installed package location. Gemini CLI discovers directories in this location automatically when it starts.

## Installing an Extension

### Method 1: Manual Installation

Create the extension directory, place a valid `gemini-extension.json` manifest inside it, and restart Gemini CLI.

This method is appropriate when you are copying a local bundle directly into the extension directory yourself.

### Method 2: `gemini extension install <source>`

Use the CLI installer when you want Gemini CLI to fetch and register the extension for you.

- `source` can be a local directory path.
- `source` can be a git URL.
- `source` can be an npm package name.
- Gemini CLI installs the extension to `~/.gemini/extensions/<name>/`.
- Gemini CLI validates the manifest during installation.

## In-Session Slash Commands

These commands are available inside an active Gemini CLI session for inspecting or toggling loaded extensions.

| Command | Description |
|---|---|
| `/extensions` or `/extensions list` | List all loaded extensions and their status |
| `/extensions <name>` | Show details for a specific extension |
| `/extensions enable <name>` | Enable a disabled extension |
| `/extensions disable <name>` | Disable an extension for this session |

## Terminal CLI Commands

Use the terminal command family when you want to manage installed extensions outside the current chat session.

| Command | Description |
|---|---|
| `gemini extension install <source>` | Install from path, git, or npm |
| `gemini extension list` | List installed extensions |
| `gemini extension remove <name>` | Uninstall an extension |
| `gemini extension enable <name>` | Enable a disabled extension |
| `gemini extension disable <name>` | Disable an extension |

## Trust Model

Extensions loaded from `~/.gemini/extensions/` are auto-trusted because the user explicitly placed or installed them there.

That trust does not automatically extend to bundled MCP servers. If an extension includes MCP server definitions, the user must still configure `trust` separately in their own `settings.json`. The extension manifest cannot grant that permission on the user's behalf.
