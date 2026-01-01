---
globs: ["*.ts", "*.tsx", "*.js", "*.jsx"]
description: "TypeScript/JavaScript coding rules"
---

## React

- Avoid massive JSX blocks and compose smaller components
- Colocate code that changes together
- Avoid 'useEffect' unless absolutely needed

## Tailwind

- Mostly use built-in values, occasionally allow dynamic values, rarely globals
- Always use v4 + global CSS file format + shadcn/ui

## Next

- Prefer fetching data in RSC (page can still be static)
- Use next/font + next/script when applicable
- next/image above the fold should have 'sync' / 'eager' / use 'priority' sparingly
- Be mindful of serialized prop size for RSC → child components

## TypeScript

- Don't unnecessarily add 'try /'catch'
- Don't cast to ' any'
- Use end-to-end types

## JSDoc

- Use JSDoc for functions whose use is not immediately clear from the title. Only use it for descriptions. TS handles argument typing
- Use one-line `/** */` JSDocs when possible
