---
name: testing-patterns
description: Use to define test strategy, choose unit, integration, or E2E coverage, write effective cases, and improve coverage, mocks, and fixtures.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
---

# Testing Patterns

## When to Use

- Define a test strategy for a new feature or service
- Choose the right test level (unit, integration, E2E) for a specific behavior
- Write effective test cases with clear arrange-act-assert structure
- Improve test coverage without writing redundant tests
- Review test quality: identify what is overtested, undertested, or tested at the wrong level
- Set up mocks, stubs, and fixtures correctly

## Core Principles

1. **Test behavior, not implementation** — tests should survive internal refactoring
2. **Right level for the right behavior** — unit tests for logic, integration tests for boundaries, E2E tests for critical user paths
3. **One reason to fail** — each test validates one behavior; multiple assertions are fine if they all describe the same outcome
4. **Readable tests are documentation** — a failing test should tell you exactly what broke and why
5. **Fast feedback loop** — the test suite must run fast enough to run on every save

## Test Pyramid

```
         /‾‾‾‾‾‾‾‾‾\
        /    E2E      \        Few, slow, high-confidence
       /_______________\
      /                 \
     /   Integration     \     Some, medium speed
    /_____________________ \
   /                        \
  /         Unit              \   Many, fast, focused
 /____________________________\ 
```

**Allocation guidance:**

| Level | Proportion | Speed | What it catches |
|---|---|---|---|
| Unit | ~70% | < 1ms each | Logic errors, edge cases, business rules |
| Integration | ~20% | 10–500ms | Boundary wiring, persistence, service calls |
| E2E | ~10% | Seconds | Critical user flows, full-stack regression |

## Unit Testing

### Arrange-Act-Assert Pattern

```javascript
describe('calculateOrderTotal', () => {
  it('applies 10% tax to subtotal', () => {
    // Arrange
    const items = [
      { price: 100, quantity: 2 },
      { price: 50, quantity: 1 },
    ];

    // Act
    const total = calculateOrderTotal(items);

    // Assert
    expect(total).toBe(275); // (100*2 + 50) * 1.1
  });

  it('returns 0 for empty items array', () => {
    expect(calculateOrderTotal([])).toBe(0);
  });

  it('throws when items is null', () => {
    expect(() => calculateOrderTotal(null)).toThrow('items is required');
  });
});
```

### What Belongs in Unit Tests

- Business logic and calculation functions
- Validation rules and their edge cases
- State machine transitions
- Error handling and boundary conditions
- Pure transformations (formatting, parsing, mapping)

### What Does NOT Belong in Unit Tests

- Database queries (those are integration tests)
- HTTP requests (those are integration tests)
- File system operations (those are integration tests)
- Rendering behavior (those are component/E2E tests)

### Test Case Design

**Equivalence partitioning** — test one case per valid and invalid class, not every possible value:

```javascript
// BAD: testing multiple values in the same class
expect(validateAge(18)).toBe(true);
expect(validateAge(25)).toBe(true);
expect(validateAge(40)).toBe(true);

// GOOD: test the boundary and representative values
expect(validateAge(17)).toBe(false);  // below minimum
expect(validateAge(18)).toBe(true);   // minimum (boundary)
expect(validateAge(25)).toBe(true);   // valid representative
expect(validateAge(null)).toBe(false); // null input
expect(validateAge('abc')).toBe(false); // invalid type
```

**Boundary value analysis** — always test at, above, and below each boundary:

```javascript
// For limit = 100:
expect(process(99)).toBe('under limit');   // below
expect(process(100)).toBe('at limit');     // at
expect(process(101)).toBe('over limit');   // above
```

## Integration Testing

### What Belongs in Integration Tests

- Repository methods against a real database
- HTTP handlers with real middleware and a real router
- Message queue publish/consume
- External service client behavior (often with a recorded mock or test server)

### Database Integration Test Pattern

```javascript
describe('OrderRepository', () => {
  let db;

  beforeAll(async () => {
    db = await createTestDatabase();
    await db.migrate();
  });

  afterAll(async () => {
    await db.close();
  });

  afterEach(async () => {
    await db.truncate(['orders', 'users']);
  });

  it('finds an order by id', async () => {
    // Arrange
    const user = await db.users.create({ email: 'test@example.com' });
    const created = await db.orders.create({
      userId: user.id,
      totalCents: 1000,
      status: 'pending',
    });

    // Act
    const found = await orderRepository.findById(created.id);

    // Assert
    expect(found).toMatchObject({
      id: created.id,
      userId: user.id,
      totalCents: 1000,
      status: 'pending',
    });
  });

  it('returns null for a non-existent id', async () => {
    const found = await orderRepository.findById('00000000-0000-0000-0000-000000000000');
    expect(found).toBeNull();
  });
});
```

### HTTP Integration Test Pattern

```javascript
describe('POST /orders', () => {
  it('creates an order and returns 201', async () => {
    const user = await createTestUser();
    const token = generateTestToken(user.id);

    const response = await request(app)
      .post('/api/v1/orders')
      .set('Authorization', `Bearer ${token}`)
      .send({
        userId: user.id,
        items: [{ productId: 'prod_123', quantity: 1 }],
      });

    expect(response.status).toBe(201);
    expect(response.body.data).toMatchObject({
      status: 'pending',
      userId: user.id,
    });
  });

  it('returns 401 without authentication', async () => {
    const response = await request(app)
      .post('/api/v1/orders')
      .send({ userId: 'usr_123', items: [] });

    expect(response.status).toBe(401);
  });

  it('returns 400 for missing items', async () => {
    const user = await createTestUser();
    const token = generateTestToken(user.id);

    const response = await request(app)
      .post('/api/v1/orders')
      .set('Authorization', `Bearer ${token}`)
      .send({ userId: user.id });

    expect(response.status).toBe(400);
    expect(response.body.error.code).toBe('VALIDATION_ERROR');
  });
});
```

