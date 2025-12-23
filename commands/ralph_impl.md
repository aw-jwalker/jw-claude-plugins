---
description: Implement highest priority Jira ticket with implementation plan
model: sonnet
---

## PART I - IF A TICKET IS MENTIONED

0c. fetch the ticket details using `mcp__atlassian__getJiraIssue` with the ticket key
0d. read the ticket and all comments to understand the implementation plan and any concerns

## PART I - IF NO TICKET IS MENTIONED

0.  read commands/jira.md
0a. search for tickets in "Ready for Dev" status using `mcp__atlassian__searchJiraIssuesUsingJql`:
    <!-- TODO: Update PROJECT_KEY and status name to match your Jira -->
    JQL: `project = "TODO_PROJECT_KEY" AND status = "Ready for Dev" ORDER BY priority DESC, created ASC`
0b. select the highest priority small issue from the list (if no suitable issues exist, EXIT IMMEDIATELY and inform the user)
0c. fetch the full ticket details using `mcp__atlassian__getJiraIssue`
0d. read the ticket and all comments to understand the implementation plan and any concerns

## PART II - NEXT STEPS

think deeply

1. transition the ticket to "In Progress" status
1a. identify the linked implementation plan document from comments or attachments
1b. if no plan exists, transition the ticket back to "Ready for Plan" and EXIT with an explanation

think deeply about the implementation

2. read the implementation plan completely
2a. read commands/implement_plan.md for guidance on executing plans

3. implement the plan:
3a. follow each phase of the implementation plan
3b. run tests and verification after each phase
3c. pause for manual verification between phases if specified in the plan

4. when implementation is complete:
4a. read commands/commit.md and create appropriate commits
4b. read commands/describe_pr.md and create a PR
4c. add a comment to the Jira ticket with the PR link
4d. transition the ticket to "Code Review" status

think deeply, use TodoWrite to track your tasks. When searching Jira, get the top priority items but only work on ONE item.

## PART III - When you're done

Print a message for the user (replace placeholders with actual values):

```
✅ Completed implementation for PROJECT-XXX: [ticket title]

The implementation has been:

- Code changes committed
- PR created: [PR URL]
- Comment added to Jira ticket with PR link
- Ticket transitioned to "Code Review" status

Summary of changes:
- [Change 1]
- [Change 2]
- [Change 3]

View the ticket: [Jira ticket URL]
View the PR: [PR URL]
```

## TODO: Configure These Values

1. Replace `TODO_PROJECT_KEY` with your Jira project key
2. Update status names to match your Jira workflow ("Ready for Dev", "In Progress", "Code Review")
3. Configure transition IDs for status changes
