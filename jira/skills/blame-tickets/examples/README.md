# Investigation Examples

Each file documents a completed blame/ownership investigation session:

- **Context**: What tickets were being investigated and why
- **Groupings**: How tickets were clustered for parallel investigation
- **Results**: Per-ticket assignments with dates and rationale
- **Lessons learned**: What worked, what to improve

## Template

```markdown
# [Date] - [Topic Description]

## Context

What tickets were being investigated and why.

## Tickets

| Ticket  | Summary | Component | Status |
| ------- | ------- | --------- | ------ |
| IWA-XXX | ...     | ...       | ...    |

## Investigation Groups

### Group 1: [Area Name]

- Tickets: IWA-XXX, IWA-YYY
- Repos searched: fullstack.assetwatch, backend.jobs
- Key files investigated: ...

## Results

| Ticket  | Recommended Assignee | Secondary   | Last Activity | Key Code Area |
| ------- | -------------------- | ----------- | ------------- | ------------- |
| IWA-XXX | Developer A          | Developer B | 2026-02-15    | path/to/file  |

## Load Distribution

| Developer   | Count | Tickets                   |
| ----------- | ----- | ------------------------- |
| Developer A | 3     | IWA-XXX, IWA-YYY, IWA-ZZZ |

## Lessons Learned

- What investigation patterns worked well
- Component mappings discovered
- Gotchas encountered
```
