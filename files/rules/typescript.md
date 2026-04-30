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

- No unnecessary try/catch
- No any casts

## Type Strictness
Make impossible states unrepresentable.

- Use discriminated unions over flag bags:
  ```ts
  // Don't — invalid combos representable
  type State = { loading: boolean; user?: User; error?: string };

  // Do — only valid states exist
  type State =
    | { status: "loading" }
    | { status: "success"; user: User }
    | { status: "error"; error: string };
  ```

- Use branded types. Validate once at the boundary; downstream code trusts the type:
  ```ts
  type PhoneNumber = string & { __brand: "PhoneNumber" };

  function parsePhone(input: string): PhoneNumber {
    if (!/^\+?\d{10,15}$/.test(input)) throw new Error(`Invalid: ${input}`);
    return input as PhoneNumber;
  }

  function sendSMS(to: PhoneNumber, body: string) {
    /* input is trusted */
  }
  ```

- Let the types flow end-to-end

  DB schema → server → client should share types without manual duplication. Use whatever end-to-end type tool the project already has (tRPC, oRPC, Elysia, TanStack Start). A users.email branded as Email should arrive on the client still branded.

  Don't restate types you can derive. Reach for Pick, Omit, Parameters, ReturnType, Awaited, typeof etc. before writing a new interface. For function arguments, infer from the source instead of typing them by hand:

  Don't restate types you can derive. Reach for `Pick`, `Omit`, `Parameters`, `ReturnType`, `Awaited`, `typeof` etc. before writing a new interface. For function arguments, infer from the source instead of typing them by hand:

  ```ts
  // Don't — duplicate shape, drifts when the row changes
  type UserSummary = { id: string; email: Email };
  function renderUser(u: UserSummary) {
    /* ... */
  }

  // Do — derive from the source of truth
  type User = Awaited<ReturnType<typeof db.query.users.findFirst>>;
  function renderUser(u: Pick<User, "id" | "email">) {
    /* ... */
  }
  ```

- Pass objects, not positional args

  ```ts
  // Don't — swap two args, still compiles
  sendEmail("Welcome!", "Hi there");
  // Do — order-independent, self-documenting
  sendEmail({ to: "alice@x.com", body: "Hi there" });
  ```

## Observability

- OpenTelemetry, not print logging

  When adding observability, instrument with OTel spans. The setup cost pays back the first time a user sends a request ID and you can answer instead of guess.

## JSDoc

- Only for unclear functions, descriptions only (TS handles types)
- Prefer one-line `/** */`

## Dependencies

- Install packages via the package manager CLI rather than editing package.json directly

## General

- When moving things, don't re-export for backwards-compatibility
