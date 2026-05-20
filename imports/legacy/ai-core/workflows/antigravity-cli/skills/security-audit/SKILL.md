---
name: security-audit
description: Use to audit code, dependencies, and configuration for vulnerabilities using current OWASP framing, with checks for access control, cryptography, injection, secrets, hardening, and severity classification.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
---

# Security Audit

## When to Use

- Audit a codebase, API, or configuration surface for vulnerabilities
- Review a pull request with security implications (auth, input handling, data access)
- Classify a reported vulnerability by severity and recommend remediation
- Validate that security controls meet baseline expectations before launch
- Investigate a suspected security incident

## Audit Mode Rules

This skill operates in **read-only audit mode**. During a security audit:
- Report findings with severity and evidence
- Recommend remediations
- Do not modify code

Code changes require a separate implementation task.

## Severity Classification (CVSS-aligned)

| Severity | Score Range | Characteristics |
|---|---|---|
| **Critical** | 9.0–10.0 | Remote, unauthenticated, high impact on confidentiality/integrity/availability |
| **High** | 7.0–8.9 | Significant impact, exploitable with low complexity or common conditions |
| **Medium** | 4.0–6.9 | Exploitable under specific conditions, partial impact |
| **Low** | 0.1–3.9 | Limited scope, requires local access or unusual conditions |
| **Info** | — | No direct vulnerability; observation that improves posture |

## OWASP Top 10 Checklist

### A01: Broken Access Control

```bash
# Find authorization checks
grep -rn "isAdmin\|hasPermission\|authorize\|can?\|role\|permission" \
  --include="*.ts" --include="*.js" --include="*.py" src/ | head -30

# Look for missing auth on routes
grep -rn "router\.\|app\.get\|app\.post\|@app.route" \
  --include="*.ts" --include="*.js" --include="*.py" src/ | head -30
```

**What to check:**
- Every route and operation has authorization verification — not just authentication
- Authorization is enforced server-side; client-side checks are UI conveniences only
- Resource ownership is verified: a user can only access their own resources unless explicitly granted broader access
- Admin-only routes are protected by role checks, not just authentication
- IDOR (Insecure Direct Object Reference): object IDs in URLs or payloads are validated for ownership before access

**Red flags:**
```javascript
// IDOR — no ownership check
app.get('/orders/:id', async (req, res) => {
  const order = await Order.findById(req.params.id);  // anyone can fetch any order
  res.json(order);
});

// Missing authorization check
app.delete('/users/:id', authenticate, async (req, res) => {
  await User.delete(req.params.id);  // authenticated, but is this user allowed?
});
```

### A02: Cryptographic Failures

```bash
grep -rn "md5\|sha1\|des\|rc4\|base64\|Math.random\|random()" \
  --include="*.ts" --include="*.js" --include="*.py" src/ | head -20
```

**What to check:**
- Passwords are hashed with bcrypt, Argon2, or scrypt — never MD5, SHA-1, or unsalted SHA-256
- Sensitive data at rest is encrypted; PII and financial data are identified
- TLS is enforced; HTTP is not accepted for any production traffic carrying sensitive data
- Cryptographic keys and secrets are not hardcoded
- `Math.random()` is not used for security-sensitive randomness — use `crypto.randomBytes` or equivalent

**Red flags:**
```python
# MD5 for passwords — broken
import hashlib
hashed = hashlib.md5(password.encode()).hexdigest()

# Weak random for tokens — predictable
import random
token = str(random.randint(100000, 999999))
```

### A03: Injection

```bash
# SQL injection patterns
grep -rn "f\"\|\.format(\|% s\|%s\|string concat.*query\|query.*+" \
  --include="*.py" src/ | grep -i "sql\|query\|select\|insert\|update\|delete" | head -20

grep -rn "execute\|query\|raw\|literal" --include="*.py" --include="*.ts" --include="*.js" src/ | head -30

# NoSQL injection
grep -rn "\$where\|\$regex\|eval(" --include="*.js" --include="*.ts" src/ | head -20

# Command injection
grep -rn "exec\|spawn\|system\|shell_exec\|popen\|subprocess" \
  --include="*.py" --include="*.js" --include="*.ts" src/ | head -20
```

**What to check:**
- All database queries use parameterized statements or a safe ORM — never string interpolation
- User input is never passed to shell commands; if subprocess calls are necessary, arguments are passed as arrays, not shell strings
- Template engines are not rendering raw user input

**Red flags:**
```python
# SQL injection
query = f"SELECT * FROM users WHERE email = '{email}'"  # CRITICAL

# Command injection
subprocess.run(f"convert {filename} output.png", shell=True)  # CRITICAL
```

**Safe patterns:**
```python
# Parameterized SQL
cursor.execute("SELECT * FROM users WHERE email = %s", (email,))

# Safe subprocess — no shell=True, args as list
subprocess.run(["convert", filename, "output.png"])
```

### A04: Insecure Design

**What to check:**
- Rate limiting exists on authentication endpoints (login, password reset, OTP)
- Account lockout or progressive delay after repeated failures
- Password reset flows use short-lived, single-use tokens
- Email enumeration is prevented (same response for existing and non-existing accounts)
- Multi-step operations use server-side state, not client-supplied state to advance steps

```bash
grep -rn "rate.limit\|rateLimit\|throttle\|lockout" \
  --include="*.ts" --include="*.js" --include="*.py" src/ | head -20
```

### A05: Security Misconfiguration

```bash
# Check security headers
grep -rn "helmet\|Content-Security-Policy\|X-Frame-Options\|HSTS\|X-Content-Type" \
  --include="*.ts" --include="*.js" src/ | head -20

# Check CORS configuration
grep -rn "cors\|origin\|Access-Control" \
  --include="*.ts" --include="*.js" --include="*.py" src/ | head -20

# Check debug or development flags in production config
grep -rn "DEBUG\s*=\s*True\|NODE_ENV.*development\|debug.*true" \
  --include="*.py" --include="*.json" --include="*.env" . | head -20
```

