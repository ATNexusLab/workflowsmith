# Memory

This directory contains memory indexes — canonical references to versioned memory sources used by AI agents.

## What a Memory Index Is

A memory index is a canonical workflow unit of `type: memory-index`. It does not store memory content directly. It records where a memory source lives, what its status is, and what is required before it can be used as active agent context.

## Format

Memory indexes are Markdown files with canonical frontmatter (see `build/schema/workflow-unit.template.md`). The body describes the memory sources in a table with columns for source name, location, status, and intended use.

## Current Indexes

- `index.md` — the primary memory index. Currently empty: no persistent memory is defined as promoted policy.

## Adding a Memory Source

1. Create or update an index file with canonical frontmatter.
2. Add a row to the sources table with: source name, location, import date, intended use, and promotion decision.
3. Set `status: draft` until the memory source has been reviewed.
4. Only promote a memory source when its intended use is clear and traceable to a repository decision.

## What Does Not Belong Here

- Raw memory content (Obsidian notes, chat logs, session summaries).
- Memory from a specific harness that has not been normalized into canonical form.
- Memory sources that have not been reviewed and promoted through the content lifecycle.
