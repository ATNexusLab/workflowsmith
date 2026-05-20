---
id: skill-review-code
type: skill
status: promoted
version: 1.0.0
---

# Review Code Skill

Use this skill for code review and repository review tasks.

## Review Focus

Prioritize:

1. Correctness bugs
2. Behavioral regressions
3. Security or data-loss risks
4. Missing tests for changed behavior
5. Maintainability issues that create concrete risk

## Output Shape

- Lead with findings.
- Order findings by severity.
- Reference concrete files and lines when possible.
- Explain the user-visible or operational risk.
- Keep summaries secondary to findings.

## No Findings

If no issues are found, say that clearly. Also state any review limits, such as tests not run, generated files not inspected, or missing runtime coverage.

## Boundaries

Do not redesign the workflow under review unless the user explicitly asks for redesign. Keep recommendations tied to observed risks.
