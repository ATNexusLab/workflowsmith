---
name: brand-identity
description: Use to define brand identity, visual positioning, and design-system foundations, including palette, typography, tokens, language, and anti-generic direction.
kind: skill
tools:
  - read_file
  - grep
  - glob
  - run_shell_command
---

# Brand Identity

## When to Use

- Define or refine the visual and verbal identity of a product
- Create or audit a design token system (colors, typography, spacing, radii)
- Establish brand language principles and tone of voice
- Position visually against market alternatives
- Guide design decisions for a new feature, landing page, or product area
- Validate whether a visual direction is generic or distinctive

## Core Principles

1. **Specificity over defaults** — distinctive over safe, intentional over default
2. **Constraint first** — fewer choices made deliberately beat unlimited options used casually
3. **Token discipline** — every visual property should map to a named token, not an arbitrary value
4. **Verbal and visual consistency** — language and appearance follow the same identity logic
5. **Anti-generic** — examine what the category typically looks like, then deliberately differentiate

## Brand Identity Dimensions

### 1. Positioning

Before any visual choice, establish:

| Dimension | Questions to answer |
|---|---|
| **Audience** | Who is the primary user? What do they value and distrust? |
| **Category** | What market or product category does this sit in? |
| **Differentiator** | What does this product do or feel like that competitors do not? |
| **Personality** | Three to five adjectives that should describe the brand experience |
| **Anti-personality** | Three adjectives that should never describe it |

### 2. Color System

**Palette structure:**

```
Primary         — Main brand action color (CTAs, links, highlights)
Secondary       — Supporting color for UI structure or contrast
Neutral         — Grays for backgrounds, borders, text hierarchy
Semantic        — Success, warning, error, info
Surface         — Background layers (page, card, overlay)
```

**Token naming convention:**

```
color-brand-primary-500       ← base
color-brand-primary-400       ← lighter
color-brand-primary-600       ← darker
color-text-default            ← semantic alias
color-text-muted
color-text-inverse
color-bg-surface-1
color-bg-surface-2
color-border-default
color-border-focus
```

**Rules:**
- Define scales (50 through 900) for primary and neutral families
- Create semantic aliases that point to scale values — components use aliases, not raw values
- Ensure contrast ratios meet WCAG AA minimum: 4.5:1 for body text, 3:1 for large text
- Limit accent colors; overuse collapses hierarchy

**Validation:**

```bash
# Check for hardcoded hex values outside token files
grep -r "#[0-9a-fA-F]\{6\}\|#[0-9a-fA-F]\{3\}" --include="*.css" --include="*.scss" --include="*.ts" --include="*.tsx" | grep -v "tokens\|theme\|variables"
```

### 3. Typography System

**Scale structure:**

```
display-2xl    72px / line-height 1.1 / weight 700-800
display-xl     60px / line-height 1.1
display-lg     48px / line-height 1.2
heading-xl     36px / line-height 1.25
heading-lg     30px / line-height 1.3
heading-md     24px / line-height 1.35
heading-sm     20px / line-height 1.4
body-lg        18px / line-height 1.6
body-md        16px / line-height 1.6
body-sm        14px / line-height 1.5
label-lg       14px / line-height 1.2 / weight 500-600
label-md       12px / line-height 1.2
caption        11px / line-height 1.4
```

**Typeface selection criteria:**

| Criterion | What to evaluate |
|---|---|
| **Legibility** | x-height, aperture, character spacing at small sizes |
| **Personality fit** | Does geometric / humanist / transitional / slab match brand adjectives? |
| **Weight range** | Minimum: regular (400), medium (500), bold (700) |
| **Variable font** | Preferred; reduces requests and enables fine-grained control |
| **Licensing** | Web-licensed, no runtime restrictions |
| **Fallback stack** | System font fallback should degrade gracefully |

**Generic combinations to avoid:**

- Poppins + Lato (startup template default)
- Montserrat + Open Sans (legacy bootstrap default)
- Inter everywhere at uniform weight (readable but characterless)

### 4. Spacing and Layout System

```
space-1    4px
space-2    8px
space-3    12px
space-4    16px
space-5    20px
space-6    24px
space-8    32px
space-10   40px
space-12   48px
space-16   64px
space-20   80px
space-24   96px
```

**Rules:**
- Use a 4px base unit
- Spacing should follow a named scale — no arbitrary pixel values
- Layout regions (page, container, section, card) each get explicit padding tokens

### 5. Border Radius

```
radius-none    0px
radius-sm      2px
radius-md      4px
radius-lg      8px
radius-xl      12px
radius-2xl     16px
radius-full    9999px
```

**Signal:** radius scale telegraphs personality — sharp (0–2px) is formal/technical, mid (4–8px) is balanced/modern, large (12px+) is friendly/soft, full is expressive/playful. Choose a dominant register and use it consistently.

### 6. Iconography and Illustration

**Iconography rules:**
- Choose one icon family and use it exclusively — do not mix two libraries in the same interface
- Decide on stroke weight and corner treatment at the system level, not per icon
- Common mistake: mixing Heroicons (sharp, 1.5px stroke) with Lucide (slightly rounded) or with filled-style Material Icons

