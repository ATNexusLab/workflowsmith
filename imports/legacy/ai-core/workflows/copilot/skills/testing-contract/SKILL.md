---
name: testing-contract
description: Three-axis test contract (Behavior, Security, Performance) with full OWASP coverage tables, threat modeling, authorization matrix, and performance budgets. Load when writing or reviewing tests for any feature.
user-invocable: true
disable-model-invocation: false
license: MIT
triggers:
  - "write tests for a feature"
  - "review test coverage or security tests"
  - "threat model a feature or endpoint"
  - "OWASP test checklist"
  - "authorization matrix, N+1 test, or performance budget"
---

## Test Contract — Three Mandatory Axes

Every implemented feature is born with coverage across the **three axes**. Missing any one of them means the feature is not done.

### Threat Modeling — Mandatory BEFORE implementing

Before writing code, **explicitly enumerate the touched surfaces** and map each one to the cases in the Axis 2 table. Mandatory output, even if brief:

```
Threat surfaces:
- [authenticated endpoint] POST /api/x → tests: anon, cross-user, expired-token, mass-assign
- [user input] body.name → tests: SQLi, XSS, length, unicode
- [secrets] uses OPENAI_API_KEY → tests: not logged, not returned in errors
- [n/a] ...
```

If a surface exists and is declared `n/a`, **the justification is mandatory**. Without a recorded threat model, the feature does not proceed to implementation.

### Axis 1 — Behavior
Happy path + edge values + expected errors + idempotency when applicable + concurrency (when there is shared state).

### Axis 2 — Security (full coverage per surface)

The rule is: **every surface touched in the change gets the mandatory cases for its row**. No exceptions. A missing case = feature not done.

#### A. Auth & Session

| Surface | Mandatory cases |
|---|---|
| Authenticated endpoint | anonymous → 401; valid user on another user's resource → 403 (**IDOR**); expired token → 401; forged/invalid-signature token → 401; token from another tenant → 403 |
| Endpoint with role | insufficient role → 403; **privilege escalation** via body/header → blocked; role downgrade only by the admin themselves |
| Login / signup | brute force → rate limit; user enumeration (same message for "user not found" vs "wrong password"); weak password rejected; **timing-safe compare** on secrets |
| Password hash | approved algorithm (argon2/bcrypt/scrypt) — **never** plain MD5/SHA1/SHA256; unique salt per hash |
| Session / token | effective expiration; rotation on login; invalidation on logout; refresh token rotation (one-time-use); cookie with `HttpOnly` + `Secure` + `SameSite=Lax\|Strict` |
| Password reset | single-use token; expires ≤ 1h; invalidates active sessions; does not reveal whether user exists |
| MFA (if present) | bypass via alternative flow blocked; TOTP code accepts ±1 step window only |

#### B. Input & Output

