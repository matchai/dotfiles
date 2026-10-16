#!/usr/bin/env bash
# Resolve the primary checkout of the focused workspace's repo, then open the branch prompt.
set -euo pipefail

herdr="${HERDR_BIN_PATH:-herdr}"
ctx="${HERDR_PLUGIN_CONTEXT_JSON:-}"

fail() {
  "$herdr" notification show "New worktree from main" --body "$1" >/dev/null 2>&1 || true
  echo "$1" >&2
  echo "workspace=${ws:-} pane=${pane:-} cwd=${cwd:-} context=$ctx" >&2
  exit 1
}

ws="${HERDR_WORKSPACE_ID:-}"
pane="${HERDR_PANE_ID:-}"
if [ -n "$ctx" ]; then
  [ -n "$ws" ] || ws="$(jq -r '.workspace_id // .workspace.workspace_id // empty' <<<"$ctx")"
  [ -n "$pane" ] || pane="$(jq -r '.pane_id // .pane.pane_id // .focused_pane_id // empty' <<<"$ctx")"
fi
[ -n "$ws" ] || fail "No focused workspace."

# Prefer herdr's worktree metadata; for linked worktrees, repo_root is the primary checkout.
repo_root="$("$herdr" workspace get "$ws" | jq -r '.result.workspace.worktree.repo_root // empty')"

# Fallback: ask git from the focused pane's directory (workspace may lack worktree metadata).
if [ -z "$repo_root" ]; then
  cwd=""
  if [ -z "$pane" ]; then
    pane="$("$herdr" pane list 2>/dev/null | jq -r --arg ws "$ws" \
      '[.result.panes[] | select(.workspace_id == $ws)] | (map(select(.focused)) + .)[0].pane_id // empty' || true)"
  fi
  if [ -n "$pane" ]; then
    cwd="$("$herdr" pane get "$pane" 2>/dev/null | jq -r '.result.pane | .foreground_cwd // .cwd // empty' || true)"
  fi
  if [ -n "$cwd" ] && common="$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)"; then
    repo_root="$(dirname "$common")"
  fi
fi
[ -n "$repo_root" ] || fail "This workspace is not a Git repo."

exec "$herdr" plugin pane open \
  --plugin "$HERDR_PLUGIN_ID" \
  --entrypoint prompt \
  --env "WORKTREE_REPO_ROOT=$repo_root"
