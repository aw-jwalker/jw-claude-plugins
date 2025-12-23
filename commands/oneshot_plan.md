---
description: Execute planning and implementation for a ticket
---

This command combines planning and implementation into a single workflow.

1. Use SlashCommand() to call /ralph_plan with the given ticket key
2. After planning is complete and approved, use SlashCommand() to call /ralph_impl with the same ticket key

## Usage

```
/oneshot_plan PROJECT-123
```

This will:
1. Create an implementation plan for the ticket
2. Implement the plan once approved
3. Create commits and PR
4. Update the Jira ticket with PR link
