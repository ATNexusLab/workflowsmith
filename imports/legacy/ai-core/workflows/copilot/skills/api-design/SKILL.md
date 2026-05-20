---
name: api-design
description: Use to design or review REST, GraphQL, and gRPC APIs, including contracts, versioning, pagination, errors, rate limiting, and API documentation.
user-invocable: true
disable-model-invocation: false
triggers:
  - "design a new REST, GraphQL, or gRPC API"
  - "review an existing API for versioning, pagination, or error handling"
  - "define API contracts or produce OpenAPI / protobuf documentation"
license: MIT
---

# API Design

## When to Use

- Design a new API surface for external or internal consumers
- Review an existing API for clarity, consistency, and evolvability
- Define request/response conventions, errors, pagination, and versioning
- Document contracts with OpenAPI, GraphQL schema descriptions, or protobuf comments

## Core Principles

1. **Contract first** — define the contract before implementation details
2. **Consistency** — similar operations should look and behave the same
3. **Predictability** — consumers should infer new endpoints from existing patterns
4. **Compatibility** — design for safe evolution without breaking clients
5. **Explicit trade-offs** — choose REST, GraphQL, or gRPC based on access patterns and constraints

## REST Design Patterns

### Resource Naming

```http
# Plural nouns, kebab-case
GET    /users
GET    /users/{id}
POST   /users
PUT    /users/{id}
PATCH  /users/{id}
DELETE /users/{id}

# Sub-resources
GET    /users/{id}/orders
POST   /users/{id}/orders

# Actions when CRUD is not enough
POST   /orders/{id}/cancel
POST   /users/{id}/reset-password
```

**Rules:**
- Resources are **nouns**, not verbs (`/users`, not `/getUsers`)
- Use plural collections and singular item identifiers
- Keep nesting shallow; beyond 2-3 levels, switch to direct identifiers
- Put identifiers in the path and filters in the query string

### Status Codes

| Code | Use When |
|---|---|
| `200 OK` | Successful read or update with response body |
| `201 Created` | Resource created; include `Location` when useful |
| `202 Accepted` | Asynchronous work accepted but not finished |
| `204 No Content` | Successful operation with no response body |
| `400 Bad Request` | Malformed request or invalid syntax |
| `401 Unauthorized` | Missing or invalid authentication |
| `403 Forbidden` | Authenticated but not allowed |
| `404 Not Found` | Resource does not exist |
| `409 Conflict` | State conflict, duplicate, or stale version |
| `422 Unprocessable Entity` | Syntactically valid but semantically invalid |
| `429 Too Many Requests` | Rate limit exceeded |
| `500 Internal Server Error` | Unexpected server-side failure |
| `503 Service Unavailable` | Temporary outage or dependency failure |

### Consistent Error Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format",
        "value": "not-an-email"
      }
    ],
    "request_id": "req_123"
  }
}
```

**Rules:**
- Return structured JSON for all errors
- `code` is machine-readable and stable
- `message` is human-readable and safe to expose
- `details` is optional and field-oriented for validation issues
- Never expose stack traces, raw SQL, or internal infrastructure details

### Pagination

**Cursor-based (preferred for large or mutable datasets):**

```json
{
  "data": [],
  "pagination": {
    "next_cursor": "eyJpZCI6MTAwfQ==",
    "has_more": true
  }
}
```

**Offset-based (simpler for small and stable datasets):**

```json
{
  "data": [],
  "pagination": {
    "page": 2,
    "per_page": 20,
    "total": 150,
    "total_pages": 8
  }
}
```

**Rules:**
- Choose a sensible default page size
- Enforce a hard maximum page size
- Prefer cursor pagination when `OFFSET` becomes expensive or ordering must stay stable during writes

### Filtering, Sorting, and Sparse Fields

```http
GET /users?status=active&role=admin
GET /users?sort=created_at&order=desc
GET /users?q=john
GET /users?fields=id,name,email
```

**Rules:**
- Keep query semantics explicit and documented
- Reject ambiguous or unsupported filter combinations
- Validate sort fields against an allowlist

### Versioning

| Strategy | Example | Best Fit |
|---|---|---|
| URL path | `/v1/users` | Public APIs and explicit deprecation windows |
| Header | `Accept: application/vnd.example+json;version=2` | Internal APIs or cleaner URLs |
| Query parameter | `/users?version=2` | Transitional or debugging-only cases |

**Practical rule:** prefer path versioning for public APIs and header versioning for controlled internal consumers.

### Rate Limiting

Recommended response headers:

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1620000000
Retry-After: 30
```

Rate limits should be scoped intentionally:
- per user for authenticated traffic
- per IP or client credential for anonymous traffic
- stricter on login, signup, password reset, and expensive search endpoints

### Idempotency

- `GET`, `PUT`, and `DELETE` should remain idempotent by contract
- `POST` is not inherently idempotent; add `Idempotency-Key` for payments, provisioning, and any retry-prone mutation
- Store the result of the first successful execution and replay it for duplicate keys inside the retention window

## GraphQL Design Patterns

### Schema Design

