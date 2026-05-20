# Architectural Patterns Catalog

> Quick reference for the main session and for `@principal`. For each pattern: when to use, when NOT to use, and team impact.

---

## Code Organization Patterns

### Layered Architecture (N-Tiers)
**When to use:** Most CRUD systems, simple APIs, small teams.
**When NOT to use:** When domain logic is complex and bleeds across layers.
**Typical layers:** Controller → Service → Repository → Database
**Cost:** Low. Familiar to most developers.

---

### Clean Architecture / Hexagonal (Ports & Adapters)
**When to use:** Rich domain, multiple external integrations, high testability required.
**When NOT to use:** Simple CRUD, teams unfamiliar with the pattern, tight deadlines.
**Key principle:** The domain does not depend on anything external — frameworks, DBs, and APIs are adapters.
**Cost:** High. Requires discipline and onboarding.

---

### Modular Monolith
**When to use:** Medium-sized teams, moderate domain, preparing for eventual decomposition into services.
**When NOT to use:** System that is already small and will not grow, or when team scale already demands separation.
**Key principle:** Modules with clear boundaries, but a single deployment unit.
**Cost:** Medium. Good balance between organization and operational simplicity.

---

## Data Patterns

### CQRS (Command Query Responsibility Segregation)
**When to use:** Read and write have very different requirements, complex domain, high read scale.
**When NOT to use:** Simple CRUD, small teams, no need to optimize reads separately.
**Cost:** High. Introduces synchronization complexity and two data models.

---

### Event Sourcing
**When to use:** Full audit trail required, historical state reconstruction, event-driven domain.
**When NOT to use:** Most systems. It is a specialized solution for specific problems.
**Cost:** Very high. Requires team maturity and infrastructure.

---

### Repository Pattern
**When to use:** Whenever data access needs to be testable and swappable.
**When NOT to use:** Simple scripts, no need for testing or DB abstraction.
**Cost:** Low. Highly recommended by default.

---

## Communication Patterns

### REST
**When to use:** Public APIs, simple integrations, broad interoperability.
**When NOT to use:** When strongly-typed contracts are required (prefer GraphQL or gRPC).
**Cost:** Low.

---

### GraphQL
**When to use:** Frontend with varied data needs, multiple clients with different queries.
**When NOT to use:** Simple and predictable APIs, teams without experience with the paradigm.
**Cost:** Medium. Resolver complexity, N+1, caching.

---

### gRPC / Protobuf
**When to use:** Internal service-to-service communication, high performance, strongly-typed contracts.
**When NOT to use:** Public APIs, browser clients without a proxy.
**Cost:** Medium. Requires tooling and schema versioning discipline.

---

### Message Queue / Event Bus
**When to use:** Service decoupling, asynchronous processing, resilience to traffic spikes.
**When NOT to use:** When synchronous consistency is required, teams without experience in distributed systems.
**Cost:** High. Introduces complexity around delivery guarantees, ordering, and idempotency.

---

## Deployment Patterns

### Monolith
**When to use:** Small teams, early-stage product, development speed as the priority.
**Cost:** Low. Simple to operate.

### Microservices
**When to use:** Large independent teams, granular scalability required, mature product.
**When NOT to use:** Small teams, early-stage product, lack of DevOps maturity.
**Cost:** Very high. Networking, observability, deployments, contracts — everything becomes more complex.

### BFF (Backend for Frontend)
**When to use:** Multiple clients (mobile, web, third-party) with different API needs.
**Cost:** Medium. Adds an extra layer but simplifies clients.

---

## How to Use This Catalog

1. Identify the architectural problem
2. Consult the candidate patterns
3. Evaluate the cost vs. benefit for the project's specific context
4. Document the choice in an ADR if it is a cross-cutting decision
