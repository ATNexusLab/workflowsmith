---
name: refactoring
description: Use to improve existing code without changing behavior, identify code smells, simplify structure, and validate safety with tests.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
  - write_file
  - replace_in_file
  - create_file
---

# Refactoring

## When to Use

- Simplify code that has become difficult to read or change
- Reduce duplication before adding a new feature
- Improve structure after a feature is complete but before merging
- Eliminate a code smell that is making testing or extension harder
- Prepare a safe path for a larger architectural change

## Core Principle

Refactoring is the act of improving the internal structure of code **without changing its observable behavior**. It is not rewriting, re-architecting, or fixing bugs. If behavior changes, that is not refactoring — it is modification.

**Rule:** refactoring requires tests that define "observable behavior" before the first change. Without tests, there is no safety net and no refactoring — only unverified editing.

## Prerequisites

### 1. Verify the test safety net

```bash
# Run existing tests before any change
npm test
python -m pytest
go test ./...
bundle exec rspec

# Confirm everything passes before starting
```

If tests do not cover the code being refactored, write characterization tests first.

### 2. Identify the scope

```bash
# Understand what is touching the target code
grep -rn "functionName\|ClassName\|module_name" src/ --include="*.ts" | head -30

# Check call sites before moving or renaming
grep -rn "import.*TargetModule\|require.*target" src/ --include="*.js" --include="*.ts"
```

### 3. One refactoring at a time

Never combine multiple refactoring techniques in a single commit. Each step should be independently safe and independently reviewed.

## Catalog of Refactorings

### Extract Function / Method

**Before:**
```javascript
function processOrder(order) {
  // Validate order
  if (!order.items || order.items.length === 0) {
    throw new Error('Order must have items');
  }
  if (!order.userId) {
    throw new Error('Order must have a user');
  }

  // Calculate total
  const subtotal = order.items.reduce((sum, item) => sum + item.price * item.qty, 0);
  const tax = subtotal * 0.1;
  const total = subtotal + tax;

  // Save to database
  return db.orders.create({ ...order, total });
}
```

**After:**
```javascript
function validateOrder(order) {
  if (!order.items || order.items.length === 0) {
    throw new Error('Order must have items');
  }
  if (!order.userId) {
    throw new Error('Order must have a user');
  }
}

function calculateOrderTotal(items) {
  const subtotal = items.reduce((sum, item) => sum + item.price * item.qty, 0);
  const tax = subtotal * 0.1;
  return subtotal + tax;
}

function processOrder(order) {
  validateOrder(order);
  const total = calculateOrderTotal(order.items);
  return db.orders.create({ ...order, total });
}
```

**When to apply:**
- A function does more than one thing (validation, calculation, persistence are different things)
- A block of code has a comment explaining what it does — the comment is the function name
- The same block appears more than once

### Inline Function

**Before:**
```javascript
function isValidUser(user) {
  return user !== null && user !== undefined;
}

if (isValidUser(user)) { ... }
```

**After:**
```javascript
if (user != null) { ... }
```

**When to apply:**
- The function body is as clear as its name
- The indirection adds no value and makes the reader jump unnecessarily

### Extract Variable

**Before:**
```javascript
if (order.total > user.creditLimit * 0.8 && order.items.length > 10 && !user.isPremium) {
  flagForReview(order);
}
```

**After:**
```javascript
const approachingCreditLimit = order.total > user.creditLimit * 0.8;
const largeItemCount = order.items.length > 10;
const standardAccount = !user.isPremium;

if (approachingCreditLimit && largeItemCount && standardAccount) {
  flagForReview(order);
}
```

### Replace Magic Numbers with Named Constants

**Before:**
```python
if len(password) < 8:
    raise ValueError("Password too short")

if user.failed_attempts >= 5:
    lock_account(user)
```

**After:**
```python
MIN_PASSWORD_LENGTH = 8
MAX_FAILED_ATTEMPTS = 5

if len(password) < MIN_PASSWORD_LENGTH:
    raise ValueError(f"Password must be at least {MIN_PASSWORD_LENGTH} characters")

if user.failed_attempts >= MAX_FAILED_ATTEMPTS:
    lock_account(user)
```

### Replace Conditional with Polymorphism

**Before:**
```javascript
function getShippingCost(order) {
  if (order.type === 'standard') {
    return order.weight * 2.5;
  } else if (order.type === 'express') {
    return order.weight * 5.0 + 10;
  } else if (order.type === 'overnight') {
    return order.weight * 8.0 + 25;
  }
}
```

