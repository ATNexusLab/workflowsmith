---
name: brand-identity
description: Use to define brand identity, visual positioning, and design-system foundations, including palette, typography, tokens, language, and anti-generic direction.
when_to_use: >
  Use when defining brand identity or visual direction, creating or updating a design system foundation, or running brand discovery for a new product.
---

# Brand Identity

## When to Use

- Define the visual and verbal identity of a new product
- Bring consistency to a product that grew without a system
- Create design-system foundations before frontend work starts
- Establish the base that will inform copy, marketing, and UX

## Discovery: 9 Dimensions

Never skip a dimension. If an answer is vague, ask again with concrete examples.

### 1. Product Truth

What the product actually does, in one sentence without jargon. What it delivers that no one else delivers in the same way. If there is no clear differentiator, that is a product problem, not a design problem — call it out before proceeding.

### 2. Audience

A concrete profile, not generic demographics. What this person values outside the product context. Which brands they already choose — that reveals the level of visual sophistication they expect.

### 3. Brand Values

- 3-5 adjectives that should be *felt* in the work
- 3 adjectives the product must never communicate
- One sentence the brand would never say

That final sentence usually reveals personality boundaries better than any adjective list.

### 4. Competitive Landscape

The visual cliches of the category are the project's anti-patterns. Map the dominant colors, common type choices, default UI patterns, and familiar claims. Those become explicit prohibitions.

### 5. Emotional Target

Not "impressed" or "comfortable." Use specific emotions: tension, familiarity, ambition, irreverence, quiet authority. The first-exposure emotion may differ from the long-term-use emotion. Both matter.

### 6. Reference World

Brands from any industry that resonate aesthetically. Physical products, editorial systems, digital products, cultural movements. Bauhaus, Swiss International Style, digital brutalism, Japanese editorial design, industrial interfaces — anything that expands the vocabulary beyond category defaults.

### 7. Anti-Inspiration

What the product must never look like. What would be the worst possible compliment about the design. Which brand association would be a disaster.

### 8. Platform and Constraints

Web, mobile, or both — and which one is primary. Whether dark mode is mandatory. Which legacy elements cannot move. Which accessibility requirements materially constrain the visual system.

### 9. Product Maturity

Brand-new system versus an existing product seeking coherence. Implementation timeline matters; it determines how ambitious the system can be right now.

---

## Output Template

Write the document in creative-director prose, not generic bullet-point filler. Each section needs a point of view.

````markdown
# [Project Name] — Brand Identity and Design System

---

## Brand Positioning

[One paragraph. What this brand is — and what it explicitly is not.
Write it as a declaration, not an aspiration. Present tense.
Example tone: "This is not a productivity product. It is a tool for people who have already decided they want to do serious work."]

---

## Brand Personality

Five traits. Each one includes a concrete behavioral implication — how that trait appears in visual and language decisions.

**[Trait 1]** — [What this means in practice. Example: "We do not explain the obvious. If a button requires tutorial copy to be understood, the button is wrong."]

**[Trait 2]** — [...]

**[Trait 3]** — [...]

**[Trait 4]** — [...]

**[Trait 5]** — [...]

---

## Tone of Voice

Three rules. Each rule includes one correct example and one wrong example.

**Rule 1: [Rule name]**
✅ "[On-brand copy example]"
❌ "[What sounds wrong for this brand]"

**Rule 2: [Rule name]**
✅ "[...]"
❌ "[...]"

**Rule 3: [Rule name]**
✅ "[...]"
❌ "[...]"

---

## Visual Language

[A narrative paragraph describing the visual world — references, aesthetic movement, cultural context.
Do not list. Describe. Write it the way a cinematographer would describe the visual language of a film before shooting begins.
Example tone: "The system lives in deliberate tension between technical precision and human warmth. The typography is dense and editorial — it does not invite, it demands attention. Color is restrained: one chromatic accent in a field of deep neutrals. No gradients. No decorative shadows. Light comes from the content, not from applied decoration."]

---

## Color System

[Opening paragraph describing the color logic — not the list of colors, but the principle governing the system.]

