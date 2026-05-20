<!-- topic: fundamentals | section: extensions -->
# Extensions Fundamentals

An extension is a reusable package that lets Gemini CLI load multiple related capabilities from a single directory and manifest.

## Quick Reference

> - An extension is a directory at `~/.gemini/extensions/<name>/` with a required `gemini-extension.json` manifest.
> - Every bundled feature is optional; the manifest can declare only the parts the extension needs.
> - Gemini CLI discovers extensions automatically from `~/.gemini/extensions/` at startup.
> - Extensions do not import from each other; each one is isolated as its own package boundary.
> - Bundled MCP servers cannot set `"trust": true` in the manifest.

## What an Extension Is

An extension is a directory-based distribution unit for Gemini CLI. The directory lives at `~/.gemini/extensions/<name>/`, and the root of that directory must contain `gemini-extension.json`. Gemini CLI reads that manifest at startup and uses it to load the features bundled inside the extension.

The important operational idea is packaging: install one extension once, and Gemini CLI can load every capability that extension bundles without separate installation steps for each feature.

## What an Extension Can Bundle

Every bundle type is optional. An extension can ship one feature or combine several related features into a single reusable unit.

| Bundle type | What it adds to Gemini CLI |
|---|---|
| **MCP servers** | Pre-configured MCP server connections that add tools or external integrations |
| **Custom slash commands** | Reusable commands equivalent to command definitions normally stored under `.gemini/commands/` |
| **GEMINI.md** | Contextual instructions injected into the conversation when the extension is loaded |
| **Skills** | Pre-packaged `SKILL.md` files that Gemini CLI can activate on demand |
| **Hooks** | Lifecycle event hooks defined through `hooks/hooks.json` |
| **Themes** | Custom color and visual themes for the CLI interface |
| **Agents** | Agent definition files packaged with the extension; this feature is preview-only |
| **Policies** | Configuration constraints that limit or shape runtime behavior |

## Discovery and Startup Loading

Gemini CLI scans `~/.gemini/extensions/` automatically at startup. Each child directory that contains `gemini-extension.json` is treated as one extension and becomes available to the session.

Because discovery is directory-based, the extension folder itself is the activation boundary. Gemini CLI does not need a secondary registry file to find installed extensions.

## Isolation and Package Boundaries

Extensions are sandboxed from each other. One extension cannot import another extension's bundled files, commands, skills, or internal assets.

This isolation keeps each extension self-contained: the manifest, bundled resources, and local files define the whole package. If two extensions need similar behavior, each one must ship its own copy or rely on shared platform features rather than inter-extension imports.

## MCP Server Trust Limitation

An extension may bundle MCP server definitions inside `gemini-extension.json`, but the manifest cannot grant those servers elevated trust. In particular, an extension manifest cannot set `"trust": true` for a bundled MCP server.

If a user wants a bundled MCP server to run with trust enabled, the user must add that setting manually in their own `settings.json`. This keeps trust as an explicit per-user decision rather than something an extension can grant during installation.
