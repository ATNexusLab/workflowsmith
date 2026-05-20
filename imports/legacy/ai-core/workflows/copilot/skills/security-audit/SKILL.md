---
name: security-audit
description: Use to audit code, dependencies, and configuration for vulnerabilities using current OWASP framing, with checks for access control, cryptography, injection, secrets, hardening, and severity classification.
user-invocable: true
disable-model-invocation: false
triggers:
  - "audit code for OWASP-aligned vulnerabilities"
  - "review dependencies for CVEs or insecure configuration"
  - "produce a security report with severity classification"
license: MIT
---

# Security Audit

## When to Use

- Audit new or existing code for vulnerabilities
- Review dependencies and build inputs for known issues
- Evaluate security configuration such as headers, CORS, TLS, and secret handling
- Review authentication, authorization, and session management
- Produce a prioritized security report

## Audit Frame

Use **OWASP Top 10 (2021)** as the external taxonomy and **OWASP ASVS** depth when a finding needs a stronger control baseline.

The current OWASP Top 10 categories are:

1. **A01: Broken Access Control**
2. **A02: Cryptographic Failures**
3. **A03: Injection**
4. **A04: Insecure Design**
5. **A05: Security Misconfiguration**
6. **A06: Vulnerable and Outdated Components**
7. **A07: Identification and Authentication Failures**
8. **A08: Software and Data Integrity Failures**
9. **A09: Security Logging and Monitoring Failures**
10. **A10: Server-Side Request Forgery**

## OWASP-Aligned Checklist

### A01: Broken Access Control

**Verify:**
- object ownership is enforced server-side
- privileged actions require explicit role or policy checks
- cross-tenant or cross-user access is blocked
- admin-only or internal endpoints are not exposed by routing mistakes
- CORS does not accidentally widen access

### A02: Cryptographic Failures

**Verify:**
- sensitive data in transit uses TLS
- passwords use approved password hashing (`argon2`, `bcrypt`, or `scrypt`)
- encryption at rest is used where the data classification requires it
- keys, IVs, salts, and nonces are generated and stored safely
- secrets do not appear in logs, traces, or error payloads

### A03: Injection

**Verify:**
- SQL and NoSQL access uses parameterization or safe query builders
- command execution does not pass unsanitized user input
- templates and HTML rendering are protected against XSS or SSTI
- file, URL, and shell arguments are validated against allowlists where possible
- deserialization of untrusted input is avoided or tightly constrained

**Useful tooling:**

```bash
semgrep --config "p/owasp-top-ten" .
```

### A04: Insecure Design

**Verify:**
- high-risk workflows have abuse cases considered: account takeover, replay, race conditions, bulk abuse
- rate limits or quotas protect expensive and auth-related operations
- state transitions enforce business invariants
- sensitive mutations require explicit authorization and ownership checks
- trust boundaries are identified and validated at every input edge

### A05: Security Misconfiguration

**Verify:**
- debug mode and verbose errors are disabled in production
- security headers are present where applicable:
  - `Content-Security-Policy`
  - `Strict-Transport-Security`
  - `X-Content-Type-Options: nosniff`
  - `X-Frame-Options` or equivalent frame policy
  - `Referrer-Policy`
- default credentials, sample accounts, and unused admin surfaces are removed
- storage buckets, queues, and internal services are not publicly exposed

### A06: Vulnerable and Outdated Components

**Verify by stack:**

```bash
# JavaScript / Node.js
npm audit
npx audit-ci --moderate

# Python
pip-audit
safety check

# Go
govulncheck ./...

# Ruby
bundle audit check --update

# Java
mvn dependency-check:check

# Rust
cargo audit
```

Also verify:
- lockfiles are committed
- base images and OS packages are patched on a defined cadence
- abandoned dependencies have an exit strategy

### A07: Identification and Authentication Failures

**Verify:**
- session or token expiration is enforced
- refresh or reset tokens are single-purpose and time-bounded
- brute-force protection exists on login and reset flows
- user enumeration is minimized
- MFA exists or is planned for high-risk operations
- cookies use `HttpOnly`, `Secure`, and appropriate `SameSite`

### A08: Software and Data Integrity Failures

**Verify:**
- CI/CD and package registries are trusted and access-controlled
- dependency updates and build artifacts are not accepted from unverified sources
- webhook and callback payloads are signature-checked when required
- auto-update mechanisms verify provenance or signatures
- unsafe deserialization, dynamic code loading, and unchecked plugin systems are avoided

### A09: Security Logging and Monitoring Failures

**Verify:**
- authentication failures and privilege-sensitive actions are logged
- logs are structured enough for alerting and investigation
- logs exclude secrets and minimize unnecessary PII
- alerting exists for suspicious spikes, auth abuse, and integrity failures
- retention and access control for logs meet the system's risk level

### A10: Server-Side Request Forgery

**Verify:**
- server-side fetches validate destination scheme and host
- internal network ranges, loopback, metadata endpoints, and local files are blocked
- DNS resolution and redirect handling do not bypass allowlists
- image fetchers, webhooks, importers, and preview features are audited specifically

## Severity Classification

| Severity | Criteria | Required Action |
|---|---|---|
| **Critical** | RCE, auth bypass, secret exposure, arbitrary data access, supply-chain compromise | Stop and fix immediately |
| **High** | Persistent XSS, IDOR, SSRF to sensitive targets, weak auth on sensitive paths | Fix before the next release |
| **Medium** | Missing hardening, permissive CORS, incomplete logging, moderate dependency risk | Prioritize in backlog |
| **Low** | Defense-in-depth gaps, hygiene improvements, low-impact misconfiguration | Track as hardening work |

## Report Template

```markdown
## Security Report

**Scope:** [modules/files/PRs audited]
**Date:** YYYY-MM-DD

### Executive Summary
- Critical: N
- High: N
- Medium: N
- Low: N

### Findings
| ID | Severity | Category | Location | Issue | Impact | Recommendation |
|---|---|---|---|---|---|---|
| 1 | High | A01 Broken Access Control | `auth.ts:42` | Cross-user data access | Unauthorized disclosure | Enforce ownership check |

### Dependency Findings
| Package | Version | Advisory / CVE | Severity | Fixed Version |
|---|---|---|---|---|

### Next Steps
- [ordered remediation list]
```

## Quick Pre-Deploy Checklist

- [ ] Dependency audit shows no unresolved critical issues
- [ ] No secrets are hardcoded or leaked in logs
- [ ] HTTPS and secure transport expectations are enforced
- [ ] Security headers are configured for exposed web surfaces
- [ ] CORS is restrictive and intentional
- [ ] Authentication endpoints have rate limiting and abuse controls
- [ ] Input validation exists at every trust boundary

## Steps

### 1. Define scope

- List the files, modules, services, or pull request under review
- Identify the stack, frameworks, and deployment environment
- Identify sensitive assets: credentials, PII, payments, admin actions

### 2. Review dependencies and build inputs

- run the relevant dependency audit tools
- inspect base images, OS packages, lockfiles, and third-party integrations
- note unsupported or abandoned components

### 3. Audit code and configuration using the OWASP frame

- start with access control, auth, secrets, and injection
- continue through the remaining Top 10 categories
- map each finding to a specific surface and exploit path

### 4. Check secrets, logging, and operational exposure

```bash
rg -n -i "(password|secret|api[_-]?key|token)" --glob "*.{js,ts,py,go,rb,java}" .
git log --all --full-history -- .env
```

### 5. Produce the report

- classify each finding by severity
- include a concrete fix recommendation
- note any assumptions, gaps, or areas not reviewed
