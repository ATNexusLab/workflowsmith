# Harness Target Contract

A harness target contract must define:

- target harness name
- supported runtime surfaces
- canonical inputs accepted, including the canonical harness resource model
- mapping rules
- mappings for canonical `instruction`, `agent`, and `skill` units
- partial mappings against canonical resources
- unsupported behavior against canonical resources
- gated or credential-dependent resources
- delegated resources satisfied through another system
- validation requirements
- traceability requirements

Harness target contracts must treat `workflow/spec/harness-resources.md` as the source of truth for expected harness capabilities. A harness-specific limitation is a documented gap, not a change to the canonical workflow.

Codex is the first target contract to be completed after the 0.0.0 foundation.
