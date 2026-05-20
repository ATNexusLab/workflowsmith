---
name: performance-analysis
description: Use to investigate latency, profile bottlenecks, benchmark changes, and validate improvements across backend, database, frontend, and infrastructure layers.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
---

# Performance Analysis

## When to Use

- Investigate elevated latency, high CPU, or memory pressure in production
- Profile a slow endpoint, query, or function to find the root cause
- Benchmark a proposed change before and after to validate improvement
- Establish baselines before starting optimization work
- Review code for structural performance anti-patterns

## Core Principles

1. **Measure first, optimize second** — never optimize without a baseline; intuition is unreliable
2. **Locate the bottleneck before changing anything** — optimization in the wrong layer wastes time
3. **One change at a time** — isolating variables is the only way to attribute improvement correctly
4. **Validate the gain** — compare post-optimization measurements against the baseline, not intuition
5. **Define "fast enough"** — optimization without a target is unlimited; set a threshold and stop

## Profiling Workflow

### Step 1: Establish the Baseline

Before touching any code:

```bash
# HTTP endpoint — wrk benchmark
wrk -t4 -c100 -d30s --latency http://localhost:3000/api/orders

# HTTP endpoint — hey
hey -n 10000 -c 100 http://localhost:3000/api/orders

# Single request timing
curl -o /dev/null -s -w "
  Time to first byte: %{time_starttransfer}s
  Total time:        %{time_total}s
  " http://localhost:3000/api/orders
```

Record: P50, P95, P99 latency, requests/second, error rate.

### Step 2: Locate the Layer

Determine which layer is contributing most to latency:

| Layer | Signals |
|---|---|
| Database | Slow queries, N+1 patterns, missing indexes |
| Application | CPU-bound processing, blocking I/O, large allocations |
| Network | External API calls without timeouts, DNS resolution time |
| Infrastructure | Container resource limits, autoscaling lag |
| Frontend | Large bundles, render-blocking resources, unoptimized assets |

```bash
# Application-level timing (Node.js example)
console.time('db_query');
const result = await db.query('SELECT ...');
console.timeEnd('db_query');

# System resource usage
top -b -n 1
vmstat 1 10
iostat -x 1 10
```

### Step 3: Profile the Identified Layer

Jump to the relevant section below based on the bottleneck layer.

## Backend Profiling (Node.js)

### CPU Profiling

```javascript
// Built-in profiler
node --prof app.js
node --prof-process isolate-*.log > profile.txt

// clinic.js (more user-friendly)
npm install -g clinic
clinic doctor -- node app.js
clinic flame -- node app.js
```

### Memory Profiling

```javascript
// Detect memory leaks — watch for growing heap across requests
node --expose-gc --inspect app.js

// In Chrome DevTools: Memory → Take Heap Snapshot → compare across time

// In code: track heap usage
const used = process.memoryUsage();
console.log({
  rss: `${Math.round(used.rss / 1024 / 1024)}MB`,
  heapUsed: `${Math.round(used.heapUsed / 1024 / 1024)}MB`,
  heapTotal: `${Math.round(used.heapTotal / 1024 / 1024)}MB`,
});
```

**Memory leak patterns:**
- Event listener accumulation (add without remove)
- Closures holding references to large objects
- Global cache without TTL or size limit
- Promises not awaited or rejected (unhandled rejection suppresses GC)

### Event Loop Blocking

```javascript
// Detect blocking operations
const { monitorEventLoopDelay } = require('perf_hooks');
const h = monitorEventLoopDelay({ resolution: 20 });
h.enable();
// After test period:
console.log(`P99 event loop delay: ${h.percentile(99)}ms`);

// Common blocking patterns to eliminate
JSON.parse(largeString)           // parse in worker_thread
fs.readFileSync(path)             // replace with readFile async
crypto.pbkdf2Sync(...)            // replace with async version
for (const row of millionRows)    // batch or stream
```

## Backend Profiling (Python)

