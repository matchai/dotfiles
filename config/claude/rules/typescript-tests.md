---
globs: ["*.test.ts", "*.test.tsx", "*.spec.ts", "*.spec.tsx"]
description: "TypeScript testing rules"
---

- Prefer integration tests
- Mock minimally 
  - Real fs in /tmp > mock fs
  - In-memory DBs > mock DB
- Only clean up when necessary
- Test like users use it
  - Accessible selectors > class names/implementation details
