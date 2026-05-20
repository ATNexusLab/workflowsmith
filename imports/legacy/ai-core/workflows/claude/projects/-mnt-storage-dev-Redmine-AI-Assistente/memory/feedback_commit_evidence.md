---
name: feedback_commit_evidence
description: "Evidence field rule for Redmine time entries — use commit ID directly, never LLM prose"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: cf12bc32-0ad4-4ebd-91e4-b9ef95467e88
---

When the user provides a commit ID (40-char hex SHA-1), the evidence field (custom_field 172) must be:

```
Commit_ID: <full_hash>
```

Do NOT call the LLM to generate 200-char prose when concrete evidence exists.

**Why:** User's explicit rule — "We will build the 200 characters max text just when we have to invent it."

**How to apply:** In `Build Payload` node, detect SHA-1 hash in `_chatRaw` and short-circuit the LLM-generated evidence with the direct format. Already implemented in `Build Payload` node via `_commitIdMatch`.
