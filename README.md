# JW Claude Plugins

Personal Claude Code plugin collection.

## Requirements

- **Claude Code CLI**: Update to latest version, this was tested on 2.0.76

## Available Plugins

| Plugin   | Description                                                 |
| -------- | ----------------------------------------------------------- |
| **rpi**  | Research-Plan-Implement workflow for structured development |
| **jira** | Jira ticket workflow commands (coming soon)                 |

---

## Quick Install (CLI)

From your terminal:

```bash
# Add the marketplace
claude plugin marketplace add aw-jwalker/jw-claude-plugins

# Install the RPI plugin
claude plugin install jw-claude-plugins@rpi

# Or install the Jira plugin
claude plugin install jw-claude-plugins@jira
```

## Quick Install (In-Session)

Or from within an active Claude Code session:

```
/plugin marketplace add aw-jwalker/jw-claude-plugins
/plugin install jw-claude-plugins@rpi
```

## Updating

### Manual Update

```bash
claude plugin marketplace update jw-claude-plugins
```

### Enable Auto-Updates (Recommended)

1. Run `/plugin` to open the plugin manager
2. Select the **Marketplaces** tab
3. Select `jw-claude-plugins` marketplace
4. Choose **Enable auto-update**

---

# RPI Plugin

The **Research-Plan-Implement** workflow plugin for structured software development.

## Quick Reference

```
rpi:quickstart              # First-time setup guide
rpi:help                    # Quick reference
```

### Core Workflow

```
rpi:research_codebase "topic"                    # Research codebase
rpi:create_plan "add logout button"              # Create plan from description
```

Then run `/clear` to free context, then:

```
rpi:implement_plan thoughts/shared/plans/xxx.md  # Execute the plan
```

> **Tip**: Run `/clear` between research, planning, and implementation phases to keep context fresh.

### Testing (Context-Efficient)

```
Use the test-runner agent to run all tests and summarize results
```

This runs tests in a separate context and returns only a summary.

## RPI Commands

### Core RPI Workflow

| Command                         | Description                               |
| ------------------------------- | ----------------------------------------- |
| `rpi:research_codebase`         | Document codebase with thoughts directory |
| `rpi:research_codebase_generic` | Generic codebase research                 |
| `rpi:research_codebase_nt`      | Research without thoughts directory       |
| `rpi:create_plan`               | Create detailed implementation plans      |
| `rpi:create_plan_generic`       | Generic plan creation                     |
| `rpi:create_plan_nt`            | Plan creation without thoughts            |
| `rpi:iterate_plan`              | Iterate on existing plans                 |
| `rpi:iterate_plan_nt`           | Iterate without thoughts                  |
| `rpi:implement_plan`            | Execute plans from thoughts/shared/plans  |
| `rpi:validate_plan`             | Validate implementation against plan      |

### Git & PR (shared)

| Command              | Description                       |
| -------------------- | --------------------------------- |
| `rpi:commit`         | Create commits with user approval |
| `rpi:ci_commit`      | CI/CD commit workflow             |
| `rpi:describe_pr`    | Generate PR descriptions          |
| `rpi:ci_describe_pr` | CI PR descriptions                |
| `rpi:describe_pr_nt` | PR descriptions without thoughts  |

### Workflow Management

| Command               | Description                                  |
| --------------------- | -------------------------------------------- |
| `rpi:create_handoff`  | Create handoff document for session transfer |
| `rpi:resume_handoff`  | Resume work from handoff document            |
| `rpi:debug`           | Debug issues via logs/git                    |
| `rpi:create_worktree` | Create worktrees for implementation          |
| `rpi:local_review`    | Set up worktree for branch review            |

## Agents

Specialized sub-agents for parallel research tasks:

| Agent                     | Description                                       |
| ------------------------- | ------------------------------------------------- |
| `codebase-analyzer`       | Analyzes HOW code works with file:line references |
| `codebase-locator`        | Finds WHERE code lives in the codebase            |
| `codebase-pattern-finder` | Finds similar implementations to model after      |
| `thoughts-analyzer`       | Extracts insights from thoughts documents         |
| `thoughts-locator`        | Discovers documents in thoughts/ directory        |
| `web-search-researcher`   | Researches web sources for information            |
| `test-runner`             | Runs tests in isolated context                    |

## Directory Structure

The RPI plugin expects/creates this structure in your project:

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
rpi:research_codebase "how does authentication work"
```

This creates a document at `thoughts/shared/research/`.

### 2. Create a Plan

```
rpi:create_plan "add logout button to settings page"
```

This creates an implementation plan at `thoughts/shared/plans/`.

### 3. Implement

```
/clear
rpi:implement_plan thoughts/shared/plans/[plan-file].md
```

This implements the plan phase by phase with verification.

---

# Jira Plugin

Jira ticket workflow commands for managing development tasks. (Coming soon)

See `jira:help` for available commands.

---

## For Teams (via Project Settings)

Add to your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "jw-claude-plugins": {
      "source": {
        "source": "github",
        "repo": "aw-jwalker/jw-claude-plugins"
      }
    }
  },
  "enabledPlugins": {
    "jw-claude-plugins@rpi": true,
    "jw-claude-plugins@jira": true
  }
}
```

## Contributing

1. Clone the repo
2. Make changes
3. Test with `claude --plugin-dir ./rpi` or `claude --plugin-dir ./jira`
4. Submit PR

## License

MIT
