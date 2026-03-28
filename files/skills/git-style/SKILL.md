---
name: git-style
description: Enforce PR and commit style conventions for projects under ~/vercel. Use when creating commits, PRs, or reviewing commit messages in any ~/vercel/* repository. Triggers on "commit", "PR", "pull request", "push", "git push", "create PR", "open PR".
---

# Git Style — PR and Commit Conventions

Enforces matchai's PR title, commit message, and PR body conventions derived from Vercel repo history.

---

## Commit Messages

### Style Selection by Repo Type

| Repo Type | Style | Example |
|-----------|-------|---------|
| Monorepo with conventional commits (vertex) | `type(scope): message` | `feat(agent): add skill loading` |
| Monorepo without conventional commits (api, infra) | `[scope] Message` | `[subscriber-omniagent] Add webhook forwarding` |
| Single-package repo (omniagent) | Plain imperative | `Fix session page 404 for GitHub thread sessions` |

**Detection**: Check `git log -30 --oneline` before committing. Match the dominant style.

### Rules (all styles)

- Imperative mood: "Add", "Fix", "Replace" — never "Added", "Fixes", "Replacing"
- Lowercase after conventional prefix: `feat(agent): add ...` not `feat(agent): Add ...`
- Sentence case for plain style: `Fix the thing` not `fix the thing`
- No trailing period
- First line under 72 chars
- No emojis

### Conventional Commit Types

Only use when the repo already uses them (check git log first):

| Type | When |
|------|------|
| `feat` | New capability |
| `fix` | Bug fix |
| `refactor` | Code restructuring, no behavior change |
| `chore` | Dependencies, config, CI |
| `docs` | Documentation only |
| `test` | Test additions/changes only |
| `perf` | Performance improvement |

### Scope

- Scope = workspace directory or package name: `agent`, `web`, `knowledge`, `flags`, `evals`
- For service-level commits in api/infra: `[subscriber-omniagent]`, `[secrets-management]`
- Omit scope if change spans the entire repo or doesn't fit a single area

---

## PR Titles

### Monorepo (vertex, api, infra)

Format: `[scope] lowercase description`

```
[agent] replace tsvector page collection search with LLM filtering
[web] add responsive right panel for mobile
[knowledge] prevent cache poisoning from transient fetch failures
[subscriber-omniagent] Fix webhook forward route to match omniagent endpoint
[secrets-management] add subscriber-omniagent to external ACL
```

- Scope = the workspace or subsystem being changed
- Lowercase after scope bracket
- No conventional commit prefix (no `feat:`, `fix:`)
- Imperative mood

### Single-package repo (omniagent)

Format: `Sentence case description`

```
Fix session page 404 for GitHub thread sessions
Enrich GitHub PR comment messages with file/line/diff context
Add Omniagent signature to GitHub replies
Isolate Slack and GitHub handlers into their own files
```

- Sentence case (capitalize first word)
- No scope prefix needed
- Imperative mood

### Reverts

Format: `Revert "[original title] (#number)"`

---

## PR Bodies

### Default (most PRs)

Plain prose. No headers. Paragraphs and bullet points are enough.

```markdown
Extends subscriber-omniagent's webhook enrichment to resolve the GitHub commenter to a Vercel user and mint a short-lived (15m) Vercel API token scoped to their team.

Allows Omniagent to use the Vercel CLI on behalf of the commenter — same capabilities as the Slack integration.

Also replaces the bulk of logging with tracing.
```

Bullets are fine inline — just don't wrap them in a `## Summary` header:

```markdown
Fixes the omniagent webhook forward URL from `/api/github/webhooks` to `/api/github` to match the actual route in the omniagent app.
```

### Large (multi-system, needs subsections to stay readable)

Use **bold text** for subsections, not markdown headers. Headers are too heavy for PR bodies. Only reach for `###` if the PR is exceptionally complex (5+ distinct areas).

```markdown
Forward select GitHub webhook events for select repos to omniagent's `/api/github` endpoint.

**Approach**

Uses the existing proxy system in `src/utils/proxy/` that already forwards events to spaces, v0, grep, and code-review. Omniagent is added as another proxy target with body-aware filtering.

**Changes**
- `proxy-webhook-event.ts` — extends `ProxyTarget` with optional `enrichHeaders` hook
- `filter-event.ts` — adds `issue_comment` as allowed omniagent event
- `target-urls.ts` — adds `getOmniagentUrl()`
```

For features with components/modules, use a table:

```markdown
| Skill | Tools |
|-------|-------|
| billing | refundInvoice, modifyInvoice |
| domains | domainAssist |
```

### Structural elements

| Element | When | Format |
|---------|------|--------|
| Ticket reference | Always if ticket exists | `Closes SPE-XXXX` or `Part of SPE-XXXX` |
| Stacked PR | When building on another PR | `Stacks on PR #XXXX` |
| Companion PR | Cross-repo dependency | `Companion PR: vercel/integrations -- slug` |
| Test results | When adding empirical validation | Table with pass rates |
| Changes table | When PR touches many files with distinct roles | `\| File \| Role \|` table |

### What NOT to do

- No `##` headers — use `###` at most, and only for large/complex PRs
- No emojis
- No "This PR..." preamble — jump straight into the substance
- No changelog-style lists of every file touched
- No screenshots unless UI change
- Don't restate the title in the body
- No hard line wraps in PR bodies

---

## PR Maintenance

When a meaningful change is made to a PR after creation (new commits, scope change, added/removed features), update the PR title and body to reflect the current state.

- Before editing, run `gh pr view <number>` to read the current title and body — match the existing tone and structure
- Title should describe the full scope of the PR, not just the initial commit
- Body should be rewritten, not appended to — the description should always read as a fresh summary of the PR's current content
- Don't update for trivial fixups (typos, lint fixes) — only for changes that alter what the PR does
