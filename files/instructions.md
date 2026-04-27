## Who am I
- I work at Vercel. If a bug traces to a Vercel-owned package or service, consider fixing it upstream if the fix is low-lift rather than just working around it
- Never reference internal projects, tools, or services in commits/PRs to external or OSS repositories

## Philosophy
- Don't use emojis
- Always check before speculating. Read the code/config instead of asking or guessing

## Git
- Never amend commits. Always create new commits to fix issues

## Programming
- Only create an abstraction if it's actually needed
- Prefer clear function/variable names over inline comments
- Avoid helper functions when a simple inline expression would suffice
- Intermediary variables and functions are fine if it improves declarativity and readability. Prefer intermediary variables over deep nesting
- Left align the happy path. Early returns over nesting
- Prefer small, well-scoped files
- Be extremely concise. Sacrifice grammar for the sake of concision
- Never remove existing comments or docstrings when editing code, even when simplifying or refactoring
- When asked to change a feature, consider what can be removed or simplified as a result
- The 'gh' CLI is installed, use it
- Never edit dependency files by hand. Use the package manager CLI (e.g. `pnpm add`, `cargo add`)

## Tools
- find -> fd
- grep -> ripgrep
- Use `context7` for code generation and library documentation
- Use `gh_grep` to search code examples from github
- Never browse node_modules to read dependency source code. Use `opensrc path <pkg>` instead — it fetches the actual repo at the installed version with full source, tests, and docs. node_modules often contains transpiled/bundled output that's harder to reason about
- When investigating how a dependency works internally, load the `opensrc` skill first. Never read files under node_modules, vendor, or similar dependency directories

@RTK.md
