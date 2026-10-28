---
name: fork
description: Fork the current fx session into a Rex split pane that resumes a copy of the conversation so far. Use when the user says /fork or asks to fork, branch, or duplicate this session or conversation.
---

# Fork

Run the helper and nothing else first:

```sh
~/.agents/skills/fork/scripts/fork
```

It finds the fx session running you, copies it into a new session that ends at the last finished turn (this `/fork` request is left out), and opens `fx session resume <new-id>` in a Rex split to the right of your pane. Pass `--split below` (or `left`, `above`) when the user asks for a different side, and `--help` for the other options.

Then tell the user the new session id in one sentence and stop. Don't continue the earlier task here unless the user asks; the fork carries it on.

If the helper exits 2, you're not in a Rex pane: give the user the `fx session resume <new-id>` command it printed. For any other failure, report its message.
