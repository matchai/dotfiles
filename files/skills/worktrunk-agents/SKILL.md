---
name: worktrunk-agents
description: Switching to a git worktree to work in (creating one for a new branch), handing one to a subagent, or setting up a repository so new worktrees start with env files and dependencies, with the `wt` CLI. Load before running `wt switch` from an agent session.
---

# Worktrees from an agent session

An agent session cannot change directory, so it switches to a worktree, then works in it by path. The `worktrunk` skill owns `wt` config, hooks, and hook approvals; load it to change any of those.

## Switch

When the primary checkout (first entry of `git worktree list`) has no `.config/wt.toml`, set the repository up first with [setup.md](setup.md), so the worktree starts with env files and dependencies.

1. Run from a checkout that has `.config/wt.toml`, usually the primary; `wt` reads project hooks from the worktree it runs in:

   ```sh
   perl -MPOSIX -e 'setsid; exec @ARGV' wt switch <branch> --no-cd --format=json
   ```

   Agent shells end every process a command leaves behind, which kills `wt`'s background `post-start` hooks; `setsid` moves `wt` into its own session so they keep running. Stdout is one JSON object; `path` is the worktree's absolute path. Progress goes to stderr. Reuse the branch the task is about; add `--create` only when the work needs a new branch.

2. Keep hooks on. They provision the worktree: copy-on-write clones of gitignored build caches and env files, then the dependency install. A command needing approval means the user has not approved the project's hooks yet: stop and ask them to run `wt config approvals add` in that repository.

3. Start reading and editing once `wt switch` returns: `pre-start` hooks have finished. `post-start` hooks, often dependency installs, keep running in the background and log to `<repo>/.git/wt/logs/<sanitized-branch>/<user|project>/post-start/<name>.log`; `wt config state logs` lists the exact paths. Before running installs, builds, tests, or dev servers, run `wt -C <path> ready`: it returns once `post-start` finishes, and fails with the failed step's log. A repository without the `ready` alias (`wt config alias show ready`) gets it from [setup.md](setup.md)'s template.

4. Confirm the copy. `wt step copy-ignored` reports `(reflinked, no extra disk)` in the `wt switch` output or its log. `(full copy)` means the filesystem cannot clone; say so in your report.

## Work in it

- Run every shell command with its working directory set to `path`; each call starts a fresh shell.
- Give file tools absolute paths under `path`.
- Report the branch and `path` to the user.

## Remove

`wt remove` deletes in the background, which agent shells cut short, leaving the half-deleted worktree in `<repo>/.git/wt/trash`. Wait for the deletion instead; a large worktree takes a few minutes:

```sh
wt remove <branch> --foreground
```

## Subagents

Create each worktree from the parent with the steps above, then name it in the subagent's task:

```
You are working in `<path>` on branch `<branch>`.
Keep every edit and command inside that worktree.
```
