---
name: database-design
description: Use to model data, design schemas and migrations, review queries, and define safe access patterns for SQL or NoSQL databases.
user-invocable: true
disable-model-invocation: false
triggers:
  - "model a schema or data structure"
  - "create or review SQL or NoSQL migrations"
  - "optimize queries or choose a database"
license: MIT
---

# Database Design

## When to Use

- Design a new database schema
- Create or review schema and data migrations
- Optimize complex queries or indexing strategy
- Choose between SQL and NoSQL for a use case
- Plan safe rollout and rollback for live database changes

## SQL Patterns and Best Practices

### Modeling

- Normalize to 3NF by default; denormalize only with a measured reason
- Choose primary keys intentionally: UUIDs for distributed systems, numeric keys for simpler internal systems
- Define foreign keys and `ON DELETE` behavior explicitly
- Add `created_at` and `updated_at` to operational tables unless the domain makes them irrelevant
- Encode domain invariants in constraints whenever practical (`UNIQUE`, `CHECK`, `NOT NULL`)

### Migrations

- Keep each migration focused on one atomic change
- Make schema migrations reversible when the toolchain supports rollback
- Separate schema changes from large data backfills when possible
- Test migrations against production-like data volume before production rollout
- Measure lock time, table rewrite risk, and runtime before scheduling the change

### Safe Rollout for Live Schemas

Destructive or compatibility-sensitive changes should follow an **expand / migrate / contract** plan.

#### Phase 1 — Expand safely

- Add new tables, columns, indexes, or nullable fields first
- Keep the old schema readable and writable by the current application version
- Prefer additive changes that let old and new code run at the same time

#### Phase 2 — Migrate traffic and data

- Deploy application code that can read from both old and new shapes when needed
- Backfill existing rows in batches with throttling, checkpoints, and idempotent logic
- Use dual-write or write-forward patterns only when the temporary complexity is justified
- Track migration progress with counts, checksums, or parity queries

#### Phase 3 — Contract only after validation

- Remove old columns, defaults, constraints, or tables only after:
  - all reads no longer depend on them
  - all writes no longer target them
  - backfill parity is validated
  - the rollback window for the previous application version has passed

### Destructive Change Safety Rules

Before a destructive migration:
- Define the exact blast radius: rows, tables, services, jobs, and reports affected
- State a rollback path that is still valid after partial execution
- Confirm backup or snapshot availability and restore timing
- Set stop conditions: replication lag, lock duration, error rate, or batch failure threshold

During execution:
- Prefer batched deletes and updates over one giant statement
- Prefer online or concurrent index operations where supported
- Avoid full table rewrites during peak traffic
- Monitor lock wait, CPU, I/O, replication lag, and error rate in real time

After execution:
- Validate row counts, constraints, and critical query paths
- Keep the dropped path recoverable until the rollback window closes
- Remove temporary dual-read or dual-write logic only after the schema is stable

### Rollback Guidance

A rollback plan should answer:
- **What can be reversed immediately?** application routing, feature flags, dual-read logic
- **What needs data repair instead of a simple down migration?** dropped columns, irreversible transforms, deletes
- **What evidence proves rollback success?** restored counts, parity queries, healthy error rate, healthy replication

If a migration is not truly reversible, document it as **forward-fix only** and require:
- verified backups or snapshots
- a tested restore procedure
- a clear decision point for aborting before the irreversible step

### Indexes

- Index columns used frequently in `WHERE`, `JOIN`, and `ORDER BY`
- Design composite indexes around actual predicate order and selectivity
- Check unused or low-value indexes periodically
- Remember that every index increases write cost and storage cost

### Queries

```sql
EXPLAIN ANALYZE SELECT ...;

SELECT id, name, email
FROM users
WHERE is_active = true;

SELECT id, user_id, status, created_at
FROM orders
WHERE id > :cursor
ORDER BY id
LIMIT 20;
```

**Rules:**
- Avoid `SELECT *` on production paths
- Use `EXPLAIN` or equivalent before guessing about performance
- Prefer keyset or cursor pagination over deep offsets on large tables

## NoSQL Patterns and Best Practices

### Choosing the Database

| Database | Use When |
|---|---|
| MongoDB | Flexible document shape with document-oriented queries |
| Redis | Cache, sessions, locks, counters, pub/sub, rate limiting |
| DynamoDB | Predictable access patterns at high scale |
| Firestore | Realtime mobile or web sync with document access |

### NoSQL Modeling

**Model around access patterns, not normalization.**

- List the primary reads and writes before designing collections
- Duplicate data intentionally when it removes expensive cross-document joins
- Keep document size and update frequency in balance
- Design partition keys and hot-key avoidance up front

### MongoDB

```javascript
db.users.createIndex({ email: 1 }, { unique: true });
db.orders.createIndex({ userId: 1, createdAt: -1 });

db.users.find({ isActive: true }, { name: 1, email: 1 });
```

### Redis

```text
SET user:123 "{...}" EX 3600

INCR rate:user:123
EXPIRE rate:user:123 60
```

## Schema Review Checklist

- [ ] Primary keys and ownership boundaries are defined
- [ ] Foreign keys or equivalent integrity rules are explicit
- [ ] Critical query paths have supporting indexes
- [ ] Audit timestamps or equivalent lifecycle fields exist where needed
- [ ] Migration plan distinguishes schema change from backfill when appropriate
- [ ] Live rollout plan covers expand, validate, and contract phases
- [ ] Rollback or restore path is documented for destructive steps
- [ ] Volume, lock, and runtime assumptions were tested realistically

## Steps

### 1. Map use cases and access patterns

Before modeling:
- Which reads and writes are most frequent?
- Which entities require transactional consistency?
- What volume and growth do you expect?
- Which operations must stay available during migration?

### 2. Choose the database type

- **SQL**: relational integrity, transactions, strong joins, rich querying
- **Document**: variable shape, aggregate reads, document ownership
- **Key-value**: extremely fast single-key access, cache, sessions
- **Time series / event store**: append-heavy telemetry or event history

### 3. Model the schema

For **SQL**:
- define tables, keys, constraints, and indexes
- model nullability and uniqueness deliberately

For **NoSQL**:
- design around query patterns, partitioning, and item size
- choose embedding versus references based on read/write behavior

### 4. Plan rollout and rollback

Use the live-schema guidance above for any change that touches production data:
- additive first
- backfill safely
- validate parity
- contract only after dependency removal

### 5. Validate with the checklist

Complete the `## Schema Review Checklist` before production rollout.

## Examples

### SQL Schema Example

```sql
CREATE TABLE users (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email       VARCHAR(255) NOT NULL UNIQUE,
    name        VARCHAR(255) NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_users_email ON users(email);
```

### Safe Destructive Change Sequence

```text
1. Add new column `full_name` nullable
2. Deploy code that writes both `name` and `full_name`
3. Backfill `full_name` in batches
4. Validate parity between old and new reads
5. Deploy code that reads only `full_name`
6. Wait through rollback window
7. Drop old column `name`
```

### NoSQL Order Document Example

```json
{
  "_id": "ord_789",
  "user": {
    "id": "usr_123",
    "email": "user@example.com",
    "name": "John Doe"
  },
  "items": [
    {
      "product_id": "prod_456",
      "name": "Product A",
      "unit_price": 49.95,
      "quantity": 2
    }
  ],
  "total": 99.9,
  "status": "pending",
  "created_at": "2024-01-15T10:30:00Z"
}
```

`user` and `items` are embedded because they are read together with the order.