```python
# cProfile — function-level timing
python -m cProfile -o profile.out app.py
python -m pstats profile.out

# line_profiler — line-by-line timing
pip install line_profiler
@profile
def slow_function():
    ...
kernprof -l -v app.py

# memory_profiler
pip install memory_profiler
@profile
def memory_intensive():
    ...
python -m memory_profiler app.py
```

## Backend Profiling (Go)

```go
import _ "net/http/pprof"

// Attach pprof endpoint
go func() {
    log.Println(http.ListenAndServe("localhost:6060", nil))
}()
```

```bash
# CPU profile (30 seconds)
go tool pprof http://localhost:6060/debug/pprof/profile?seconds=30

# Heap profile
go tool pprof http://localhost:6060/debug/pprof/heap

# Goroutine analysis
go tool pprof http://localhost:6060/debug/pprof/goroutine

# Interactive flamegraph
go tool pprof -http=:8080 profile.out
```

## Database Profiling

### Query Analysis (PostgreSQL)

```sql
-- Enable slow query logging (set in postgresql.conf or session)
SET log_min_duration_statement = 100; -- log queries over 100ms

-- EXPLAIN ANALYZE for a specific query
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT o.id, o.total_cents, u.email
FROM orders o
JOIN users u ON u.id = o.user_id
WHERE o.status = 'pending'
  AND o.created_at > now() - INTERVAL '7 days'
ORDER BY o.created_at DESC
LIMIT 50;

-- Find slow queries (requires pg_stat_statements extension)
SELECT query,
       calls,
       mean_exec_time,
       total_exec_time,
       rows
FROM pg_stat_statements
WHERE mean_exec_time > 100
ORDER BY mean_exec_time DESC
LIMIT 20;

-- Find missing indexes (tables with high seq scan count)
SELECT schemaname,
       tablename,
       seq_scan,
       seq_tup_read,
       idx_scan,
       idx_tup_fetch
FROM pg_stat_user_tables
WHERE seq_scan > 100
ORDER BY seq_tup_read DESC;
```

### Reading EXPLAIN ANALYZE Output

| Plan Node | What to look for |
|---|---|
| `Seq Scan` on large table | Missing or unused index |
| `Nested Loop` with high row estimates | Poor cardinality estimate; consider `ANALYZE tablename` |
| High `Buffers: shared read` | Data not in cache; may need query or schema changes |
| `Sort` on large intermediate result | Composite index covering sort column may eliminate it |
| `Hash Join` with large hash batch | Hash exceeds `work_mem`; may be fine or may need tuning |

### N+1 Detection

```bash
# Look for query patterns in application code
grep -rn "\.find\|\.where\|execute\|query" src/ | head -30

# Enable query logging in development to spot N+1 patterns
# Node.js (Sequelize): logging: console.log
# Python (SQLAlchemy): echo=True
# Rails: config.log_level = :debug
```

**Fix:** batch queries with `WHERE id IN (...)`, use joins, or use the ORM's eager loading.

## Frontend Profiling

### Lighthouse Audit

```bash
# CLI audit
npm install -g lighthouse
lighthouse https://yourapp.com --output html --output-path ./report.html

# Key metrics
# FCP (First Contentful Paint)  < 1.8s
# LCP (Largest Contentful Paint) < 2.5s
# TBT (Total Blocking Time)     < 200ms
# CLS (Cumulative Layout Shift)  < 0.1
# TTI (Time to Interactive)     < 3.8s
```

### Bundle Analysis

```bash
# webpack-bundle-analyzer
npm install --save-dev webpack-bundle-analyzer
npx webpack-bundle-analyzer stats.json

# Next.js bundle analysis
ANALYZE=true npm run build

# Vite bundle visualization
npx vite-bundle-visualizer
```

**Common bundle issues:**
- Importing entire library when only one function is needed (`import _ from 'lodash'` vs. `import debounce from 'lodash/debounce'`)
- Large translation files loaded synchronously
- Images not optimized or missing responsive sizes
- Fonts blocking render (add `font-display: swap`)