**After:**
```javascript
const shippingStrategies = {
  standard: (order) => order.weight * 2.5,
  express: (order) => order.weight * 5.0 + 10,
  overnight: (order) => order.weight * 8.0 + 25,
};

function getShippingCost(order) {
  const strategy = shippingStrategies[order.type];
  if (!strategy) throw new Error(`Unknown order type: ${order.type}`);
  return strategy(order);
}
```

**When to apply:**
- A switch or if-else chain is duplicated across the codebase
- Adding a new type requires modifying multiple functions
- Each branch contains substantial logic

### Move Function / Method

**Signal:** a function uses data or calls methods from another module more than its own.

```bash
# Find what a function depends on
grep -n "this\.\|self\." src/OrderController.ts | head -30
# If most references point to order properties, the function belongs on Order
```

### Introduce Parameter Object

**Before:**
```javascript
function searchOrders(userId, startDate, endDate, status, limit, offset) {
  ...
}

searchOrders(userId, '2024-01-01', '2024-01-31', 'pending', 50, 0);
```

**After:**
```javascript
function searchOrders({ userId, startDate, endDate, status, limit = 50, offset = 0 }) {
  ...
}

searchOrders({
  userId,
  startDate: '2024-01-01',
  endDate: '2024-01-31',
  status: 'pending',
});
```

### Remove Dead Code

**Before:**
```javascript
function formatDate(date, legacy = false) {
  if (legacy) {
    // This code path has not been called since 2021
    return date.toLocaleDateString('en-US', { year: '2-digit' });
  }
  return date.toISOString().split('T')[0];
}
```

**After:**
```javascript
function formatDate(date) {
  return date.toISOString().split('T')[0];
}
```

```bash
# Find dead code candidates
grep -rn "TODO\|FIXME\|DEPRECATED\|UNUSED\|dead\|legacy" src/ --include="*.ts" --include="*.js"

# Find functions never called
# TypeScript: use TypeScript Language Server unused symbol analysis
# Python: use vulture
pip install vulture
vulture src/
```

### Rename for Clarity

```bash
# Find all occurrences before renaming
grep -rn "oldFunctionName\|old_var_name" src/ --include="*.py" --include="*.ts"

# After renaming, verify no references remain
grep -rn "oldFunctionName" src/ --include="*.py" --include="*.ts"
# Should return zero results
```

## Code Smell Catalog

| Smell | Symptom | Refactoring |
|---|---|---|
| **Long function** | Function exceeds 20–30 lines | Extract Function |
| **Long parameter list** | More than 3–4 parameters | Introduce Parameter Object |
| **Duplicated code** | Same logic in two or more places | Extract Function + call from both |
| **Large class** | Class owns too many concerns | Extract Class |
| **Feature envy** | Method uses another class's data heavily | Move Method |
| **Data clump** | Same group of variables always appears together | Introduce Parameter Object or Value Object |
| **Switch statement** | Switch duplicated across codebase | Replace with Polymorphism |
| **Comments explaining what** | Comment needed to explain a block of code | Extract Function with descriptive name |
| **Magic numbers** | Unexplained literals scattered in logic | Extract Named Constant |
| **Dead code** | Code that cannot be reached or is never called | Delete |
| **Speculative generality** | Abstractions built for requirements that do not exist yet | Inline and simplify |

## Refactoring Workflow

```
1. Run tests → confirm all pass
2. Identify a single code smell or refactoring target
3. Apply one technique
4. Run tests → confirm all still pass
5. Commit with message: "refactor: [what was changed]"
6. Repeat from step 2
```

**Commit message format:**
```
refactor: extract validateOrder from processOrder
refactor: replace shipping type switch with strategy map
refactor: rename userId to customerId across order module
```

## Validation Pattern

### Before Starting

```bash
npm test -- --coverage 2>&1 | tail -20
```

Record:
- Test count: N passing
- Coverage: X% lines

### After Each Step

```bash
npm test 2>&1 | tail -10
# Must show same or more tests passing, zero failing
```

### After Completing

```bash
npm test -- --coverage 2>&1 | tail -20
# Coverage must not decrease
# Behavior tests must all still pass
```

## Refactoring Constraints

**When not to refactor:**
- No tests exist and writing them is not feasible right now — the risk outweighs the gain
- The change is large enough that it must go through full review and testing cycles — treat as a planned project, not opportunistic cleanup
- The code is at a critical path in production with no staging validation — defer to a safer moment

**Safe scope limit:**
If the refactoring touches more than three files or would require more than a one-PR change, stop and plan it as a structured project with design review first.

## Never Do

- Change behavior while refactoring — behavioral change is a bug or a feature, not a refactoring
- Refactor without a passing test suite — editing without tests is not refactoring, it is risk
- Combine refactoring commits with feature or fix commits — reviewers cannot isolate intent
- Apply a speculative abstraction for a use case that does not yet exist
- Rename things without verifying all call sites are updated
