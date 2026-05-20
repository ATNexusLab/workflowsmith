---
name: devops-patterns
description: Use to design CI/CD pipelines, Docker workflows, infrastructure as code, environments, deployments, observability, and secure secrets handling.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
---

# DevOps Patterns

## When to Use

- Design or review CI/CD pipelines
- Build or improve Dockerfile and container workflows
- Establish environment parity between dev, staging, and production
- Define deployment strategies (rolling, blue-green, canary)
- Set up observability (logging, metrics, tracing, alerting)
- Audit secrets and configuration management
- Configure infrastructure as code (Terraform, Pulumi, CDK)

## Core Principles

1. **Pipeline as code** — all CI/CD configuration lives in the repository and is reviewed
2. **Reproducibility** — the same commit must produce the same artifact on every machine and every environment
3. **Fail fast** — cheap checks run first; expensive checks run only if cheap checks pass
4. **Environment parity** — dev, staging, and production differ only in scale and secrets
5. **Secure by default** — credentials never appear in logs, images, or source code

## CI/CD Pipeline Design

### Pipeline Stage Order

```
1. Lint / format check      — fast, catches trivial issues
2. Unit tests               — fast, no external dependencies
3. Build / compile          — produces the artifact
4. Integration tests        — requires services, slower
5. Security scan            — dependency audit and SAST
6. Publish artifact         — push image or package after all checks pass
7. Deploy to staging        — automatic on main branch
8. Smoke tests              — validates staging deployment
9. Deploy to production     — manual gate or auto on tag
```

**Rule:** Never publish or deploy before all earlier stages pass.

### GitHub Actions Pattern

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run type-check

  test:
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm test -- --coverage
      - uses: actions/upload-artifact@v4
        with:
          name: coverage
          path: coverage/

  build:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v5
        with:
          push: ${{ github.ref == 'refs/heads/main' }}
          tags: ghcr.io/${{ github.repository }}:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

**Rules:**
- Pin action versions to a full SHA or major version tag; avoid `@main`
- Use `npm ci` (not `npm install`) for reproducible dependency installation
- Cache dependencies between runs (`actions/cache` or built-in `cache:` option)
- Scope `GITHUB_TOKEN` permissions to the minimum required

### Security Scanning in CI

```yaml
  security:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - uses: actions/checkout@v4
      - name: Dependency audit
        run: npm audit --audit-level=high
      - name: SAST scan
        uses: github/codeql-action/analyze@v3
        with:
          languages: javascript
      - name: Container scan
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: ghcr.io/${{ github.repository }}:${{ github.sha }}
          severity: HIGH,CRITICAL
          exit-code: '1'
```

## Docker Patterns

### Production Dockerfile

```dockerfile
# syntax=docker/dockerfile:1

# ── Build stage ──────────────────────────────────────────────────────────────
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

# ── Runtime stage ────────────────────────────────────────────────────────────
FROM node:20-alpine AS runtime
WORKDIR /app

# Non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy only what is needed
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package.json ./

USER appuser
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "dist/index.js"]
```

**Rules:**
- Always use multi-stage builds; never ship build tools into the runtime image
- Run as a non-root user (`adduser`/`addgroup`)
- Copy only the final artifact, not the full source tree
- Declare a `HEALTHCHECK`
- Pin base image to a specific version tag (not `latest`)
- Use `.dockerignore` to exclude `node_modules`, `.git`, test files, and local secrets

### .dockerignore

```
.git
.gitignore
node_modules
npm-debug.log
coverage
.env
.env.*
*.test.ts
*.spec.ts
Dockerfile*
docker-compose*
README.md
docs/
```

### Docker Compose for Local Development

```yaml
version: '3.9'

services:
  app:
    build:
      context: .
      target: builder          # Use the build stage for dev with hot reload
    ports:
      - "3000:3000"
    volumes:
      - .:/app
      - /app/node_modules      # Preserve container node_modules
    environment:
      NODE_ENV: development
    env_file: .env.local
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    command: npm run dev

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: appdb
      POSTGRES_USER: appuser
      POSTGRES_PASSWORD: apppassword
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U appuser -d appdb"]
      interval: 5s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5

volumes:
  postgres_data:
```

**Rules:**
- Use `healthcheck` + `depends_on: condition: service_healthy` to enforce startup order
- Mount source code as a volume for hot reloading in development
- Never use hardcoded credentials in compose files — use `env_file` pointing to `.env.local`

## Deployment Strategies

### Rolling Deploy

Default for stateless services. Replace instances one at a time; health checks gate progression.

**When to use:** most stateless web services, APIs without breaking schema changes

**Risk:** briefly runs two versions simultaneously; new code must remain backward-compatible with existing clients and the current database schema during rollout

### Blue-Green Deploy

Maintain two identical environments (blue = current, green = new). Switch traffic atomically after green passes health checks.

**When to use:** major changes requiring instant rollback capability, scheduled maintenance windows

**Cost:** requires double the infrastructure during transition

### Canary Deploy

Route a small percentage of traffic to the new version. Observe error rates and latency. Gradually increase or roll back.

**When to use:** high-traffic services where validating with real traffic before full rollout is essential

**Implementation checklist:**
- [ ] Error rate and latency metrics exist for both canary and stable versions
- [ ] Automated rollback triggers are configured
- [ ] Canary traffic is representative, not biased to a specific segment

