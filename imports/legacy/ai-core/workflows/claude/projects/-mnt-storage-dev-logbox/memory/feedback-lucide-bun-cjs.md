---
name: lucide-bun-cjs
description: Some lucide-react icons (Arrow*) trigger SyntaxError in bun test when imported via CJS chain
metadata: 
  node_type: memory
  type: feedback
  originSessionId: c276a45c-861f-4995-a91f-9b047eaafb57
---

When a test imports a component that uses lucide-react icons via a CJS chain (i.e., the test doesn't mock lucide-react and loads through `node_modules/lucide-react/dist/cjs/lucide-react.js`), some icon names — confirmed: `ArrowRightLeft`, `ArrowLeftRight` — cause:

```
SyntaxError: Export named 'X' not found in module '...dist/cjs/lucide-react.js'
```

even though `require()` from Node can find them.

**Why:** Bun's static CJS→ESM named export analysis fails for certain icon names. Root cause is a Bun quirk; the icons physically exist in the CJS file.

**How to apply:**
- If adding a new icon to a component that existing tests load directly (without mocking), use only icons already proven to work in that context.
- Alternatively, mock the component (`mock.module("@/components/X", () => ({ X: () => null }))`) in the test so its transitive imports are never resolved.
- The test `lista-encomendas.wave2b-scanner.test.ts` is particularly sensitive because it doesn't mock lucide-react and imports `ListaEncomendasCompleta` directly.
