<!-- type: adr | section: decisions -->
# ADR-005: Antigravity-First Documentation Migration

**Status:** Accepted  
**Date:** 2026-05-20

## Context

This repository already contains a large, modular documentation set centered on **Gemini CLI** concepts and filenames. At the same time, the local runtime and plugin surfaces already show Antigravity-oriented state, including `antigravity-cli/` runtime directories and a `google-antigravity-sdk/` plugin surface.

The result is a mixed naming environment:

- deep reference is mostly Gemini-oriented
- runtime observations increasingly look Antigravity-oriented
- new workflow documentation needs to help the user design future work around Antigravity CLI as the primary client

Without an explicit migration decision, any new documentation would risk creating a second source of truth instead of a coherent navigation layer.

## Decision

Adopt **Antigravity CLI** as the canonical **user-facing documentation term** for this repository.

Phase one of the migration is **documentation-first**, not a full mechanical rename.

That means:

1. Create an Antigravity-first navigation layer under `docs/antigravity-cli/`
2. Keep existing Gemini-named deep-reference modules in place as **legacy implementation reference**
3. Update top-level documentation navigation so readers start from Antigravity docs first
4. Document the migration boundary explicitly instead of pretending the rename is already complete
5. Treat runtime state under `antigravity-cli/` and `config/` as implementation surfaces, not the primary documentation source of truth

## Consequences

- ✅ New documentation becomes aligned with the user's future-facing Antigravity workflow
- ✅ Readers get a single preferred entry point instead of choosing between competing documentation trees
- ✅ Existing Gemini deep-reference modules remain available for lower-level details during migration
- ✅ Phase one stays bounded and avoids risky mass renaming across runtime and plugin surfaces
- ⚠️ Gemini-named leaf docs will still exist for a while, so navigation and cross-linking must stay explicit
- ⚠️ Some lower-level examples and filenames will remain Gemini-oriented until later migration phases

## Alternatives Considered

### Keep Gemini CLI as the primary documentation term

This would minimize immediate change and preserve the current docs structure.

It was rejected because the user is actively standardizing future workflow design around Antigravity CLI, and Gemini-first navigation would make the docs less useful for upcoming work.

### Rename the entire repository surface immediately

This would maximize naming consistency in one pass.

It was rejected because the repository still contains live runtime surfaces, plugin assets, and detailed reference modules that would be expensive and risky to rename before the migration boundary is documented clearly.

### Create parallel Antigravity docs by copying the Gemini tree

This would produce fast surface-level coverage.

It was rejected because duplicated trees would drift quickly and create two conflicting sources of truth.
