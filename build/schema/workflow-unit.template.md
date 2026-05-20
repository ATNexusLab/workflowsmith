---
# Required fields — must be present in every canonical workflow unit.

id: your-unique-slug
# Unique identifier for this unit. Lowercase kebab-case.
# Examples: skill-spec-writing, agent-engine, policy-routing

type: skill
# One of: agent | skill | policy | checklist | memory-index

status: draft
# One of: draft | reviewed | promoted
# Only 'promoted' units are active policy. See ADR-003 for transition criteria.

version: 1.0.0

schema_version: 1.0.0
# Schema version this unit was authored against. See ADR-005 and build/schema/VERSION.
# Adapters use this to verify compatibility before reading the unit.
# Semver string. Increment on any breaking change to the unit's behavior.

# Optional fields — include only when relevant.

# tags:
#   - planning
#   - security
# Thematic labels for discovery and filtering.

# replaces: old-unit-slug
# The id of the unit this one supersedes. The old unit should be archived.

# see-also:
#   - related-unit-slug
# Related unit ids. Cross-references for contributors and adapters.
---

# Unit Title

One-sentence description of what this unit does and when to use it.

## [Body content follows — structure depends on type]

For `type: skill`, include: trigger conditions, behavior description, output format.
For `type: agent`, include: responsibilities, operating rules, default behavior.
For `type: policy`, include: the rule, rationale, and scope.
For `type: checklist`, include: ordered list of checkable items.
For `type: memory-index`, include: source table and promotion requirements.
