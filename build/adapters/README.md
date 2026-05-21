# Adapters

This directory contains harness adapters — one subdirectory per supported target harness.

## What an Adapter Is

An adapter is a set of documents that describes how to translate canonical WorkflowSmith workflow units into the native format a specific AI tool expects. Adapters live here; canonical content lives in `core/`, `agents/`, `skills/`, `memory/`, and `checklists/`.

## Current Status

No adapters are implemented. This directory is a reserved location.

Adding an adapter requires an ADR before any files are created here. The ADR must describe the target harness format, the field mapping rules from the canonical schema, and any constraints specific to that harness.

## Future Adapter Structure

When an adapter is added, it will follow this structure:

```
build/adapters/
└── <harness-name>/
    ├── README.md         ← mapping rules and harness-specific notes
    └── [adapter files]   ← format depends on harness
```

Supported harnesses in scope for future phases: Copilot, Claude, Antigravity CLI. Others require an ADR.
