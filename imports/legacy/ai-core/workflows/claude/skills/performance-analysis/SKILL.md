---
name: performance-analysis
description: Use to investigate latency, profile bottlenecks, benchmark changes, and validate improvements across backend, database, frontend, and infrastructure layers.
when_to_use: >
  Use when a system, endpoint, query, or workload is slow, when identifying bottlenecks before optimizing, or when profiling, benchmarking, or defining performance budgets.
---

# Performance Analysis

## When to Use

- A system is slow and the cause is unclear
- Before optimizing, to find the real bottleneck
- To define SLOs or performance budgets
- To verify that a change actually improved the numbers

## Golden Rule

**Do not optimize before measuring.** Performance work follows a loop:

**Measure → Identify bottleneck → Form a hypothesis → Change one thing → Measure again**

## Metrics by Layer

### Backend / API

- **Latency p50, p95, p99**
- **Throughput** (requests per second)
- **Error rate**
- **CPU and memory usage under load**

### Database

- **Slow queries**
- **Query count per request** to catch N+1
- **Index hit rate** versus sequential scans
- **Connection pool saturation**

### Frontend

- **Core Web Vitals:** LCP, INP, CLS
- **Time to interactive**
- **Bundle size**
- **Network waterfall**

### Infrastructure / Runtime

- **CPU saturation or throttling**
- **Memory pressure, OOM kills, and GC pauses**
- **Disk I/O latency and queue depth**
- **Network latency, retransmissions, and packet loss**
- **Load balancer, cache, and queue latency**
- **Pod/container restarts, autoscaling events, and noisy-neighbor effects**

## Tools by Stack

### Backend

```bash
# Node.js
clinic doctor -- node server.js
clinic flame -- node server.js

# Python
python -m cProfile -o output.prof app.py
python -m pstats output.prof

# Go
go tool pprof http://localhost:6060/debug/pprof/profile
```

### Database

```sql
SELECT query, mean_exec_time, calls
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS) SELECT ...;
```

### Frontend

```bash
npx lighthouse https://example.com --view
npx webpack-bundle-analyzer stats.json
```

### Infrastructure

```bash
vmstat 1
iostat -xz 1
kubectl top pods
kubectl top nodes
```

Use platform-native telemetry when available:
- Prometheus / Grafana for time series and saturation
- Cloud load balancer metrics for edge latency
- APM traces for cross-service breakdown
- Container or orchestrator events for restarts and throttling

## Validation Checklist

### 1. Establish a baseline

- [ ] Measure current p50/p95/p99 latency
- [ ] Measure current throughput or concurrency limit
- [ ] Identify the slowest paths or workloads
- [ ] Capture relevant infrastructure metrics during the same window

### 2. Identify the bottleneck

- [ ] CPU-bound?
- [ ] I/O-bound?
- [ ] Memory pressure or GC issue?
- [ ] Database issue?
- [ ] Network issue?
- [ ] Infrastructure saturation, throttling, or cache miss problem?

### 3. Form a hypothesis and optimize

- [ ] Change one thing at a time
- [ ] Measure each change in isolation
- [ ] Keep workload shape consistent between runs

### 4. Validate and document

- [ ] Compare before and after using the same method
- [ ] Confirm no regression elsewhere
- [ ] Record the winning change and measured gain

## Common Warning Signs

- Large table scan because an index is missing
- N+1 query pattern inside a loop
- JavaScript bundle so large that rendering is delayed
- Memory leak with continuously growing resident set size
- CPU spike caused by synchronous work on the main thread
- Container CPU throttling even though application code looks efficient
- Queue backlog growing faster than workers can drain it
- Cache hit rate collapse causing downstream latency spikes

## Steps

### 1. Define the performance problem

Before profiling:
- What is slow: endpoint, query, page load, job, or full system?
- What metric is failing and what target matters?
- In which environment does it happen, and is the workload representative?

### 2. Measure before changing anything

```bash
curl -sS -w "\ntime_connect: %{time_connect}\ntime_starttransfer: %{time_starttransfer}\ntime_total: %{time_total}\n" \
  http://localhost:3000/api/endpoint
```

```sql
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'user@example.com';
```

```bash
npx lighthouse https://example.com --output json
```

### 3. Separate application and infrastructure causes

Use `## Metrics by Layer` to narrow the bottleneck:
- application logic and synchronous work
- query plan and lock contention
- frontend rendering and asset delivery
- container, host, network, cache, or queue saturation

### 4. Profile with the right tool

Choose a profiler or telemetry source appropriate to the suspected layer.

### 5. Implement one optimization and re-measure

- Keep the workload and measurement method constant
- Re-test with comparable concurrency and data volume
- Reject improvements that simply move the bottleneck elsewhere

### 6. Complete the checklist

Use `## Validation Checklist` before closing the investigation.

## Examples

### Slow Query Analysis

```sql
SELECT query, mean_exec_time, calls, total_exec_time
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 10;

EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT u.*, o.*
FROM users u
JOIN orders o ON o.user_id = u.id
WHERE u.email = 'user@example.com';
```

### API Profiling Example

```javascript
async function getUser(id) {
  console.time("db-query");
  const user = await db.findById(id);
  console.timeEnd("db-query");
  return user;
}
```

### Infrastructure Bottleneck Example

```text
Symptom: p95 latency spikes only under load.
Findings:
- application CPU moderate
- database healthy
- container CPU throttled at limit
Action:
- raise CPU limit or reduce per-request CPU usage
- rerun the same load test and compare p95 plus throttling metrics
```
