#!/usr/bin/env bash
# Popup: ask for a branch name and create the worktree from main via the primary checkout.
set -uo pipefail

herdr="${HERDR_BIN_PATH:-herdr}"
repo_root="${WORKTREE_REPO_ROOT:?WORKTREE_REPO_ROOT not set}"
base="main"

printf 'Repo: %s  (base: %s)\n\n' "$(basename "$repo_root")" "$base"
read -r -e -p "Branch name: " branch || exit 0
branch="${branch#"${branch%%[![:space:]]*}"}"
branch="${branch%"${branch##*[![:space:]]}"}"
[ -n "$branch" ] || exit 0

if ! out="$("$herdr" worktree create --cwd "$repo_root" --branch "$branch" --base "$base" --focus 2>&1)"; then
  printf '\nFailed:\n%s\n\nPress Enter to close.' "$out"
  read -r _
  exit 1
fi