| Surface | Mandatory cases |
|---|---|
| User input (any) | **schema validation** rejects extras (mass assignment); maximum length; correct type; **unicode/emoji/null byte** safe |
| String → SQL | SQLi payloads (`' OR 1=1`, stacked queries, comment); parameterized query confirmed |
| String → NoSQL | embedded operators (`{$ne: null}`, `{$gt: ""}`) rejected |
| String → shell/exec | meta-chars (`;`, `|`, `` ` ``, `$()`) rejected; **never** `shell: true` with external input |
| String → render HTML | XSS reflected/stored; payload in attributes, in href (`javascript:`), in SVG |
| String → template engine | **SSTI** (`{{7*7}}`, `${...}`) — engine in safe mode |
| String → XML | **XXE** disabled; entity expansion limited |
| String → URL fetch (server) | **SSRF** — block `localhost`, `169.254.x`, `10.x`, `192.168.x`, `file://`, `gopher://`; resolve DNS first |
| String → redirect | **open redirect** — only allowlisted URLs or relative paths |
| Deserialization | never from untrusted input; use safe format (JSON, not pickle/yaml.load) |
| Output (response/log) | **secrets never appear** in logs, errors, traces, response bodies; PII redacted where applicable |
| Error handling | never leaks stack trace, SQL query, server path, or lib version in production |

#### C. Mutation & State

| Surface | Mandatory cases |
|---|---|
| POST/PUT/PATCH/DELETE | **CSRF** — token validated OR SameSite cookie + Origin check |
| Mutation with sensitive fields | mass assignment blocked (explicit whitelist); ownership validated server-side |
| Concurrent operation on the same resource | **race condition / TOCTOU** — optimistic (version) or pessimistic lock; double-spend impossible |
| Declared idempotent operation | retry with same idempotency-key does not duplicate the effect |
| Soft-delete / restore | deleted user cannot operate; orphaned resources cleaned up |

#### D. Upload & Files

| Surface | Mandatory cases |
|---|---|
| File upload | real MIME validated (magic bytes, not just extension); maximum size; **path traversal** (`../`, null byte, unicode); sanitized name |
| Image | maximum dimensions; image bombs (decompression bomb) rejected; EXIF metadata stripped if sensitive |
| Download/serving | only serves files from an allowlisted directory; never concatenates path with raw input |

#### E. API & Network

| Surface | Mandatory cases |
|---|---|
| Public API | specific CORS allowlist (not `*` with credentials); rate limit per IP + per user; **security headers** (CSP, HSTS, X-Frame-Options, X-Content-Type-Options, Referrer-Policy) |
| Incoming webhook | **signature verification** (HMAC) with timing-safe compare; replay protection (timestamp + nonce or idempotency) |
| Outgoing webhook | retry with backoff; signature in payload |
| GraphQL | depth limit; complexity limit; introspection disabled in prod; field-level authz |
| WebSocket | auth on handshake **and** validated per message; Origin check |
| Cache | key includes user identity (no **cache poisoning** cross-user); correct cache headers |

#### F. Crypto & Secrets

| Surface | Mandatory cases |
|---|---|
| Token/ID/secret generation | **CSPRNG** (`crypto.randomBytes`, `crypto.randomUUID`, `secrets` in Python, `rand` in Rust); never `Math.random()` or `random.random()` |
| Encryption | approved algorithm (AES-GCM, ChaCha20-Poly1305); unique IV per message; never ECB |
| Secret comparison | **timing-safe** (`crypto.timingSafeEqual`, `hmac.compare_digest`, `subtle::ConstantTimeEq`); never `===` or `==` |
| Keys/secrets | only in env vars / secret manager; never committed; rotatable |

#### G. Dependency & Build

| Surface | Mandatory cases |
|---|---|
| Touched manifest (`package.json`, `pyproject.toml`, `Cargo.toml`) | `npm audit` / `pip-audit` / `cargo audit` with no high/critical; lockfile committed |
| New library | version pinned; trusted origin (no typosquatting); compatible license |

#### Authorization Matrix — mandatory on every protected endpoint

`{anonymous, regular user, resource owner, admin} × {GET, POST, PUT, DELETE}` in `test/integration/authz/{resource}.test.{ext}`. Each cell is an explicit test.

#### Fixtures
Versioned attack payloads in `test/fixtures/security/` (sqli.json, xss.json, ssrf.json, traversal.json, etc.) — reused by all tests.

### Axis 3 — Performance

| Path | Assertion type |
|---|---|
| Critical feature (auth, checkout, main flow) | **Fixed numeric budget** — p95, query count, payload size. Fails if exceeded. |
| All other features | **Regression** vs baseline in `test/perf/baseline.json` — must not degrade > X% |
| Endpoints with lists | **N+1 absent** — query count with `n=1, 10, 100`; linear growth = bug |
| Frontend | LCP, INP, CLS, bundle size with budget in Lighthouse CI |

Budgets versioned in `test/perf/budgets.json`. Changing them requires an explicit justification in the commit.

> **Philosophy:** tests are the **contract** that prevents code from having security or performance bugs. Writing the test first costs far less than fixing production later. Fix-first is regression.
