- Only create an abstraction if it's actually needed
- Prefer clear function/variable names over inline comments
- Avoid helper functions when a simple inline expression would suffice
- Left align the happy path. Early returns over nesting
- Prefer small, well-scoped files
- Be extremely concise. Sacrifice grammar for the sake of concision
- Never remove existing comments or docstrings when editing code, even when simplifying or refactoring
- When asked to change a feature, consider what can be removed or simplified as a result
- Use 'knip' to remove unused code if making large changes
- The 'gh' CLI is installed, use it
- Don't use emojis
- Prefer the following CLIs:
  - find -> fd
  - grep -> ripgrep

## MCPs

- Use `context7` for code generation and library documentation
- If you are unsure how to do something, use `gh_grep` to search code examples from github