## E2E Testing

### What Belongs in E2E Tests

- Critical user journeys (sign up, login, complete a purchase, core activation event)
- Cross-service workflows that cannot be validated at a lower level
- Accessibility and visual regression for key pages

### E2E Anti-Patterns

- Testing every variation of form validation (that belongs in unit and integration tests)
- Testing the same flow from multiple entry points when one suffices
- Long, chained tests where early failure breaks unrelated assertions
- Tests that depend on external services rather than a stable test environment

### Playwright Pattern

```javascript
test('user completes checkout', async ({ page }) => {
  // Arrange
  await page.goto('/');
  await loginAs(page, { email: 'test@example.com', password: 'testpassword' });

  // Act
  await page.click('[data-testid="add-to-cart"]');
  await page.click('[data-testid="checkout-button"]');
  await page.fill('[name="cardNumber"]', '4242424242424242');
  await page.fill('[name="cardExpiry"]', '12/26');
  await page.fill('[name="cardCvc"]', '123');
  await page.click('[data-testid="place-order"]');

  // Assert
  await expect(page.locator('[data-testid="order-confirmation"]')).toBeVisible();
  await expect(page.locator('[data-testid="order-id"]')).toContainText('ord_');
});
```

## Mocks and Stubs

### When to Mock

- External HTTP services (third-party APIs, payment providers)
- Time-dependent behavior (`Date.now()`, timers)
- Services not under test in a unit test
- Expensive operations that are tested separately

### When NOT to Mock

- The database in integration tests — use a real test database
- The code under test itself
- Simple utility functions with no side effects

### Mock Patterns

```javascript
// Stub a dependency
jest.mock('../services/emailService', () => ({
  sendEmail: jest.fn().mockResolvedValue({ messageId: 'msg_123' }),
}));

// Verify the stub was called correctly
expect(emailService.sendEmail).toHaveBeenCalledWith({
  to: 'user@example.com',
  subject: 'Order confirmed',
  orderId: expect.any(String),
});

// Mock time
jest.useFakeTimers();
jest.setSystemTime(new Date('2024-01-15T10:00:00Z'));
// ... test time-dependent behavior ...
jest.useRealTimers();
```

### Avoid Over-Mocking

Over-mocking produces tests that pass even when the integration is broken. Prefer:

- Real implementations for fast in-process collaborators
- In-memory implementations for persistence layers in unit tests
- Recorded HTTP responses (VCR/nock) for stable third-party APIs
- Test doubles only for slow, flaky, or side-effect-heavy dependencies

## Fixtures and Test Data

### Factory Pattern

```javascript
// factories/order.js
const createOrder = (overrides = {}) => ({
  id: `ord_${Math.random().toString(36).slice(2)}`,
  userId: 'usr_default',
  status: 'pending',
  totalCents: 1000,
  items: [{ productId: 'prod_default', quantity: 1 }],
  createdAt: new Date().toISOString(),
  ...overrides,
});

// In tests
const order = createOrder({ status: 'paid', totalCents: 5000 });
const cancelledOrder = createOrder({ status: 'cancelled' });
```

**Factory rules:**
- Factories produce valid objects by default
- Override only the fields relevant to the test
- Avoid sharing mutable state across tests — each test creates its own data

### Database Seed vs. Per-Test Setup

| Approach | Use when |
|---|---|
| Per-test create + truncate | Default for integration tests; isolation guaranteed |
| Shared read-only seed | Large static reference data that never changes |
| Transaction rollback | When creating data is expensive and the database supports it |

## Coverage Guidance

### Coverage Targets

| Type | Target |
|---|---|
| Business logic (services, use cases) | 90–100% |
| Data access layer (repositories) | 80–90% |
| HTTP handlers (routes, controllers) | 70–85% |
| Utilities and formatters | 90–100% |
| Generated code | Excluded |
| Configuration | Excluded |

### What Coverage Misses

Coverage tells you which lines were executed during tests. It does not tell you:
- Whether the assertions are meaningful
- Whether edge cases were exercised
- Whether the tests will catch regressions

A line covered by a test that has no assertions is not tested — it is merely executed.

### Audit Undertested Paths

```bash
# Jest
npm test -- --coverage --coverageReporters=text

# Python
pytest --cov=src --cov-report=term-missing

# Go
go test ./... -coverprofile=coverage.out
go tool cover -func=coverage.out | grep -v "100.0%"
```

## Test Review Checklist

- [ ] Tests describe behavior, not implementation details
- [ ] Each test has one clear reason to fail
- [ ] Test name is a complete statement: "returns 400 when items is empty"
- [ ] Arrange-Act-Assert structure is visible
- [ ] No shared mutable state between tests
- [ ] Mocks verify calls when the call itself is the contract
- [ ] Integration tests use a real database or service, not a mock
- [ ] E2E tests cover only critical paths, not every variation

## Never Do

- Mock the module under test
- Write assertions that always pass (`expect(true).toBe(true)`)
- Use `sleep` or fixed timeouts in tests — use `waitFor` or observable signals
- Depend on test execution order — each test must be independently runnable
- Assert on implementation details that will change during refactoring
- Skip testing error paths — they are where the most important behavior lives
- Leave disabled tests (`xit`, `test.skip`) in the codebase without a tracked resolution
