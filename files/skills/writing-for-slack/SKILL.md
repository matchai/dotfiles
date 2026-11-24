---
name: writing-for-slack
description: Use when drafting a Slack message, reply, or post for the user to paste, or copying anything to their clipboard for Slack. Covers what Slack renders and how to copy it so the formatting survives.
---

Write the draft in the user's voice, following the `tone-of-voice` skill when you have it. This skill covers the format and the copy.

## Copy with slackfmt

Write the draft as standard Markdown (`**bold**`, `_italic_`, `` `code` ``, `[label](url)`, `- ` lists) and pipe it to `slackfmt`:

```sh
slackfmt < draft.md
```

`slackfmt` puts Slack's own rich text on the clipboard, so links, lists, and blank lines survive the paste. It's done when it prints `Copied to clipboard!`; then tell the user the draft is ready to paste. In a t-rex box, `slackfmt` runs on the user's Mac, so the draft lands on their clipboard the same way.

Slack's own markup (`*bold*`, `<url|label>`) is for the API, not for pasting: `slackfmt` reads standard Markdown. To see how a draft converts without touching the clipboard, add `--stdout`.

## What renders

| Markdown | In Slack |
| --- | --- |
| Bold, italic, inline code, links | As written |
| Bullet and numbered lists, nested too | As lists |
| Quotes and fenced code blocks | As quotes and code blocks |
| Headings | A bold line. Use a bold lead-in instead |
| Tables | An aligned code block |

## Tables

When the table is the message, pipe the Markdown table on its own to `trx copy --table`. It copies it as a spreadsheet does, and Slack attaches the paste to the message as a real table.

In a message with prose, keep the table in the draft for `slackfmt`, which renders it as an aligned code block that reads well for a few rows. If the user wants a real table there, copy it with `trx copy --table` once they've pasted the prose, since each copy replaces the last.
