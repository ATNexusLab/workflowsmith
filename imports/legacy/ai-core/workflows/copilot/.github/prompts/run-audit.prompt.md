---
description: Run a security audit and threat model on a specific module, file path, or surface area.
agent: engine
argument-hint: "Specify what to audit — e.g. src/auth/, the payment flow, all API endpoints"
---

Run a security audit on this codebase.

- Target: _[Replace with the module name, file path, or area to audit. If not specified, ask the user before proceeding.]_

Deliver:
- Findings with severity: Critical / High / Medium / Low / Informational
- Identified threat surfaces and attack vectors for each finding
- Recommended fixes with enough detail to act on immediately
- Any areas outside the requested scope that warrant a follow-up review

If a finding requires an architectural decision to resolve, flag it explicitly so an ADR can be created before implementation.
