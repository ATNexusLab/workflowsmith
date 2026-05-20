---
name: database-design
description: Use to model data, design schemas and migrations, review queries, and define safe access patterns for SQL or NoSQL databases.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
---

# Database Design

## When to Use

- Model data for a new feature or service
- Review or improve an existing schema
- Design or review a migration strategy
- Investigate query performance issues
- Define data access patterns for a repository or data layer
- Evaluate SQL vs NoSQL trade-offs for a specific use case

## Core Principles

1. **Constraints are correctness** — let the database enforce what the application depends on
2. **Migration safety first** — every schema change must be reversible or explicitly non-destructive
3. **Access patterns drive design** — model for the queries the system actually runs
4. **Normalize for write integrity, denormalize for read performance** — make this trade-off consciously
5. **Data outlasts code** — schema mistakes compound over time; names and constraints must be deliberate

## Schema Design

### Naming Conventions (SQL)

```sql
-- Tables: plural, snake_case
users
order_items
payment_transactions

-- Columns: snake_case, unambiguous
id                  -- NOT pk, uid, user_id on the users table
created_at          -- NOT created, date_created, timestamp
updated_at
deleted_at          -- soft deletes only

-- Foreign keys: {singular_table}_id
user_id
order_id
product_id

-- Booleans: is_ or has_ prefix
is_active
has_verified_email

-- Indexes: idx_{table}_{columns}
idx_users_email
idx_orders_user_id_created_at

-- Constraints: {type}_{table}_{columns}
uq_users_email
fk_orders_user_id
chk_products_price_positive
```

### Column Design Rules

- **Primary keys:** surrogate UUID or auto-increment integer; use UUID for distributed systems or when IDs are client-visible
- **Timestamps:** `created_at` and `updated_at` on every mutable table; use `TIMESTAMPTZ` in PostgreSQL
- **Soft deletes:** `deleted_at TIMESTAMPTZ DEFAULT NULL`; include in indexes that filter active records
- **Enums:** prefer database-level check constraints or lookup tables over string columns with application-level enforcement
- **Money:** use `INTEGER` (cents) or `NUMERIC(19,4)`, never `FLOAT` or `DOUBLE`
- **Text length:** define `VARCHAR(n)` with intentional limits; use `TEXT` only where unbounded length is genuinely required

### Essential Constraints

```sql
CREATE TABLE orders (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID NOT NULL REFERENCES users(id),
    status      TEXT NOT NULL CHECK (status IN ('pending', 'paid', 'cancelled')),
    total_cents INTEGER NOT NULL CHECK (total_cents >= 0),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    deleted_at  TIMESTAMPTZ
);
```

**Constraint checklist:**
- [ ] `NOT NULL` on every column that must have a value
- [ ] `REFERENCES` for every foreign key relationship
- [ ] `UNIQUE` or unique index for natural keys
- [ ] `CHECK` for enumerated states, non-negative amounts, and bounded ranges
- [ ] `DEFAULT` for computed values the database can provide (`now()`, `gen_random_uuid()`)

### Indexing Strategy

```sql
-- Primary key index is automatic

-- Foreign keys that appear in JOINs or WHERE clauses
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Composite: column order follows query filter+sort pattern
CREATE INDEX idx_orders_user_id_created_at ON orders(user_id, created_at DESC);

-- Partial index for sparse conditions
CREATE INDEX idx_orders_pending ON orders(created_at) WHERE status = 'pending';

-- Unique natural key
CREATE UNIQUE INDEX uq_users_email ON users(email) WHERE deleted_at IS NULL;

-- JSONB field querying (PostgreSQL)
CREATE INDEX idx_events_meta_type ON events USING gin(metadata);
```

**Rules:**
- Every foreign key column needs an index unless join to that table never occurs
- Composite index column order: equality filters first, then range/sort columns
- Partial indexes on status or boolean columns avoid index bloat from filtered queries
- Avoid over-indexing write-heavy tables — each index adds write overhead
- Review `EXPLAIN ANALYZE` output before committing an index to production

## Migration Patterns

### Safe Migration Protocol

Every migration must be:
1. **Additive or read-safe** — adding a column, table, or index is safe; dropping or renaming requires a multi-step rollout
2. **Idempotent** — applying twice should not fail or corrupt data
3. **Reversible** — provide a rollback migration unless the change is provably non-destructive and reversible by re-running

### Column Operations

**Adding a nullable column (safe):**
```sql
ALTER TABLE orders ADD COLUMN notes TEXT;
```

