---
name: pr
description: "Use when writing or updating a PR body."
---

Write PR bodies in this shape:

```markdown
<one or two sentences: the problem and what changes, in reviewer terms>

<visual: diff, pseudocode, call tree, or file tree>

**Merge danger:** <one-way | two-way> door, <blast radius in a few words>. <optional: one sentence on what could break>
```

When the PR changes several separate areas, give each one a short paragraph that starts with a bold label, then add its visual:

```markdown
**`dashboard.live.test.ts`** retries Slack's `blocks.validate` with a 15s deadline per attempt instead of hanging.

<diff>
```

## Rules

- Structure the body with bold labels only. Markdown headers of any level are too heavy for a PR body.
- Open with the substance: the problem or change in the first sentence. The title is already visible, so don't repeat it.
- Keep prose to 40–150 words, not counting snippets. Cut prose before you cut a snippet.
- Describe the outcome: what changed, why, and what a reviewer or deployer must do. Give a design choice one clause of reasoning, and only when a reviewer would otherwise question it.
- Reviewers trust CI and the diff stats GitHub already shows. Leave out:
  - Validation: test commands, test results, CI status, before/after evidence, checklists.
  - Change counts: number of files, `+12 −73`.
  - "Not addressed" or out-of-scope sections. If a reviewer must know about one excluded item, use one sentence.
  - The investigation: debugging stories, run IDs, timings, failure counts.
- If something is still needed before or after merge, write one line ("Production still needs `VERCEL_CLIENT_SECRET`.").
- Add `Closes ABC-123`, `Stacks on #123`, or `Companion PR: org/repo#123` on its own line when it applies.
- Use the user's domain language from `GLOSSARY.md` when it exists.

## Visuals

Show the few lines that carry the change, not the whole hunk. Most snippets are 3–10 lines. Collapse the rest with comments like `// ...41 lines of report assertions` or `{ ... }`. Pick the smallest view that makes the point:

- `diff`, when the point is what changes and the surrounding shape already exists. Match the diff to the topic: code, a component tree, a file tree, or a call tree.

```diff
 submitForm
   createSession
     persistPrompt
+    expandSkillMention
     launchAgent
```

- Pseudocode for logic or an algorithm.
- A call tree for runtime control flow.
- A component tree for UI structure, including the state and module boundaries that matter.
- A shallow file tree for a broad refactor.
- Mermaid for interaction or data flow across components.
- The whole block, when most of it is new or the reviewer needs to see the new API.

Put each visual right after the sentence it supports. A small PR may need only one visual. A one-line fix may need none.

## Merge danger

A two-way door is cheap to roll back. A one-way door is a destructive or hard-to-reverse change, such as a data migration, a deleted resource, a published API, or a sent message. The blast radius is what could break if the change is wrong, such as consumers, layout, mobile, a single test file, or production traffic. Consider every possibility, but write only the ones that are real.

## Example

```markdown
Fixes four flaky Omniagent unit tests that hit timeouts or real-time limits in CI.

**`agent-setup.test.ts`** stops rendering the HTML report, which cold-launched Chrome past the 30s timeout. `packages/evals` already covers report rendering.

<diff>
 expect(outcome.error).toBeUndefined();
-const html = await renderEvalReportHtml({ ... });
-const browser = await chromium.launch({ channel: "chrome" });
-// ...41 lines of report presentation assertions
</diff>

**`dashboard.live.test.ts`** retries Slack's `blocks.validate` with a 15s deadline per attempt instead of hanging.

<diff>
-const response = await fetch("https://slack.com/api/blocks.validate", {
+const response = await fetchWithRetry("https://slack.com/api/blocks.validate", {
   method: "POST",
+  timeoutMs: 15_000,
 });
</diff>

**`process-manager.test.ts`** checks the result instead of elapsed time. The time bound lives in a real Python subprocess, so fake timers can't control it.

<diff>
-mockInstalledRunner("import time; time.sleep(10)");
+mockInstalledRunner('import json, time; time.sleep(10); print(json.dumps({"totalBytes": 1024}))');
-expect(Date.now() - startedAt).toBeLessThan(5_000);
</diff>

**`tests/evals-cli/cli.ts`** gets a 30s timeout because it spawns the CLI twice as fresh Node processes.

**Merge danger:** two-way door, test-only. Omniagent no longer re-tests report presentation, which `packages/evals` owns.
```

In a real body, write each `<diff>...</diff>` as a fenced `diff` code block.

## Publishing with `gh`

Write the body to a temp file and pass `--body-file`. After a change to what the PR does, read the current body with `gh pr view` and rewrite it to describe the PR as it is now.
