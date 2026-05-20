<!-- common fragment: engineering-principles — loaded via @import or read_file -->

## Code Conventions

| Convention | Application |
|-----------|-----------|
| `camelCase` | Variables and functions |
| `PascalCase` | Classes and components |
| `kebab-case` | File names |
| ESM imports | All JS/TS projects |
| `async/await` | Preferred over `.then()` |
| Guard clauses | Reduce nesting |
| Early returns | Avoid unnecessary else |
| Self-documenting code | Comments only when necessary for real clarity |

---

## Engineering Principles

**Design:** Clean Code, SOLID, DRY, KISS, YAGNI, Clean Architecture, Hexagonal Architecture, Separation of Concerns, Single Responsibility, Composition over Inheritance, Dependency Inversion

**Quality:** Immutability when possible, Pure Functions when possible, Idempotency, Fail Fast, Explicit Error Handling, Testable Code, Deterministic Behavior

**Security:** No Hardcoded Secrets, Input Validation, Output Sanitization, Least Privilege, Secure Defaults

**Performance:** Avoid N+1, Caching Strategies, Pagination, Stateless Design, Lazy Loading, Batching

**Decisions:** Simplicity > Complexity, No Premature Optimization, Explicit Trade-offs, No Tight Coupling, No Magic Behavior, No Hidden Side Effects
