---
name: refactoring
description: Use to improve existing code without changing behavior, identify code smells, simplify structure, and validate safety with tests.
user-invocable: true
disable-model-invocation: false
triggers:
  - "improve existing code without changing behavior"
  - "identify and remove code smells"
  - "extract modules, simplify functions, or reduce coupling"
license: MIT
---

# Refactoring

## When to Use

- Improve readability or maintainability of existing code
- Reduce complexity or duplication
- Prepare a code path for future features
- Address code smells found during review
- Decide whether refactoring is safer than a rewrite

## Golden Rule

> **Refactoring changes structure without changing behavior.**
> If behavior changes, it is a functional change, not refactoring.

Tests should stay green before, during, and after the work.

## Code Smells Catalog

### Complexity

| Smell | Symptom | Typical Refactoring |
|---|---|---|
| **Long function** | More than one responsibility, difficult to scan | Extract Function |
| **Large class/module** | Too many unrelated responsibilities | Extract Class / Extract Module |
| **Deep nesting** | Multiple levels of `if` or `else` | Guard Clauses / Extract Function |
| **Large switch** | Many branches encoding behavior | Strategy / Polymorphism |
| **Too many parameters** | Hard to call and hard to understand | Introduce Parameter Object |

### Duplication

| Smell | Symptom | Typical Refactoring |
|---|---|---|
| **Duplicate code** | Same logic in more than one place | Extract Function / Template Method |
| **Feature envy** | Method depends more on another object than its own | Move Method |
| **Data clumps** | Values that always travel together | Extract Class / Parameter Object |

### Coupling

| Smell | Symptom | Typical Refactoring |
|---|---|---|
| **God object** | One module knows and does too much | Extract Class / Delegate |
| **Inappropriate intimacy** | Modules reach into each other's internals | Move Method / Extract Interface |
| **Middle man** | Layer adds no real value beyond delegation | Remove Middle Man / Inline Class |
| **Shotgun surgery** | One change forces edits in many places | Re-center responsibility |

### Naming

| Smell | Symptom | Typical Refactoring |
|---|---|---|
| **Generic name** | `data`, `info`, `manager`, `temp` | Rename to domain language |
| **Inconsistent name** | Same concept has multiple names | Standardize naming |
| **Obscure abbreviation** | `usrMgr`, `cfgSvc` | Expand to clear names |

## Refactoring Patterns

### Extract Function

```javascript
function processOrder(order) {
  validateOrder(order);
  const total = calculateTotal(order.items);
  const finalTotal = applyDiscount(total);
  return { total: finalTotal, status: "processed" };
}
```

### Guard Clauses

```javascript
function getDiscount(customer) {
  if (!customer) return 0;
  if (!customer.active) return 0;
  if (customer.orders > 10) return 0.2;
  return 0.1;
}
```

### Replace Magic Numbers

```javascript
const HTTP_TOO_MANY_REQUESTS = 429;
const MAX_RETRIES = 3;

if (response.status === HTTP_TOO_MANY_REQUESTS) {
  // ...
}

if (retryCount > MAX_RETRIES) {
  // ...
}
```

## Safe Refactoring Order

1. **Start from a known-good baseline** that can be restored if needed
2. **Ensure tests are green**
3. **Take one small step at a time**
4. **Run tests after each step**
5. **Keep behavior-preserving changes separate from feature changes**
6. **Stop when the code is simpler and safer, not merely different**

## Refactor or Rewrite?

| Scenario | Better Choice |
|---|---|
| Code works but is hard to maintain | **Refactor** |
| Tests exist and behavior is understood | **Refactor** |
| No tests and behavior is unclear | **Write characterization tests first** |
| Architecture is fundamentally wrong for the problem | **Rewrite with a new design** |
| Technology is obsolete and blocks progress | **Rewrite** |
| Understanding cost is higher than replacement cost | **Rewrite** |

## Pre-Refactoring Checklist

- [ ] Tests exist and pass, or characterization tests were added first
- [ ] Current behavior is understood
- [ ] Scope is explicit: which smells or structures are being improved
- [ ] Functional changes are excluded from this pass
- [ ] A restorable baseline exists

## Post-Refactoring Checklist

- [ ] All tests still pass
- [ ] No behavior changed
- [ ] Build and lint still pass
- [ ] The result is simpler, clearer, or less coupled
- [ ] The new structure is easier to extend or test

## Steps

### 1. Protect behavior with tests

If tests do not exist:
1. Write characterization tests for current behavior
2. Run them against the current code
3. Only then begin refactoring

### 2. Identify the dominant smells

Use the `## Code Smells Catalog` and prioritize by:
- risk to maintainability
- frequency of change
- chance of accidental breakage

### 3. Apply atomic refactorings

- move one responsibility at a time
- prefer tiny, reversible structural edits
- keep tests close to each step

### 4. Use the right pattern

- Extract Function for mixed responsibilities
- Rename for poor domain language
- Extract Variable or Parameter Object for dense expressions
- Move Method or Extract Interface to rebalance coupling

### 5. Validate the result

- run tests, lint, and build
- compare behavior before and after
- finish only when the `## Post-Refactoring Checklist` is complete

## Examples

### Extract Function Example

```python
def calculate_total(items):
    return sum(calculate_item_price(item) for item in items)

def calculate_item_price(item):
    price = item.price * item.quantity
    return price * 0.9 if item.quantity > 10 else price

def process_order(order):
    order.total = calculate_total(order.items)
    order.status = "processed"
    db.save(order)
```

### Rename Variable Example

```typescript
const currentDate = new Date();
const user = await db.findOne({ id: req.params.id });
const isAdmin = user.role === "admin";
```
