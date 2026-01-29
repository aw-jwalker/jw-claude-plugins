---
description: Create a git worktree for isolated development
argument-hint: <branch-name>
---

# Create Worktree

Creates a git worktree for isolated development. Use this when you want to work on a branch without affecting your current working directory.

## Arguments

- `branch-name` (required): The name of the branch for the worktree

## Workflow

1. **Validate branch name provided**:
   - If no branch name, show usage and exit

2. **Check current state**:

   ```bash
   git branch --show-current
   thoughts worktree list
   ```

3. **Create the worktree**:

   ```bash
   thoughts worktree add "$BRANCH_NAME"
   ```

4. **Report success**:

   ```
   Worktree created successfully!

   Branch: {branch}
   Location: ~/wt/{project}/{branch}

   To work in this worktree:
     cd ~/wt/{project}/{branch}

   To launch Claude in this worktree:
     claude -w ~/wt/{project}/{branch}

   To clean up when done:
     /clean_worktree {branch}
   ```

## Options

You can specify a base branch with `--base`:

```bash
thoughts worktree add "$BRANCH_NAME" --base develop
```

By default, new branches are created from `dev`.

## Example Usage

```
/create_worktree IWA-1234
# → Creates ~/wt/project/IWA-1234 with branch IWA-1234

/create_worktree feature-new-api
# → Creates ~/wt/project/feature-new-api with branch feature-new-api
```

## Notes

- Worktrees are created at `~/wt/{project}/{branch}/`
- The thoughts directory is synced between main repo and worktrees
- Use `/clean_worktree` to remove worktrees when done
- Use `/implement_plan_wt` if you want to create a worktree AND start implementing a plan