**Adding a NOT NULL column (requires default):**
```sql
-- Step 1: Add nullable
ALTER TABLE orders ADD COLUMN priority INTEGER;

-- Step 2: Backfill
UPDATE orders SET priority = 0 WHERE priority IS NULL;

-- Step 3: Add NOT NULL constraint
ALTER TABLE orders ALTER COLUMN priority SET NOT NULL;
ALTER TABLE orders ALTER COLUMN priority SET DEFAULT 0;
```

**Renaming a column (multi-step):**
```sql
-- Deploy 1: Add new column, keep old
ALTER TABLE users ADD COLUMN display_name TEXT;

-- Deploy 2: Backfill and dual-write in application
UPDATE users SET display_name = full_name WHERE display_name IS NULL;

-- Deploy 3: Switch reads to new column, stop writing old

-- Deploy 4: Drop old column
ALTER TABLE users DROP COLUMN full_name;
```

**Never do in a single migration on a live table:**
- `DROP COLUMN` without verifying zero application references
- `ALTER COLUMN … SET NOT NULL` on a large table without a concurrent index and backfill
- `RENAME COLUMN` while any application is reading the old name

### Index Operations

```sql
-- PostgreSQL: non-blocking index creation
CREATE INDEX CONCURRENTLY idx_orders_status ON orders(status);

-- Drop index without table lock
DROP INDEX CONCURRENTLY idx_orders_old;
```

Always use `CONCURRENTLY` in production for index creation and removal on large tables.

### Rollback Pattern

```sql
-- up.sql
ALTER TABLE products ADD COLUMN sku TEXT;
CREATE UNIQUE INDEX uq_products_sku ON products(sku) WHERE sku IS NOT NULL;

-- down.sql
DROP INDEX IF EXISTS uq_products_sku;
ALTER TABLE products DROP COLUMN IF EXISTS sku;
```

## Query Review

### EXPLAIN ANALYZE Pattern

```sql
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT o.id, o.total_cents, u.email
FROM orders o
JOIN users u ON u.id = o.user_id
WHERE o.status = 'pending'
  AND o.created_at > now() - INTERVAL '7 days'
ORDER BY o.created_at DESC
LIMIT 50;
```

**What to look for:**
- `Seq Scan` on large tables → missing index
- `Nested Loop` with large row estimates → index not used or cardinality estimate is wrong
- High `Buffers: shared hit` or `read` → large data volume; consider partial index or pagination
- `Sort` step on a large result set → composite index may eliminate the sort

### N+1 Detection

```bash
# Look for queries inside loops in the application layer
grep -n "\.find\|\.get\|\.query\|execute" src/**/*.py | head -30
```

N+1 patterns to fix:
- Load related records in batch: `WHERE id IN (...)` or a single JOIN instead of one query per record
- Use eager loading if the ORM supports it
- Move aggregation to the database when computing counts or sums per entity

### Dangerous Query Patterns

```sql
-- Unbounded query — always add LIMIT
SELECT * FROM events WHERE user_id = $1;  -- BAD
SELECT * FROM events WHERE user_id = $1 ORDER BY created_at DESC LIMIT 100;  -- GOOD

-- SELECT * in production queries — name columns explicitly
SELECT * FROM users WHERE id = $1;  -- BAD
SELECT id, email, name, created_at FROM users WHERE id = $1;  -- GOOD

-- Implicit type cast breaking index
SELECT * FROM orders WHERE user_id = '123';  -- BAD if user_id is UUID/INTEGER
SELECT * FROM orders WHERE user_id = $1::UUID;  -- GOOD

-- LIKE with leading wildcard — table scan
SELECT * FROM users WHERE email LIKE '%@example.com';  -- cannot use btree index
-- Alternative: pg_trgm GIN index for full-text substring search
```

## NoSQL Access Pattern Design

### Document Store (MongoDB / Firestore)

**Embed vs. reference decision:**

| Embed | Reference |
|---|---|
| Data is accessed together | Data is accessed independently |
| 1:1 or 1:few relationships | 1:many or many:many |
| Child does not grow unboundedly | Child set can be large or unbounded |
| Child rarely updated independently | Child updated frequently on its own |

**Example:**

```javascript
// Embed: order with line items (bounded, accessed together)
{
  _id: "ord_123",
  user_id: "usr_456",
  items: [
    { product_id: "prod_789", qty: 2, unit_price_cents: 1500 }
  ],
  total_cents: 3000,
  status: "pending"
}

// Reference: user with orders (unbounded, independently accessed)
// users collection: { _id, email, name }
// orders collection: { _id, user_id, ... }
```

