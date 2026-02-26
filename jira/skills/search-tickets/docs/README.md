# Documentation

## Rate Limits

All Atlassian MCP tools share the same rate limit budget. The exact
threshold is not published, but in practice:

- **7+ parallel `getJiraIssue` calls will trigger 429 errors.**
  This was observed after running multiple Rovo searches followed by
  7 parallel issue fetches — the combination exhausted the budget.
- **Once throttled, immediate retries make it worse.** The 429 state
  persists and repeated calls extend the cooldown.
- **Rovo Search calls also count** against the shared budget.

### Safe limits (observed)

| Operation | Max parallel | Notes |
|-----------|-------------|-------|
| Rovo Search | 2-3 | Stagger in batches |
| `getJiraIssue` | 3 | Prefer bulk JQL instead |
| `searchJiraIssuesUsingJql` | 1-2 | Can fetch up to 100 tickets per call |
| `editJiraIssue` | 3 | For labeling operations |

### Recovery from 429

1. Stop all Atlassian MCP calls immediately
2. Wait 10-15 seconds
3. Resume with a single call
4. If still throttled, inform the user and wait longer

### Best practice: bulk JQL over individual fetches

Instead of 15 `getJiraIssue` calls, use 1 `searchJiraIssuesUsingJql`:

```
jql: "key in (IWA-1, IWA-2, ..., IWA-15)"
fields: ["summary", "status", "issuetype", "priority"]
maxResults: 50
```

This returns the same data in a single API call.

## Known Gotchas

### JQL text search is unreliable through the API

`summary ~ "keyword"` and `text ~ "keyword"` return 0 results for the
IWA project when used via the Atlassian MCP `searchJiraIssuesUsingJql`
tool. This appears to be a Jira search index issue specific to API
access. Always use Rovo Search (`mcp__claude_ai_Atlassian__search`)
for content-based discovery.

### JQL operator precedence

When combining OR and AND in JQL, wrap OR clauses in parentheses:

```
# WRONG - AND only applies to last OR clause
text ~ "swap" OR text ~ "replace" AND status NOT IN (Live, Closed)

# RIGHT - AND applies to all clauses
(text ~ "swap" OR text ~ "replace") AND status NOT IN (Live, Closed)
```

### getJiraIssue parameter name

The `getJiraIssue` MCP tool uses `issueIdOrKey` as the parameter name,
not `issueKey`. This has caused errors in past sessions.

### Rovo Search tips

- Append the project key (e.g., "IWA") to search queries to focus results
- Rovo searches across summary, description, and comments
- Results include a mix of ticket types and statuses — always fetch
  individual tickets to verify before including in results
- Run 5+ searches with varied keywords for comprehensive coverage

### Adding labels via editJiraIssue

When adding a label, you need to add it to the existing label array,
not replace it. Fetch the ticket first to get current labels, then
include all labels (existing + new) in the edit call.
