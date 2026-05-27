# ADR-0008: Instruction Scope Model

## Status

Accepted

## Context

ADR-0002 separated canonical source, compiler contracts, and harness distributions.
ADR-0005 defined `instruction`, `agent`, and `skill` as distinct canonical unit
types. RFC #14 now needs a canonical instruction scope model before
`workflow/source/instructions/` can receive real product content.

The research in `docs/research/instruction-scope-survey.md` showed recurring
instruction surfaces across the current target harnesses:

- global or user scope;
- project or repository scope;
- subdirectory or path-specific scope;
- local uncommitted overrides.

The same research also showed that the file names, merge rules, and extra
surfaces differ by harness. Those differences belong in compiler contracts and
distributions, not in canonical source.

Product decisions made during RFC #14 clarified three points:

1. the global workflow is part of the product;
2. subdirectory scope is canonical;
3. the current repository `/AGENTS.md` is tooling guidance, not canonical source.

The design discussion for the global instruction layer added another critical
constraint: global instructions are always carried alongside the rest of the
runtime prompt, so they must stay short and only contain behavior-shaping rules.
WorkflowSmith should not spend instruction budget restating what a capable model
already knows by default.

## Decision

WorkflowSmith recognizes these canonical instruction scopes:

| Scope | Purpose | Authority | Canonical content |
|---|---|---|---|
| `global` | Product-level always-on workflow installed for a specific harness | WorkflowSmith product authority | Durable, high-precedence behavior that should govern work in any project |
| `project` | Repository-level workflow material committed with a project | Project authority | Project-specific context, architecture, validation, conventions, local WorkflowSmith capabilities |
| `subdir` | Narrower rules for a bounded area of a repository | Project authority | Area-specific guidance for a subtree or matched path set |
| `local` | User-private local additions or overrides | User-local only, never product authority | Personal overrides or local capabilities not committed as project truth |

`org` is **not** a canonical source scope in `0.1.0`. Some harnesses expose an
organization-level instruction surface, but that is treated as a harness-native
distribution target documented by compiler contracts when relevant. It does not
introduce a fifth canonical source scope.

### Global scope

The `global` scope is part of the product. WorkflowSmith installation is always
harness-specific. The installer or compiler contract identifies the native
global location for the selected harness and deploys the complete WorkflowSmith
workflow there, not just a standalone instructions file.

Global instructions contain only always-on, high-precedence behavior anchors.
They must not be a dump of generic advice or obvious best practices that a
capable model already knows by default.

The global layer should cover these behavior categories:

1. planning gate before execution, with work split into reviewable increments;
2. preservation of accepted scope;
3. never assuming missing facts and deferring to project documentation;
4. project and stack authority over model preference;
5. code quality rules that reject hacks, magic behavior, dead code, oversized
   files, weak naming, hardcoded environment values, and missing error handling;
6. security and performance as blocking concerns, not optional polish;
7. honest validation before closeout;
8. intellectual honesty over agreement-seeking behavior;
9. always-on awareness of WorkflowSmith artifacts when they exist.

### Project scope

The `project` scope holds repository-specific truth. It carries the local
architecture, stack constraints, conventions, validation commands, and other
project authority that the global layer must defer to.

Project scope may also host WorkflowSmith material that teaches the workflow how
to operate inside that repository, including local skills that help create or
adapt agents, skills, or other project-specific workflow artifacts.

### Subdirectory scope

The `subdir` scope is canonical. It is used when a repository needs narrower
guidance for a bounded area such as frontend, billing, infrastructure, or a
specific package.

How a harness resolves subdirectory scope is a compiler-contract concern. Some
harnesses use nearest-file lookup. Others use path globs or equivalent matching.
Those differences do not change the canonical model.

### Local scope

The `local` scope is for uncommitted, user-private overrides or capabilities.
It can help a user adapt the workflow in a local environment, but it is never a
source of project truth and must not silently override committed product or
project decisions.

### Size and modularity policy

The primary instruction entry file should stay single-file when possible and is
expected to remain within **200 lines**.

When instruction content exceeds that budget:

1. first split it into smaller instruction files with one responsibility each;
2. move reusable procedures to `skill`;
3. move conditional or reactive behavior to a future `hook` or `rule` kind once
   those kinds exist canonically;
4. move execution-role material to `agent`.

This keeps the global prompt surface small and preserves the boundaries already
defined by ADR-0005 and `workflow/spec/authoring-modularity.md`.

## Consequences

- `workflow/source/instructions/` will be authored against four canonical
  scopes: `global`, `project`, `subdir`, and `local`.
- Fase 4 can now create the first global instruction units using the behavior
  categories defined above.
- Compiler contracts must map those canonical scopes to harness-native files,
  merge behavior, and install locations.
- Harness-native org-level features may be used by a distribution, but only as a
  mapping detail. They do not redefine canonical source structure.
- The current repository `/AGENTS.md` remains development tooling and is not
  canonical instruction source.
- Any future addition of a new canonical scope requires a new ADR.