**Illustration rules:**
- Establish a single illustration style; mixed styles fragment perceived quality
- Consider whether illustration is consistent with brand personality (technical product using playful blob characters creates a trust mismatch)
- Ensure diverse and inclusive representation is the default, not the exception

### 7. Brand Voice and Tone

**Voice (stable, defines the brand):**
- 3–5 voice attributes with behavioral definitions
- One "we are / we are not" pair per attribute

**Example:**
```
Clear, not dumbed-down
  We explain complex ideas without jargon.
  We do not assume ignorance.

Direct, not blunt
  We say what we mean with confidence.
  We do not use filler phrases or false warmth.

Human, not casual
  We write like a knowledgeable person.
  We do not use slang or forced informality.
```

**Tone (adapts to context):**

| Context | Tone adjustment |
|---|---|
| Error messages | Direct, calm, never blaming |
| Empty states | Encouraging, specific, not cutesy |
| Success states | Confirmatory, brief, not over-celebratory |
| Onboarding | Welcoming, task-oriented, not overwhelming |
| Marketing copy | Benefit-led, specific, not superlative |

**Anti-patterns to reject:**
- Filler superlatives: "amazing," "powerful," "seamless," "world-class"
- Hollow CTA text: "Learn more," "Click here," "Get started" without context
- Passive constructions that obscure responsibility: "An error occurred"
- Unnecessary exclamation points in product UI

## Anti-Generic Direction

For each category, identify the dominant visual language and document what to avoid:

| Category | Typical generic pattern | Differentiated direction |
|---|---|---|
| SaaS tools | Blue primary, Inter, card-heavy UI | — |
| Developer tools | Dark mode, monospace everywhere, minimal color | — |
| Fintech | Navy/green, trust iconography, conservative serif | — |
| Consumer wellness | Sage/terracotta, rounded everything, soft photography | — |
| B2B enterprise | Gray-heavy, table-centric, no illustration | — |

Fill the third column with what this specific brand does instead.

## Token Audit

Check that no design property is hardcoded outside the token system:

```bash
# Hardcoded colors
grep -rn "color:\s*#\|background:\s*#\|border-color:\s*#" --include="*.css" --include="*.scss" | grep -v "tokens\|variables\|theme"

# Hardcoded font sizes outside token references
grep -rn "font-size:\s*[0-9]" --include="*.css" --include="*.scss" | grep -v "tokens\|variables\|theme"

# Hardcoded spacing
grep -rn "padding:\s*[0-9]\|margin:\s*[0-9]" --include="*.css" --include="*.scss" | grep -v "tokens\|variables\|theme" | head -20
```

## Deliverables

Depending on scope, brand identity work produces one or more of:

| Deliverable | Contents |
|---|---|
| **Positioning brief** | Audience, differentiator, personality, anti-personality |
| **Color token file** | Full palette scale + semantic aliases |
| **Typography spec** | Typeface choice, scale, weight assignments, fallback stack |
| **Spacing/radius tokens** | Named scales for spacing and border radius |
| **Voice guide** | Voice attributes with behavioral definitions and tone by context |
| **Anti-generic audit** | Category conventions documented with explicit departures |
| **Design token file** | All tokens in a single JSON/CSS variables file |

## Steps

### 1. Audit the existing system (if any)

Read what exists before proposing changes:

```bash
find . -name "tokens*" -o -name "theme*" -o -name "variables*" | grep -v node_modules | head -20
cat tailwind.config.js 2>/dev/null || cat tailwind.config.ts 2>/dev/null
find . -name "*.css" -o -name "*.scss" | grep -v node_modules | head -20
```

Identify: what tokens exist, what is hardcoded, what is missing.

### 2. Define positioning

Answer the five positioning dimensions before touching any color or font.

### 3. Build the color system

- Define the full scale for primary and neutral families
- Create semantic aliases for all usage contexts
- Validate contrast ratios

### 4. Select and specify typography

- Choose typeface based on legibility, personality fit, and licensing
- Define the full scale with sizes, weights, and line heights
- Produce the fallback stack

### 5. Define spacing, radius, and other tokens

- Establish the spacing scale
- Choose the radius register and define the scale
- Token-ize any other recurring values (shadow, z-index, transition timing)

### 6. Write the voice guide

- Name and define 3–5 voice attributes
- Write tone guidance for the 4–5 key UI contexts

### 7. Run the anti-generic audit

- Document the category's dominant visual language
- Explicitly name what this system avoids

### 8. Validate the token system

Run the token audit commands to confirm nothing is hardcoded outside the system.

## Never Do

- Choose a typeface based on popularity rather than fit
- Use color tokens inconsistently — some components using tokens and others using raw hex values
- Define typography without a scale — free-size values collapse consistency
- Mix icon families without explicit justification
- Write brand voice in abstract adjectives without behavioral definitions
- Accept generic anti-patterns ("powerful", "seamless") as brand language
- Skip the anti-generic audit — distinctive identity requires knowing the category convention being rejected
