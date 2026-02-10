---
description: Quick reference for all RPI Workflow plugin commands and features
---

# RPI Workflow - Quick Reference

## Getting Started

| Command          | Description                           |
| ---------------- | ------------------------------------- |
| `rpi:quickstart` | First-time setup and onboarding guide |
| `rpi:help`       | This quick reference                  |

---

## Core Workflow

### 1. Plan (includes research)

```
rpi:create_plan "add logout button"      # Plan from description (researches automatically)
rpi:iterate_plan [plan-path]             # Refine existing plan
```

> **Note**: `rpi:create_plan` has research built in - it spawns agents to analyze the codebase before creating the plan. No need to run research first!

### 2. Implement

```
rpi:implement_plan thoughts/shared/plans/xxx.md   # Execute plan phase by phase
rpi:validate_plan thoughts/shared/plans/xxx.md    # Verify implementation against plan
```

> **Tip**: Run `/clear` between planning and implementation to free up context.

### 3. Standalone Research (optional)

Use these when you want to **understand** something without creating a plan:

```
rpi:research_codebase "how does auth work"    # Creates doc in thoughts/shared/research/
rpi:research_codebase_generic "alert system"  # Research without thoughts directory
```

---

## Git & PR

```
rpi:commit                    # Create commit with user approval
rpi:describe_pr               # Generate PR description
rpi:create_worktree [branch]  # Create worktree for parallel work
```

---

## Session Management

```
rpi:create_handoff            # Save session state for later
rpi:resume_handoff [path]     # Resume from handoff document
rpi:debug [issue]             # Investigate issues via logs/git
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

| Agent                     | Use For                         |
| ------------------------- | ------------------------------- |
| `codebase-analyzer`       | Understanding HOW code works    |
| `codebase-locator`        | Finding WHERE code lives        |
| `codebase-pattern-finder` | Finding similar implementations |
| `thoughts-analyzer`       | Extracting insights from docs   |
| `web-search-researcher`   | External research               |

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
        ├── research/    # rpi:research_codebase output
        ├── plans/       # rpi:create_plan output
        └── tickets/     # Ticket snapshots
```

---

## Need More Help?

- **Full documentation**: https://github.com/aw-jwalker/jw-claude-plugins
- **Quickstart guide**: `rpi:quickstart`