```graphql
type User {
  id: ID!
  name: String!
  email: String!
  orders(first: Int, after: String): OrderConnection!
}

type OrderConnection {
  edges: [OrderEdge!]!
  pageInfo: PageInfo!
}
```

**Rules:**
- Use connections for list pagination
- Reserve non-null (`!`) for fields that are truly guaranteed
- Make mutation payloads explicit and typed
- Keep business errors in the payload shape when clients must handle them deterministically

### Operational Guidance

- Enforce depth and complexity limits
- Use batching and caching (for example, DataLoader) to avoid N+1 queries
- Add field descriptions to the schema
- Separate public schema concerns from internal resolver implementation details
- Deprecate fields with explicit replacement guidance before removal

## gRPC Design Patterns

### Protobuf Structure

```proto
syntax = "proto3";

package billing.v1;

service InvoiceService {
  rpc GetInvoice(GetInvoiceRequest) returns (Invoice);
  rpc ListInvoices(ListInvoicesRequest) returns (ListInvoicesResponse);
  rpc CreateInvoice(CreateInvoiceRequest) returns (CreateInvoiceResponse);
}

message GetInvoiceRequest {
  string invoice_id = 1;
}

message Invoice {
  string id = 1;
  string customer_id = 2;
  int64 amount_cents = 3;
}
```

**Rules:**
- Version the package namespace (`billing.v1`) instead of renaming every RPC
- Keep service names domain-oriented and RPC names verb-oriented
- Use explicit request and response messages, even for single-field calls
- Reserve removed field numbers and names to prevent accidental reuse

### Compatibility and Evolution

- Never renumber existing fields
- Add new fields with new numbers and safe defaults
- Mark removed fields as `reserved`
- Prefer additive changes; breaking proto changes require a new versioned package
- Document consumer migration windows before retiring an older service version

### RPC Semantics

| RPC Type | Use When |
|---|---|
| Unary | Request/response operations with bounded payloads |
| Server streaming | Large result sets or live feeds from server to client |
| Client streaming | Incremental uploads or event ingestion |
| Bidirectional streaming | Interactive low-latency exchange |

**Rules:**
- Use unary by default; choose streaming only when it materially improves throughput or latency
- Define deadlines for every call path
- Classify retries by idempotency; do not retry non-idempotent mutations blindly
- Propagate auth and correlation metadata consistently

### Error Handling

- Map failures to canonical gRPC status codes (`INVALID_ARGUMENT`, `NOT_FOUND`, `FAILED_PRECONDITION`, `PERMISSION_DENIED`, `UNAVAILABLE`)
- Include structured error details when clients must branch on failure type
- Keep internal exception messages out of the public contract

## Documentation

Every API surface should stay documented:

- **REST:** OpenAPI kept near the implementation
- **GraphQL:** schema descriptions plus examples for key operations
- **gRPC:** protobuf comments, service ownership, deadlines, retry expectations, and compatibility notes

Minimum documentation for each operation:
- purpose and ownership
- request parameters and validation rules
- success and failure responses
- authentication and authorization requirements
- example request/response or example RPC usage
- versioning or deprecation notes when applicable

## Design Checklist

- [ ] Naming is consistent across resources, fields, and operations
- [ ] Status codes or gRPC status mappings are intentional and documented
- [ ] Error format is stable and safe to expose
- [ ] Pagination exists for list operations
- [ ] Authentication and authorization rules are defined
- [ ] Rate limits, deadlines, or retry behavior are explicit where relevant
- [ ] Versioning and deprecation strategy are planned
- [ ] Documentation artifacts are updated (OpenAPI, schema docs, or protobuf comments)

## Steps

### 1. Understand the use cases

Before choosing a style or shape:
- What operations does the consumer need?
- What data volume and latency profile matter?
- Who owns the contract and how many clients will depend on it?

### 2. Choose the API style deliberately

- **REST**: resource-oriented workflows, broad HTTP compatibility, public APIs
- **GraphQL**: flexible reads, multiple frontends with varying data needs
- **gRPC**: service-to-service calls, strict schemas, low-latency internal contracts, streaming use cases

### 3. Model the contract

- REST: resources, methods, request bodies, filters, and status codes
- GraphQL: types, connections, mutations, and resolver boundaries
- gRPC: services, request/response messages, status mapping, metadata, and deadlines

### 4. Define validation and error semantics

- Input schemas must be explicit
- Required versus optional fields must be documented
- Failure modes must be stable enough for clients to automate against

### 5. Document examples

- REST: example HTTP requests and responses
- GraphQL: example queries and mutations
- gRPC: example proto definitions and client call expectations

### 6. Validate with the checklist

Complete the `## Design Checklist` before treating the contract as ready.

## Examples

### REST Example

```http
POST /api/v1/orders
Content-Type: application/json
Authorization: Bearer {token}

{
  "user_id": "usr_123",
  "items": [
    { "product_id": "prod_456", "quantity": 2 }
  ]
}
```

```json
{
  "data": {
    "id": "ord_789",
    "status": "pending",
    "total": 99.9,
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### gRPC Example

```proto
message CreateOrderRequest {
  string user_id = 1;
  repeated OrderItem items = 2;
  string idempotency_key = 3;
}

message CreateOrderResponse {
  Order order = 1;
}
```
