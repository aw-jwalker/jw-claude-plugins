---
description: Create a git worktree for isolated development
argument-hint: <branch-name>
---

# Create Worktree

Creates a git worktree for isolated development. Use this when you want to work
on a branch without affecting your current working directory.

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

3. **Create the worktree using the thoughts CLI**:

   **CRITICAL**: You MUST use the `thoughts` CLI to create worktrees. Do NOT run
   `git worktree add` directly.

   ```bash
   thoughts worktree add "$BRANCH_NAME"
   ```

   The `thoughts` CLI handles:
   - Converting slashes to hyphens in filesystem paths
   - Creating the correct directory structure
   - Copying `.claude/settings.local.json` from main repo (preserves
     project-specific permissions)
   - Auto-installing dependencies (pnpm/npm/yarn/bun)
   - Ensuring compatibility with `cdwt` command

4. **Report success**:

   Use the actual path returned by the `thoughts worktree add` command output.

   ```
   Worktree created successfully!

   Branch: {branch}
   Location: {actual-path-from-command-output}

   To work in this worktree:
     cd {actual-path-from-command-output}

   To launch Claude in this worktree:
     claude -w {actual-path-from-command-output}

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

/create_worktree feature/add-api
# → Creates ~/wt/project/feature-add-api with branch feature/add-api
# Note: Slash converted to hyphen in filesystem path
```

## Notes

- Worktrees are created at `~/wt/{project}/{branch}/`
- Branch names with slashes (e.g., `feature/something`) are converted to hyphens
  in the filesystem path (`feature-something`)
- Project-specific permissions (`.claude/settings.local.json`) are automatically
  copied
- Dependencies are automatically installed (no need to manually run
  `pnpm install`)
- The thoughts directory is synced between main repo and worktrees
- Use `/clean_worktree` to remove worktrees when done
- Use `/implement_plan_wt` if you want to create a worktree AND start
  implementing a plan
