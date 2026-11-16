---
name: review-pr
description: "Review a GitHub PR by asking how to simplify it, stage the findings as comments in a pending review, and ask before submitting. Use when asked to review a PR or leave review comments on one."
---

Every review answers one question: **how can we simplify this PR?** Simplification surfaces bugs: when the simpler shape behaves differently from the PR's, that difference is usually a bug, so name it in the comment.

## Steps

1. **Read the PR.** Fetch its metadata, base branch, head SHA, and diff (`gh pr view <n> --json ...`, `gh pr diff <n>`). Read the touched files at the head SHA, plus their callers and the conventions nearby (`AGENTS.md`, sibling code the PR is modelled on). Done when you can say why each touched area is shaped the way it is.

2. **Simplify.** Load `make-native` and run its steps 1–4 as a read-only lens: each redesign it finds becomes a candidate comment instead of a commit. Done when every piece the PR adds (step, branch, flag, file, test, duplicated logic) is either already native or has a candidate.

3. **Pick the few that matter.** Keep the review short and focused: comment on the bugs and the simplifications that remove the most code or concepts, usually three to five. Fold repeats of one idea into a single comment that lists the other sites. Leave the rest out.

4. **Write the comments.** Load `tone-of-voice` and follow its "Reviewing a PR" recipe for wording; this skill owns length. Each comment is one idea in at most two lines of prose, proposing a simpler shape or naming a bug the simpler shape revealed, with no closing caveat or way out. Point at the rule or sibling file that backs it, when there is one. End each body with `<sub>Drafted by fx, reviewed by Matan</sub>` on its own line, so readers can tell the agent's comments from Matan's own. Write each body to its own file; done when `scripts/check-comment-length.sh <files>` passes, so cut whatever it flags.

   Show the change as a GitHub suggestion whenever it replaces a contiguous run of lines in the diff, so the author can apply it in one click. Anchor the comment on exactly the lines it replaces (`startLine` to `line`), and write the block as the full replacement for that range, matching its indentation:

   ````markdown
   Small nit: `.github/AGENTS.md` asks multi-line `run:` blocks to start with `set -euo pipefail`

   ```suggestion
           run: |
             set -euo pipefail
   ```
   ````

   Use a plain fenced code block when the change spans files, non-contiguous lines, or lines outside the diff.

5. **Stage the pending review.** GitHub allows one pending review per user per PR. Find yours:

   ```sh
   gh api graphql -f query='query{repository(owner:"OWNER",name:"REPO"){pullRequest(number:N){id headRefOid reviews(last:20,states:PENDING){nodes{id author{login} body comments(first:100){nodes{path line body}}}}}}}'
   ```

   Keep only a review authored by `gh api user -q .login`. If none exists, create one with `addPullRequestReview(input:{pullRequestId:...})` and no `event`, which leaves it pending. Skip any finding an existing comment in the review already covers.

6. **Add each comment** with `addPullRequestReviewThread` (`pullRequestReviewId`, `path`, `line`, optional `startLine`, `side: RIGHT`), passing the body from a file with `-F body=@file`. Keep each highlighted range under 10 lines: a comment about a whole function or block goes on its signature line alone, with no `startLine`. A suggestion can highlight the lines it replaces up to 30 lines; one that would replace 30 or more becomes a plain code block on the signature line. A line outside the diff's hunks returns `thread: null` with no error. Check every response, then re-anchor a failed comment to the nearest line inside a hunk (`@@ ... +start,count @@`) and name the step or symbol in its text. A re-anchored suggestion would replace the wrong lines, so turn it into a plain code block. Re-query the review and confirm it is `PENDING` with every comment.

7. **Ask whether to submit.** First send a short message with a table of the review's comments (file, lines, one-line gist, whether it's a suggestion) and any anchors you moved. Then ask with the question tool, which carries the preview:
   - **Question:** the ask and the review link on one line, such as `Submit your review on #106952? Review: https://github.com/vercel/api/pull/106952/files`. The Files tab shows the pending comments to their author.
   - **Options:** **Comment**, plus **Approve** when no comment names a bug, or **Request changes** when one names a bug that must be fixed before merging, then **Keep pending**. Each option that submits describes the exact submission as plain text: the event and its inline comment count, such as `Comment: submit the 3 inline comments`. **Keep pending** says `Don't submit`.

8. **Submit only on a yes.** Call `submitPullRequestReview(input:{pullRequestReviewId:..., event:COMMENT|APPROVE|REQUEST_CHANGES})` with the chosen event and no `body`: the inline comments are the whole review, and GitHub accepts an empty body for a review that has them. Report the returned review URL and state. On **Keep pending**, leave the review untouched and report its link.

Done when the user has answered, and the review is submitted as chosen or left pending.
