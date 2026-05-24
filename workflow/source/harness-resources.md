# Canonical Harness Resource Model

## Metadata

- id: `canonical-harness-resource-model`
- kind: `contract`
- status: `draft`
- version: `0.1.0`
- owner: `WorkflowSmith`

## Purpose

WorkflowSmith defines a complete canonical resource model for modern AI software engineering harnesses.

The canonical workflow does not reduce itself to the lowest common denominator across harnesses. Harness-specific incapabilities are documented by each harness contract or distribution. They do not redefine the canonical workflow.

## Resource Standard

A WorkflowSmith harness resource is any runtime capability the workflow can rely on when directing planning, implementation, review, validation, handoff, or governance work.

Canonical resources are harness-agnostic. A resource describes the capability and operating obligation, not the product-specific tool name, command surface, UI affordance, or API used to satisfy it.

## Required Resource Areas

### Conversation And Control

The harness must support interactive collaboration, clarifying questions, structured status updates, resumable work, and final closeout reporting.

It must distinguish between planning, execution, review, and closeout so the workflow can require different behavior at each stage.

### Planning And Progress

The harness must support explicit plans, task decomposition, progress tracking, decision capture, assumptions, open questions, and acceptance criteria.

It must make material decisions visible before execution when the workflow requires a gate.

### Workspace Inspection

The harness must support reading files, listing directories, searching text, inspecting code structure, comparing current and expected behavior, and identifying relevant entrypoints, schemas, tests, and documentation.

It must prefer repository truth over unsupported assumptions.

### Editing And Change Management

The harness must support creating, editing, deleting, moving, and patching files. It must support reviewing diffs and preserving unrelated user changes.

It must keep edits scoped to the accepted goal and avoid destructive workspace operations unless the workflow explicitly permits them.

### Execution And Validation

The harness must support shell or equivalent command execution, tests, builds, linters, format checks, long-running processes, logs, and environment inspection.

It must report validation commands, outcomes, failures, and remaining risk before closeout.

### Version Control And Collaboration

The harness must support git-oriented workflows, including status inspection, branches, diffs, commits, issue context, pull requests, reviews, labels, assignees, project tracking, and merge-readiness signals.

It must preserve traceability from goal to change, validation, review, and closeout.

### External Knowledge

The harness must support current external knowledge retrieval through web, documentation, repository, or connector-backed sources.

It must use authoritative sources for unstable, high-stakes, or product-specific facts and cite sources when the workflow depends on external knowledge.

### Tooling And Connectors

The harness must support discoverable tools, connectors, or plugin-like integrations for external systems such as repositories, issue trackers, package registries, browsers, observability systems, documents, and internal services.

It must expose tool availability and unsupported tool behavior clearly enough for the workflow to choose a safe path.

### Delegation And Parallel Work

The harness must support parallel or delegated work when useful for research, inspection, validation, or review.

It must preserve coordination, summarize delegated findings, and avoid hiding unresolved decisions behind delegation.

### Memory And Instructions

The harness must support local instructions, project guidance, durable or session memory, skills, rules, and context compaction or recovery.

It must respect project-local authority and distinguish product decisions from assistant or harness-specific operating guidance.

### Visual And Interactive Inspection

The harness must support previewing applications, inspecting screenshots or images, interacting with browser or app surfaces, and validating visual or UI behavior when the work requires it.

It must report what was visually inspected and what was not inspected.

### Safety, Permission, And Audit

The harness must support permission gates for mutating, destructive, external, privileged, networked, or high-risk operations.

It must preserve an audit trail of material actions, external sources, approvals, validation results, and known residual risk.

## External And Mutating Resource Policy

The workflow requires explicit caution when a resource can change outside the workspace, reveal sensitive data, spend money, modify infrastructure, contact a third-party service, install dependencies, publish artifacts, or destroy data.

For those resources, the harness must:

- identify the risk before use;
- request approval when the workflow or environment requires it;
- prefer official or primary sources for factual claims;
- cite external sources used for decisions;
- validate the result through the strongest available local or external check;
- report unresolved risk at closeout.

## Harness Gap Policy

Harness-specific contracts and distributions must declare any gap against this canonical model.

A gap may be:

- unsupported: the harness cannot provide the capability;
- partial: the harness provides only a constrained form;
- gated: the capability exists only with approval, configuration, or credentials;
- delegated: the capability must be satisfied through another system.

Gaps belong in harness contracts or distributions. They must not narrow the canonical resource model.
