---
name: ux-specification
description: Use to specify user flows, interface behavior, and accessibility criteria before implementing UX or UI.
user-invocable: true
disable-model-invocation: false
triggers:
  - "create a UX specification or user flow"
  - "define accessibility criteria"
  - "evaluate or document interface decisions"
license: MIT
---

# UX Specification

## When to Use

- Define a user flow before implementation starts
- Specify behavior for complex UI components
- Define accessibility criteria for a feature
- Evaluate whether an interface decision is acceptable

## UX Discovery Questions

Before specifying any interface:

- **Who is the user?** — profile, context, primary device
- **What is the goal?** — what is the user trying to accomplish?
- **What is the shortest valid path?** — how many steps are actually necessary?
- **What can go wrong?** — error, loading, empty, offline, and interruption states
- **Is it accessible?** — can people with visual, motor, or cognitive constraints complete the task?

## Flow Specification Format

```markdown
## Flow: [Flow Name]

### Persona
[Who the user is in this flow]

### Goal
[What the user wants to achieve]

### Preconditions
[What must be true before the flow starts]

### Primary Path
1. User does X
2. System shows Y
3. User does Z
4. System confirms and redirects to W

### Alternate Paths
- **Case A:** If [condition], then [behavior]
- **Case B:** If [condition], then [behavior]

### Error States
- **Validation error:** [message shown, field highlighted]
- **Server error:** [friendly generic message, no technical details]
- **Timeout:** [visible feedback + retry option]

### Loading States
- [What feedback appears during async work]

### Empty State
- [What appears when there is no data]
```

## Accessibility Criteria (WCAG 2.1 AA)

### Required

- **Contrast:** normal text ≥ 4.5:1, large text ≥ 3:1
- **Keyboard access:** every interactive element must be reachable without a pointer
- **Labels:** every input has an associated label, not just a placeholder
- **Alt text:** every informative image has a meaningful description
- **Visible focus:** focus state is always visible
- **No color-only meaning:** color is never the only signal for important information

### Forms

- Validation errors appear close to the affected field
- Error messages are descriptive, not generic
- Required fields are marked visually and programmatically

### Navigation

- Provide skip links to main content where appropriate
- Use semantic landmarks such as `main`, `nav`, `header`, and `footer`
- Keep heading hierarchy logical

## Feedback Patterns

| Situation | Expected feedback |
|---|---|
| Async action | Spinner or skeleton, and disable the repeated action if needed |
| Success | Positive confirmation with a clear next step |
| Validation error | Inline feedback near the field |
| System error | Toast or banner with clear language and retry path |
| Empty list | Explain the state and suggest a next action |
| Destructive action | Explicit confirmation, not instant execution |

## Never Do

- Never rely on color alone to communicate critical meaning
- Never trigger destructive actions without explicit confirmation
- Never use placeholder text as a label replacement
- Never create blocking modals without a clear exit
- Never move focus unexpectedly without a user benefit and proper announcement

## Steps

### 1. Gather Product Context

Before specifying the flow:

- Who is the user?
- What problem is being solved?
- What are the platform constraints: mobile, desktop, or both?

### 2. Run UX Discovery

Use the discovery questions to collect structured context before writing the flow.

### 3. Map the User Flow

Use the flow-specification format to document:

- starting context
- trigger
- primary path
- alternate and failure states
- expected result

### 4. Define Accessibility Criteria

Apply the WCAG requirements that affect this flow, including contrast, keyboard behavior, labels, and announcements.

### 5. Review Feedback States

Check the feedback-pattern table to ensure loading, error, success, empty, and destructive states are specified.

### 6. Deliver the Specification

- Review with product stakeholders
- Hand off to frontend or mobile implementation
- Write clear, testable acceptance criteria

## Validation Checklist

- [ ] User persona identified and documented
- [ ] User flow mapped with happy path, alternate paths, and failure states
- [ ] WCAG 2.1 AA criteria applied
- [ ] Feedback patterns defined for loading, success, empty, and error states
- [ ] Edge cases identified, including slow connections or empty data
- [ ] Specification reviewed with product stakeholders
- [ ] Acceptance criteria are written and testable
- [ ] Handoff to implementation is clear

## Example

### Flow specification — Email and password login

```markdown
## Flow: Email and Password Login

**Context:** Unauthenticated user tries to access a restricted area
**Trigger:** Click on "Sign in" or automatic redirect

### Primary Path
1. User sees a form with Email and Password fields
2. User fills the fields
3. User clicks "Sign in"
4. System validates credentials
5. System redirects to the dashboard

### Alternate States
- **Loading:** Button is disabled and shows a spinner after submit
- **Validation error:** Inline message appears on invalid fields
- **Invalid credentials:** "Email or password is incorrect" without exposing which one failed
- **Locked account:** Specific message with support path

### Accessibility
- Labels are associated with each input
- After validation failure, focus moves to the first invalid field
- Error messages are announced through `aria-live`
```
