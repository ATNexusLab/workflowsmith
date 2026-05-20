<!-- type: adr | section: decisions -->
# ADR-003: MCP Server Naming: Kebab-Case Mandate

**Status:** Accepted  
**Date:** 2025

## Context

Gemini CLI integrates Model Context Protocol (MCP) servers and exposes their tools through generated Fully Qualified Names (FQNs). An FQN is the tool identifier the runtime uses internally to map a configured server and one of its exported tools into a callable name.

The relevant format is:

```text
mcp_{serverName}_{toolName}
```

The parser splits this identifier on underscore characters (`_`) to determine where the server name ends and the tool name begins.

This creates an ambiguity when the configured server name itself contains underscores. For example, if a server is named `my_server`, the resulting identifier `mcp_my_server_toolName` no longer has a reliable delimiter boundary between the server portion and the tool portion.

Because the ambiguity is structural, failures are difficult to diagnose. The runtime may misparse the identifier without producing a clear error message.

## Decision

All MCP server names in `mcpServers` configuration must use **kebab-case**.

### Accepted examples

- `my-server`
- `github-tools`
- `filesystem-mcp`

### Rejected examples

- `my_server`
- `githubTools`
- `filesystem_mcp`

Kebab-case is mandated because hyphens do not collide with the underscore delimiter used by the FQN parser.

Reference examples:

```text
Server: github-tools
Tool:   search_repos
FQN:    mcp_github-tools_search_repos
```

```text
Server: github_tools
Tool:   search_repos
FQN:    mcp_github_tools_search_repos
```

The second form is ambiguous because the parser cannot reliably determine whether `github` is the full server name and `tools_search_repos` is the tool name, or whether `github_tools` is the server name and `search_repos` is the tool name.

This rule is currently enforced as a configuration convention rather than a hard validation error, but it is treated as a mandatory compatibility contract for anyone building on top of Gemini CLI.

## Consequences

- ✅ MCP tool identifiers remain predictable and unambiguous.
- ✅ Configuration review is straightforward because non-compliant names are easy to spot in `settings.json` or extension manifests.
- ✅ Extension authors can document a single naming rule that avoids parser edge cases.
- ⚠️ Existing configurations that use underscore-based server names may fail silently or behave inconsistently until renamed.
- ⚠️ Because enforcement is presently conventional rather than strict, teams must catch violations during review.
- ⚠️ Any future tooling that generates MCP configs must emit kebab-case names by default.

## Alternatives Considered

### Allow any name and rely on user discipline

The system could leave naming entirely unconstrained.

It was rejected because the ambiguity is parser-level, not stylistic. User discipline alone does not create a safe boundary when the identifier format itself becomes ambiguous.

### Change the FQN delimiter format

The runtime could adopt a new delimiter or escaping scheme for FQNs.

It was rejected because it would break existing integrations and tool references that already depend on the current naming format.

### Fail hard on invalid names immediately

The runtime could reject underscore-based names at configuration load time.

It was not chosen as the current decision because compatibility and rollout concerns remain, although stricter validation is a plausible future hardening step.
