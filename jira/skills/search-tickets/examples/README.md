# Search Examples

Each file documents a completed search session including:

- **Context**: What was the user looking for?
- **Keywords used**: Which Rovo search terms worked well?
- **Results**: How many candidates found, how many kept?
- **Patterns identified**: What categories emerged?
- **Final JQL**: The resulting `key in (...)` query

## Template

```markdown
# [Date] - [Topic Description]

## Context
What the user was searching for and why.

## Search Keywords Used
1. "keyword combo 1" → X results
2. "keyword combo 2" → Y results
...

## Patterns Identified
1. Pattern name - description
2. Pattern name - description

## Final Ticket List
| Ticket | Summary | Status | Type | Priority |
|--------|---------|--------|------|----------|
| IWA-XXX | ... | ... | ... | ... |

## Final JQL
\`\`\`
key in (IWA-XXX, IWA-YYY, ...)
\`\`\`

## Label Applied
`label-name` (if applicable)

## Lessons Learned
- What keyword strategies worked well
- What was missed initially
- What to try differently next time
```
