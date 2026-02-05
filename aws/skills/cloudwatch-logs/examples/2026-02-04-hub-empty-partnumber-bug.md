# Hub Empty PartNumber Bug Investigation

**Date:** 2026-02-04 **Environments:** Production & Dev **Lambda:**
hub-prod-master, hub-dev-dev **Issue:** Malformed Hub strings like
`"()_0006436"` sent to downstream services

## Context

Users reported "invalid topic" errors when adding hubs without selecting a part
number. The bug allowed submission with empty `partID=""`, causing the backend
to generate malformed Hub identifiers.

## Investigation Approach

### 1. Search Production Logs for Serial Number

Searched for specific hub serial number in production logs during the reported
error time:

```bash
export AWS_PROFILE=prod

# Convert time range (3-4 PM EST) to epoch milliseconds
START_TIME=$(TZ=America/New_York date -d "2026-02-03 15:00:00" +%s)000
END_TIME=$(TZ=America/New_York date -d "2026-02-03 16:00:00" +%s)000

# Search for serial number in logs
aws logs filter-log-events \
  --log-group-name "/aws/lambda/hub-prod-master" \
  --start-time $START_TIME \
  --end-time $END_TIME \
  --filter-pattern '"0006436"' \
  --output json | jq -r '.events[] | "\(.timestamp | tonumber / 1000 | strftime("%Y-%m-%d %H:%M:%S UTC")) - \(.message)"'
```

### 2. Parse JSON and Filter for Error Patterns

Used jq and grep to extract relevant information:

```bash
# Find error messages and malformed data patterns
aws logs filter-log-events \
  --log-group-name "/aws/lambda/hub-prod-master" \
  --start-time $START_TIME \
  --end-time $END_TIME \
  --filter-pattern '"0006436"' \
  --output json | jq -r '.events[].message' | grep -E "(error|partID|Syncing|()_)"
```

### 3. Reproduce in Dev Environment

Repeated the same test in dev to confirm reproducibility:

```bash
export AWS_PROFILE=dev

# Same time range search in dev logs
START_TIME=$(TZ=America/New_York date -d "2026-02-03 16:00:00" +%s)000
END_TIME=$(TZ=America/New_York date -d "2026-02-03 17:00:00" +%s)000

aws logs filter-log-events \
  --log-group-name "/aws/lambda/hub-dev-dev" \
  --start-time $START_TIME \
  --end-time $END_TIME \
  --filter-pattern '"addHub"' \
  --output json | jq -r '.events[] | "\(.timestamp | tonumber / 1000 | strftime("%Y-%m-%d %H:%M:%S UTC")) - \(.message)"'
```

## Key Findings

### Error Sequence Found in Logs:

1. **Request with empty partID:**

   ```json
   {"meth":"addHub","partID":"","hubList":"0006436",...}
   ```

2. **Database foreign key error:**

   ```
   (1452, 'Cannot add or update a child row: a foreign key constraint fails')
   ```

3. **Empty query executed:**

   ```sql
   SELECT PartNumber FROM Part WHERE PartID='';
   ```

   Result: `error retrieving hub part number`

4. **Malformed Hub string generated:**

   ```
   Syncing facility 4539 with hub ()_0006436
   ```

5. **Invalid downstream requests:**
   ```json
   { "RequestType": "HubDiagnostic", "Hub": "()_0006436" }
   ```

## Resolution

**Frontend fixes:**

- Added `selectedPartNumber === ""` to disabled condition in SaveModal
- Added `partID: string` to `assignHub` TypeScript interface

**Backend fixes (pending):**

- Update `get_hub_part_number_from_id()` to return `None` for empty/invalid
  partID
- Add validation in `addHub` handler to prevent downstream calls when partID is
  invalid

## Key Learnings

1. **Use serial numbers as search anchors** - Searching for specific serial
   numbers (e.g., `"0006436"`) is effective for tracking issues through logs

2. **Format timestamps for readability** - Using jq to format timestamps makes
   log analysis much easier:

   ```bash
   jq -r '.events[] | "\(.timestamp | tonumber / 1000 | strftime("%Y-%m-%d %H:%M:%S UTC")) - \(.message)"'
   ```

3. **Search for error patterns, not just ERROR** - Looking for specific patterns
   like `()_` or `error retrieving` found the root cause faster than generic
   ERROR searches

4. **Reproduce in dev first** - Testing the same scenario in dev environment
   confirmed the bug was reliably reproducible

5. **Save logs for evidence** - Saving logs to `/tmp/` files allowed detailed
   analysis and comparison:
   ```bash
   aws logs filter-log-events ... > /tmp/bug_reproduction_evidence.json
   ```

## Related Files

- Investigation handoff:
  `/home/aw-jwalker/repos/thoughts/shared/handoffs/general/2026-02-03_17-30-00_hub-diagnostic-empty-partnumber-implementation.md`
- Evidence files: `/tmp/bug_reproduction_evidence.md`,
  `/tmp/bug_reproduction_dev_evidence.md`
