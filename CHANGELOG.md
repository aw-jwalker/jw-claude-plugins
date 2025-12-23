# Changelog

All notable changes to this project will be documented in this file.

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
