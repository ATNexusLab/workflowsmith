# Plugins

Label: **Official reference** with **generic adaptation** notes

Plugins are the packaging layer of Copilot CLI. Use them when you want to distribute a reusable bundle of Copilot customizations instead of copying files manually into each user's configuration.

## What a plugin can contain

Official docs describe plugins as installable packages that can bundle any combination of:

- skills
- custom agents
- hooks
- MCP server configuration
- related supporting assets

That makes plugins the right construct for team-wide or organization-wide rollout, not for one-off local experiments.

## Management surfaces

The command reference documents both interactive and non-interactive plugin management.

Interactive surface:

- `/plugin marketplace`
- `/plugin install`
- `/plugin uninstall`
- `/plugin update`
- `/plugin list`

Command-line surface:

- `copilot plugin ...`

## Where plugin state lives

The configuration-directory reference documents these plugin-related locations in `~/.copilot`:

- `installed-plugins/` for installed plugin files
- `plugin-data/` for persistent plugin data

It also documents configuration keys that matter for plugin rollout:

- `enabledPlugins`
- `extraKnownMarketplaces`

## When to use a plugin

Use a plugin when you need one or more of these:

- reproducible installation across a team
- versioned distribution of a Copilot setup
- bundled updates for multiple customization surfaces at once
- a marketplace or repository installation path instead of manual copying

## When not to start with a plugin

Do not lead with a plugin when:

- you are still experimenting with the workflow locally
- a single skill or instruction file would solve the problem
- the distribution problem is not real yet

In those cases, start with local files and package later if the pattern proves durable.

## Generic adaptation guidance

When translating from another ecosystem, a plugin is the closest match to a distributable extension or toolkit that bundles behavior, personas, tools, and policy in one installable unit.

If the foreign system only ships a single workflow document or a single persona, mapping directly to a plugin is usually heavier than necessary.

## Plugin manifest schema

A plugin is distributed as a package directory containing at minimum a `plugin.json` manifest file. Optional components:

```
my-plugin/
├── plugin.json          # Required — manifest
├── skills/              # Optional — SKILL.md files
├── agents/              # Optional — .agent.md files
├── hooks/               # Optional — hooks.json or *.json files
└── mcp-servers.json     # Optional — MCP server configurations
```

### Manifest fields

| Field | Type | Required | Description |
|---|---|---|---|
| `name` | string | **Yes** | Unique plugin identifier |
| `version` | string | **Yes** | SemVer version string (e.g. `1.2.0`) |
| `description` | string | Recommended | Human-readable description shown in `/plugin list` and marketplace |
| `copilotVersion` | string | No | Minimum Copilot CLI version required (e.g. `>=1.5.0`) |
| `skills` | array | No | Relative paths to `SKILL.md` files bundled with the plugin |
| `agents` | array | No | Relative paths to `.agent.md` files bundled with the plugin |
| `hooks` | string | No | Relative path to a `hooks.json` file or a `hooks/` directory |
| `mcpServers` | object | No | MCP server configurations to bundle (same shape as `mcp-config.json`) |

> **Note:** This schema is version-sensitive. The CLI plugin system is actively evolving. Always check the [official CLI plugin reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference) for the current field list before authoring or publishing a manifest.

---

## Packaging and publishing

### Packaging a plugin

Bundle the plugin directory into a distributable archive (typically a `.zip` or tarball). The archive must preserve the relative paths declared in `plugin.json`.

```
zip -r my-plugin-1.0.0.zip my-plugin/
```

Test local installation before publishing:

```
copilot plugin install ./my-plugin-1.0.0.zip
```

### Distribution options

| Option | Use when |
|---|---|
| **GitHub Copilot Marketplace** | Public distribution to any Copilot CLI user; subject to marketplace review |
| **Private registry** | Team or organization distribution; configure via `extraKnownMarketplaces` in `~/.copilot/settings.json` |
| **Direct path / URL** | Internal rollout or testing; `copilot plugin install <path-or-url>` |

### Versioning strategy

Follow SemVer strictly:

- **Patch** (`1.0.x`) — bug fixes, no behavior changes
- **Minor** (`1.x.0`) — new skills, agents, or hooks added; backward compatible
- **Major** (`x.0.0`) — breaking changes to existing skill interfaces, removed agents, or hook contract changes

Declare `copilotVersion` in the manifest whenever a new Copilot CLI feature is required. This prevents installation on incompatible CLI versions.

> **Note:** This section reflects the plugin packaging system as documented at the time of writing. Check the [official plugin reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference) before automating a distribution workflow.

---

## Dependency management

Plugin-to-plugin dependencies are not explicitly documented in the current official plugin reference. If your plugin assumes another plugin is installed (e.g. a shared skill library), handle this by:

1. Documenting the dependency clearly in the plugin `description` and any accompanying README.
2. Using `copilotVersion` to gate on a CLI version that includes any required built-in functionality.
3. Checking with the official plugin reference for any formal dependency declaration syntax introduced after this document was written.

### Bundled assets — precedence rules

When a plugin bundles skills or agents:

- Bundled skills are loaded alongside global and repo-local skills; the routing protocol determines which applies.
- If a bundled skill name conflicts with a global skill name, repo-local and plugin-bundled skills are additive by default — treat explicit override declarations in the plugin manifest as authoritative if present.
- Bundled hooks merge with other active hook files; duplicate event handlers run in load order.

> **Note:** Formal precedence rules for plugin assets are version-sensitive. Verify against the official reference if composing multiple plugins.

---

## Version compatibility

### Checking the installed CLI version

```bash
copilot --version
```

### Declaring version requirements in the manifest

Use the `copilotVersion` field with a semver range:

```json
{
  "name": "my-plugin",
  "version": "2.0.0",
  "copilotVersion": ">=1.5.0",
  "description": "Requires CLI 1.5+ for subagentStart hook support."
}
```

The CLI will refuse to install a plugin if the `copilotVersion` constraint is not satisfied.

### Handling breaking changes between plugin versions

When releasing a breaking change (major version bump):

1. Bump the major version in `plugin.json`.
2. Document breaking changes in a `CHANGELOG.md` or the plugin description.
3. Update the `copilotVersion` constraint if the new version relies on newer CLI features.
4. Users on the old major version will not receive automatic updates — they must explicitly upgrade.

> **Note:** This section reflects the plugin system as documented at the time of writing. Check the [official plugin reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference) before automating a distribution workflow.

---

## Version note

This page covers both the high-level plugin model and the current manifest schema and lifecycle. Packaging, marketplace behavior, and dependency management details are version-sensitive and should be verified against the official plugin reference before automating or publishing a distribution workflow.

## Sources

- [Comparing GitHub Copilot CLI customization features](https://docs.github.com/en/copilot/concepts/agents/copilot-cli/comparing-cli-features)
- [GitHub Copilot CLI command reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference)
- [GitHub Copilot CLI configuration directory](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-config-dir-reference)
- [GitHub Copilot CLI plugin reference](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference)