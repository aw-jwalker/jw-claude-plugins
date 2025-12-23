---
description: First-time setup and onboarding guide for the RPI Workflow plugin
---

# RPI Workflow - Quickstart Guide

Welcome to the **Research-Plan-Implement** workflow! This guide will get you up and running.

---

## Step 1: Verify Installation

You're already here, so the plugin is installed! To confirm, you should see these commands in `/help`:
- `/create_plan`
- `/implement_plan`
- `/research_codebase`

---

## Step 2: Set Up Jira Integration (Optional)

If you want to use Jira-related commands (`/ralph_*`, `/jira`), set these environment variables:

```bash
export ATLASSIAN_SITE_URL="https://assetwatch.atlassian.net"
export ATLASSIAN_USER_EMAIL="your-email@assetwatch.com"
export ATLASSIAN_API_TOKEN="your-api-token"
```

Get your API token at: https://id.atlassian.com/manage-profile/security/api-tokens

---

## Step 3: Enable Auto-Updates

Keep your plugin up to date:

1. Run `/plugin` to open plugin manager
2. Go to **Marketplaces** tab
3. Select **rpi-workflow**
4. Choose **Enable auto-update**

---

## Step 4: Try the Workflow

### Option A: Quick Task (No Ticket)

```
/create_plan Add a logout button to the settings page
```

This will:
1. Research the codebase
2. Ask clarifying questions
3. Create a plan at `thoughts/shared/plans/`

Then:
```
/clear
/implement_plan thoughts/shared/plans/[your-plan].md
```

> **Tip**: Run `/clear` between steps to free context for the next phase.

### Option B: From Jira Ticket

```
/oneshot AW-1234
```

This researches the ticket and creates a plan in one step.

Then:
```
/clear
/implement_plan thoughts/shared/plans/[plan-file].md
```

---

## Step 5: Test Verification

When implementing, use the test-runner agent for context-efficient testing:

```
Use the test-runner agent to run all tests and summarize results
```

This runs tests in a separate context and shows only a summary with:
- Pass/fail status
- NEW failures (from your changes) vs pre-existing
- Recommendations

---

## Key Commands Cheat Sheet

| Task | Command |
|------|---------|
| Get help | `/rpi-help` |
| Research codebase | `/research_codebase [topic]` |
| Create plan | `/create_plan [description or ticket-path]` |
| Implement plan | `/implement_plan [plan-path]` |
| Quick Jira flow | `/oneshot [ticket]` |
| Run tests | `Use the test-runner agent...` |
| Clear context | `/clear` |

---

## Workflow Tips

1. **Use `/clear` between phases** - Research, planning, and implementation each benefit from fresh context

2. **Let agents do research** - Instead of manually searching, say:
   ```
   Use the codebase-locator agent to find all authentication-related files
   ```

3. **Test efficiently** - Use the test-runner agent to avoid test output polluting your context

4. **Save your work** - Before ending a long session:
   ```
   /create_handoff
   ```

5. **Resume later** - Start a new session with:
   ```
   /resume_handoff thoughts/shared/handoffs/[file].md
   ```

---

## Need Help?

- **Quick reference**: `/rpi-help`
- **Full docs**: https://github.com/AssetWatch1/rpi-workflow
- **Report issues**: https://github.com/AssetWatch1/rpi-workflow/issues
