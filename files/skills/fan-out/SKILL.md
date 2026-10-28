---
name: fan-out
description: Run parallel workers in Rex split panes beside you so the user watches each one work. Use when the user asks to fan out, parallelize a task, or use subagents.
---

# Fan out

You are the orchestrator. Workers are separate `fx ask` processes, each in its own Rex pane in a column to your right, so the user can watch every worker live while you keep working.

The helper is `scripts/fan-out` in this skill's directory (`~/.agents/skills/fan-out/scripts/fan-out`); `fan-out` below means that path. Run `fan-out --help` for every command and option.

## 1. Pick the surface

- **Inside Rex** (`REX_SESSION` and `REX_BLOCK` are set): use `fan-out`. This is the default whenever the user asks for subagents.
- **Outside Rex**, or when a worker needs follow-up messages: use the built-in subagent tool and tell the user the panes aren't available.

## 2. Split the work

Split the task into 2–4 independent slices with no ordering between them; more panes than that are too short to read. Keep sequential or tightly coupled work for yourself.

Each slice is one of two kinds:

- **Research** (the default): reads, investigates, and reports, without editing. Its pane closes on its own once it succeeds, because its answer comes back through `wait`. A failed research pane stays open so the user can see the error.
- **Code**: edits files. Spawn it with `--code`, which keeps its pane open for the user to review and runs it with `--auto`. Give each code slice its own files or its own worktree (see the `worktrunk` skill).

Done when every slice has a label, a kind, a scope, and an expected output.

## 3. Brief each worker

A worker starts cold: it sees the workspace and its brief, nothing from this conversation. Write each brief as a self-contained handoff:

- the goal and why it matters
- the exact files, paths, or questions in scope
- what it may change, and "do not edit files" for read-only slices
- the shape of the answer: findings with file paths and line numbers, kept short

## 4. Spawn, then wait

Pipe each brief on stdin. Pass `--cwd` when the slice belongs to another directory or worktree.

```sh
fan-out spawn auth-flow <<'EOF'
<brief>
EOF
fan-out spawn --code session-store <<'EOF'
<brief>
EOF
fan-out wait
```

Tell the user which labels are running before calling `wait`. `wait` prints every worker's answer once all have exited. It exits 124 on timeout: check `fan-out status` and call `wait` again rather than respawning.

## 5. Synthesize

Treat worker answers as evidence. Spot-check the claims your conclusion depends on with your own reads before reporting them, and resolve disagreements between workers yourself. Give the user one combined answer, attributing points to worker labels where it helps.

Code panes stay open so the user can review them; offer `fan-out close` once they're done. Start the next fan-out with `fan-out close` so old panes don't pile up.