### Pre-Deployment Checklist

- [ ] Database migrations are backward-compatible with the previous app version
- [ ] Secrets are in the secret store, not in the deployment manifest
- [ ] Container image is tagged with the commit SHA, not `latest`
- [ ] Health check endpoint is functional before routing traffic
- [ ] Rollback path is tested and documented

## Secrets Management

### What Belongs Where

| Type | Storage |
|---|---|
| API keys, database passwords | Secret store (Vault, AWS Secrets Manager, GCP Secret Manager) |
| Non-secret config (feature flags, URLs) | Environment-specific config maps |
| Per-developer local overrides | `.env.local` (git-ignored) |
| CI/CD secrets | Repository or organization secrets in the CI provider |
| Certificates | Certificate store or secret store; never in the image |

**Never:**
- Commit secrets to git (even in `.env` files)
- Print secrets in CI logs (`set -x` exposes them; use `set +x` around secret operations)
- Pass secrets as Docker build arguments (they appear in layer history)
- Store secrets in environment variables baked into the container image

### Secret Rotation Protocol

1. Provision new secret in the secret store
2. Update applications to read both old and new (if rotation requires simultaneous support)
3. Rotate the credential at the source (database, API provider)
4. Remove the old secret from the store and application config
5. Verify no references to the old secret remain in logs or configs

### Detecting Secrets in Code

```bash
# Use a dedicated tool for pre-commit scanning
which gitleaks && gitleaks detect --source . --no-git

# Quick manual audit
grep -r "password\|secret\|api_key\|token\|private_key" \
  --include="*.env" --include="*.json" --include="*.yaml" \
  --include="*.py" --include="*.js" --include="*.ts" \
  -l | grep -v ".gitignore\|node_modules\|test\|spec"
```

## Observability

### Three Pillars

**Logs** — structured JSON, written to stdout, collected by the platform

```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "level": "info",
  "message": "Order created",
  "service": "order-service",
  "request_id": "req_abc123",
  "user_id": "usr_456",
  "order_id": "ord_789",
  "duration_ms": 145
}
```

**Metrics** — counters, gauges, histograms (Prometheus or platform equivalent)

```
# Request rate
http_requests_total{method="POST", route="/orders", status="201"} 1024

# Latency histogram
http_request_duration_seconds_bucket{le="0.1"} 850
http_request_duration_seconds_bucket{le="0.5"} 980
http_request_duration_seconds_bucket{le="1.0"} 1000

# Business metric
orders_created_total{region="us-east"} 542
```

**Traces** — distributed request tracing with span context propagation (OpenTelemetry)

### Minimum Alerting

Every service must alert on:

| Signal | Threshold (adjust per service) |
|---|---|
| Error rate | > 1% of requests over 5 minutes |
| P99 latency | Exceeds SLO target |
| Service availability | Health check failing |
| Queue depth | Worker backlog growing beyond threshold |
| Disk/memory pressure | > 85% utilization |

**Alert hygiene:**
- Every alert must have a documented runbook
- Alerts fire on symptoms (high error rate), not causes (CPU at 70%)
- Tune thresholds to avoid alert fatigue — zero-tolerance thresholds on non-critical metrics cause on-call burnout

### Health Check Endpoint

```typescript
app.get('/health', async (req, res) => {
  const checks = await Promise.allSettled([
    db.query('SELECT 1'),
    redis.ping(),
  ]);

  const healthy = checks.every(c => c.status === 'fulfilled');

  res.status(healthy ? 200 : 503).json({
    status: healthy ? 'ok' : 'degraded',
    timestamp: new Date().toISOString(),
    checks: {
      database: checks[0].status === 'fulfilled' ? 'ok' : 'error',
      cache: checks[1].status === 'fulfilled' ? 'ok' : 'error',
    }
  });
});
```

## Infrastructure as Code Patterns

### Terraform Module Structure

```
infrastructure/
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
└── modules/
    ├── networking/
    ├── database/
    └── application/
```

**Rules:**
- Lock provider versions in `versions.tf`
- Store state in remote backend (S3 + DynamoDB lock, GCS, Terraform Cloud); never store locally
- Separate `plan` from `apply` in CI — plan on PR, apply on merge to main
- Use workspaces or separate state files for different environments
- Tag all resources with environment, service, and owner

### Terraform CI Pattern

```yaml
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3

      - name: Terraform Init
        run: terraform init
        working-directory: infrastructure/

      - name: Terraform Plan
        run: terraform plan -out=tfplan
        working-directory: infrastructure/
        env:
          TF_VAR_environment: ${{ github.ref == 'refs/heads/main' && 'production' || 'staging' }}

      # Apply only on push to main
      - name: Terraform Apply
        if: github.event_name == 'push' && github.ref == 'refs/heads/main'
        run: terraform apply tfplan
        working-directory: infrastructure/
```

## Never Do

- Store secrets in environment variables baked into the container image
- Use `latest` as a production image tag — it makes rollbacks impossible
- Run containers as root without explicit justification
- Skip the health check — orchestrators and load balancers cannot route traffic safely without it
- Deploy without a rollback plan
- Run `terraform apply` without a prior `terraform plan` review
- Commit `.env` files or any file containing real credentials
- Print secrets in CI/CD logs
