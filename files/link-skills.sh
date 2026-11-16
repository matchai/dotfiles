#!/bin/sh
# Links every skill in this repo's files/skills and in ~/second-brain/skills into ~/.agents/skills,
# where agents look for skills (~/.codex/skills and ~/.claude/skills point there too), and removes
# links to skills that are gone. Run it after adding, renaming, or removing a skill.
set -eu

public="$(cd "$(dirname "$0")" && pwd)/skills"
private="$HOME/second-brain/skills"
target="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"
mkdir -p "$target"

# A link into one of these whose skill is gone, such as after a rename, is removed.
for link in "$target"/*; do
  [ -L "$link" ] || continue
  dest=$(readlink "$link")
  case "$dest" in
    "$public/"* | "$private/"*) [ -e "$dest" ] || rm "$link" ;;
  esac
done

status=0
for source in "$public" "$private"; do
  [ -d "$source" ] || continue
  for skill in "$source"/*/; do
    [ -f "$skill/SKILL.md" ] || continue
    name=$(basename "$skill")
    link="$target/$name"
    # Another link, such as one to where the skill used to live, is replaced; a real folder is a
    # skill installed some other way, such as by the skills CLI, and is left alone.
    if [ -e "$link" ] && [ ! -L "$link" ]; then
      echo "link-skills: $name is already installed at $link; rename one of them" >&2
      status=1
      continue
    fi
    ln -sfn "$source/$name" "$link"
  done
done
exit "$status"
