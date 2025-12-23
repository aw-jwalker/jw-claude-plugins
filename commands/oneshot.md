---
description: Research ticket and launch planning session
---

This command combines research and planning into a single workflow.

1. Use SlashCommand() to call /ralph_research with the given ticket key
2. After research is complete, use SlashCommand() to call /ralph_plan with the same ticket key

Alternatively, if you want to launch a separate session for planning:
<!-- TODO: Update the launch command for your environment if needed -->
```
Launch a new Claude Code session with: "/ralph_plan PROJECT-XXX"
```

## Usage

```
/oneshot PROJECT-123
```

This will:
1. Research the ticket (gather codebase context, document findings)
2. Create an implementation plan based on the research
