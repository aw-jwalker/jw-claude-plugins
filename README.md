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

---

## Current Status (WIP)

This plugin was initialized on 2025-12-23. Here's what's been done and what still needs work:

### What's Been Added

- **6 agents** - Copied from humanlayer, ready to use as-is
- **20 generic commands** - Planning, research, git, PR, handoff workflows (ready to use)
- **7 Jira commands** - Adapted from Linear, have `TODO` placeholders that need configuration
- **MCP config** - `.mcp.json` for automatic Jira integration for teammates
- **Plugin manifest** - `plugin.json` with proper metadata

### Placeholders That Need Configuration

The following files contain `TODO_PROJECT_KEY` and other placeholders:

| File | What Needs Configuring |
|------|----------------------|
| `commands/jira.md` | Project key, workflow statuses, GitHub org/repo URLs, labels |
| `commands/ralph_research.md` | Project key, status names ("Research Needed", etc.) |
| `commands/ralph_plan.md` | Project key, status names ("Ready for Plan", etc.) |
| `commands/ralph_impl.md` | Project key, status names ("Ready for Dev", etc.) |
| `commands/founder_mode.md` | Project key |

Search for `TODO` in any of these files to find all placeholders.

### Next Steps

1. **Configure Jira project key** - Replace `TODO_PROJECT_KEY` with actual project key (e.g., `AW`, `ASSET`)
2. **Map Jira workflow statuses** - Update status names to match our actual Jira workflow
3. **Update GitHub URLs** - Replace placeholder org/repo in `commands/jira.md`
4. **Test the plugin** - Run `claude --plugin-dir ~/repos/rpi-workflow` to test
5. **Iterate on commands** - Adjust commands based on team feedback

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

## Setup

### Jira Integration

The plugin includes Jira MCP configuration. Set these environment variables:

```bash
export ATLASSIAN_SITE_URL="https://your-company.atlassian.net"
export ATLASSIAN_USER_EMAIL="your-email@company.com"
export ATLASSIAN_API_TOKEN="your-api-token"
```

To get an API token: [Atlassian API Tokens](https://id.atlassian.com/manage-profile/security/api-tokens)

### Configuration Required

Before using Jira-related commands, update the `TODO_PROJECT_KEY` placeholders in:
- `commands/jira.md`
- `commands/ralph_research.md`
- `commands/ralph_plan.md`
- `commands/ralph_impl.md`
- `commands/founder_mode.md`

## Commands (27 total)

### Core RPI Workflow

| Command | Description |
|---------|-------------|
| `/research_codebase` | Document codebase with thoughts directory |
| `/research_codebase_generic` | Generic codebase research |
| `/research_codebase_nt` | Research without thoughts directory |
| `/create_plan` | Create detailed implementation plans |
| `/create_plan_generic` | Generic plan creation |
| `/create_plan_nt` | Plan creation without thoughts |
| `/iterate_plan` | Iterate on existing plans |
| `/iterate_plan_nt` | Iterate without thoughts |
| `/implement_plan` | Execute plans from thoughts/shared/plans |
| `/validate_plan` | Validate implementation against plan |

### Jira Integration (Ticket Workflow)

| Command | Description |
|---------|-------------|
| `/jira` | Manage Jira tickets - create, update, comment |
| `/ralph_research` | Research highest priority ticket needing investigation |
| `/ralph_plan` | Create plan for highest priority ticket ready for planning |
| `/ralph_impl` | Implement highest priority ticket with plan |
| `/oneshot` | Research ticket + launch planning |
| `/oneshot_plan` | Plan + implement in one workflow |
| `/founder_mode` | Create ticket/PR for experimental features |

### Git & PR

| Command | Description |
|---------|-------------|
| `/commit` | Create commits with user approval |
| `/ci_commit` | CI/CD commit workflow |
| `/describe_pr` | Generate PR descriptions |
| `/ci_describe_pr` | CI PR descriptions |
| `/describe_pr_nt` | PR descriptions without thoughts |

### Workflow Management

| Command | Description |
|---------|-------------|
| `/create_handoff` | Create handoff document for session transfer |
| `/resume_handoff` | Resume work from handoff document |
| `/debug` | Debug issues via logs/git |
| `/create_worktree` | Create worktrees for implementation |
| `/local_review` | Set up worktree for branch review |

## Agents (6 total)

Specialized sub-agents for parallel research tasks:

| Agent | Description |
|-------|-------------|
| `codebase-analyzer` | Analyzes HOW code works with file:line references |
| `codebase-locator` | Finds WHERE code lives in the codebase |
| `codebase-pattern-finder` | Finds similar implementations to model after |
| `thoughts-analyzer` | Extracts insights from thoughts documents |
| `thoughts-locator` | Discovers documents in thoughts/ directory |
| `web-search-researcher` | Researches web sources for information |

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

### 1. Start with Research
```
/ralph_research PROJECT-123
```
This researches the ticket and creates a document at `thoughts/shared/research/`.

### 2. Create a Plan
```
/ralph_plan PROJECT-123
```
This creates an implementation plan at `thoughts/shared/plans/`.

### 3. Implement
```
/ralph_impl PROJECT-123
```
This implements the plan, creates commits, and opens a PR.

### Or All-in-One
```
/oneshot PROJECT-123      # Research + Plan
/oneshot_plan PROJECT-123 # Plan + Implement
```

## Contributing

1. Clone the repo
2. Make changes
3. Test with `claude --plugin-dir ./rpi-workflow`
4. Submit PR

## License

MIT
