---
name: backend-test-isolation
description: Bun runs multiple test files in the same group in-process; mock.module leaks between files
metadata: 
  node_type: memory
  type: feedback
  originSessionId: c276a45c-861f-4995-a91f-9b047eaafb57
---

Each backend test file that uses `mock.module` on shared modules (like `../../lib/prisma`) must be in its **own isolated group** in `backend/app/scripts/run-tests.ts`.

**Why:** The run-tests.ts comment says it explicitly: "Alguns grupos precisam permanecer isolados para evitar vazamento de mock.module entre arquivos quando o Bun executa várias suítes no mesmo processo." Wave O confirmed this: when `identifier`, `container-autolink`, and `user-email-update` wave-o tests were added to the same group, the prisma mock from one file leaked into the next, causing 6/20 tests to fail.

**How to apply:** When writing new backend unit tests that mock `lib/prisma`, always add them as a single-path group (`{ timeout: 15000, paths: ["path/to/file.ts"] }`), not appended to an existing group. Check surrounding groups for any that mock the same modules.
