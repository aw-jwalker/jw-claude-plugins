---
description: Safely remove git worktrees
argument-hint: <[branch-name]>
---

# Clean Worktree

Safely removes git worktrees created by `/implement_plan_wt` or `/create_worktree`.

## Safety Checks

**CRITICAL**: This command MUST check if the current Claude session is running inside the worktree being removed. If so, bash commands will fail after removal.

## Workflow

### If branch name provided:

1. **Get the worktree path**:

   ```bash
   thoughts worktree path "$BRANCH_NAME"
   ```

2. **Check if we're in the target worktree**:

   ```bash
   pwd
   ```

   - Compare current directory with worktree path
   - If current directory starts with the worktree path, STOP and warn:

     ```
     Cannot remove worktree - you are currently inside it!

     Current directory: /home/user/wt/project/branch
     Worktree to remove: /home/user/wt/project/branch

     To clean this worktree:
     1. Start a new Claude session in the main repository
     2. Run: /clean_worktree {branch}

     Or manually:
     1. cd ~/repos/{project}
     2. thoughts worktree remove {branch} --delete-branch
     ```

3. **Check if worktree exists**:

   ```bash
   thoughts worktree list
   ```

4. **Confirm removal** with user:

   ```
   Remove worktree for branch '{branch}'?

   Worktree path: ~/wt/{project}/{branch}

   Options:
   1. Remove worktree only (keep branch for later)
   2. Remove worktree AND delete branch
   3. Cancel
   ```

5. **Execute removal based on user choice**:

   ```bash
   # Option 1 - keep branch:
   thoughts worktree remove "$BRANCH_NAME"

   # Option 2 - delete branch too:
   thoughts worktree remove "$BRANCH_NAME" --delete-branch
   ```

### If no branch name provided:

1. **List available worktrees**:

   ```bash
   thoughts worktree list
   ```

2. **Present options to user**:
   - Show each worktree with its branch name
   - Ask which one(s) to remove
   - Or allow user to specify branch name

## Example Usage

```
/clean_worktree IWA-1234
# → Removes worktree for IWA-1234 after confirmation

/clean_worktree
# → Lists worktrees and prompts for selection

/clean_worktree gh-9-fix-zips
# → Removes worktree for gh-9-fix-zips
```

## Notes

- Always run this command from the MAIN repository, not from inside a worktree
- If you need to clean up the worktree you're currently in, start a new session in the main repo first
- The `--delete-branch` option is useful for cleanup after PR is merged
