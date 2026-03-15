---
allowed-tools: Bash(gh pr:*), Bash(gh api:*), Bash(git rev-parse --show-toplevel)
description: Fetch CI failures from the pull request for the current branch. Analyze the logs for the failures and fix any issues.
argument-hint: [pr-number] (optional)
---

## Usage

```
/ci-failures [pr-number]
```

If no PR number provided, detect from current branch.

## Instructions

1. Get the PR number from argument or current branch:

   ```bash
   gh pr view --json number,headRefName --jq '"\(.number) \(.headRefName)"'
   ```

2. Run `gh pr checks <PR number>` to find the failing CI checks for the pull request.

3. **Prioritize the MOST RECENT run, even if in-progress:**
   - If the latest run is `in_progress` or `queued`, check it FIRST - it has the most relevant failures
   - Individual jobs complete before the overall run - analyze them as they finish
   - Only fall back to older completed runs if the current run has no completed jobs yet

4. Get all failed jobs from the run (works for in-progress runs too):

   ```bash
   gh api "repos/vercel/<repo name>>/actions/runs/{run_id}/jobs?per_page=100" \
     --jq '.jobs[] | select(.conclusion == "failure") | "\(.id) \(.name)"'
   ```

   **Note:** For runs with >100 jobs, paginate:

   ```bash
   gh api "repos/vercel/<repo name>/actions/runs/{run_id}/jobs?per_page=100&page=2"
   ```

5. Extract logs for the failing jobs. Always use the GitHub API endpoint for reliability:

   ```bash
   gh api "repos/vercel/<repo name>/actions/jobs/{job_id}/logs"
   ```

6. Analyze the logs and look for the failure messages. Make recommendations about how to fix the issues. If the user asked you to fix the issue, then automatically fix the issues.
