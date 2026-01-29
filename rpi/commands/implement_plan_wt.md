---
description: Create worktree and implement plan in isolated environment
argument-hint: <[branch] thoughts/shared/plans/2025-01-01-IWA-1234-feature.md>
---

# Implement Plan in Worktree

Creates a git worktree for isolated implementation, then launches a Claude session to implement the plan.

## Argument Parsing

Arguments: `[branch] <plan-path>`

- If TWO arguments: first is branch name, second is plan path
- If ONE argument: it's the plan path, extract branch from filename

## Branch Name Extraction

When branch is not provided, extract from plan filename:

1. Plan filename format: `YYYY-MM-DD-{identifier}-description.md`
2. Extract the identifier portion (usually ticket number)
3. Examples:
   - `2025-01-29-IWA-1234-add-feature.md` → branch: `IWA-1234`
   - `2025-01-29-gh-9-fix-zips.md` → branch: `gh-9-fix-zips`
   - `2025-01-29-MOBILE-567-update-api.md` → branch: `MOBILE-567`

Pattern: After the date prefix (YYYY-MM-DD-), look for:

- Jira-style tickets: `[A-Z]+-[0-9]+` (e.g., IWA-1234, MOBILE-567)
- GitHub issues: `gh-[0-9]+-[a-z-]+` (e.g., gh-9-fix-zips)

If extraction fails or is ambiguous, ask the user for the branch name.

## Workflow

1. **Parse arguments** to get branch name and plan path:
   - Count arguments
   - If 2 args: branch = first, plan = second
   - If 1 arg: plan = first, extract branch from filename

2. **Validate plan exists**:

   ```bash
   test -f "$PLAN_PATH" && echo "Plan found" || echo "Plan not found"
   ```

   - If not found, list available plans: `ls thoughts/shared/plans/`

3. **Extract branch name** (if not provided):
   - Parse the plan filename
   - Look for ticket pattern after date prefix
   - If unclear, ask the user

4. **Check current branch**:

   ```bash
   git branch --show-current
   ```

   - If already on a feature branch (not main/master/dev), warn user and ask if they want to continue or use current branch

5. **Create worktree** using thoughts CLI:

   ```bash
   thoughts worktree add "$BRANCH_NAME"
   ```

   - Capture the worktree path from output (last line)
   - If worktree already exists, that's OK - script will output the existing path

6. **Get the worktree path**:

   ```bash
   thoughts worktree path "$BRANCH_NAME"
   ```

7. **Confirm with user** before launching:

   ```
   Ready to launch implementation session:

   Worktree: ~/wt/{project}/{branch}
   Branch: {branch}
   Plan: {plan-path}

   Command:
       claude -w ~/wt/{project}/{branch} "/implement_plan {plan-path} and when done, /commit then /describe_pr"

   Proceed?
   ```

8. **Launch Claude session**:
   ```bash
   claude -w "$WORKTREE_PATH" "/implement_plan $PLAN_PATH and when you are done implementing and all tests pass, /commit then /describe_pr then add a comment to the ticket with the PR link"
   ```

## Error Handling

- If `thoughts worktree` command not found:

  ```
  Error: thoughts CLI not found or worktree command not available.

  Install/update thoughts CLI:
    - Ensure ~/dotfiles/thoughts is in your PATH
    - Or run: export PATH="$HOME/dotfiles/thoughts:$PATH"
  ```

- If worktree creation fails: Show error and suggest manual steps

- If plan file not found: List available plans in `thoughts/shared/plans/`

## Example Usage

```
/implement_plan_wt thoughts/shared/plans/2025-01-29-IWA-1234-feature.md
# → Creates branch IWA-1234, worktree at ~/wt/project/IWA-1234, launches implementation

/implement_plan_wt my-custom-branch thoughts/shared/plans/2025-01-29-feature.md
# → Uses explicit branch name "my-custom-branch"

/implement_plan_wt IWA-5678 thoughts/shared/plans/2025-01-29-IWA-5678-new-api.md
# → Explicit branch IWA-5678
```

## Notes

- The thoughts directory is synced between main repo and worktrees, so use relative paths like `thoughts/shared/plans/...`
- After the implementation session completes, use `/clean_worktree {branch}` from the main repo to clean up