### [Color Name — for example "Obsidian"]
- **Hex:** #[value]
- **Token:** `--color-obsidian`
- **RGB / HSL:** [values]
- **Role:** [Surface base / Primary text / Accent / etc.]
- **Use for:** [specific use cases]
- **Never use for:** [specific prohibitions]

### [Color Name 2]
[same structure]

[repeat for every system color — minimum 3, maximum 7]

**Color-system rules:**
- [Rule 1 — for example "The accent never occupies more than 10% of the visible area on any screen"]
- [Rule 2 — for example "Surfaces do not use opacity — only named system colors"]
- [Rule 3]

---

## Typography System

[Opening paragraph: the logic behind the type system. Why these typefaces. How they relate. What they communicate beyond words.]

### [Typeface Name] — [Foundry]
- **Role:** Display / Body / Mono / Label
- **Weights used:** [only the weights that belong in the system]
- **Tracking:** [value in em — for example -0.02em for display, 0 for body]
- **Line height:** [value — for example 1.1 for headlines, 1.6 for body]
- **System sizes:** [scale — for example 12 / 14 / 16 / 20 / 24 / 32 / 48 / 64px]
- **Tokens:** `--font-display`, `--font-body`, etc.
- **Usage rule:** [what governs how this face is applied]

### [Typeface Name 2]
[same structure]

**Typography-system rules:**
- [Rule 1 — for example "Headlines are always weight 300 or 700. Nothing between those extremes."]
- [Rule 2 — for example "Body copy never uses Bold — Medium is the maximum."]
- [Rule 3]

---

## Spacing and Layout

**Base unit:** [value — for example 4px]
**Scale:** [sequence — for example 4 / 8 / 12 / 16 / 24 / 32 / 48 / 64 / 96 / 128]
**Grid:** [definition — for example 12 columns, 24px gutter, minimum 16px margin]
**Max width:** [value — for example 1280px]
**Tokens:** `--space-1` (4px) → `--space-32` (128px)

**Spacing principle:**
[One sentence about the philosophy of space in this system — for example "This system breathes. When in doubt, add space rather than remove it."]

---

## Component Principles

Five constraints that govern component decisions across the system.

1. **[Principle name]** — [Concrete meaning in practice]
2. **[Principle name]** — [...]
3. **[Principle name]** — [...]
4. **[Principle name]** — [...]
5. **[Principle name]** — [...]

---

## Marketing Foundation

*(This section feeds later copy, messaging, and conversion work.)*

### Positioning Statement
For [specific audience] who [situation/need], [product name] is [category] that [unique differentiator].

### Messaging Pillars

**Pillar 1: [Name]**
Headline territory: [what can be said here]
Unlocks in copy: [argument types, angles, proof points]

**Pillar 2: [Name]**
[same structure]

**Pillar 3: [Name]**
[same structure]

### Tagline Territory

**Direction A: [Name]**
Target emotion: [specific emotion]
Forbidden in this territory: [what would break coherence]

**Direction B: [Name]**
[same structure]

### Voice in Practice

Three copy transformations that show the brand voice in real situations.

**1. [Context — for example sign-up CTA]**
❌ "Create your free account and get started today"
✅ "[On-brand version]"

**2. [Context — for example error message]**
❌ "An unexpected error occurred. Try again."
✅ "[On-brand version]"

**3. [Context — for example landing-page headline]**
❌ "The complete platform for [category]"
✅ "[On-brand version]"

### Tone Boundaries for Marketing

What the brand voice never does in marketing materials:
- [Boundary 1 — for example "Never uses exclamation marks"]
- [Boundary 2 — for example "Never promises ease — the product requires effort, and that is part of the positioning"]
- [Boundary 3]
- [Boundary 4]

---

## Anti-Patterns

*(As important as the guidelines. Each item is a conscious decision, not an arbitrary restriction.)*

### Visual Anti-Patterns

- **[Anti-pattern 1]** — [Why this prohibition exists]
- **[Anti-pattern 2]** — [...]
- [continue for every anti-pattern identified during discovery]

Required visual anti-pattern examples (customize them to the project):
- Gradients outside the few cases explicitly defined in the system
- Decorative drop shadows; shadows are functional only
- `#000000` or `#FFFFFF` as surface or text values
- Rounded corners that ignore the system radius
- Any color outside the approved palette, even "just once"
- Generic icon-library aesthetics without visual adaptation

