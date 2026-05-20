---
name: ux-specification
description: Use to specify user flows, interface behavior, and accessibility criteria before implementing UX or UI.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
---

# UX Specification

## When to Use

- Define user flows and interface behavior before implementation begins
- Specify states, transitions, and edge cases for a UI component or feature
- Establish accessibility requirements for a feature
- Write acceptance criteria that capture both happy path and failure states
- Review a proposed UI design for completeness before handoff to engineering

## Core Principle

A UX specification is complete when an engineer can implement the feature without guessing and a QA engineer can verify it without asking for clarification. Every ambiguous state is a future bug.

## Specification Structure

### User Flow Specification

```markdown
## Flow: {Flow Name}

**Entry points:**
- {Where the user can start this flow}

**Prerequisites:**
- {State that must be true before the user enters this flow}

### Step 1: {Step Name}

**Screen / Component:** {name}

**User sees:**
- {What is visible, in priority order}

**User can:**
- {Primary action} → leads to Step 2
- {Secondary action} → leads to {state}
- {Destructive action} → triggers {confirmation / warning}

**System state:** {what the backend has or has not done at this point}

### Step 2: {Step Name}

...

### Terminal States

| State | How reached | What the user sees | What happens next |
|---|---|---|---|
| Success | Completes Step N | {success message / next screen} | {navigation or auto-action} |
| Error: {type} | {condition} | {error message} | User can {retry / go back / contact support} |
| Cancelled | User exits flow | {any data preserved?} | Returns to {entry point} |
```

### Component State Specification

```markdown
## Component: {Component Name}

**Purpose:** {one sentence description}

### States

#### Default
- {What the component looks like with no data loaded and no interaction}

#### Loading
- Trigger: {what causes loading state}
- Visual: {skeleton / spinner / disabled state}
- Duration: {max expected duration before error state}
- Behavior: {can the user interact? is navigation blocked?}

#### Populated
- {What the component looks like with data}
- Maximum items / characters displayed: {limit}
- Overflow behavior: {pagination / scroll / truncation / expand}

#### Empty
- Trigger: {when data returns with zero results}
- Visual: {illustration, message, or action}
- Action available: {what can the user do from empty state}

#### Error
- Trigger: {when the data request fails}
- Visual: {error message and severity}
- Recovery action: {retry button / navigate away / contact support}
- Error message: {exact text or template}

#### Disabled
- Trigger: {condition that disables the component}
- Visual: {opacity, cursor, tooltip explaining why}
- Accessibility: `aria-disabled="true"`, not `disabled` attribute when interaction feedback is needed

### Interactions

| Trigger | Condition | Action | Result |
|---|---|---|---|
| Click primary button | Form is valid | Submit form | → Loading state |
| Click primary button | Form is invalid | Show inline validation | Stay on current state |
| Press Enter | Input focused | Submit if valid | → Loading state |
| Press Escape | Modal open | Close modal | → Previous state |

### Validation Rules

| Field | Rule | Error message |
|---|---|---|
| Email | Required, valid format | "Enter a valid email address" |
| Password | Required, min 8 characters | "Password must be at least 8 characters" |
| {field} | {rule} | {exact message text} |
```

## Accessibility Requirements

Every UI specification must include accessibility criteria. Minimum requirements:

### Keyboard Navigation

```markdown
### Keyboard Navigation

- Tab order follows visual reading order (top-left to bottom-right)
- All interactive elements are reachable by Tab key
- No keyboard trap: pressing Tab or Escape always provides a way out
- Focus is visible: focused element has a visible outline (not removed with outline: none)
- Destructive actions require explicit confirmation; Escape cancels

**Focus management:**
- Modal opens: focus moves to the modal's first focusable element or the modal heading
- Modal closes: focus returns to the element that triggered it
- Dynamic content added to the page: focus moves to the new content if the action was explicit
```

### Screen Reader Requirements

