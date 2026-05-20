---
name: testing-patterns
description: Use to define test strategy, choose unit, integration, or E2E coverage, write effective cases, and improve coverage, mocks, and fixtures.
when_to_use: >
  Use when defining a test strategy for a feature or project, writing unit, integration, or E2E tests, or improving coverage and choosing between mocks, stubs, fakes, or spies.
---

# Testing Patterns

## When to Use

- Define a test strategy for a project or feature
- Write unit, integration, or end-to-end tests
- Choose between mocks, stubs, fakes, and spies
- Improve existing test coverage
- Diagnose fragile or low-value tests

## Testing Pyramid

```text
        ╱ E2E ╲          ← Few, slow, high cost
       ╱───────╲
      ╱Integration╲      ← Moderate count, validates boundaries
     ╱─────────────╲
    ╱  Unit Tests   ╲    ← Many, fast, isolated
   ╱─────────────────╲
```

**Rule of thumb:**

- **Unit:** ~70% — fast, isolated, logic-heavy coverage
- **Integration:** ~20% — validates real boundaries such as DB, API, filesystem
- **E2E:** ~10% — protects critical user journeys

These ratios are heuristics, not quotas. Let risk drive the mix.

## Core Test Patterns

### Arrange, Act, Assert

```javascript
// Arrange
const user = createUser({ email: "test@example.com" })

// Act
const result = await loginUser(user.email, "password123")

// Assert
expect(result.token).toBeDefined()
expect(result.user.email).toBe("test@example.com")
```

### Given, When, Then

```text
Given an active user with email "test@example.com"
When the user logs in with valid credentials
Then the API returns a valid JWT token
And the response status is 200
```

### Naming Convention

Test names should describe **behavior**, not implementation details:

- ✅ `should return 404 when user does not exist`
- ✅ `should reject an invalid email format`
- ❌ `tests findById`
- ❌ `test 1`

## Test Doubles

| Type | Use when | Example |
|---|---|---|
| **Mock** | You must verify an interaction itself is the behavior under test | Confirm `emailService.send()` is called |
| **Stub** | You need a dependency to return a controlled value | `userRepo.findById()` returns a fake user |
| **Fake** | You need a lightweight working substitute | In-memory database instead of PostgreSQL |
| **Spy** | You want to observe calls without changing behavior | Count how many times a function runs |

**Default:** prefer stubs and fakes over mocks. Mocks tend to lock tests to implementation shape.

## Strategy by Test Level

### Unit Tests

- Test one unit of logic at a time
- Isolate collaborators with stubs or fakes
- Cover happy path, expected failures, and edge values
- Keep execution in milliseconds

### Integration Tests

- Test boundaries: database, filesystem, queue, cache, third-party clients
- Prefer real integrations or faithful substitutes over shallow mocks
- Keep setup and teardown deterministic
- Cover serialization, persistence, auth boundaries, and contract behavior

### E2E Tests

- Test complete user-facing flows
- Keep the suite small and focused on critical paths
- Wait on observable conditions, not arbitrary sleeps
- Run in an environment as production-like as practical

## Factories and Fixtures

Prefer factories over static fixtures:

```javascript
// Factory — explicit and flexible
const user = buildUser({ role: "admin", active: true })

// Static fixture — rigid and often opaque
const user = fixtures.adminUser
```

**Practices:**

- Each test should create its own data
- Use sensible defaults in factories and override only what matters
- Reset or isolate state between tests

## How This Skill Connects to the Global Contract

The global `CLAUDE.md` is the source of truth for mandatory cross-cutting requirements such as threat-model coverage, three-axis validation, and closeout. This skill does **not** duplicate those tables.

Use this skill to decide:

- which level should carry each assertion
- which doubles and data setup make the test trustworthy
- which critical flows deserve regression coverage
- how to keep the suite fast, deterministic, and maintainable

When security or performance obligations apply, derive the required cases from the global contract and place them at the cheapest test level that still proves the requirement.

## Validation Checklist

For each feature, review coverage through these lenses:

### 1. Behavior

- [ ] Happy path
- [ ] Invalid input and validation failures
- [ ] Edge values and empty states
- [ ] Expected error handling
- [ ] Regression coverage for fixed bugs

### 2. Security-sensitive Behavior

- [ ] Auth, authorization, or data ownership cases are covered at the right level
- [ ] Untrusted input is tested with malicious and malformed values when relevant
- [ ] Security assertions required by the global contract are implemented where they belong

### 3. Performance-sensitive Behavior

- [ ] Hot paths have budgets or regression checks where required
- [ ] List endpoints or rendering paths are checked for scaling issues
- [ ] Expensive flows are not protected only by slow E2E coverage when a lower-level test would work

## Test Anti-Patterns

| Anti-pattern | Why it hurts | Better move |
|---|---|---|
| **Fragile test** | Breaks on harmless refactors | Test behavior, not implementation |
| **Slow suite** | Kills feedback loops | Isolate scope, parallelize, use fakes wisely |
| **Mock-only test** | Proves call choreography, not value | Assert outcomes and observable behavior |
| **Huge setup** | Hides intent behind boilerplate | Extract factories and narrow the scenario |
| **No assertion** | Can pass while proving nothing | Require explicit expectations |
| **Interdependent tests** | Order affects results | Keep every test independent |
| **Coverage vanity** | High line coverage, low confidence | Target risk, not percentages alone |

## Steps

### 1. Define the Strategy

Before writing tests:

- Identify the artifact under test: pure function, service, UI component, API endpoint, workflow
- Choose the cheapest level that can prove the behavior
- Map external dependencies and decide whether they need stubs, fakes, or real integrations

### 2. Write the Test First or Map Existing Coverage

For TDD:

1. Write the failing test
2. Implement the smallest change that passes
3. Refactor without changing behavior

For retroactive coverage:

1. Identify critical code paths
2. Prioritize happy path, error cases, then edge cases
3. Add regression tests for known bugs before broadening coverage

### 3. Implement the Tests

- One concept per test
- Use descriptive names
- Keep setup local and obvious
- Prefer behavior assertions over internal-call assertions

### 4. Run and Review

```bash
# Run the suite
npm test
pytest
go test ./...

# Run with coverage
npm test -- --coverage
pytest --cov
```

### 5. Tighten the Suite

- Remove duplicate tests that prove the same thing
- Split oversized tests with multiple reasons to fail
- Add focused regression cases after bug fixes

## Examples

### Unit test — JavaScript / Jest

```javascript
describe("formatCurrency", () => {
  it("should format a positive BRL amount", () => {
    expect(formatCurrency(1234.56, "BRL")).toBe("R$ 1.234,56")
  })

  it('should return "R$ 0,00" for zero', () => {
    expect(formatCurrency(0, "BRL")).toBe("R$ 0,00")
  })

  it("should throw for a negative amount", () => {
    expect(() => formatCurrency(-1, "BRL")).toThrow("Amount cannot be negative")
  })
})
```

### Integration test — Python / pytest

```python
def test_create_user_should_persist_and_send_email(db_session, mock_email_service):
    # Arrange
    payload = {"email": "user@example.com", "name": "Test User"}

    # Act
    response = client.post("/users", json=payload)

    # Assert
    assert response.status_code == 201
    assert db_session.query(User).filter_by(email=payload["email"]).first()
    mock_email_service.send_welcome.assert_called_once_with(payload["email"])
```
