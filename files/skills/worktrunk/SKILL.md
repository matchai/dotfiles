---
name: worktrunk
description: Git worktree management via the `wt` CLI. Use when asked to create worktrees, switch branches for parallel work, list worktrees, clean up old branches, or merge worktree branches. Triggers on "worktree", "worktrunk", "wt", "create branch", "new branch", "switch branch", "parallel branch".
---

# Worktrunk (`wt`) - Git Worktree Management

Manage git worktrees for parallel development workflows. Each worktree is an independent working directory with its own branch, allowing concurrent work without stashing or switching.

## Agent Usage

Since agents cannot change directories interactively, always use `--no-cd` with `wt switch` and operate on the worktree path directly via the `workdir` parameter in Bash tool calls.

### Get worktree path after creation

```bash
# Create worktree, then extract path from JSON
wt switch --create <branch> --no-cd --yes
wt list --format=json | jq -r '.[] | select(.branch == "<branch>") | .path'
```

Then use `workdir=<path>` for subsequent commands in that worktree.

## Commands

### Create a new worktree + branch

```bash
wt switch --create <branch-name> --no-cd --yes
```

- `--create` / `-c`: Create a new branch (required for new branches)
- `--no-cd`: Skip directory change (required for agents)
- `--yes` / `-y`: Skip approval prompts (required for agents)
- `--base <branch>`: Base branch (defaults to default branch)
- `--no-verify`: Skip post-create/post-start hooks

```bash
# From main (default)
wt switch --create feature-auth --no-cd --yes

# From a specific base branch
wt switch --create hotfix --base production --no-cd --yes
```

### Switch to an existing worktree

```bash
wt switch <branch> --no-cd --yes
```

Shortcuts: `^` (default branch), `-` (previous), `@` (current), `pr:123` (GitHub PR).

### List worktrees

```bash
# Human-readable table
wt list

# JSON for scripting/parsing
wt list --format=json

# Include branches without worktrees
wt list --branches

# Include CI status and diff analysis (slower)
wt list --full
```

#### Key JSON fields

| Field | Description |
|-------|-------------|
| `branch` | Branch name |
| `path` | Worktree directory path |
| `main_state` | Relation to default branch: `ahead`, `behind`, `diverged`, `integrated`, `would_conflict` |
| `is_current` | Whether this is the current worktree |
| `working_tree.modified` | Has uncommitted changes |
| `symbols` | Status symbols (e.g., `!` modified, `?` untracked, `^` default, `⊂` integrated) |

#### Useful JSON queries

```bash
# Get path of a specific worktree
wt list --format=json | jq -r '.[] | select(.branch == "feature") | .path'

# Branches safe to remove (integrated into default)
wt list --format=json | jq -r '.[] | select(.main_state == "integrated" or .main_state == "empty") | .branch'

# Branches with uncommitted changes
wt list --format=json | jq '.[] | select(.working_tree.modified) | .branch'

# Branches ahead of main
wt list --format=json | jq '.[] | select(.main.ahead > 0) | {branch, ahead: .main.ahead}'
```

### Remove a worktree

```bash
# Remove current worktree (and delete branch if merged)
wt remove --yes

# Remove specific worktree
wt remove <branch> --yes

# Keep the branch after removal
wt remove <branch> --no-delete-branch --yes

# Force-delete unmerged branch
wt remove <branch> -D --yes

# Force remove with untracked files (build artifacts)
wt remove <branch> --force --yes
```

### Merge worktree branch into default

Squash + rebase, fast-forward target, remove worktree.

```bash
wt merge --yes

# Merge to a specific target
wt merge develop --yes

# Keep worktree after merge
wt merge --no-remove --yes

# Preserve commit history (no squash)
wt merge --no-squash --yes
```

### Individual operations (`wt step`)

```bash
wt step commit       # Stage and commit with LLM-generated message
wt step squash       # Squash commits since branching
wt step rebase       # Rebase onto target
wt step push         # Fast-forward target to current branch
wt step copy-ignored # Copy gitignored files to another worktree
```

## Workflow Pattern for Agents

```bash
# 1. Create worktree
wt switch --create my-feature --no-cd --yes

# 2. Get the worktree path
path=$(wt list --format=json | jq -r '.[] | select(.branch == "my-feature") | .path')

# 3. Work in the worktree using workdir parameter
# (use workdir="$path" in Bash tool calls)

# 4. When done, merge back
# (run from within the worktree)
wt merge --yes
```
