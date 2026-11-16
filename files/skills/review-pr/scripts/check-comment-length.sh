#!/bin/sh
# Usage: check-comment-length.sh BODY_FILE...
# Fails for each review comment body whose prose, outside fenced code blocks,
# runs past 2 lines or 300 characters. The `<sub>` sign-off line doesn't count.
set -eu

status=0
for body in "$@"; do
  awk -v body="$body" '
    /^[[:space:]]*(```|~~~)/ { fenced = !fenced; next }
    fenced || /^[[:space:]]*$/ || /^<sub>.*<\/sub>$/ { next }
    { lines++; chars += length($0) }
    END {
      if (lines > 2 || chars > 300) {
        printf "%s: %d prose lines, %d chars (max 2 lines, 300 chars)\n", body, lines, chars
        exit 1
      }
    }
  ' "$body" || status=1
done
exit "$status"
