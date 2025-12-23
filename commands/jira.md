---
description: Manage Jira tickets - create, update, comment, and follow workflow patterns
argument-hint: <create | update AW-123 | comment AW-123>
---

# Jira - Ticket Management

You are tasked with managing Jira tickets, including creating tickets from thoughts documents, updating existing tickets, and following the team's specific workflow patterns.

## Initial Setup

First, verify that Jira MCP tools are available by checking if any `mcp__atlassian__` tools exist. If not, respond:
```
I need access to Jira tools to help with ticket management. Please ensure the Atlassian MCP server is configured, then try again.

Required environment variables:
- ATLASSIAN_SITE_URL
- ATLASSIAN_USER_EMAIL
- ATLASSIAN_API_TOKEN
```

If tools are available, respond based on the user's request:

### For general requests:
```
I can help you with Jira tickets. What would you like to do?
1. Create a new ticket from a thoughts document
2. Add a comment to a ticket (I'll use our conversation context)
3. Search for tickets
4. Update ticket status or details
```

### For specific create requests:
```
I'll help you create a Jira ticket from your thoughts document. Please provide:
1. The path to the thoughts document (or topic to search for)
2. Any specific focus or angle for the ticket (optional)
```

Then wait for the user's input.

## Team Workflow & Status Progression

<!-- TODO: Configure these statuses to match your Jira workflow -->
The team follows a specific workflow to ensure alignment before code implementation:

1. **To Do** → All new tickets start here for initial review
2. **Research Needed** → Ticket requires investigation before plan can be written
3. **Research In Progress** → Active research/investigation underway
4. **Ready for Plan** → Research complete, ticket needs an implementation plan
5. **Plan In Progress** → Actively writing the implementation plan
6. **Plan In Review** → Plan is written and under discussion
7. **Ready for Dev** → Plan approved, ready for implementation
8. **In Progress** → Active development
9. **Code Review** → PR submitted
10. **Done** → Completed

**Key principle**: Review and alignment happen at the plan stage (not PR stage) to move faster and avoid rework.

## Important Conventions

### URL Mapping for Thoughts Documents
When referencing thoughts documents, provide GitHub links using attachments or comments:
- `thoughts/shared/...` → `https://github.com/AssetWatch1/[repo]/blob/main/thoughts/shared/...`
- `thoughts/[user]/...` → `https://github.com/AssetWatch1/[repo]/blob/main/thoughts/[user]/...`

<!-- TODO: Update the GitHub org/repo above to match your actual repository -->

### Default Values
<!-- TODO: Configure these defaults for your Jira project -->
- **Status**: Always create new tickets in "To Do" status
- **Project**: Default project key is `TODO_PROJECT_KEY`
- **Priority**: Default to Medium for most tasks
  - Highest: Critical blockers, security issues
  - High: Important features with deadlines, major bugs
  - Medium: Standard implementation tasks (default)
  - Low: Nice-to-haves, minor improvements

### Automatic Label Assignment
<!-- TODO: Configure labels for your team -->
Automatically apply labels based on the ticket content:
- **backend**: For tickets about backend/API changes
- **frontend**: For tickets about UI changes
- **infrastructure**: For tickets about deployment/DevOps

## Action-Specific Instructions

### 1. Creating Tickets from Thoughts

#### Steps to follow after receiving the request:

1. **Locate and read the thoughts document:**
   - If given a path, read the document directly
   - If given a topic/keyword, search thoughts/ directory using Grep to find relevant documents
   - If multiple matches found, show list and ask user to select
   - Create a TodoWrite list to track: Read document → Analyze content → Draft ticket → Get user input → Create ticket

2. **Analyze the document content:**
   - Identify the core problem or feature being discussed
   - Extract key implementation details or technical decisions
   - Note any specific code files or areas mentioned
   - Look for action items or next steps
   - Identify what stage the idea is at (early ideation vs ready to implement)

3. **Check for related context (if mentioned in doc):**
   - If the document references specific code files, read relevant sections
   - If it mentions other thoughts documents, quickly check them
   - Look for any existing Jira tickets mentioned

4. **Draft the ticket summary:**
   Present a draft to the user:
   ```
   ## Draft Jira Ticket

   **Title**: [Clear, action-oriented title]

   **Description**:
   [2-3 sentence summary of the problem/goal]

   ## Key Details
   - [Bullet points of important details from thoughts]
   - [Technical decisions or constraints]
   - [Any specific requirements]

   ## Implementation Notes (if applicable)
   [Any specific technical approach or steps outlined]

   ## References
   - Source: `thoughts/[path/to/document.md]` ([View on GitHub](converted GitHub URL))
   - Related code: [any file:line references]
   - Parent ticket: [if applicable]

   ---
   Based on the document, this seems to be at the stage of: [ideation/planning/ready to implement]
   ```

