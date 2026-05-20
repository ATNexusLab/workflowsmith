---
name: growth-marketing
description: Use to improve conversion in a site or app, structure funnels, write benefit-led copy, and audit landing pages or products through a growth lens.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
---

# Growth Marketing

## When to Use

- Audit a landing page, onboarding flow, or product feature for conversion
- Write or rewrite benefit-led copy for CTAs, headlines, or feature descriptions
- Identify and prioritize drop-off points in a user funnel
- Define growth experiments and success metrics
- Evaluate product-led growth loops or referral mechanics
- Assess positioning against alternatives

## Core Principles

1. **Clarity beats cleverness** — users act when they understand what they get and why it matters
2. **Specificity converts** — "save 4 hours a week" outperforms "save time"
3. **Benefits over features** — lead with the outcome the user experiences, not the mechanism
4. **Friction is the enemy of activation** — every unnecessary step is a reason to leave
5. **Measure before optimizing** — hypotheses without baseline metrics produce noise

## Funnel Framework

### AARRR (Pirate Metrics)

```
Acquisition  — How do users find the product?
Activation   — Do users experience the core value quickly?
Retention    — Do users return?
Revenue      — Do users pay or expand?
Referral     — Do users bring others?
```

**How to apply:**
1. Map the current funnel against each stage
2. Identify which stage has the largest drop-off
3. Prioritize experiments at the stage with the highest leverage
4. Do not optimize acquisition when activation is broken — filling a leaky bucket

### Activation: The Critical Path

Activation is the moment a user experiences the core value for the first time. It is the highest-leverage metric for early-stage products.

**How to identify the activation event:**
- Find the action that most strongly correlates with long-term retention
- Common examples: first successful API call, first completed project, first successful collaboration, first value-delivering export

**Audit questions:**
- How long does it take from signup to the activation event?
- What is the completion rate between signup and activation?
- What is the first point of friction (where do users leave first)?
- Is the activation event obvious to the user, or does it happen invisibly?

## Landing Page Audit

### Headline Evaluation

**Weak headline patterns:**
```
"The future of [category]"          — vague, every competitor says this
"The all-in-one [tool] platform"    — generic, no differentiated claim
"Work smarter, not harder"          — cliché, no specificity
"Welcome to [Product Name]"         — describes nothing, missed opportunity
```

**Strong headline patterns:**
```
Specific outcome:  "Deploy in 3 minutes. Rollback in 1."
Clear differentiator: "The only [tool] that [specific capability]"
Quantified benefit: "Cut your CI pipeline from 12 minutes to 90 seconds"
Problem-led: "Stop losing [specific thing] to [specific cause]"
```

**Headline audit checklist:**
- [ ] Does it communicate what the product does in one reading?
- [ ] Does it state a concrete benefit or outcome?
- [ ] Would a competitor be able to use the same headline? (If yes, it is generic)
- [ ] Is it specific enough to be falsifiable?

### Above-the-Fold Audit

Every landing page must answer five questions within the first viewport:

1. **What is this?** — Product category and primary use case
2. **Who is it for?** — Target audience or job title signal
3. **What do I get?** — Concrete outcome or primary benefit
4. **Why this and not alternatives?** — Differentiating claim
5. **What should I do now?** — Single, clear CTA

**Above-the-fold checklist:**
- [ ] Five questions answered without scrolling
- [ ] One primary CTA (not two or three equally weighted options)
- [ ] CTA text describes the action and outcome ("Start free" beats "Submit")
- [ ] Social proof signal visible (logos, review badge, user count)
- [ ] Page loads in under 3 seconds on mobile

### CTA Copy Patterns

**Weak CTAs:**
```
Learn more
Get started
Submit
Sign up
Click here
```

**Strong CTAs:**
```
Start your free trial — no credit card required
See [Product] in action (2-min demo)
Get my free [specific outcome]
Add to your [tool] in 60 seconds
Start building — free forever
```

**CTA formula:** verb + specific outcome + friction reducer

### Social Proof Hierarchy

Ranked by conversion impact:

1. **Case studies with specific metrics** — "Acme reduced deployment time by 73%"
2. **Named customer logos (recognizable brands)**
3. **Review platform badges** (G2, Capterra, Product Hunt) with score
4. **Testimonials with name, title, company, and photo**
5. **User/customer count** — "Trusted by 10,000+ developers"
6. **Anonymous testimonials** — lowest credibility; use only if nothing else exists

