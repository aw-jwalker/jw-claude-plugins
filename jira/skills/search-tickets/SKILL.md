---
name: search-tickets
description:
  Search Jira for tickets by topic, group them, and produce a JQL query.
  Use when searching for related bugs, grouping tickets by theme, or
  building a ticket list. Keywords: search jira, find tickets, group bugs,
  related tickets, ticket list, JQL query.
---

# Jira Ticket Search & Grouping

Search for related Jira tickets by topic, filter by status/type, and
produce a grouped `key in (...)` JQL query. Optionally label tickets
for persistent grouping.

## Quick Start

When the user wants to search for related Jira tickets, gather:

1. **Topic / keywords** - What are the tickets about?
2. **Type filter** - Bug, Task, Story, Epic, or any (default: Bug + Task)
3. **Status filter** - Which statuses to include/exclude (default: exclude
   Live, Closed, Obsolete)
4. **Project** - Which Jira project (default: IWA)

## Critical Rules

### ALWAYS use Rovo Search for discovery

**DO NOT** use JQL `text ~` or `summary ~` for searching ticket content.
These return unreliable results (often 0 hits) through the Atlassian MCP
API, especially for the IWA project.

**ALWAYS** use `mcp__claude_ai_Atlassian__search` (Rovo Search) as the
primary discovery method. It searches across summary, description, and
comments far more effectively.

### JQL is for filtering, not discovery

Use JQL (`searchJiraIssuesUsingJql`) only for:

- Fetching a known set of tickets: `key in (IWA-123, IWA-456)`
- Filtering by structured fields: `status`, `type`, `priority`, `labels`
- Final output queries

### Run multiple searches in parallel

A single search will miss tickets. Run **5+ parallel Rovo searches** with
varied keyword combinations to get comprehensive coverage. Think about:

- Synonyms (sensor / receiver, schedule / rate, swap / replace / change)
- Different angles (the UI action, the DB tables, the symptom, the root cause)
- Related concepts (the feature area, the workflow, the error type)

## Step-by-Step Workflow

### Step 1: Understand the Request

Ask the user (or infer from context):

- What topic/theme are we searching for?
- What ticket types? (default: Bug + Task)
- What statuses to exclude? (default: Live, Closed, Obsolete)
- Which project? (default: IWA)

### Step 2: Generate Search Keywords

From the topic, generate **5-8 keyword combinations** that cover:

- Direct terms (e.g., "sensor schedule missing")
- Synonyms (e.g., "receiver schedule not applied")
- UI references (e.g., "monitoring point modal swap")
- Technical references (e.g., "Facility_Receiver duplicate")
- Symptom descriptions (e.g., "sensor assigned two facilities")

### Step 3: Run Parallel Rovo Searches

Run 5+ searches in parallel using `mcp__claude_ai_Atlassian__search`:

```
Search 1: "sensor schedule missing swap IWA"
Search 2: "receiver schedule not applied replace IWA"
Search 3: "monitoring point modal sensor duplicate IWA"
Search 4: "Facility_Receiver MonitoringPoint_Receiver bad data IWA"
Search 5: "sensor assigned wrong facility inventory IWA"
```

Always append the project key (e.g., "IWA") to focus results.

### Step 4: Deduplicate & Collect Candidates

Merge results from all searches. Remove duplicates by ticket key.
You will likely have 15-30 candidate tickets.

### Step 5: Fetch Ticket Details

For each candidate, fetch details using `getJiraIssue` with
`issueIdOrKey` parameter (NOT `issueKey`). Check:

- **Status** - Is it in the included statuses?
- **Type** - Is it Bug/Task (or whatever the user specified)?
- **Summary** - Is it actually related to the topic?

Filter out tickets that don't match. Be aggressive about filtering
status/type but conservative about relevance — let the user decide
borderline cases.

**Important parameter note**: The `getJiraIssue` tool uses
`issueIdOrKey`, not `issueKey`.

### Step 6: Present Results

Show the filtered tickets in a table grouped by category/pattern:

```markdown
### Category Name
| Ticket | Summary | Status | Priority | Type |
|--------|---------|--------|----------|------|
| IWA-123 | Description here | Ready for Development | P2 | Bug |
```

Include:

- How many total candidates were found vs how many passed filters
- The categories/patterns you identified
- Any borderline tickets the user should review

### Step 7: User Refinement

The user will review and may remove some tickets. After refinement,
produce the final JQL:

```
key in (IWA-123, IWA-456, IWA-789)
```

### Step 8: Optional Labeling

Ask the user:

> "Would you like to add a label to these tickets for persistent
> grouping? For example: `sensor-schedule-bugs`"

If yes:

1. Confirm the label name with the user
2. For each ticket, use `editJiraIssue` to add the label:
   - Use `issueIdOrKey` for the ticket key
   - Add the label to the existing labels (don't replace them)
3. Confirm completion and provide the label-based JQL:
   ```
   project = IWA AND labels = "sensor-schedule-bugs"
   ```

This lets anyone find the group later without the static `key in` query.

## Project Reference

For project metadata (keys, statuses, components), see
[reference/project-metadata.md](reference/project-metadata.md).

## Search Examples

For examples of past searches and keyword strategies, see the
[examples/](examples/) directory.

## Search Templates

For reusable keyword templates by topic area, see the
[templates/](templates/) directory.

---

## Improving This Skill

After completing a search session, capture learnings by creating files
in the subdirectories.

**CRITICAL - File Locations:**

- Write to source repo:
  `C:\Users\JacksonWalker\repos\jw-claude-plugins\jira\skills\search-tickets\`
- NOT to cache: `~/.claude/plugins/cache/jw-claude-plugins/...`

### What to Capture

- **Search examples** → `examples/YYYY-MM-DD-description.md`
- **Keyword templates** → `templates/topic-name.json`
- **Project metadata updates** → `reference/project-metadata.md`

### When to Update

- After finding a new effective keyword strategy
- After discovering new project metadata (statuses, components)
- After a search session that reveals patterns worth documenting
