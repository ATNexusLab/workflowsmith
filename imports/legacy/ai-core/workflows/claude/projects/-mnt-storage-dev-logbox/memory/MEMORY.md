# Memory Index — LogBox

- [Backend Test Isolation](feedback-backend-test-isolation.md) — Wave O confirmed: bun test runs files in the same group in-process; mock.module leaks. Each file with unique mocks needs its own group in run-tests.ts.
- [Lucide-react Bun CJS Issue](feedback-lucide-bun-cjs.md) — Certain lucide-react icons (ArrowRightLeft, ArrowLeftRight) cause SyntaxError in bun test when loaded via CJS chain; use only icons already proven to work in that test context or mock the importing module.
