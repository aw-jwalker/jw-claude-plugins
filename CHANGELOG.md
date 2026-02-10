# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2025-12-29

### Changed

- **BREAKING**: Restructured repository to support multiple plugins
- Plugin renamed from `rpi-workflow` to `rpi` (commands now `rpi:create_plan` instead of `rpi_workflow:create_plan`)
- Repository renamed from `rpi-workflow` to `jw-claude-plugins`
- Commands `rpi-help` and `rpi-quickstart` renamed to `help` and `quickstart` (now `rpi:help`, `rpi:quickstart`)
- All command references in documentation updated to include plugin prefix

### Added

- **Multi-plugin architecture**: Repository now supports multiple plugins with shared resources
- `shared/` directory for agents and commands shared across plugins
- `jira/` plugin skeleton for upcoming Jira workflow commands
- Symlink-based resource sharing between plugins

### Structure

```
jw-claude-plugins/
├── rpi/          # RPI plugin
├── jira/         # Jira plugin (coming soon)
└── shared/       # Shared agents and commands
```

## [1.6.0] - 2025-12-26

### Removed

- **Jira integration commands**: `/jira`, `/ralph_research`, `/ralph_plan`, `/ralph_impl`, `/oneshot`, `/oneshot_plan`, `/founder_mode`
- Jira setup and configuration sections from README and quickstart guide

### Changed

- Command count reduced from 27 to 20
- Documentation updated to focus on core Research-Plan-Implement workflow
- Typical Workflow examples now use generic commands (`/create_plan`, `/research_codebase`)

## [1.5.0] - 2025-12-23

### Added

- `/rpi-help` command: Quick reference for all plugin commands and features
- `/rpi-quickstart` command: First-time setup and onboarding guide
- `argument-hint` to all commands: Shows example arguments in autocomplete
- Quick Reference section in README with core workflow examples

### Changed

- README now includes Quick Reference near top for easy access
- Command hints show realistic examples (e.g., `<AW-123>`, `<thoughts/shared/plans/...>`)

## [1.4.0] - 2025-12-23

### Added

- **Baseline caching**: SessionStart hook captures test baseline with hash-based invalidation
- scripts/capture-baseline.sh: Captures test state, only re-runs when git hash changes
- `.test-baseline.json` stores baseline for comparison during session
- test-runner agent now compares results to baseline, distinguishing NEW vs pre-existing failures

### Changed

- SessionStart hook runs baseline capture in background (non-blocking)
- test-runner agent summary now shows "NEW failures" vs "pre-existing" when baseline available

## [1.3.0] - 2025-12-23

### Added

- **test-runner agent**: Runs tests in isolated context, returns only summary (prevents context pollution)
- Agent uses subagent pattern for true context isolation - full output analyzed, only summary returns
- Updated implement_plan.md and create_plan.md to use test-runner agent

### Changed

- Upgraded from script-based truncation to agent-based context isolation
- Test verification now runs in separate context window for quality analysis without pollution

## [1.2.0] - 2025-12-23

### Added

- Smart test-runner skill: Runs automated tests with concise output to avoid context pollution
- scripts/run-tests.sh: Smart test runner that handles missing commands gracefully
- Updated implement_plan.md and create_plan.md to use test-runner skill

## [1.1.0] - 2025-12-23

### Added

- Auto-format hook: Runs Prettier on files after Write/Edit operations
- hooks/ directory with hooks.json configuration
- scripts/ directory with format.sh script

## [1.0.0] - 2025-12-23

### Added

- Initial plugin setup with RPI (Research-Plan-Implement) workflow
- 6 research agents: codebase-analyzer, codebase-locator, codebase-pattern-finder, thoughts-analyzer, thoughts-locator, web-search-researcher
- 27 workflow commands for planning, research, implementation, and git workflows
- Jira MCP integration for ticket management
