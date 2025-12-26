# RPI Workflow Plugin

AssetWatch's Claude Code plugin for the **Research-Plan-Implement** workflow.

## Quick Install

```bash
# Add the marketplace and install the plugin
claude plugin marketplace add AssetWatch1/rpi-workflow
claude plugin install rpi-workflow@rpi-workflow
```

Or from within Claude Code:

```
/plugin marketplace add AssetWatch1/rpi-workflow
/plugin install rpi-workflow@rpi-workflow
```

## Updating

### Manual Update

```bash
# Refresh marketplace and update to latest version
claude plugin marketplace update rpi-workflow
```

Or from within Claude Code:

```
/plugin marketplace update rpi-workflow
```

### Enable Auto-Updates (Recommended)

1. Run `/plugin` to open the plugin manager
2. Select the **Marketplaces** tab
3. Select `rpi-workflow` marketplace
4. Choose **Enable auto-update**

With auto-update enabled, Claude Code will automatically check for and install updates at session start.

## Quick Reference

### Getting Started

```
/rpi-quickstart              # First-time setup guide
/rpi-help                    # Quick reference (this info)
```

### Core Workflow

```
/research_codebase "topic"                    # Research codebase
/create_plan "add logout button"              # Create plan from description
```

Then run `/clear` to free context, then:

```
/implement_plan thoughts/shared/plans/xxx.md  # Execute the plan
```

> **Tip**: Run `/clear` between research, planning, and implementation phases to keep context fresh.

### Testing (Context-Efficient)

```
Use the test-runner agent to run all tests and summarize results
```

This runs tests in a separate context and returns only a summary.

---

## Overview

This plugin provides a structured workflow for software development:

1. **Research** - Investigate tickets, explore codebase, document findings
2. **Plan** - Create detailed implementation plans with success criteria
3. **Implement** - Execute plans with verification at each phase

## Installation

### For Individual Use

```bash
# First, add the plugin repository
claude plugin marketplace add AssetWatch1/rpi-workflow

# Then install the plugin
claude plugin install rpi-workflow@rpi-workflow
```

Or use the shorthand within Claude Code:

```
/plugin marketplace add AssetWatch1/rpi-workflow
/plugin install rpi-workflow@rpi-workflow
```

### For Team (via Project Settings)

Add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "rpi-workflow": {
      "source": {
        "source": "github",
        "repo": "AssetWatch1/rpi-workflow"
      }
    }
  },
  "enabledPlugins": {
    "rpi-workflow@rpi-workflow": true
  }
}
```

## Commands (20 total)

### Core RPI Workflow

| Command                      | Description                               |
| ---------------------------- | ----------------------------------------- |
| `/research_codebase`         | Document codebase with thoughts directory |
| `/research_codebase_generic` | Generic codebase research                 |
| `/research_codebase_nt`      | Research without thoughts directory       |
| `/create_plan`               | Create detailed implementation plans      |
| `/create_plan_generic`       | Generic plan creation                     |
| `/create_plan_nt`            | Plan creation without thoughts            |
| `/iterate_plan`              | Iterate on existing plans                 |
| `/iterate_plan_nt`           | Iterate without thoughts                  |
| `/implement_plan`            | Execute plans from thoughts/shared/plans  |
| `/validate_plan`             | Validate implementation against plan      |

### Git & PR

| Command           | Description                       |
| ----------------- | --------------------------------- |
| `/commit`         | Create commits with user approval |
| `/ci_commit`      | CI/CD commit workflow             |
| `/describe_pr`    | Generate PR descriptions          |
| `/ci_describe_pr` | CI PR descriptions                |
| `/describe_pr_nt` | PR descriptions without thoughts  |

### Workflow Management

| Command            | Description                                  |
| ------------------ | -------------------------------------------- |
| `/create_handoff`  | Create handoff document for session transfer |
| `/resume_handoff`  | Resume work from handoff document            |
| `/debug`           | Debug issues via logs/git                    |
| `/create_worktree` | Create worktrees for implementation          |
| `/local_review`    | Set up worktree for branch review            |

## Agents (6 total)

Specialized sub-agents for parallel research tasks:

| Agent                     | Description                                       |
| ------------------------- | ------------------------------------------------- |
| `codebase-analyzer`       | Analyzes HOW code works with file:line references |
| `codebase-locator`        | Finds WHERE code lives in the codebase            |
| `codebase-pattern-finder` | Finds similar implementations to model after      |
| `thoughts-analyzer`       | Extracts insights from thoughts documents         |
| `thoughts-locator`        | Discovers documents in thoughts/ directory        |
| `web-search-researcher`   | Researches web sources for information            |

## Directory Structure

The plugin expects/creates this structure in your project:

```
your-project/
├── thoughts/
│   ├── shared/
│   │   ├── research/      # Research documents
│   │   ├── plans/         # Implementation plans
│   │   └── tickets/       # Ticket snapshots
│   └── [username]/        # Personal thoughts
└── ...
```

## Typical Workflow

### 1. Research (Optional)

```
/research_codebase "how does authentication work"
```

This creates a document at `thoughts/shared/research/`.

### 2. Create a Plan

```
/create_plan "add logout button to settings page"
```

This creates an implementation plan at `thoughts/shared/plans/`.

### 3. Implement

```
/clear
/implement_plan thoughts/shared/plans/[plan-file].md
```

This implements the plan phase by phase with verification.

## Contributing

1. Clone the repo
2. Make changes
3. Test with `claude --plugin-dir ./rpi-workflow`
4. Submit PR

## License

MIT
