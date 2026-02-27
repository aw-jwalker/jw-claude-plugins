---
name: blame-tickets
description:
  Investigate code ownership for Jira tickets using git blame and git log.
  Maps tickets to the developer who last worked on the relevant code area.
  Use when assigning bugs, triaging tickets, or finding who owns a code area.
  Keywords: blame, git blame, code owner, assign ticket, who worked on,
  developer ownership, triage, assign bugs.
---

# Jira Ticket Code Ownership Investigation

Given a list of Jira tickets, investigate which developer last worked on the
relevant code area using git blame and git log. Produces a per-ticket
assignment recommendation with dates and rationale.

## Quick Start

When the user wants to find who should own a set of tickets, gather:

1. **Ticket list** - Jira keys, a JQL query, a Jira URL, or output from
   `jira:search-tickets`
2. **Repos** - Auto-discover from cwd (default), or user-specified paths

## Critical Rules

### Group tickets by component before investigating

Do NOT launch one agent per ticket. Instead, group tickets by their Jira
component (or by code area if components overlap) and launch one sub-agent
per group. Aim for **2-5 groups** to balance parallelism with efficiency.

If a ticket has no component, infer the code area from its summary and
description.

### Always use BOTH git log AND git blame

- **git log** = recency (who touched this area recently, when)
- **git blame** = ownership volume (who wrote most of this code)

A developer who wrote 500 lines 2 years ago may not be the right assignee
if someone else has been actively fixing bugs there for the past 3 months.
Weight recency heavily, but note ownership for context.

### Check for prior context first

If a `thoughts/` directory exists in any discovered repo, search it for
existing research, plans, or handoff documents referencing the ticket IDs.
This provides valuable context and may already identify the right developer.

### Use parallel sub-agents for investigation

Launch sub-agents using the Task tool with `subagent_type: "general-purpose"`.
Run them in the background (`run_in_background: true`) to parallelize.

Each sub-agent should be given:

- The ticket IDs and summaries in its group
- The repo paths to investigate
- The component-to-code mappings from `reference/component-code-map.md`
- Explicit instructions to run BOTH git log and git blame
- Instructions to search for commits referencing the ticket IDs

### Rate limit awareness for Jira API

Follow the same rate limit rules as `jira:search-tickets`:

- Max 3 parallel Atlassian MCP calls
- Use bulk JQL (`key in (...)`) instead of individual fetches
- On 429 errors, wait 10-15 seconds

## Step-by-Step Workflow

### Step 1: Parse Input

Extract ticket keys from the input. Supported formats:

- **Direct list**: `IWA-123, IWA-456, IWA-789`
- **JQL URL**: `https://nikolalabs.atlassian.net/issues?jql=key%20in%20(...)`
- **JQL query**: `key in (IWA-123, IWA-456)`
- **Previous skill output**: Ticket list from `jira:search-tickets`

URL-decode the JQL if needed. Extract all `IWA-XXXXX` patterns.

### Steps 2-4: Fetch Details, Discover Repos, Check Prior Context (parallel)

These three steps are independent -- run them simultaneously.

**Fetch ticket details** using `searchJiraIssuesUsingJql` with bulk fetch:

```
cloudId: "nikolalabs.atlassian.net"
jql: "key in (IWA-123, IWA-456, ...)"
fields: ["summary", "status", "issuetype", "priority", "assignee", "components", "labels"]
maxResults: 50
```

If more than 50 tickets, split into multiple JQL calls (not individual
fetches).

**Discover repos** from the working directory. Use user-specified paths if
provided. Otherwise, scan cwd for directories containing `.git/`:

```bash
find "$(pwd)" -maxdepth 2 -name ".git" -type d 2>/dev/null | sed 's/\/.git$//'
```

Confirm with the user if more than 3 repos are found.

**Check for prior context** -- if any discovered repo contains a `thoughts/`
directory, search it for references to the ticket IDs. This finds existing
research, plans, or handoff documents that may already identify the right
developer.

### Step 5: Group Tickets by Component/Code Area

Cluster tickets by their Jira component field. Tickets with the same or
overlapping components go in the same group. Guidelines:

- If a component has a `>` separator (e.g., `AssetDetail>AddEditMP`),
  the parent component (`AssetDetail`) can be used to merge related groups
- Tickets with no component should be grouped by keywords in their summary
- Check `reference/component-code-map.md` for known component-to-code mappings
- Aim for 2-5 groups total

### Step 6: Launch Parallel Investigations

For each group, launch a `general-purpose` sub-agent in the background.
Use the prompt template from [docs/README.md](docs/README.md), filling in
the group's tickets, repo paths, and component keywords.

Each agent should:

1. Find relevant files using component names and keywords
2. Run `git log` for recent activity (who, when)
3. Run `git blame` for code ownership (who owns the most lines)
4. Search for commits referencing the ticket IDs
5. Search for related historical bug fix commits

### Step 7: Compile Report

Once all agents complete, compile their findings into a unified report.
For each ticket, determine:

- **Primary assignee**: The developer with the strongest combination of
  recent activity + code ownership in the relevant area
- **Secondary assignee**: A backup developer with context
- **Last activity date**: When the primary assignee last committed to this
  code area
- **Key code area**: The most relevant file(s) for this ticket

### Step 8: Present Results

Present two tables:

**Per-Ticket Assignments:**

```markdown
| Ticket  | Summary         | Recommended Assignee | Secondary   | Last Activity | Key Code Area   |
| ------- | --------------- | -------------------- | ----------- | ------------- | --------------- |
| IWA-123 | Bug description | Developer A          | Developer B | 2026-02-15    | path/to/file.ts |
```

**Load Distribution:**

```markdown
| Developer   | Count | Tickets                   |
| ----------- | ----- | ------------------------- |
| Developer A | 3     | IWA-123, IWA-456, IWA-789 |
```

Also note:

- Any tickets that appear to be duplicates or closely related
- Tickets where the assignee has not touched the code recently (risk flag)
- Uneven load distribution that might need rebalancing

## Reference Files

- [reference/component-code-map.md](reference/component-code-map.md) - Component-to-code-area mappings
- [docs/README.md](docs/README.md) - Git commands, interpretation tips, sub-agent prompt template
- [examples/](examples/) - Past investigation sessions

---

## Improving This Skill

After completing an investigation, capture learnings. Write to the source
repo (`jw-claude-plugins/jira/skills/blame-tickets/`), NOT to the plugin
cache.

- **Investigation examples** -> `examples/YYYY-MM-DD-description.md`
- **New component mappings** -> `reference/component-code-map.md`
- **New git patterns** -> `docs/README.md`