### Copy Anti-Patterns

- **[Anti-pattern 1]** — [for example "Using 'innovative' to describe any feature"]
- **[Anti-pattern 2]** — [...]
````

---

## Language Rules: No AI Face

This is the most important rule in the system. A brand-identity document must read like it was written by a human creative director, not by an assistant producing plausible filler.

### Forbidden Phrases

| ❌ Forbidden phrase | Why it fails |
|---|---|
| "a perfect balance between X and Y" | Hedge language. Design decisions are made, not balanced into vagueness. |
| "communicates trust and innovation" | Empty. Every brand wants that. |
| "clean and modern" | Meaningless without a specific reference. |
| "bold yet approachable" | Generic pitch-deck oxymoron. |
| "could consider", "maybe", "one option would be" | No hedging. Declare decisions. |
| "versatile" for any element | Versatile often means personality-free. |
| "aesthetic" without naming the aesthetic | There is no aesthetic without reference. |
| "minimalist" without saying what was removed | Minimalism is a consequence, not a style label. |
| "sophisticated" as a standalone descriptor | What exactly is sophisticated and why? |
| "premium" without defining what costs more or feels rarer | Premium in which dimension? |

### Correct Tone

**Declarative, not hypothetical:**
- ❌ "The primary color could be a deep blue that evokes trust"
- ✅ "The chromatic accent is #1B4FFF — a saturated indigo blue. Not navy. Not royal. Indigo. The distinction matters."

**Specific, not generic:**
- ❌ "The chosen typography communicates professionalism"
- ✅ "The -0.02em tracking on display sizes is intentional. It tightens the letters enough to feel editorial without drifting into wordmark territory."

**Technically reasoned, not personality-metaphor filler:**
- ❌ "We chose this typeface because it feels modern and accessible"
- ✅ "ABC Diatype Medium works because its humanist grotesk structure holds legibility at small sizes without losing the formality this category demands."

**Anti-patterns as detailed as patterns:**
- Every prohibition needs a reason.
- "Never use gradients" is not enough.
- "Gradients do not exist in this system. Depth comes from tonal value, not chromatic transition." is the correct level.

### Document Structure

- Do not use bullet lists to carry core reasoning — use prose
- Narrative sections such as Visual Language and Brand Positioning should be full paragraphs
- Lists are acceptable only where structure improves reference use, such as color tokens or type tokens
- The document should have a beginning, middle, and end — not feel like a dump of disconnected items

---

## Validation Checklist

Before delivery, confirm:

**Discovery**
- [ ] All 9 dimensions are captured with concrete answers
- [ ] Category cliches are mapped and converted into anti-patterns
- [ ] The product differentiator is explicit and reflected in the identity

**Color System**
- [ ] Every color has a proper name, not just "Primary" or "Secondary"
- [ ] No color is pure `#000000` or `#FFFFFF`
- [ ] Every color includes use cases and prohibitions
- [ ] CSS tokens are defined for all colors

**Typography System**
- [ ] No more than 3 type families in the system
- [ ] Every weight in use is justified
- [ ] Tracking and line height are defined per role
- [ ] CSS tokens are defined

**Document Language**
- [ ] None of the forbidden phrases appear
- [ ] Narrative sections are prose, not bullet lists
- [ ] Anti-patterns are as detailed as patterns
- [ ] The document has a point of view

**Marketing Foundation**
- [ ] Positioning statement uses the correct structure
- [ ] 3 messaging pillars define territory and unlocks
- [ ] 2+ tagline directions include target emotion and prohibitions
- [ ] 3 voice-in-practice examples are included
- [ ] Tone boundaries are listed

**Delivery**
- [ ] Reviewed against the brand values gathered during discovery
- [ ] Anti-patterns checked against mapped category cliches
- [ ] Document saved in `docs/brand-identity.md` or `.github/brand-identity.md`

---

## References

- *Designing Brand Identity* — Alina Wheeler
- *The Brand Gap* — Marty Neumeier
- *Logo Design Love* — David Airey
- *Detail in Typography* — Jost Hochuli
- [Pentagram work](https://www.pentagram.com/work)
- [Wolff Olins case studies](https://www.wolffolins.com/work)
