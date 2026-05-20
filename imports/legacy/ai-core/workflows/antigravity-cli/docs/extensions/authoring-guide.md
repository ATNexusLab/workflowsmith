<!-- topic: authoring-guide | section: extensions -->
# Authoring Guide

Author an extension when you want to package one or more reusable Gemini CLI capabilities into a single installable directory.

## Quick Reference

> - Start with `~/.gemini/extensions/<name>/` and add `gemini-extension.json` first.
> - Add only the components your extension actually needs.
> - Use `${extensionPath}` for every internal file path so the bundle is relocatable.
> - Restart Gemini CLI and verify the extension with `/extensions`.
> - If the extension bundles MCP servers, tell users to configure `trust` themselves.

## Step 1: Create the Extension Directory

```bash
mkdir -p ~/.gemini/extensions/my-extension
```

This directory is the package boundary for the extension. Everything the extension ships should live inside it.

## Step 2: Create `gemini-extension.json`

Start with a minimal manifest.

```json
{
  "name": "my-extension",
  "version": "1.0.0",
  "description": "What this extension does"
}
```

This is enough for Gemini CLI to recognize the extension as a valid package shell, even before you add bundled features.

## Step 3: Add Components You Need

Choose only the bundle types that belong to the extension's job.

| Component | What to add |
|---|---|
| MCP server | Add an `mcpServers` object to the manifest |
| Custom commands | Add a `slashCommands` array to the manifest |
| Hooks | Create `hooks/hooks.json` and reference it in `hooks` |
| Skills | Create `SKILL.md` files and list them in `skills` |
| Contextual instructions | Create `GEMINI.md` in the extension root so Gemini CLI can load it as extension context |

A focused extension is easier to understand and maintain than a bundle that mixes unrelated features.

## Step 4: Use Manifest Variables for Portability

Always use `${extensionPath}` instead of absolute filesystem paths.

For example, prefer `"${extensionPath}/hooks/hooks.json"` over a machine-specific path such as `"/home/alice/.gemini/extensions/my-extension/hooks/hooks.json"`.

Using manifest variables makes the extension relocatable across machines, usernames, and operating systems.

## Step 5: Test the Extension

Restart Gemini CLI after creating or changing the extension.

Then verify it with these checks:

1. Run `/extensions` to confirm Gemini CLI loaded the extension.
2. Run `/mcp` if the extension bundles MCP servers.
3. Exercise any slash commands, hooks, or skills the extension defines.

Testing after each change keeps packaging errors small and easy to diagnose.

## Design Principles for Extension Authors

1. **Single responsibility**: bundle features that naturally belong together.
2. **No `trust: true` in manifest**: inform users they must add it themselves.
3. **Use `${extensionPath}` for all paths**: never hardcode absolute paths.
4. **Document dependencies**: list any external processes users must have installed.
5. **Version your manifest**: use semantic versioning for tracking changes.
