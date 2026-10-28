## Who am I
- I work at Vercel. If a bug traces to a Vercel-owned package or service, consider fixing it upstream if the fix is low-lift rather than just working around it
- Never reference internal projects, tools, or services in commits/PRs to external or OSS repositories

## Philosophy
- Don't use emojis
- Always check before speculating. Read the code/config instead of asking or guessing

## Git
- Never amend commits. Always create new commits to fix issues
- Never force-push (`--force`, `--force-with-lease`) unless I explicitly ask. Pushing fix-up commits on top of existing ones is the default; rewriting published history is opt-in only
- Never `git checkout`/`git switch` branches in a repo's main checkout. It may hold my in-progress work or be used by another agent. To work on another branch, create or switch to a worktree with `wt switch <branch>` (add `-c` to create a new branch; see the `worktrunk` skill), then work from that worktree's path

## Programming
- Only create an abstraction if it's actually needed
- Prefer clear function/variable names over inline comments
- Use `/** */` only for what callers of a declaration need to know. Explain why a line or block does something with a `//` comment beside it
- Avoid helper functions when a simple inline expression would suffice
- Intermediary variables and functions are fine if it improves declarativity and readability. For example:
  ```ts
  const hasMatchingDeployment = deploymentId && subscription.deploymentId === deployment;
  const hasActiveDeployment = subscription.deploymentStatus === "active";
  if (hasMatchingDeployment && hasActiveDeployment) { ... }
  ```
- Prefer intermediary variables over deep nesting
- Left align the happy path. Early returns over nesting
- Prefer small, well-scoped files
- Never remove existing comments or docstrings when editing code, even when simplifying or refactoring
- When asked to change a feature, consider what can be removed or simplified as a result
- When the approach changes partway through, reread the diff as a first-time reviewer before finishing, and delete anything vestigial: types, wrappers, optional fields, and helpers that only an earlier approach needed
- The `gh` CLI is installed, use it
- Never edit dependency files by hand. Use the package manager CLI (e.g. `pnpm add`, `cargo add`)

## Dev Flow
- Repos are all in `~/vercel/<repo>` (Vercel) and `~/dev/<repo>` (others). Look there first to read a repo's source or make a PR. Checkouts are often stale, so `git fetch` and read via `git show origin/main:<path>` or a tag
- Avoid writing files with python + heredocs

## Tools
- find -> fd
- grep -> ripgrep
- Read the `find-docs` skill for library documentation
- Use `gh_grep` to search code examples from github
- Instead of browsing `node_modules` to read dependency source code, use `opensrc path <pkg>`
