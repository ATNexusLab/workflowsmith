---
name: devops-patterns
description: Use to design CI/CD pipelines, Docker workflows, infrastructure as code, environments, deployments, observability, and secure secrets handling.
when_to_use: >
  Use when setting up a CI/CD pipeline, working on Docker, Compose, or infrastructure as code, or defining deployment strategy, environments, or secret management.
---

# DevOps Patterns

## When to Use

- Configure or improve CI/CD pipelines
- Build or optimize Docker images and local container workflows
- Define deployment strategies such as rolling, blue-green, or canary
- Manage infrastructure as code
- Handle secrets, environment variables, and operational hardening
- Standardize development, staging, and production environments

## CI/CD Pipeline

### Recommended Flow

```text
Install → Lint → Build → Test → Security → Package → Deploy
```

**Principles:**
- **Fail fast** — run cheap validation before expensive stages
- **Reproducible** — the same commit should produce the same artifact
- **Incremental** — cache dependencies and build layers intentionally
- **Secure** — keep secrets out of logs and automate dependency or image scanning

### GitHub Actions Pattern

```yaml
name: CI

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version-file: ".node-version"
          cache: "npm"
      - run: npm ci
      - run: npm run lint

  test:
    needs: lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version-file: ".node-version"
          cache: "npm"
      - run: npm ci
      - run: npm test

  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm ci
      - run: npm run build
```

**Best practices:**
- Pin action versions instead of using floating tags
- Split jobs to enable useful parallelism
- Publish immutable build artifacts
- Require green CI before merge or release

## Docker

### Multi-Stage Dockerfile

```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build && npm prune --omit=dev

FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
EXPOSE 3000
USER node
CMD ["node", "dist/index.js"]
```

**Best practices:**
- Use multi-stage builds to reduce final image size
- Keep `.dockerignore` current
- Run as a non-root user when possible
- Add a healthcheck for long-lived services
- Pin base images to supported versions

### Compose for Development

```yaml
services:
  app:
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
    depends_on:
      db:
        condition: service_healthy

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: app_dev
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U dev"]
      interval: 5s
      timeout: 5s
      retries: 5
```

## Infrastructure as Code

- Keep infrastructure definitions versioned and reviewable
- Prefer reusable modules over copy-paste stacks
- Separate environment-specific values from shared templates
- Validate plans before apply
- Treat networking, IAM, DNS, storage, and compute as part of one controlled system

## Deployment Strategies

| Strategy | Risk | Rollback | Best Fit |
|---|---|---|---|
| **Rolling** | Medium | Slower | Default for incremental updates |
| **Blue-Green** | Low | Fast | High-risk changes with near-zero downtime |
| **Canary** | Low | Fast | Progressive exposure to real traffic |
| **Recreate** | High | Slow | Workloads that tolerate downtime |

**Rules:**
- Have a rollback plan before production deployment
- Separate database migrations from application rollout when possible
- Use feature flags when deployment and release should be decoupled
- Run smoke checks immediately after deployment

## Secrets Management

**Never:**
- store secrets in source control
- print secrets in logs or CI output
- share production credentials across environments

**Always:**
- use a secret manager or encrypted CI secret store
- rotate secrets on a schedule and after incidents
- apply least privilege to every credential
- audit access to secret material

## Environments

| Environment | Purpose | Data |
|---|---|---|
| **Development** | Local work and rapid iteration | Fake or seeded data |
| **Staging** | Pre-production validation | Sanitized or anonymized production-like data |
| **Production** | Live user traffic | Real data with backups and recovery controls |

**Rules:**
- Keep staging as close to production as practical
- Never use raw production data in development
- Use observability in every environment
- Keep environment-specific configuration explicit

## Observability and Operations

- Collect logs, metrics, and traces for critical services
- Alert on user-visible failures, saturation, and resource exhaustion
- Track deploy markers so incidents can be correlated with changes
- Verify backup cadence, restore procedures, and disaster recovery assumptions

## Validation Checklist

- [ ] CI/CD pipeline is configured and reliable
- [ ] Build artifacts and container images are reproducible
- [ ] Docker images are minimized, non-root where possible, and health-checked
- [ ] Infrastructure changes are managed as code
- [ ] Secrets are handled by a secure secret store
- [ ] Deployment rollback path is documented and tested
- [ ] Monitoring, alerting, and backup strategy are in place
- [ ] Development, staging, and production are isolated appropriately

## Steps

### 1. Map the operational context

- Identify the target platform: cloud, Kubernetes, VM, serverless, or on-prem
- List existing CI/CD, container, and IaC tooling
- Confirm environment topology and release constraints

### 2. Design the pipeline

- Choose triggers: push, pull request, tag, or schedule
- Define stages: validate, test, package, deploy
- Decide what artifacts, reports, and approvals are required

### 3. Package the workload

- Build lean images or artifacts
- Isolate runtime dependencies from build dependencies
- Keep runtime configuration externalized

### 4. Plan deployment and rollback

- Choose rolling, blue-green, canary, or recreate
- Define health checks and promotion criteria
- Define rollback triggers and procedure

### 5. Secure and observe

- Route secrets through the right store
- Confirm metrics, logs, traces, and alerts
- Verify backup and recovery coverage

### 6. Validate with the checklist

Complete the `## Validation Checklist` before production rollout.

## Examples

### Basic CI/CD Pipeline

```yaml
name: CI/CD

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "20"
      - run: npm ci
      - run: npm test -- --coverage

  build-and-push:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build and push Docker image
        run: |
          docker build -t ${{ secrets.REGISTRY }}/app:${{ github.sha }} .
          docker push ${{ secrets.REGISTRY }}/app:${{ github.sha }}
```

### IaC Review Questions

```text
- Are state changes reviewable before apply?
- Are IAM permissions least-privilege?
- Are environment differences parameterized instead of duplicated?
- Can the stack be recreated from source control alone?
```

## Never Do

- Hardcode secrets, credentials, or tokens in any config, Dockerfile, or pipeline file
- Use `latest` as an image tag in production configs — always pin to a specific digest or version
- Skip health checks or readiness probes in service definitions
- Expose the Docker socket to containers without explicit user acknowledgement
- Disable TLS or authentication "for simplicity" in infrastructure configs
- Combine build and runtime layers in a single Dockerfile stage without justification
