# Git Investigation Reference

## Git Commands

### Recent commits on a file

```bash
git log -10 --format="%an | %ad | %s" --date=short -- <file>
```

Shows the last 10 commits touching a file with author, date, and message.

### Code ownership by blame

```bash
git blame --line-porcelain <file> | grep "^author " | sort | uniq -c | sort -rn | head -10
```

Shows how many lines each developer currently owns in a file.

### Find commits referencing ticket IDs

```bash
git log --all --format="%an | %ad | %s" --date=short --grep="IWA-12345\|IWA-67890" -- .
```

Use `\|` to OR multiple ticket IDs. The `--all` flag searches all branches.

### Historical bug fix commits in an area

```bash
git log --all --format="%an | %ad | %s" --date=short --grep="fix\|bug" -- <directory-or-file>
```

Finds past bug fixes in the same code area -- useful for identifying who
has fixed similar issues before.

## Gotchas

### Monorepo refactors skew blame

Large file moves (e.g., the Jan 2026 refactor moving `packages/frontend/`
to `apps/frontend/`) cause `git blame` to attribute all lines to the
developer who did the move. To get true ownership:

- Use `git log --follow` to trace history through the rename
- Run blame at the pre-refactor commit:
  ```bash
  git blame --line-porcelain <pre-refactor-commit> -- <old-path> | grep "^author " | sort | uniq -c | sort -rn
  ```

### Bulk formatting commits inflate blame

Auto-formatting commits (prettier, eslint --fix) inflate one developer's
blame count. Discount authors whose blame counts seem inflated relative to
their git log activity.

## Sub-Agent Prompt Template

When launching investigation sub-agents (Step 6), use this template:

```
RESEARCH ONLY - do not write any code.

I need to find which developers last worked on [AREA DESCRIPTION] in:
[REPO PATH(S)]

Tickets in this group:
- [TICKET-ID]: [SUMMARY] (component: [COMPONENT])
- ...

Steps:
1. Search for files related to [KEYWORDS] in apps/, api/, lambdas/, mysql/
2. For each relevant file, run:
   git log -10 --format="%an | %ad | %s" --date=short -- <file>
3. For critical files, run:
   git blame --line-porcelain <file> | grep "^author " | sort | uniq -c | sort -rn | head -10
4. Search for commits referencing ticket IDs:
   git log --all --format="%an | %ad | %s" --date=short --grep="[TICKET-IDS-WITH-\|]"
5. Look for historical bug fix commits in the same area

Report:
- Which files are most relevant per ticket
- Which developers own the code (blame) and who's been active (log, with dates)
- Recommended assignee for each ticket (primary + secondary)
```