### Key-Value and Cache (Redis)

**Key naming:**
```
{service}:{entity}:{id}:{field}

user:session:usr_123
product:cache:prod_456
rate_limit:api:ip:192.168.1.1
```

**Expiry rules:**
- Always set TTL for cache and session keys
- Never cache without a defined invalidation or expiry strategy
- For rate limiting, use atomic `INCR` + `EXPIRE` or `SET NX EX`

### Time-Series (ClickHouse / TimescaleDB / InfluxDB)

- Design for append-only inserts; avoid updates
- Partition by time range (day, week, month depending on volume)
- Use materialized views or continuous aggregates for metrics queries
- Define retention policies for raw data versus aggregated rollups

## Data Access Layer Patterns

### Repository Pattern (SQL)

```python
class OrderRepository:
    def __init__(self, db: Connection):
        self._db = db

    def find_by_id(self, order_id: UUID) -> Optional[Order]:
        row = self._db.execute(
            "SELECT id, user_id, status, total_cents, created_at "
            "FROM orders WHERE id = %s AND deleted_at IS NULL",
            (order_id,)
        ).fetchone()
        return Order.from_row(row) if row else None

    def find_pending_by_user(
        self, user_id: UUID, limit: int = 50
    ) -> list[Order]:
        rows = self._db.execute(
            "SELECT id, user_id, status, total_cents, created_at "
            "FROM orders "
            "WHERE user_id = %s AND status = 'pending' AND deleted_at IS NULL "
            "ORDER BY created_at DESC LIMIT %s",
            (user_id, limit)
        ).fetchall()
        return [Order.from_row(r) for r in rows]
```

**Rules:**
- Queries live in the repository, not in service or controller layers
- Always name columns explicitly; never `SELECT *` in repository methods
- Always validate inputs before constructing queries
- Use parameterized queries exclusively; never format user input into SQL strings

### Transaction Pattern

```python
def transfer_funds(
    from_account_id: UUID,
    to_account_id: UUID,
    amount_cents: int,
    db: Connection
) -> None:
    with db.transaction():
        from_balance = db.execute(
            "SELECT balance_cents FROM accounts WHERE id = %s FOR UPDATE",
            (from_account_id,)
        ).scalar()

        if from_balance < amount_cents:
            raise InsufficientFundsError()

        db.execute(
            "UPDATE accounts SET balance_cents = balance_cents - %s WHERE id = %s",
            (amount_cents, from_account_id)
        )
        db.execute(
            "UPDATE accounts SET balance_cents = balance_cents + %s WHERE id = %s",
            (amount_cents, to_account_id)
        )
        db.execute(
            "INSERT INTO transfers (from_account_id, to_account_id, amount_cents) "
            "VALUES (%s, %s, %s)",
            (from_account_id, to_account_id, amount_cents)
        )
```

## Review Checklist

**Schema:**
- [ ] All foreign keys declared with `REFERENCES`
- [ ] All mandatory fields have `NOT NULL`
- [ ] Money stored as integer cents, not float
- [ ] Timestamps use `TIMESTAMPTZ`, not naive `TIMESTAMP`
- [ ] Enum-like columns have `CHECK` constraints
- [ ] Every table has `created_at`; mutable tables have `updated_at`

**Indexes:**
- [ ] Every foreign key column has an index
- [ ] Columns in `WHERE` clause of common queries are indexed
- [ ] Composite indexes match the actual query filter/sort pattern
- [ ] No missing index flagged by `EXPLAIN ANALYZE`

**Migrations:**
- [ ] Every migration has a rollback
- [ ] `NOT NULL` additions are done in multi-step deploys
- [ ] Renames follow the multi-step rename protocol
- [ ] Indexes use `CONCURRENTLY` in PostgreSQL

**Access layer:**
- [ ] No raw SQL in controllers or service layer
- [ ] All queries use parameterized values
- [ ] No `SELECT *` in production query paths
- [ ] Mutating operations that span multiple tables use transactions

## Never Do

- Store money as FLOAT or DOUBLE — floating-point rounding errors corrupt financial data
- Drop a column or table in the same migration that removes the application code referencing it
- Add a NOT NULL column without a default or a multi-step backfill
- Write queries with user input interpolated into the SQL string — this is SQL injection
- Skip the rollback migration — assume live deployments will sometimes need to revert
- Query without LIMIT on tables that grow unboundedly
- Let business logic determine which table to query — that belongs in the data access layer