5. **Interactive refinement:**
   Ask the user:
   - Does this summary capture the ticket accurately?
   - What priority? (Default: Medium)
   - Any additional context to add?
   - Should we include more/less implementation detail?
   - Do you want to assign it to yourself?

6. **Create the Jira ticket:**
   ```
   Use mcp__atlassian__createJiraIssue or similar with:
   - summary: [refined title]
   - description: [final description in markdown]
   - projectKey: [TODO_PROJECT_KEY]
   - issueType: [Story/Task/Bug]
   - priority: [selected priority]
   - assignee: [if requested]
   - labels: [apply automatic label assignment from above]
   ```

7. **Post-creation actions:**
   - Show the created ticket URL
   - Ask if user wants to:
     - Add a comment with additional implementation details
     - Create sub-tasks for specific action items
     - Update the original thoughts document with the ticket reference

### 2. Adding Comments to Existing Tickets

When user wants to add a comment to a ticket:

1. **Determine which ticket:**
   - Use context from the current conversation to identify the relevant ticket
   - If uncertain, use `mcp__atlassian__getJiraIssue` to show ticket details and confirm with user
   - Look for ticket references in recent work discussed

2. **Format comments for clarity:**
   - Keep comments concise (~10 lines) unless more detail is needed
   - Focus on the key insight or most useful information for a human reader
   - Not just what was done, but what matters about it
   - Include relevant file references with backticks

3. **Comment structure example:**
   ```markdown
   Implemented retry logic in webhook handler to address rate limit issues.

   Key insight: The 429 responses were clustered during batch operations,
   so exponential backoff alone wasn't sufficient - added request queuing.

   Files updated:
   - `src/webhooks/handler.ts`
   - `thoughts/shared/rate_limit_analysis.md`
   ```

### 3. Searching for Tickets

When user wants to find tickets:

1. **Gather search criteria:**
   - Query text
   - Project filters
   - Status filters
   - Assignee

2. **Execute search using JQL:**
   ```
   Use mcp__atlassian__searchJiraIssuesUsingJql with JQL query like:
   - project = "PROJECT_KEY" AND text ~ "search term"
   - project = "PROJECT_KEY" AND status = "In Progress"
   - assignee = currentUser() AND status != Done
   ```

3. **Present results:**
   - Show ticket key, title, status, assignee
   - Group by status if helpful
   - Include direct links to Jira

### 4. Updating Ticket Status

When moving tickets through the workflow:

1. **Get current status:**
   - Fetch ticket details with `mcp__atlassian__getJiraIssue`
   - Show current status in workflow

2. **Suggest next status based on workflow:**
   <!-- TODO: Map these to your actual Jira transition IDs -->
   - To Do → Research Needed (needs investigation)
   - Research Needed → Research In Progress (starting research)
   - Research In Progress → Ready for Plan (research complete)
   - Ready for Plan → Plan In Progress (starting plan)
   - Plan In Progress → Plan In Review (plan written)
   - Plan In Review → Ready for Dev (plan approved)
   - Ready for Dev → In Progress (work started)
   - In Progress → Code Review (PR submitted)
   - Code Review → Done (merged)

3. **Update with transition:**
   Use the appropriate Jira transition API to move the ticket.
   Consider adding a comment explaining the status change.

## Important Notes

- Keep tickets concise but complete - aim for scannable content
- All tickets should include a clear "problem to solve" - if the user asks for a ticket and only gives implementation details, ask "To write a good ticket, please explain the problem you're trying to solve from a user perspective"
- Focus on the "what" and "why", include "how" only if well-defined
- Always preserve links to source material
- Don't create tickets from early-stage brainstorming unless requested
- Include code references as: `path/to/file.ext:linenum`
- Ask for clarification rather than guessing project/status

## TODO: Configure These Values

Before using this command, configure the following:

1. **Project Key**: Replace `TODO_PROJECT_KEY` with your actual Jira project key (e.g., `AW`, `ASSET`)
2. **Workflow Statuses**: Map the status names above to your actual Jira workflow statuses
3. **GitHub URLs**: Update the GitHub organization and repository names
4. **Labels**: Configure labels that match your team's conventions
5. **User IDs**: Add team member Jira account IDs if needed for mentions
