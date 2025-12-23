---
description: Quick reference for all RPI Workflow plugin commands and features
---

# RPI Workflow - Quick Reference

## Getting Started

| Command | Description |
|---------|-------------|
| `/rpi-quickstart` | First-time setup and onboarding guide |
| `/rpi-help` | This quick reference |

---

## Core Workflow

### 1. Research
```
/research_codebase [topic]           # Document codebase for a specific area
/research_codebase_generic [topic]   # Generic research without thoughts/
```

### 2. Plan
```
/create_plan [ticket-path-or-description]   # Create implementation plan
/iterate_plan [plan-path]                   # Refine existing plan
```

### 3. Implement
```
/implement_plan [plan-path]    # Execute plan phase by phase
/validate_plan [plan-path]     # Verify implementation against plan
```

> **Tip**: Run `/clear` between major steps (after research, after planning) to free up context for the next phase.

---

## Jira Integration

```
/jira [action] [ticket]        # Manage Jira tickets (create, update, comment)
/ralph_research [ticket]       # Research a specific ticket
/ralph_plan [ticket]           # Create plan for a ticket
/ralph_impl [ticket]           # Implement ticket with plan
/oneshot [ticket]              # Research + Plan in one step
/oneshot_plan [ticket]         # Plan + Implement in one step
```

---

## Git & PR

```
/commit                    # Create commit with user approval
/describe_pr               # Generate PR description
/create_worktree [branch]  # Create worktree for parallel work
```

---

## Session Management

```
/create_handoff            # Save session state for later
/resume_handoff [path]     # Resume from handoff document
/debug [issue]             # Investigate issues via logs/git
```

---

## Testing (Context-Efficient)

Instead of running tests directly (which pollutes context), use:

```
Use the test-runner agent to run all tests and summarize results
```

This runs tests in an isolated context and returns only a summary, comparing against baseline to show NEW vs pre-existing failures.

---

## Agents (for Research Tasks)

Spawn these for parallel research:

| Agent | Use For |
|-------|---------|
| `codebase-analyzer` | Understanding HOW code works |
| `codebase-locator` | Finding WHERE code lives |
| `codebase-pattern-finder` | Finding similar implementations |
| `thoughts-analyzer` | Extracting insights from docs |
| `web-search-researcher` | External research |

Example:
```
Use the codebase-analyzer agent to understand how authentication works
```

---

## Directory Structure

Plans and research are stored in:
```
your-project/
└── thoughts/
    └── shared/
        ├── research/    # /research_codebase output
        ├── plans/       # /create_plan output
        └── tickets/     # Ticket snapshots
```

---

## Need More Help?

- **Full documentation**: https://github.com/AssetWatch1/rpi-workflow
- **Quickstart guide**: `/rpi-quickstart`
