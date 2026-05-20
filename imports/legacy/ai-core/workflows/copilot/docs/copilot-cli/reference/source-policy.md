# Source Policy

Label: **Official reference**

This atlas is designed to stay useful even when this repository evolves. The only way to do that is to separate canonical Copilot CLI behavior from local convention.

## Canonical source rule

Official GitHub Docs are the source of truth for:

- feature availability
- command and slash-command behavior
- supported configuration files and directories
- settings and environment variables
- lifecycle hooks, MCP server behavior, and trust rules
- skills, custom agents, subagents, plugins, and built-in capabilities

Third-party blog posts, examples in unrelated repositories, and local experiments can help with implementation ideas, but they are never canonical for this atlas.

## Allowed content types

### Official reference

Use this label when a page explains behavior directly supported by official GitHub Docs.

Requirements:

- point to one or more official GitHub Docs URLs
- avoid repo-specific assumptions
- distinguish confirmed facts from open questions

### Generic adaptation

Use this label when a page explains how to combine official Copilot CLI features to achieve a reusable outcome.

Requirements:

- every building block in the pattern must exist in official docs
- the page must state when the pattern is a composition, not a first-class named feature
- any fidelity loss compared with another ecosystem must be explicit

### Repo example

Use this label when a page borrows material from this repository to illustrate a pattern.

Requirements:

- call out that the example is local to `~/.copilot`
- do not treat the example as an upstream default
- keep the generic explanation separate from the example block

## Boundary rules

- If a claim changes how a reader would configure Copilot CLI, it needs an official source.
- If a page explains this repository's conventions, it belongs in an example block or divergence note, not in the canonical narrative.
- If a foreign-tool concept does not map directly to Copilot CLI, document the nearest supported composition and the remaining gap.

## Version-sensitive areas

Revalidate these sections whenever Copilot CLI changes version:

- command and slash-command inventories
- settings keys and cascading behavior
- built-in agents and built-in MCP servers
- permission model details
- VS Code integration behavior
- programmatic, ACP, and automation interfaces

## Maintenance workflow

1. Update the [source ledger](source-ledger.md) first.
2. Update canonical reference pages next.
3. Update translation guidance after the reference layer is correct.
4. Update repo examples last.

## Acceptance checklist

- Every reference page cites official GitHub Docs.
- Repo examples are labeled as examples.
- Translation pages do not invent unsupported one-to-one mappings.
- Open questions are recorded instead of implied away.