```markdown
### Screen Reader Support

- All images have `alt` text; decorative images have `alt=""`
- Form inputs have associated `<label>` elements or `aria-label`
- Error messages are associated with their input via `aria-describedby`
- Loading states are announced: `aria-live="polite"` for non-disruptive updates
- Icons used as buttons have `aria-label`; icon-only buttons are not unlabeled
- Modals use `role="dialog"` with `aria-modal="true"` and `aria-labelledby` pointing to the heading
- Data tables have `<th>` elements with `scope` attributes
```

### Color and Contrast

```markdown
### Color and Contrast

- Body text: minimum 4.5:1 contrast ratio against background
- Large text (≥18pt or ≥14pt bold): minimum 3:1 contrast ratio
- UI components and focus indicators: minimum 3:1 against adjacent colors
- Information is not conveyed by color alone: error states use icon + color + text
```

### ARIA Patterns

```markdown
### ARIA Usage

Use native HTML semantics before adding ARIA. ARIA supplements; it does not override.

Required patterns for this component:
- {Pattern}: {reason and implementation}

Example:
- Disclosure (show/hide): use `<button aria-expanded="true/false" aria-controls="{panel-id}">`
- Alert: use `role="alert"` for urgent messages announced immediately
- Live region: use `aria-live="polite"` for updates that do not require immediate action
```

## Acceptance Criteria Format

Write acceptance criteria in Given-When-Then form for testability:

```markdown
### Acceptance Criteria

**Happy path:**
- Given I am on the order list page
  When I click "Create order"
  Then the order creation modal opens with focus on the first input field

- Given I have filled in all required fields
  When I click "Confirm order"
  Then the modal shows a loading state and the button is disabled

- Given the order is successfully created
  When the API returns 201
  Then the modal closes, the order list updates, and a success toast appears

**Error path:**
- Given I submit the form with an empty email field
  When validation runs
  Then the email field shows "Enter a valid email address" and focus moves to the field

- Given the API returns a 422 error
  When the error response is received
  Then the modal stays open and shows "Unable to place order. Check your item quantities."

- Given the API returns a 500 error
  When the error response is received
  Then the modal shows "Something went wrong. Try again or contact support." with a Retry button

**Edge cases:**
- Given the user presses Escape while the modal is loading
  Then the modal closes and the in-flight request is cancelled

- Given the user presses Tab from the last focusable element in the modal
  Then focus wraps to the first focusable element in the modal (focus trap)
```

## Specification Completeness Checklist

A spec is complete when:

**States:**
- [ ] Default state is specified
- [ ] Loading state is specified
- [ ] Empty state is specified
- [ ] Error state is specified with the exact error message
- [ ] Every conditional state is specified (authenticated/unauthenticated, admin/regular user, etc.)

**Interactions:**
- [ ] Every interactive element has a defined action and result
- [ ] Every form field has validation rules and error messages
- [ ] Destructive actions have confirmation steps
- [ ] Cancelation behavior is defined

**Accessibility:**
- [ ] Keyboard navigation order is defined
- [ ] Focus management for modals and drawers is specified
- [ ] Screen reader labels are specified for non-text elements
- [ ] Color contrast meets WCAG AA

**Acceptance Criteria:**
- [ ] Happy path has criteria
- [ ] Each documented error has criteria
- [ ] Edge cases are covered (empty, maximum, concurrent action)

## What NOT to Specify in a UX Spec

- Exact pixel values — those belong in the design system tokens
- Implementation details — the spec defines what the user experiences, not how it is built
- Copy for marketing purposes — copy with persuasion intent belongs in a content brief, not a spec
- Aesthetic preferences without behavioral consequence — document what the system does, not what it looks like beyond state-relevant appearance

## Never Do

- Specify only the happy path — error and empty states are where users need the most clarity
- Leave validation rules ambiguous ("must be valid") — define exactly what valid means
- Omit accessibility requirements — they are functional requirements, not nice-to-haves
- Write acceptance criteria that cannot be tested ("should feel fast") — quantify or specify observable behavior
- Hand off a spec with undefined states — "TBD" in a spec is a bug waiting to happen
