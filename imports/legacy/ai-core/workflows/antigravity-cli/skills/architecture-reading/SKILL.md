---
name: architecture-reading
description: Use to understand the current architecture before deciding or implementing, mapping the stack, boundaries, flows, patterns, and existing decisions.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
---

# Architecture Reading

## When to Use

- Before implementing a feature, to understand the existing structure
- When diagnosing a complex bug that crosses multiple layers
- When assessing the scope and risk of a proposed change
- When onboarding to a new codebase
- Before designing an API contract or data model

## Core Principle

Read and map the actual system before deciding anything. The goal is an accurate mental model, not an idealized one. What matters is what the code does, not what it was supposed to do.

## Reading Protocol

### 1. Start from the manifest

Identify the technology stack and declared dependencies before reading any source code.

**Node.js**
```bash
cat package.json
```

**Python**
```bash
cat requirements.txt
cat pyproject.toml
cat setup.py
```

**Go**
```bash
cat go.mod
```

**Rust**
```bash
cat Cargo.toml
```

**JVM**
```bash
cat pom.xml
cat build.gradle
```

**Multiple services**
```bash
cat docker-compose.yml
cat docker-compose.yaml
```

### 2. Find entry points

Locate where execution begins.

**Web frameworks**
```bash
grep -r "app.listen\|server.listen\|uvicorn\|gunicorn\|main()" --include="*.js" --include="*.ts" --include="*.py" --include="*.go" -l
```

**API routers**
```bash
grep -r "router\|Route\|@app.route\|@router" --include="*.js" --include="*.ts" --include="*.py" -l | head -20
```

**CLI tools**
```bash
grep -r "if __name__\|cobra\|urfave/cli\|yargs\|commander" -l | head -10
```

**Background workers**
```bash
grep -r "queue\|worker\|job\|scheduler\|cron" --include="*.js" --include="*.ts" --include="*.py" --include="*.go" -l | head -20
```

### 3. Map the directory structure

```bash
find . -type f | grep -v "node_modules\|.git\|__pycache__\|.pytest_cache\|dist\|build\|vendor" | sort
```

For larger repositories, examine key structural indicators:

```bash
ls -la
ls src/ 2>/dev/null || ls app/ 2>/dev/null || ls lib/ 2>/dev/null
```

### 4. Identify layers and boundaries

Map which directories or modules own which concerns.

**Look for layered patterns:**
- `routes/` or `controllers/` → HTTP entry points
- `services/` or `usecases/` → Business logic
- `repositories/` or `dao/` or `models/` → Data access
- `middleware/` → Cross-cutting concerns
- `utils/` or `helpers/` or `lib/` → Shared infrastructure

**Check for integration boundaries:**
```bash
grep -r "http.get\|http.post\|axios\|fetch\|requests.get\|requests.post\|grpc\|amqp\|kafka\|redis\|postgres\|mysql\|mongodb" -l | head -20
```

### 5. Find the existing contract

Look for explicit contracts before assuming there are none.

**OpenAPI / Swagger**
```bash
find . -name "openapi.yml" -o -name "openapi.yaml" -o -name "swagger.yml" -o -name "swagger.json" 2>/dev/null
```

**GraphQL schema**
```bash
find . -name "*.graphql" -o -name "schema.gql" 2>/dev/null | head -10
```

**Protobuf**
```bash
find . -name "*.proto" 2>/dev/null | head -10
```

**Type definitions**
```bash
find . -name "*.d.ts" -o -name "types.py" -o -name "schema.py" 2>/dev/null | head -10
```

### 6. Locate existing decisions

Look for ADRs, architecture notes, and long-lived documentation before adding anything.

```bash
find . -path "*/adr*" -o -path "*/decisions*" -o -path "*/docs*" 2>/dev/null | grep -i "\.md$" | head -20
grep -r "ADR\|Architecture Decision\|technical debt\|FIXME\|TODO\|HACK" --include="*.md" -l | head -10
```

Read the repository root first:
```bash
cat README.md 2>/dev/null
cat CONTRIBUTING.md 2>/dev/null
cat ARCHITECTURE.md 2>/dev/null
```

### 7. Check test coverage boundaries

Tests reveal what behavior the system considers intentional and what integration points are exercised.

```bash
find . -path "*/test*" -o -path "*/spec*" -o -path "*/__tests__*" | grep -v node_modules | head -30
```

**What to look for:**
- Which modules have coverage versus which are untested
- Which integration points are mocked versus hit for real
- Whether test files mirror source structure (good) or are scattered (warning)

### 8. Inspect configuration management

```bash
find . -name ".env*" -o -name "config.yml" -o -name "config.yaml" -o -name "config.json" -o -name "settings.py" | grep -v node_modules | head -20
```

Check for secrets handling:
```bash
grep -r "process.env\|os.environ\|os.getenv\|config\." --include="*.js" --include="*.ts" --include="*.py" -l | head -20
```

## What to Map

After reading, document these before proposing any change:

### Stack
- Language, framework version, package manager
- External services (databases, queues, caches, third-party APIs)
- Infrastructure (containers, cloud provider, orchestration)

### Boundaries
- Which modules own which concerns
- Where the layering is clean versus where it leaks
- Where integration points cross process boundaries

### Flows
For the specific feature or domain area you care about, trace at least one request from entry to persistence and back.

### Patterns
- Authentication and authorization mechanisms
- Error handling conventions
- Logging and observability hooks
- Migrations and schema management approach
- Testing conventions

### Gaps and Risks
- Missing contracts (no schema, no tests, no types)
- Layers that are collapsed (logic in routes, queries in controllers)
- Duplicated logic that indicates accidental divergence
- Configuration or secrets that appear hardcoded
- Dependencies that are significantly outdated or have known vulnerabilities

## Reading Signals

| Observation | What It Suggests |
|---|---|
| Business logic in route handlers | No service layer; changes are high-risk |
| SQL queries in HTTP controllers | No data access boundary; coupling is direct |
| No type definitions or annotations | Dynamic behavior; runtime errors may be hidden |
| Tests only at E2E level | Business logic unprotected; refactors are risky |
| Multiple config files with overlapping keys | Configuration is fragmented; behavior varies by environment |
| Inline `require()` / `import` inside functions | Tight coupling or circular dependency risk |
| `console.log` / `print` in production paths | Observability gap; no structured logging |
| API keys or credentials in source files | Critical security vulnerability |

## Output

After mapping the architecture, summarize in this form before proposing any action:

```
Stack: [language] [framework] [db] [cache] [queue if any]
Entry: [entry point(s)]
Layers: [directory → concern mapping]
Boundary gap: [any collapsed or missing layer]
Contract: [OpenAPI / schema / types present or absent]
Tests: [what is covered and how]
Decisions: [ADRs or equivalent present or absent]
Key risk: [most important thing to address before changing this]
```

This summary is the prerequisite for any API design, data modeling, or implementation proposal.
