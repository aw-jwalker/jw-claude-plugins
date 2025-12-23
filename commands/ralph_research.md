---
description: Research highest priority Jira ticket needing investigation
---

## PART I - IF A JIRA TICKET IS MENTIONED

0c. fetch the ticket details using `mcp__atlassian__getJiraIssue` with the ticket key (e.g., PROJECT-123)
0d. read the ticket description and all comments to understand what research is needed and any previous attempts

## PART I - IF NO TICKET IS MENTIONED

0.  read .claude/commands/jira.md (or the plugin's commands/jira.md)
0a. search for tickets in "Research Needed" status using `mcp__atlassian__searchJiraIssuesUsingJql`:
    <!-- TODO: Update PROJECT_KEY and status name to match your Jira -->
    JQL: `project = "TODO_PROJECT_KEY" AND status = "Research Needed" ORDER BY priority DESC, created ASC`
0b. select the highest priority small issue from the list (if no suitable issues exist, EXIT IMMEDIATELY and inform the user)
0c. fetch the full ticket details using `mcp__atlassian__getJiraIssue`
0d. read the ticket and all comments to understand what research is needed and any previous attempts

## PART II - NEXT STEPS

think deeply

1. transition the ticket to "Research In Progress" status
   <!-- TODO: Configure the transition ID for your Jira workflow -->
1a. read any linked documents to understand context
1b. if insufficient information to conduct research, add a comment asking for clarification and transition back to "Research Needed"

think deeply about the research needs

2. conduct the research:
2a. read commands/research_codebase.md for guidance on effective codebase research
2b. if the ticket comments suggest web research is needed, use WebSearch to research external solutions, APIs, or best practices
2c. search the codebase for relevant implementations and patterns
2d. examine existing similar features or related code
2e. identify technical constraints and opportunities
2f. Be unbiased - don't think too much about an ideal implementation plan, just document all related files and how the systems work today
2g. document findings in a new thoughts document: `thoughts/shared/research/YYYY-MM-DD-PROJECT-XXX-description.md`
   - Format: `YYYY-MM-DD-PROJECT-XXX-description.md` where:
     - YYYY-MM-DD is today's date
     - PROJECT-XXX is the ticket key
     - description is a brief kebab-case description of the research topic

think deeply about the findings

3. synthesize research into actionable insights:
3a. summarize key findings and technical decisions
3b. identify potential implementation approaches
3c. note any risks or concerns discovered
<!-- TODO: Add sync command if your team has one, or use git commit -->

4. update the ticket:
4a. add a comment with a link to the research document
4b. transition the ticket to "Ready for Plan" status (or "Research In Review" if that exists)

think deeply, use TodoWrite to track your tasks. When searching Jira, get the top priority items but only work on ONE item.

## PART III - When you're done

Print a message for the user (replace placeholders with actual values):

```
✅ Completed research for PROJECT-XXX: [ticket title]

Research topic: [research topic description]

The research has been:

Created at thoughts/shared/research/YYYY-MM-DD-PROJECT-XXX-description.md
Comment added to the Jira ticket
Ticket transitioned to "Ready for Plan" status

Key findings:
- [Major finding 1]
- [Major finding 2]
- [Major finding 3]

View the ticket: [Jira ticket URL]
```

## TODO: Configure These Values

1. Replace `TODO_PROJECT_KEY` with your Jira project key
2. Update status names to match your Jira workflow ("Research Needed", "Research In Progress", "Ready for Plan")
3. Configure transition IDs for status changes
