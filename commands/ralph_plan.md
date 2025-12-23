---
description: Create implementation plan for highest priority Jira ticket ready for planning
argument-hint: <AW-123>
---

## PART I - IF A TICKET IS MENTIONED

0c. fetch the ticket details using `mcp__atlassian__getJiraIssue` with the ticket key
0d. read the ticket and all comments to learn about past research and any questions or concerns

## PART I - IF NO TICKET IS MENTIONED

0.  read commands/jira.md
0a. search for tickets in "Ready for Plan" status using `mcp__atlassian__searchJiraIssuesUsingJql`:
    <!-- TODO: Update PROJECT_KEY and status name to match your Jira -->
    JQL: `project = "TODO_PROJECT_KEY" AND status = "Ready for Plan" ORDER BY priority DESC, created ASC`
0b. select the highest priority small issue from the list (if no suitable issues exist, EXIT IMMEDIATELY and inform the user)
0c. fetch the full ticket details using `mcp__atlassian__getJiraIssue`
0d. read the ticket and all comments to learn about past research and any questions or concerns

## PART II - NEXT STEPS

think deeply

1. transition the ticket to "Plan In Progress" status
1a. read commands/create_plan.md
1b. check if the ticket has a linked implementation plan document in comments or attachments
1c. if the plan exists and is complete, you're done - respond with a link to the ticket
1d. if no plan exists or it needs work, create a new plan document following the instructions in commands/create_plan.md

think deeply

2. when the plan is complete:
2a. add a comment to the ticket with a link to the plan document
2b. transition the ticket to "Plan In Review" status

think deeply, use TodoWrite to track your tasks. When searching Jira, get the top priority items but only work on ONE item.

## PART III - When you're done

Print a message for the user (replace placeholders with actual values):

```
✅ Completed implementation plan for PROJECT-XXX: [ticket title]

Approach: [selected approach description]

The plan has been:

Created at thoughts/shared/plans/YYYY-MM-DD-PROJECT-XXX-description.md
Comment added to the Jira ticket
Ticket transitioned to "Plan In Review" status

Implementation phases:
- Phase 1: [phase 1 description]
- Phase 2: [phase 2 description]
- Phase 3: [phase 3 description if applicable]

View the ticket: [Jira ticket URL]
```

## TODO: Configure These Values

1. Replace `TODO_PROJECT_KEY` with your Jira project key
2. Update status names to match your Jira workflow ("Ready for Plan", "Plan In Progress", "Plan In Review")
3. Configure transition IDs for status changes
