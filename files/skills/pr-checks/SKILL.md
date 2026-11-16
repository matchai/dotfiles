---
name: pr-checks
description: Use when creating a PR or pushing updates to an existing PR. Monitors CI status checks and handles failures.
---

# PR Status Checks

After creating a PR or pushing updates to an existing PR, you MUST monitor status checks and attempt to fix failures.

## Workflow

1. **Wait briefly** for CI checks to start (~5-10 seconds)
2. **Monitor checks** using `gh pr checks <PR_NUMBER> --watch`
3. **If checks fail**, for each failure:
   - Get the run ID from `gh pr checks` output (the URL contains it, or use `--json`)
   - View failed logs: `gh run view <RUN_ID> --log-failed`
   - **If a test job has been running >10 minutes without progress**, it's likely hanging due to open handles - see "Hanging Tests (Open Handles)" section below
   - Attempt to fix locally using the appropriate command (see Common Check Types below)
   - Not all checks can be run locally. Where they can't, make your best attempt at a fix
   - Only "fix" a check if there is a clear correction in line with the author's obvious intent (especially as documented in specs or comments). Where ambiguity exists, note it for later rather than guessing
4. **Push the fix(es)** and monitor checks again (repeat from step 1)
5. **Do not continue** with further actions until all non-deployment checks either pass, or are too ambiguous to be confidently resolved
6. **Report** the final check status to the user. If any failures were ambiguous and could not be confidently resolved, ask about the intended behaviour

## Commands

```bash
# Watch all checks until they finish
gh pr checks <PR_NUMBER> --watch

# Exit immediately on first failure
gh pr checks <PR_NUMBER> --watch --fail-fast

# View only the failed step logs
gh run view <RUN_ID> --log-failed

# View a specific job's full log
gh run view --job <JOB_ID> --log
```

### When to Escalate

**Attempt a fix when:**
- The open handle is in code being modified by the PR
- The fix is straightforward (adding cleanup, tracking async ops)

**Escalate to the user when:**
- The open handle originates in third-party code or core infrastructure
- The fix would require significant refactoring beyond the PR's scope
- You're unsure whether the async pattern is intentional

## Notes

- Some checks run only on specific file changes - if your change doesn't trigger a check, that's expected
- If a test check has been "in progress" for more than 10 minutes, investigate for hanging tests rather than waiting for the full CI timeout
