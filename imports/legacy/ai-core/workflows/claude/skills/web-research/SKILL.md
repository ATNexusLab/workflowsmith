---
name: web-research
description: Use to find official documentation, validate technical information against primary sources, and compare versions, APIs, or technologies with evidence.
when_to_use: >
  Use when finding official documentation for a library or framework, validating technical information against a primary source, or comparing API versions and synthesizing multiple sources.
---

# Web Research

## When to Use

- Verify the correct behavior of an API for a specific version
- Find official documentation for a library, protocol, or standard
- Validate a technical practice with real evidence rather than sample code alone
- Compare technology options with objective data
- Check recent spec changes, deprecations, or breaking changes

## Source Hierarchy

Always search in the order below. Move down only if the higher source does not answer the question.

| Level | Type | Examples |
|-------|------|----------|
| 1 | Official maintainer documentation | docs.python.org, developer.mozilla.org, redis.io |
| 2 | Open specs and RFCs | RFC 9110, W3C specs, IETF drafts, OpenAPI spec |
| 3 | Official changelogs and release notes | GitHub releases, official `CHANGELOG.md` |
| 4 | Technical articles with verifiable authorship | engineering blogs (Stripe, Netflix, Cloudflare) |
| 5 | Stack Overflow | Only for diagnosing symptoms and error messages |
| 6 | Other GitHub repositories | For implementation examples, never as the source of truth |

> ⚠️ Third-party blog posts, tutorials, and README files are **not primary sources**. Verify them against official documentation.

## Query Framework

### Formulate before searching

Answer these questions before opening the browser:

1. **Exact question:** What do I need to know? Not "how to use X", but "what is X's behavior when Y happens?"
2. **Relevant version:** Which software, language, or protocol version applies?
3. **Information type:** Is this stable (spec) or version-sensitive (behavior)?
4. **Target site:** What is the official documentation site for this component?

### Efficient queries

```
# Search the official site
site:docs.rust-lang.org lifetime borrow checker

# Search for a specific version
python 3.11 asyncio.gather exception handling

# Search for a specific behavior
postgresql 16 JSONB index performance

# Search for a version change
react 18 concurrent mode breaking changes
```

## Steps

### 1. Identify the official source

For any technology:
- Find the official domain (`docs.x.com`, `x.io/docs`, `developer.x.com`)
- Check whether there is a centralized documentation landing page
- Confirm that the site belongs to the maintainer, not a tutorial or wrapper

### 2. Navigate the documentation

- Use the documentation index or native search
- Verify the documentation version when versioned docs exist
- Identify whether the behavior is stable or changed over time

### 3. Collect evidence

For each factual point, record:

```markdown
**Source:** [full URL]
**Documented version:** [for example, Python 3.11, Redis 7.2]
**Relevant excerpt:** "[literal documentation quote]"
**Context:** [what question this answers]
```

### 4. Evaluate credibility

Checklist for each source:

- [ ] Is it the official site for the maintainer or original author?
- [ ] Does the documented version match the version used in the project?
- [ ] Is the publication date relevant to the question?
- [ ] If it is a third-party article, does the author have verifiable expertise?
- [ ] Does it contradict official documentation? If yes, the official source wins.

### 5. Synthesize with traceability

Delivery structure:

```markdown
## Research Result: [original question]

### Direct answer
[Objective answer in 1-3 sentences]

### Evidence
**Source 1:** [URL]
> "[literal excerpt]"

**Source 2:** [URL]
> "[literal excerpt]"

### Limitations and uncertainty
- [What could not be confirmed]
- [Where sources disagree]
- [Behavior that may vary by version]

### Recommendation
[What to do based on the evidence]
```

## Source Evaluation — Red Flags

| Signal | Meaning |
|-------|---------|
| "I learned that..." without a link | No evidence — verify it |
| Blog tutorial with no date | May be outdated |
| README from an unofficial repo | May not match current behavior |
| "Everybody uses..." | Popularity is not correctness |
| Sample code with no version | Behavior may have changed |
| Only one source for a critical claim | Seek independent confirmation |

## Validation Checklist

- [ ] The original question is clearly formulated
- [ ] A level 1 or 2 source was checked when available
- [ ] The documentation version matches the version in use
- [ ] Every claim has a recorded source URL
- [ ] Uncertainty and limitations are documented
- [ ] The synthesis is separate from literal quotations
- [ ] The recommendation is evidence-based, not opinion-based

## Examples

### API behavior search

**Question:** Does `fetch` cancel the request when `AbortController` aborts?

```
Query: site:developer.mozilla.org AbortController fetch cancel request
Source: https://developer.mozilla.org/en-US/docs/Web/API/AbortController
Excerpt: "Calling AbortController.abort() causes the request to be aborted immediately."
```

### Version-change search

**Question:** Did `asyncio.gather` change exception behavior in Python 3.11?

```
Query: python 3.11 asyncio.gather exception propagation changelog
Source: https://docs.python.org/3/whatsnew/3.11.html
Source: https://docs.python.org/3/library/asyncio-task.html#asyncio.gather
```
