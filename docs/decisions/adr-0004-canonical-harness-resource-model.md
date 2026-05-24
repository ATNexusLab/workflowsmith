# ADR-0004: Canonical Harness Resource Model

## Status

Accepted

## Context

WorkflowSmith is beginning the `0.1.0` canonical workflow specification. The first content slice defines which harness resources the canonical workflow may rely on.

The project already separates canonical source, compiler contracts, and harness distributions. Codex is the first planned distribution, but the workflow must remain generalized across modern AI software engineering harnesses.

Leading harnesses expose broad capabilities including conversation, planning, file inspection, editing, shell execution, validation, git collaboration, web or documentation retrieval, connectors, delegation, memory, visual inspection, and permission controls. WorkflowSmith needs a complete canonical model for those capabilities before writing detailed procedures.

Reference documentation from Codex, Claude Code, Cursor, Windsurf, Antigravity CLI, GitHub Copilot coding agent, and Devin was used to calibrate current market coverage. Those references are examples, not product authority.

## Decision

WorkflowSmith will define harness resources in canonical source as a complete, harness-agnostic resource model.

The canonical workflow will not use the lowest common denominator across harnesses. It will describe the capabilities expected of a complete modern AI software engineering harness.

Harness-specific limitations are documented in each harness contract or distribution as gaps against the canonical model. Those limitations do not redefine or reduce the canonical workflow.

External, mutating, destructive, privileged, networked, or otherwise high-risk resources require explicit safety policy: permission gates when required, authoritative sources for unstable facts, citations for external knowledge, validation, and closeout risk reporting.

## Consequences

- The first canonical workflow unit is a resource contract in `workflow/source/`.
- Harness contracts must map to the canonical resource model and declare unsupported, partial, gated, or delegated capabilities.
- Future workflow procedures may rely on the canonical resource model without naming Codex, Claude, Cursor, Devin, Antigravity, Windsurf, Copilot, or any other harness.
- Distribution authors must document incompatibilities instead of weakening canonical behavior.
- Changes to the canonical resource model are product-level workflow or harness strategy changes and require the normal RFC/ADR process when material.

## Reference Calibration

- OpenAI Codex CLI: https://developers.openai.com/codex/cli
- Claude Code tools: https://code.claude.com/docs/en/tools-reference
- Cursor agent tooling: https://docs.cursor.com/agent/tools
- Windsurf Cascade: https://docs.windsurf.com/windsurf/cascade/cascade
- Antigravity CLI: https://antigravity.google/docs/cli-overview
- GitHub Copilot coding agent: https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent
- Devin session tools: https://docs.devin.ai/work-with-devin/devin-session-tools
