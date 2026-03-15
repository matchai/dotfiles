---
name: linear
description: Interact with Linear project management to search issues, create/update tickets, view projects, teams, and cycles. Use when managing tasks, tracking work, or querying Linear data.
mcp:
  linear:
    command: npx
    args: ["-y", "mcp-remote", "https://mcp.linear.app/mcp"]
---

# Linear Project Management

Use the Linear MCP tools to query and manage issues, projects, teams, and cycles.
Auth is handled automatically via OAuth on first connection.

## Query Strategy

### Understanding Issue States

| State Type | Common Names | Meaning |
|------------|--------------|---------|
| `triage` | Triage | New issues awaiting review |
| `backlog` | Backlog | Accepted but not scheduled |
| `unstarted` | Todo | Ready to work on |
| `started` | In Progress, In Review | Currently being worked on |
| `completed` | Done | Finished |
| `canceled` | Canceled | Won't be done |

### Interpreting User Intent

| User Says | What They Mean | Filter |
|-----------|----------------|--------|
| "open issues" | Not Done/Canceled | Exclude completed/canceled states |
| "active issues" | Currently being worked | Filter to "In Progress" state |
| "todo issues" | Ready to start | Filter to "Todo" state |
| "all issues" | Everything | No state filter |
| "completed issues" | Finished | Filter to "Done" state |

### When User Mentions a "Project"

When a user asks about issues for a specific project (e.g., "Project Level Routing issues"), they mean a **Linear project**, not a keyword search. Filter by project, don't search by keyword.

## Presenting Results

1. **Summarize key findings first**: "Found 5 issues assigned to you in the current sprint"
2. **Highlight important details**: identifiers, titles, states, assignees
3. **Include Linear URLs** for easy navigation
4. **Suggest next actions**: "Would you like me to update any of these?"

## Summarizing Work

When asked to summarize completed work:
1. Fetch issues filtered by assignee, state, and date range
2. Aggregate by month, project, and team
3. Identify themes from titles and project membership
4. Highlight high-priority completions (priority 1-2)