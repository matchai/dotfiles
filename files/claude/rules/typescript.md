---
globs: ["*.ts", "*.tsx", "*.js", "*.jsx"]
description: "TypeScript/JavaScript coding rules"
---

## React

- Compose small components, avoid massive JSX
- Colocate code that changes together
- Avoid 'useEffect' unless necessary

## Tailwind

- Prefer built-in values > dynamic > globals
-	Always v4 + global CSS + shadcn/ui

## Next

- Fetch in RSC (page can still be static)
- Use next/font + next/script when applicable
- next/image above fold: 'sync'/'eager', use 'priority' sparingly
- Mind serialized prop size RSC → children

## TypeScript

- No unnecessary ⁠try/⁠catch
- No ⁠any casts
- Use end-to-end types

## JSDoc

- Only for unclear functions, descriptions only (TS handles types)
- Prefer one-line `⁠/** */`