### React Rendering

```tsx
// Profile component render frequency
import { Profiler } from 'react';

<Profiler
  id="OrderList"
  onRender={(id, phase, actualDuration) => {
    console.log(`${id} ${phase}: ${actualDuration.toFixed(2)}ms`);
  }}
>
  <OrderList orders={orders} />
</Profiler>
```

**Common React performance issues:**

| Issue | Fix |
|---|---|
| Component re-renders on every parent render | `React.memo` or `useMemo` on derived data |
| Expensive calculation inside render | `useMemo` with correct dependency array |
| New function reference on every render | `useCallback` |
| Large list rendering all items | Virtualization (`react-window` or `react-virtual`) |
| Context causing widespread re-renders | Split context by update frequency |

## Infrastructure Profiling

```bash
# Container resource usage
docker stats --no-stream

# Kubernetes pod resource usage
kubectl top pods
kubectl top nodes
kubectl describe pod {pod-name} | grep -A 10 "Limits\|Requests"

# Check if CPU throttling is occurring (CFS throttle)
cat /sys/fs/cgroup/cpu/cpu.stat | grep throttled

# Network latency between services
ping -c 100 internal-service-hostname | tail -5
traceroute internal-service-hostname
```

## Benchmark Pattern

### Before-After Validation

```bash
# Baseline (before change)
wrk -t4 -c100 -d60s --latency http://localhost:3000/api/orders > baseline.txt

# Apply change

# Post-optimization
wrk -t4 -c100 -d60s --latency http://localhost:3000/api/orders > optimized.txt

diff baseline.txt optimized.txt
```

### Microbenchmark (Node.js)

```javascript
const { performance } = require('perf_hooks');

const ITERATIONS = 10_000;
const WARMUP = 1_000;

// Warmup
for (let i = 0; i < WARMUP; i++) { functionUnderTest(); }

// Measure
const start = performance.now();
for (let i = 0; i < ITERATIONS; i++) { functionUnderTest(); }
const duration = performance.now() - start;

console.log(`${ITERATIONS} iterations: ${duration.toFixed(2)}ms`);
console.log(`Per iteration: ${(duration / ITERATIONS).toFixed(4)}ms`);
```

### Microbenchmark (Python)

```python
import timeit

result = timeit.repeat(
    stmt='function_under_test()',
    setup='from module import function_under_test',
    repeat=5,
    number=10_000
)

print(f"Min: {min(result):.4f}s over 10,000 runs")
print(f"Avg: {sum(result)/len(result):.4f}s")
```

## Optimization Priority

Address in this order — each outer layer can dwarf inner layer gains:

```
1. Database queries        (10ms → 1ms is 9ms saved per request)
2. External API calls      (eliminate, cache, or parallelize)
3. Algorithm complexity    (O(n²) → O(n log n) at scale)
4. Memory allocations      (GC pressure at high throughput)
5. Serialization           (JSON parse/stringify on hot paths)
6. CPU-intensive work      (move to worker threads or background jobs)
7. Frontend bundles        (eliminate render-blocking resources)
8. Infrastructure sizing   (last resort; rarely the root cause)
```

## Findings Report Format

After profiling, summarize:

```
## Performance Analysis: {endpoint or feature}

Baseline: P50 {Xms} P95 {Xms} P99 {Xms} @ {Y} rps

Root cause identified:
- {layer}: {specific finding} — {evidence}

Changes made:
1. {change} — {rationale}

Post-optimization: P50 {Xms} P95 {Xms} P99 {Xms} @ {Y} rps

Improvement: {X%} reduction in P99 latency

Remaining headroom / next bottleneck:
- {observation}
```

## Never Do

- Optimize code without a measured baseline
- Optimize at a layer that is not the bottleneck
- Make multiple changes simultaneously and attribute the gain to any one of them
- Report improvement based on a single run — use multiple runs to account for variance
- Introduce a cache to fix an N+1 problem — fix the query instead
- Set performance targets without context on what the user actually experiences
