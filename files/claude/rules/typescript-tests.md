---
globs: ["*.test.ts", "*.test.tsx", "*.spec.ts", "*.spec.tsx"]
description: "TypeScript testing rules"
---

- Tests are in `.test.ts` files alongside their source file
- Playwright tests are in `.spec.test.ts` files
- Prefer integration tests
- Mock minimally 
- Real fs in /tmp > mock fs
- In-memory DBs > mock DB
- When mocking third-party services is necessary, use msw
- Only clean up when necessary
- Test like users use it
- Accessible selectors > class names/implementation details
- When an accesible selector is unavailable, use a data-testid
- Keep explicit timeouts to a minimum

