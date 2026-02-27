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

### Rate Limit Awareness

The Atlassian MCP API has rate limits that are easy to hit. **All
Atlassian MCP calls share the same rate limit budget** — Rovo searches,
`getJiraIssue`, `searchJiraIssuesUsingJql`, and `editJiraIssue` all
count against it.

**Rules to avoid throttling:**

1. **Never fire more than 3 Atlassian MCP calls in parallel.** Stagger
   searches into batches of 2-3.
2. **Use bulk JQL instead of individual fetches.** To get details on 10
   tickets, use one `searchJiraIssuesUsingJql` call with
   `key in (IWA-1, IWA-2, ...)` instead of 10 separate `getJiraIssue`
   calls. Set `maxResults` to cover all tickets (up to 100).
3. **On 429 "Too Many Requests" errors, stop and wait.** Do not retry
   immediately — this makes it worse. Wait 10-15 seconds before the
   next call.
4. **Don't retry failed calls in a loop.** If you get throttled, wait
   once, then continue with a single call. If still throttled, tell
   the user and pause.

### Run multiple searches with staggering

A single search will miss tickets. Run **5-8 Rovo searches** with
varied keyword combinations, but **stagger them in batches of 2-3**
to avoid rate limits. Think about:

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

### Step 3: Run Rovo Searches (Staggered)

Run 5-8 searches using `mcp__claude_ai_Atlassian__search`, **in batches
of 2-3 at a time** to avoid rate limits:

```
Batch 1 (parallel):
  Search 1: "sensor schedule missing swap IWA"
  Search 2: "receiver schedule not applied replace IWA"
  Search 3: "monitoring point modal sensor duplicate IWA"

Batch 2 (parallel, after batch 1 completes):
  Search 4: "Facility_Receiver MonitoringPoint_Receiver bad data IWA"
  Search 5: "sensor assigned wrong facility inventory IWA"

Batch 3 (if needed):
  Search 6: "sensor removal reason missing guardrail IWA"
  Search 7: "sensor transfer inventory assigned devices IWA"
```

Always append the project key (e.g., "IWA") to focus results.

### Step 4: Deduplicate & Collect Candidates

Merge results from all searches. Remove duplicates by ticket key.
You will likely have 15-30 candidate tickets.

### Step 5: Fetch Ticket Details (Bulk)

**Prefer bulk JQL over individual fetches** to minimize API calls and
avoid rate limits.

**Primary method — bulk JQL fetch:**

Use `searchJiraIssuesUsingJql` with a `key in (...)` query to fetch
all candidates at once (up to 100 per call):

```
cloudId: "1d52b6e0-a650-4fcd-a003-6f250217a316"
jql: "key in (IWA-123, IWA-456, IWA-789, ...)"
fields: ["summary", "status", "issuetype", "priority"]
maxResults: 50
```

If you have more than 50 candidates, split into 2 JQL calls (not 50
individual `getJiraIssue` calls).

**Fallback — individual fetch:**

Only use `getJiraIssue` (with `issueIdOrKey` parameter, NOT `issueKey`)
when you need the full description or fields not available through
search. Limit to **3 parallel calls max**.

**Check each ticket for:**

- **Status** - Is it in the included statuses?
- **Type** - Is it Bug/Task (or whatever the user specified)?
- **Summary** - Is it actually related to the topic?

Filter out tickets that don't match. Be aggressive about filtering
status/type but conservative about relevance — let the user decide
borderline cases.

### Step 6: Present Results

Show the filtered tickets in a table grouped by category/pattern:

```markdown
### Category Name

| Ticket  | Summary          | Status                | Priority | Type |
| ------- | ---------------- | --------------------- | -------- | ---- |
| IWA-123 | Description here | Ready for Development | P2       | Bug  |
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
   - **Apply labels in batches of 3** to avoid rate limits
3. Confirm completion and provide the label-based JQL:
   ```
   project = IWA AND labels = "sensor-schedule-bugs"
   ```

This lets anyone find the group later without the static `key in` query.

### Step 9: Optional Developer Investigation

After identifying a set of tickets, you can investigate which developer
should own each one based on git blame/log analysis.

> Use the `jira:blame-tickets` skill with the ticket list to map tickets
> to code owners via git blame and git log.

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
  `jw-claude-plugins/jira/skills/search-tickets/`
- NOT to cache: `~/.claude/plugins/cache/jw-claude-plugins/...`

### What to Capture

- **Search examples** → `examples/YYYY-MM-DD-description.md`
- **Keyword templates** → `templates/topic-name.json`
- **Project metadata updates** → `reference/project-metadata.md`

### When to Update

- After finding a new effective keyword strategy
- After discovering new project metadata (statuses, components)
- After a search session that reveals patterns worth documenting
