# Roadmap

WorkflowSmith progresses by versioned milestones. Each milestone must leave the repository coherent and validated.

## 0.0.0 - Clean Foundation

Goal: define the product, architecture, governance, validation, and repository layout.

Deliverables:

- root manifest
- canonical source directory
- compiler contract directory
- Codex distribution placeholder
- GitHub Project governance
- issue and PR templates
- validation script
- initial ADR sequence

Exit criteria:

- `sh scripts/validate.sh` passes
- no legacy import directory exists
- GitHub Project `WorkflowSmith-0.0.0` exists
- new issues and PRs are routed into the Project

## 0.1.0 - Canonical Workflow Specification

Goal: define the complete harness-agnostic workflow.

Deliverables:

- workflow roles
- rigor levels
- planning and execution model
- review and validation model
- closeout contract
- canonical workflow schema

## 0.2.0 - Codex Compiler Contract

Goal: define how the canonical workflow compiles into Codex-native surfaces.

Deliverables:

- Codex mapping contract
- unsupported/partial behavior matrix
- validation checklist for Codex output

## 0.3.0 - Codex Distribution

Goal: ship the first validated compiled harness distribution.

Deliverables:

- `dist/codex/` production-ready package
- installation and usage notes
- traceability record
- acceptance scenarios

## 1.0.0 - Enterprise Workflow Release

Goal: release the complete WorkflowSmith product.

The 1.0.0 release requires a stable canonical workflow, validated Codex distribution, documented compiler model, governance process, and a path for additional harnesses.
