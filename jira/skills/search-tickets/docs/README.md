# Documentation

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