### Objection Handling

Map the primary objections for the target audience and address them explicitly:

| Objection | On-page response |
|---|---|
| "Is this secure?" | SOC 2 badge, encryption callout, data handling FAQ |
| "How long does setup take?" | "Up and running in 10 minutes" with setup steps |
| "Will this work with my stack?" | Explicit integration list or compatibility table |
| "What if I want to cancel?" | "No contracts, cancel any time" with no-friction wording |
| "Can I trust this company?" | Press mentions, founding story, team page |

## Copy Frameworks

### PAS (Problem — Agitate — Solution)

Use for email, ad copy, and hero sections targeting users who are aware of the problem:

```
Problem:   "Managing environment variables across 12 services is error-prone and slow."
Agitate:   "One wrong value in staging can cascade into a production incident at 2am."
Solution:  "[Product] syncs secrets across all your services automatically, with audit logs for every change."
```

### BAB (Before — After — Bridge)

Use for feature pages and case studies:

```
Before:   "Deployments took 45 minutes and required three people to coordinate."
After:    "Now the team ships in 8 minutes, fully automated, with zero manual steps."
Bridge:   "[Product] handles environment config, secret injection, and rollback automatically."
```

### Feature-to-Benefit Translation

Always translate features into user outcomes:

| Feature | Benefit |
|---|---|
| "Automatic retries" | "Your jobs finish even when upstream services blip" |
| "Real-time collaboration" | "No more merge conflicts from working in the same file" |
| "One-click rollback" | "Undo any deployment in under 30 seconds" |
| "Role-based permissions" | "Contractors see only what they need — nothing more" |
| "99.99% uptime SLA" | "Your customers never see a maintenance page during business hours" |

## Growth Experiment Design

### Hypothesis Format

```
We believe that [change]
will result in [measurable outcome]
for [specific user segment]
because [reason based on evidence or observation].
```

**Example:**
```
We believe that adding a social proof section with customer logos above the CTA
will increase trial signup conversion by 10–20%
for first-time visitors from organic search
because these users have no prior brand awareness and require trust signals before acting.
```

### Experiment Checklist

- [ ] One variable changed per test
- [ ] Sample size calculated before starting (minimum detectable effect defined)
- [ ] Primary metric defined before starting
- [ ] Secondary guardrail metrics defined (avoid improving one metric by damaging another)
- [ ] Test runs to statistical significance (minimum 95% confidence)
- [ ] Winning variant is analyzed for the "why" before scaling

### Common Growth Levers

**Acquisition:**
- SEO: target long-tail keywords with clear buying intent, not generic informational queries
- Paid: CPL and CAC tracked by channel; kill channels where LTV/CAC < 3:1
- Content: bottom-of-funnel content (comparisons, alternatives, use-case guides) converts better than top-of-funnel awareness content

**Activation:**
- Reduce steps to the activation event
- Make the first run experience produce visible output within 60 seconds
- Send activation nudge emails within 24 hours of signup if activation event not reached
- Remove optional fields from signup forms

**Retention:**
- Identify the retention metric (weekly active, monthly active, return visits)
- Build habit-forming triggers tied to user value (not generic "come back" notifications)
- Measure D1, D7, D30 retention and segment by acquisition channel and activation status

**Revenue:**
- Shorten the path from activation to first paid action
- Test annual plan discounts for monthly users
- Track expansion revenue (seat additions, plan upgrades) separately from new revenue

## Audit Output Format

When auditing a page or funnel, structure findings as:

```
## Funnel Audit: [page or flow name]

### What is working
- [specific element] because [reason]

### Critical issues (fix first)
1. [issue] — [why it matters] — [recommended fix]

### Improvement opportunities
1. [opportunity] — [hypothesis] — [expected impact]

### Copy changes
Before: [current copy]
After:  [recommended copy]
Reason: [why the new version converts better]

### Metrics to set up
- [metric] — [tool] — [baseline target]
```

## Never Do

- Optimize a broken activation flow by driving more acquisition traffic
- Run an experiment without a pre-defined success metric
- Use superlatives without specifics ("best-in-class," "industry-leading," "world-class")
- Write CTAs that describe the action without describing the outcome ("Click here," "Submit")
- Add social proof that cannot be verified (attributed to "A happy customer" with no other detail)
- Stack multiple independent experiments on the same page simultaneously
- Declare a winner before reaching statistical significance
