---
name: merge-in-main
description: Merge the current branch with the latest version of the repository's default branch and resolve conflicts. Use when the user asks to merge or update from main, bring their branch up to date, resolve merge conflicts from main, or invokes $merge-in-main.
---

# Merge In Main

1. Inspect the repository before changing it:
   - Run `git status --short` and `git branch --show-current`.
   - Stop and ask before proceeding if HEAD is detached or uncommitted user changes could be overwritten. Do not stash, reset, or discard changes without explicit instruction.

2. Determine the default branch from `origin/HEAD`. If it is unavailable, use the repository metadata; use `main` only when it is the confirmed default branch.

3. Fetch the latest default branch, then merge `origin/<default-branch>` into the current branch. Preserve merge commits; do not rebase unless the user asks for a rebase.

4. If conflicts occur:
   - List all unmerged files and inspect both sides of each conflict.
   - Resolve them according to the surrounding code and the intent of the incoming default-branch change. Never blindly accept one side.
   - Stage every resolved file and complete the merge commit. Pause only when the intended behavior is materially ambiguous.

5. Verify the completed merge with `git diff --check`, `git status`, and the most relevant repository checks. Report the merge result and any remaining ambiguity. Do not push unless the user asks.
