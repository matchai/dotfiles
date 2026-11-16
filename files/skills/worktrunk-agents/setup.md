# Set up warm worktrees for a repository

A repository is set up when its primary checkout has a `.config/wt.toml` whose hooks give every new worktree its env files as copy-on-write clones and install its dependencies in the background. The file is personal: it is gitignored globally, never committed, and each worktree links to the primary's copy.

## Steps

1. **Survey the primary checkout.** Its path is the first entry of `git worktree list`. Find:
   - the package manager, from the lockfile
   - the gitignored files a fresh checkout needs to run, such as `.env.local`: `git ls-files -o -i --exclude-standard --directory`
   - large dependency directories, such as `node_modules/`

2. **Write `<primary>/.config/wt.toml`** from the template below. Replace the install command for the repository's package manager. Never clone `node_modules/` from the primary: a single `clonefile(2)` over hundreds of thousands of files froze the whole machine for about a minute.

3. **Link the config into existing worktrees** so `wt` commands run from them see the hooks:

   ```sh
   mkdir -p <worktree>/.config && ln -sfn <primary>/.config/wt.toml <worktree>/.config/wt.toml
   ```

4. **Ask the user to approve the hooks**: `cd <primary> && wt config approvals add`. Wait for them; the approval is theirs to give.

5. **Verify with a throwaway worktree.** Create one as `SKILL.md` describes, confirm `copy-ignored` reports `(reflinked, no extra disk)`, confirm `wt -C <path> ready` prints `ready`, run one project command (such as a test), then remove it with `wt remove <branch> --foreground`.

## Template

```toml
# Personal worktree setup, gitignored globally. New worktrees symlink this file from the
# primary checkout and branch from an up-to-date default branch. Code and env files are ready
# when `wt switch` returns; dependencies finish in the background (post-start logs).
pre-switch.update-main = "[ \"$(git -C {{ primary_worktree_path }} branch --show-current)\" = {{ default_branch }} ] && git -C {{ primary_worktree_path }} -c url.https://github.com/.insteadOf=git@github.com: pull --ff-only --quiet || true"

# copy-ignored reads its excludes from this worktree's config, so link it first.
[[pre-start]]
link-config = "mkdir -p .config && ln -sfn {{ primary_worktree_path }}/.config/wt.toml .config/wt.toml"

[[pre-start]]
copy = "wt step copy-ignored"

[[post-start]]
install = "pnpm install --frozen-lockfile --prefer-offline"

# Background hooks record no completion, so mark it in the worktree's own git dir.
[[post-start]]
done = "touch \"$(git rev-parse --git-dir)/post-start-done\""

# `wt ready` blocks until post-start finishes, and fails with the runner log once a step fails.
[aliases]
ready = '''
marker="$(git rev-parse --git-dir)/post-start-done"
runner="$(git rev-parse --git-common-dir)/wt/logs/{{ branch | sanitize_hash }}/project/post-start/runner.log"
until [ -f "$marker" ]; do
  [ -s "$runner" ] && { cat "$runner" >&2; exit 1; }
  sleep 2
done
echo ready
'''

[step.copy-ignored]
exclude = ["node_modules/", ".config/wt.toml"]
```

## Install commands

Pick an install that installs exactly what the branch's lockfile lists and reuses the package manager's local cache:

| Lockfile | Install command |
| --- | --- |
| `pnpm-lock.yaml` | `pnpm install --frozen-lockfile --prefer-offline` |
| `package-lock.json` | `npm install --prefer-offline --no-audit --no-fund` (`npm ci` deletes `node_modules/` first) |
| `bun.lock` | `bun install --frozen-lockfile` |
| `yarn.lock` | `yarn install --immutable` (Yarn 2+) or `yarn install --frozen-lockfile` (Yarn 1) |
| `uv.lock` | `uv sync --frozen`, with `.venv/` excluded from the copy: virtual environments hold absolute paths |
