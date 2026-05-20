---
name: web-research
description: Use to find official documentation, validate technical information against primary sources, and compare versions, APIs, or technologies with evidence.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
  - fetch
---

# Web Research

## When to Use

- Verify a version, API signature, or configuration option against the official documentation
- Find breaking changes between two versions of a dependency
- Compare two technologies or libraries with current, accurate data
- Validate that a proposed solution is still recommended practice (not deprecated)
- Find the canonical source for a security advisory or CVE

## Core Principles

1. **Primary sources only** — official documentation, official repositories, and authoritative specifications take precedence over blog posts, Stack Overflow, and tutorials
2. **Date-aware** — technology changes; verify that the source is current for the version being used
3. **One claim, one source** — do not state a technical fact without a verifiable reference
4. **Distinguish behavior from recommendation** — document what is true now, flag what is deprecated, and note what the migration path is

## Source Hierarchy

| Tier | Examples | Trust level |
|---|---|---|
| **Tier 1 — Primary** | Official docs, official GitHub repo, RFC, specification, CVE database | Highest |
| **Tier 2 — Authoritative** | Official changelogs, official release notes, official migration guides | High |
| **Tier 3 — Secondary** | Well-known platform docs (MDN, AWS docs), official blog posts | Medium |
| **Tier 4 — Community** | Stack Overflow, tutorials, blog posts, GitHub Issues | Use only to find the Tier 1 source; do not cite directly |

## Research Protocol

### Step 1: Identify what needs to be verified

Classify the question:
- **Version/API**: Does this API exist in version X? What are its parameters?
- **Breaking change**: What changed between version X and version Y?
- **Best practice**: Is this approach still recommended?
- **Security**: Is this dependency vulnerable? What is the CVE?
- **Comparison**: How do these two technologies differ on dimension Z?

### Step 2: Find the primary source

```
Version/API questions:
  → Official documentation site
  → GitHub repository README or docs/ directory
  → NPM / PyPI / crates.io package page (links to the official source)

Breaking change questions:
  → Official CHANGELOG.md in the repository
  → Official migration guide
  → GitHub Releases page

Security questions:
  → CVE database: https://nvd.nist.gov/vuln/search
  → GitHub Advisory Database: https://github.com/advisories
  → Snyk Vulnerability Database: https://security.snyk.io

Comparison questions:
  → Official documentation for each technology
  → Benchmarks from the project maintainers, not third-party blogs
```

### Step 3: Verify currency

Before citing a source, confirm:
- Is this documentation for the version being used?
- When was this page last updated?
- Does this reflect the current release, not a pre-release or archived version?

### Step 4: Cite the source

Every technical claim from research must include:
- The URL of the primary source
- The version it applies to
- The date retrieved (if the content may change)

## Fetch Usage Pattern

```
# Fetch official documentation
fetch("https://docs.example.com/api/v2/authentication")

# Fetch a CHANGELOG
fetch("https://raw.githubusercontent.com/org/repo/main/CHANGELOG.md")

# Fetch CVE details
fetch("https://nvd.nist.gov/vuln/detail/CVE-2023-XXXXX")
```

After fetching:
1. Locate the specific section that answers the question
2. Quote the relevant passage
3. Provide the URL
4. Note the version and date if relevant

## Common Research Tasks

### Verifying a Dependency Version

```bash
# Check current installed version
npm list {package-name}
pip show {package-name}
go list -m all | grep {package}

# Check latest available version
npm view {package-name} version
pip index versions {package-name}
```

Then fetch the official changelog or release notes for the specific version.

### Finding Breaking Changes

Protocol:
1. Identify the repository URL (from `npm view {pkg} repository.url` or the package homepage)
2. Fetch `CHANGELOG.md` or the GitHub Releases page
3. Locate the section for the target version
4. Extract breaking changes, deprecated APIs, and migration instructions

### Security Vulnerability Research

```
1. Fetch: https://github.com/advisories?query={package-name}
2. Fetch: https://nvd.nist.gov/vuln/search/results?query={package-name}
3. Record: CVE ID, severity (CVSS score), affected versions, patched version
4. Verify: does the current project use an affected version?
```

Report format for a security finding:
```
CVE-YYYY-NNNNN
Package: {name}
Affected versions: < {patched version}
Severity: {Critical/High/Medium/Low} (CVSS {score})
Description: {one sentence}
Fix: upgrade to {version}
Source: {URL}
```

### Technology Comparison

Structure the comparison around dimensions that matter for the decision:

```markdown
## Comparison: {Technology A} vs {Technology B}

Decision context: {what is being chosen and why it matters}

| Dimension | {Technology A} | {Technology B} | Source |
|---|---|---|---|
| License | {license} | {license} | {official source URL} |
| Latest stable version | {version} | {version} | {URL} |
| Performance | {benchmark or claim} | {benchmark or claim} | {URL} |
| {Dimension} | {value} | {value} | {URL} |

### Summary

{Technology A} is preferred when: {conditions}
{Technology B} is preferred when: {conditions}

All claims sourced from official documentation accessed on {date}.
```

## Handling Conflicting Information

When official sources conflict with community sources:
- Follow the official documentation
- Note the conflict explicitly: "The official documentation states X; some community sources suggest Y, but official docs are authoritative here"

When official sources are ambiguous:
- Fetch the source code for the specific version
- Check the GitHub Issues or Discussions for clarification from maintainers
- Report the ambiguity rather than guessing

When information is unavailable:
- State that you searched and did not find a definitive source
- Describe what was searched
- Do not fabricate a citation

## Research Output Format

After completing research, report in this structure:

```markdown
## Research: {Question}

**Verdict:** {direct answer in one sentence}

**Evidence:**

> {Direct quote from primary source}
> Source: {URL} (version {X}, retrieved {date})

**Additional context:**
{Relevant notes, caveats, migration requirements, or related information}

**Deprecated/changed behavior:**
{If applicable: what the old behavior was, what it is now, migration path}
```

## Never Do

- State a technical fact without a primary source
- Cite a blog post or Stack Overflow answer as authoritative
- Use documentation for a different version than the one being used
- Fabricate a URL or a quote — if you cannot verify it, say so
- Present a deprecated API as current without noting the deprecation and its replacement
- Cite community speculation from GitHub Issues as official behavior
