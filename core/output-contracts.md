---
id: policy-output-contracts
type: policy
status: promoted
version: 1.0.0
schema_version: 1.0.0
---

# Output Contracts

These contracts define the baseline expectations for AI responses that use this repository.

## General Contract

An output should:

- Answer the user's request directly.
- State important assumptions.
- Keep the level of detail appropriate to the task.
- Prefer concrete file paths, commands, and decisions over vague descriptions.
- Avoid inventing workflow policy that is not present in the repository or requested by the user.

## Repository Change Contract

When changing repository files, the final answer should include:

- What changed
- Which verification command ran
- Any files or checks that could not be completed
- The next practical step when relevant

## Review Contract

When reviewing code or workflow material, lead with findings ordered by severity. Use file references and explain the risk. If no issues are found, say so and mention residual test or review gaps.

## Import Contract

When importing external workflow material:

- Preserve the original content first.
- Record source and date metadata.
- Keep normalization separate from raw import.
- Promote only after the intended behavior is clear.
