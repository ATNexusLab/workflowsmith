---
name: testing-contract
description: Use for any implementation task that must define or verify Behavior, Security, and Performance coverage before completion.
kind: skill
tools:
  - read_file
  - grep
  - run_shell_command
---

# Testing Contract

## When to Use

Load this skill for any implementation task where a feature, fix, refactor, API change, schema change, or UI flow needs explicit test coverage across **Behavior + Security + Performance**.

## Activation

Trigger this skill for requests such as:
- "implement feature"
- "write tests"
- "add coverage"
- "fix bug with regression test"
- "make this production-ready"
- "review test plan before shipping"

## Canonical Source

Load the shared 3-axis contract from the canonical source instead of duplicating it here:

@./../../common/test-contract.md

If the runtime does not expand relative imports automatically, load it explicitly with:

`read_file ~/.gemini/common/test-contract.md`

## Workflow

1. **Threat modeling first** — enumerate touched surfaces and map them to the security cases before writing or approving tests.
2. **Axis 1: Behavior** — cover happy path, edge cases, expected failures, and idempotency or concurrency when relevant.
3. **Axis 2: Security** — apply the required OWASP-aligned cases from the canonical contract to every touched surface; do not mark items n/a without justification.
4. **Axis 3: Performance** — define budgets or regression checks after Behavior and Security coverage are clear.

## Validation Checklist

- [ ] The canonical contract was loaded from `~/.gemini/common/test-contract.md`
- [ ] Threat surfaces were listed before implementation
- [ ] Coverage was planned or reviewed in the order: Threat model → Behavior → Security → Performance
- [ ] The full OWASP and performance tables were not copied into this skill file

## Never Do

- Do not duplicate the canonical contract inline.
- Do not skip threat modeling.
- Do not treat Security or Performance coverage as optional for feature completion.
