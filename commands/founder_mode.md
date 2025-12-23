---
description: Create Jira ticket and PR for experimental features after implementation
---

You're working on an experimental feature that didn't get the proper ticketing and PR stuff set up.

Assuming you just made a commit, here are the next steps:

1. Get the SHA of the commit you just made (if you didn't make one, read `commands/commit.md` and make one)

2. Read `commands/jira.md` - think deeply about what you just implemented, then create a Jira ticket about what you just did:
   - Use `mcp__atlassian__createJiraIssue` to create the ticket
   - Set it to "In Progress" status
   - It should have sections for "Problem to Solve" and "Solution Implemented"
   <!-- TODO: Update PROJECT_KEY -->
   - Project key: `TODO_PROJECT_KEY`

3. Create a branch named after the ticket:
   ```bash
   git checkout main
   git checkout -b 'PROJECT-XXX-description'
   git cherry-pick 'COMMIT_SHA'
   git push -u origin 'PROJECT-XXX-description'
   ```

4. Create the PR:
   ```bash
   gh pr create --fill
   ```

5. Read `commands/describe_pr.md` and follow the instructions to add a proper PR description

6. Add a comment to the Jira ticket with the PR link

7. Transition the ticket to "Code Review" status

## Usage

```
/founder_mode
```

This is for when you've been hacking on something experimental and now want to formalize it with proper ticketing and PR workflow.

## TODO: Configure These Values

1. Replace `TODO_PROJECT_KEY` with your Jira project key
2. Update status names to match your Jira workflow