**What to check:**
- Security headers are set: `Content-Security-Policy`, `X-Frame-Options`, `X-Content-Type-Options`, `Strict-Transport-Security`
- CORS `origin` is not `*` for authenticated APIs
- Error responses do not expose stack traces, file paths, or library versions
- Debug mode is disabled in production configuration
- Unused ports and services are not exposed

### A06: Vulnerable and Outdated Components

```bash
# Node.js dependency audit
npm audit --audit-level=high

# Python
pip-audit
safety check

# Check for significantly outdated dependencies
npm outdated
pip list --outdated
```

**What to check:**
- No dependencies with known critical or high CVEs
- Core framework and runtime versions are within supported range
- Security patches are applied promptly (SLA: critical < 24h, high < 7 days)

### A07: Authentication Failures

```bash
grep -rn "jwt\|token\|session\|cookie\|bearer\|auth" \
  --include="*.ts" --include="*.js" --include="*.py" src/ | head -30
```

**What to check:**
- JWT tokens have expiry (`exp` claim)
- JWT secrets are environment-specific and sufficiently random (minimum 256 bits)
- JWT algorithm is explicitly validated — reject `alg: none`
- Session tokens are invalidated on logout
- Passwords meet minimum length; brute-force protection exists
- Sensitive cookies have `HttpOnly`, `Secure`, and `SameSite=Strict` or `Lax`

**Red flags:**
```javascript
// No expiry on JWT
jwt.sign({ userId: user.id }, secret);  // missing { expiresIn: '1h' }

// Algorithm confusion — allows alg:none
jwt.verify(token, secret);  // should be jwt.verify(token, secret, { algorithms: ['HS256'] })

// Missing cookie security attributes
res.cookie('session', token);  // should include httpOnly: true, secure: true, sameSite: 'strict'
```

### A08: Software and Data Integrity Failures

**What to check:**
- CI/CD pipeline does not allow unsigned or unreviewed code to deploy to production
- Package integrity is verified (`package-lock.json` committed, lockfile is used in CI with `npm ci`)
- Third-party scripts loaded in the frontend have subresource integrity (SRI) hashes
- Deserialization of user-supplied data is not done without schema validation

### A09: Security Logging and Monitoring Failures

```bash
grep -rn "logger\.\|log\.\|console\." --include="*.ts" --include="*.js" --include="*.py" src/ | head -20
```

**What to check:**
- Authentication events (login success, failure, logout) are logged with user ID and IP
- Access to sensitive resources is logged
- Log entries include timestamp, user, action, resource, and outcome
- Logs do not contain passwords, tokens, or PII
- Alerting exists for anomalous patterns (multiple failures, unusual access volume)

### A10: Server-Side Request Forgery (SSRF)

```bash
grep -rn "fetch\|axios\|http.get\|requests.get\|urllib\|curl" \
  --include="*.ts" --include="*.js" --include="*.py" src/ | head -20
```

**What to check:**
- URLs constructed from user input are validated against an allowlist before the request is made
- Internal network ranges (169.254.x.x, 10.x, 172.16–31.x, 192.168.x) are blocked for externally-triggered requests
- Cloud metadata endpoints (169.254.169.254) are blocked

## Secret Detection

```bash
# Search for hardcoded secrets
grep -rn \
  "password\s*=\s*['\"][^'\"]\|api_key\s*=\s*['\"][^'\"]\|secret\s*=\s*['\"][^'\"]" \
  --include="*.py" --include="*.js" --include="*.ts" src/ | grep -v test | head -20

# AWS keys
grep -rn "AKIA[0-9A-Z]\{16\}" src/ | head -10

# Private key headers
grep -rn "BEGIN.*PRIVATE KEY\|BEGIN RSA" src/ | head -10

# Generic token patterns
grep -rn "ghp_\|gho_\|glpat-\|xoxb-\|sk-" src/ | head -10
```

## Dependency Audit

```bash
# Node.js
npm audit --json | python3 -c "
import json, sys
data = json.load(sys.stdin)
vulns = data.get('vulnerabilities', {})
for name, info in vulns.items():
    sev = info.get('severity', 'unknown')
    if sev in ('critical', 'high'):
        print(f'{sev.upper()}: {name}')
"

# Python
pip-audit --format=json 2>/dev/null | python3 -c "
import json, sys
data = json.load(sys.stdin)
for v in data.get('vulnerabilities', []):
    print(f\"{v.get('id')}: {v.get('package')} {v.get('installed_version')}\")
"
```

## Audit Report Format

```
## Security Audit: {scope}

### Critical Findings
None / or:
- [CRITICAL] {title}
  File: {path}:{line}
  Evidence: {code snippet}
  Impact: {what an attacker can do}
  Remediation: {specific fix}

### High Findings
- [HIGH] {title}
  ...

### Medium Findings
- [MEDIUM] {title}
  ...

### Low / Informational
- [LOW] {title}
  ...

### Dependency Vulnerabilities
| Package | Version | CVE | Severity | Fix Version |
|---|---|---|---|---|

### Positive Observations
- {what is implemented correctly}
```

## Never Do

- Modify code during an audit — report and recommend only
- Mark a finding as low severity to avoid uncomfortable conversations
- Dismiss a theoretical vulnerability without verifying whether the precondition can be met
- Report a "credentials in code" finding without redacting the actual secret from the report
- Skip checking for IDOR just because the application uses UUIDs instead of sequential integers
- Assume a dependency vulnerability is unexploitable without confirming the code path is unreachable
