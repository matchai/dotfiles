---
name: monthly-perf-checkin
description: Draft monthly performance check-in answers from Slack, Linear, GitHub PRs, and commits. Use when the user asks for monthly perf review/check-in content, especially “What did you ship?” or “Where do you want to grow?” for a specific month.
---

# Monthly Performance Check-In

Use this skill to answer **“What did you ship?”** and **“Where do you want to grow?”** from evidence. Write concise retrospective performance-check-in prose, not a changelog.

## Quick start

When the user names a month, gather the full calendar month with inclusive start and exclusive end boundaries:

```text
April 2026 => 2026-04-01T00:00:00Z through 2026-05-01T00:00:00Z
May 2026   => 2026-05-01T00:00:00Z through 2026-06-01T00:00:00Z
```

Then produce one paragraph per question. If comparing adjacent months, say whether any wins should move between months.

## Evidence gathering workflow

Gather all sources in parallel before drafting.

1. **Slack**
   - Load/use the `slack` skill and run its install check first.
   - Search project channels and relevant feedback channels for the month.
   - Prefer channel IDs from Linear project metadata when names are missing from cache.
   - Read threads for launches, project updates, metrics, beta/customer feedback, and blockers.

2. **Linear**
   - Load/use the `linear` skill.
   - Fetch project metadata, milestones, status updates, and issues updated during the month.
   - Treat Linear project updates as high-signal summaries, but verify with GitHub/Slack before making ownership claims.

3. **GitHub**
   - Use `gh` read-only commands.
   - Determine the authenticated login with `gh api user --jq .login`.
   - Search authored PRs created, merged, or updated during the month.
   - Read full PR bodies for non-trivial PRs; titles alone are not enough.
   - Search local git history for authored commits in likely repos.

4. **Repo history**
   - For known project repos, inspect merged PRs and commits on main during the month.
   - Separate personal contributions from team-wide project movement.
   - Note access limitations instead of guessing.

## Synthesis rules

### What did you ship?

Write one paragraph unless the user asks for bullets. Lead with shipped outcomes, then supporting proof.

Prefer:
- “Shipped X, which enabled Y.”
- “Reduced A from B to C.”
- “Moved Z from prototype to production by landing…”

Avoid:
- Long PR lists.
- Internal implementation detail without outcome.
- Claiming team-wide progress as personal work.
- Saying “worked on” when the question is “shipped.”

Use metrics when verified: latency, coverage, merged PR counts, test counts, cost reduction, milestone completion, launch state.

### Where do you want to grow?

Write one retrospective, forward-looking paragraph. Tie growth areas to what the month revealed.

Good growth themes:
- Turning prototype evidence into team-wide alignment.
- Operating production agent systems with stronger observability and rollout discipline.
- Improving reliability for state machines, approvals, streaming, and recovery paths.
- Communicating tradeoffs and migration paths earlier.
- Balancing speed with safety in multi-repo changes.

Avoid generic self-improvement. Do not repeat the shipped paragraph in weaker words.

## Month attribution

When work spans months, assign wins by where the outcome landed:
- Prototype built or benchmark proven => prototype month.
- Production integration, rollout, or measured platform impact => integration month.
- PR opened but not merged => usually “in review,” not shipped.
- Local-only work => mention only if it produced a demo, milestone, or clear shipped artifact.

If the user asks whether to “spread wins,” recommend moving only the parts that truly shipped in the later month.

## Output style

- Default to one paragraph per question, under ~120 words each unless asked for detail.
- Use first person for the user's review: “I shipped…” for personal work and “helped ship…” for team-wide outcomes.
- Mention repos/projects only when they clarify the shipped outcome.

## Verification checklist

Before finalizing, confirm sources were checked or limitations noted, month boundaries are correct, ownership is clear, shipped outcomes are concrete, growth is retrospective/forward-looking, and any attribution recommendation is explicit.
