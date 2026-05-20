---
description: Run a full security audit on $ARGUMENTS — invokes @engine with the security-audit skill.
---

Run a security audit on this codebase.

- Target: $ARGUMENTS

If no target is specified, ask the user before proceeding. Accepted inputs: a module name, file path, feature area, or surface description (e.g. `src/auth/`, `the payment flow`, `all API endpoints`).

Deliver:
- Findings with severity: Critical / High / Medium / Low / Informational
- Identified threat surfaces and attack vectors for each finding
- Recommended fixes with enough detail to act on immediately
- Any areas outside the requested scope that warrant a follow-up review

If a finding requires an architectural decision to resolve, flag it explicitly so an ADR can be created via @principal before implementation begins.
