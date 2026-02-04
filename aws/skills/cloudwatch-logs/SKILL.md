---
name: cloudwatch-logs
description:
  Search CloudWatch logs for AssetWatch lambdas. Automatically transforms code
  names to AWS lambda names, handles AWS profile switching, and manages timezone
  conversions.
---

# CloudWatch Logs Search

Search CloudWatch logs for AssetWatch Lambda functions with automatic name
transformation, profile switching, and timezone handling.

## Quick Start

When the user wants to search CloudWatch logs, gather this information:

1. **Lambda identifier** - Code folder name OR AWS lambda name
2. **Environment** - dev, qa, or prod (defaults to dev)
3. **Branch** - master, dev, or feature branch like `iwa-12345` (defaults to
   master for prod, dev for dev/qa)
4. **Time range** - When to search (user's local time, typically EST)
5. **Search terms** - Optional text to filter logs

## Lambda Name Transformation

**CRITICAL**: The code folder names do NOT match AWS lambda names.

**BEFORE transforming lambda names, read the mapping files:**

- `mappings/fullstack-lambdas.json` - fullstack.assetwatch repository
- `mappings/jobs-lambdas.json` - assetwatch-jobs repository
- `mappings/api-lambdas.json` - API repositories (internal.api, external.api)

These JSON files contain complete mappings with examples and edge cases.

### Quick Reference

**fullstack.assetwatch:**

- Pattern: `lf-vero-prod-{name}` → `{name}-{env}-{branch}`
- Example: `lf-vero-prod-hub` + dev + iwa-12345 = `hub-dev-iwa-12345`
- Common: hub, asset, assetalert, facilities, sensor, monitoringpoint,
  inventory, hwqa

**assetwatch-jobs:**

- Pattern: `jobs_{name}/` → `jobs-{name-with-hyphens}-{env}-{branch}`
- Example: `jobs_data_processor_gen2/` + prod + master =
  `jobs-data-processor-gen2-prod-master`
- Common: data_processor_gen2, notifications, alarm, hardware

**API repositories:**

- internal.api: `internal-api-{env}-{branch}`,
  `internal-api-jpw-etl-processor-{env}`
- external.api: `external-api-{env}-{branch}`,
  `enterprise-api-authorizer-{env}-{branch}`

For complete mappings, descriptions, and all examples, read the JSON files
above.

## AWS Account/Profile Mapping

**IMPORTANT**: Different environments are in DIFFERENT AWS accounts. You MUST
use the correct profile:

| Environment     | AWS Profile       | Account ID   |
| --------------- | ----------------- | ------------ |
| dev             | `dev` (default)   | 396913697939 |
| qa              | `qa`              | 221463224365 |
| prod            | `prod`            | 975740733715 |
| shared-services | `shared-services` | 831926601094 |
| sandbox         | `sandbox`         | 160885252127 |

## Step-by-Step Search Process

### Step 1: Transform Lambda Name

```
User says: "hub lambda" or "lf-vero-prod-hub"
Transform to: hub-{env}-{branch}
```

### Step 2: Switch AWS Profile

```bash
# For prod environment:
export AWS_PROFILE=prod

# For qa environment:
export AWS_PROFILE=qa

# For dev environment (default):
export AWS_PROFILE=dev
```

### Step 3: Verify the Log Group Exists

```bash
# Construct the log group name
LOG_GROUP="/aws/lambda/{transformed-lambda-name}"

# Verify it exists
aws logs describe-log-groups --log-group-name-prefix "$LOG_GROUP" --query 'logGroups[*].logGroupName' --output text
```

If the exact log group doesn't exist, list similar ones:

```bash
aws logs describe-log-groups --query 'logGroups[*].logGroupName' --output text | tr '\t' '\n' | grep -i "{short-name}"
```

### Step 4: Convert Time to UTC

User time is typically **EST (Eastern Standard Time = UTC-5)** or **EDT (Eastern
Daylight Time = UTC-4)**.

```bash
# Convert EST to epoch milliseconds
# Example: "3:30 PM EST on Feb 3, 2026" = "2026-02-03 15:30:00 EST"

# Method 1: Using date command
START_TIME=$(TZ=America/New_York date -d "2026-02-03 15:25:00" +%s)000
END_TIME=$(TZ=America/New_York date -d "2026-02-03 15:35:00" +%s)000

# Method 2: Manual calculation (EST = UTC-5)
# 15:30 EST = 20:30 UTC
```

### Step 5: Search the Logs

**Basic search (last N minutes):**

```bash
aws logs filter-log-events \
  --log-group-name "/aws/lambda/hub-prod-master" \
  --start-time $START_TIME \
  --end-time $END_TIME \
  --output text
```

**Search with filter pattern:**

```bash
aws logs filter-log-events \
  --log-group-name "/aws/lambda/hub-prod-master" \
  --start-time $START_TIME \
  --end-time $END_TIME \
  --filter-pattern "ERROR" \
  --output text
```

**Search for specific text (case-sensitive):**

```bash
aws logs filter-log-events \
  --log-group-name "/aws/lambda/hub-prod-master" \
  --start-time $START_TIME \
  --end-time $END_TIME \
  --filter-pattern '"specific text to find"' \
  --output text
```

**Tail logs in real-time (for live debugging):**

```bash
aws logs tail "/aws/lambda/hub-prod-master" --follow
```

### Step 6: Get Recent Log Streams (if needed)

```bash
# List recent log streams
aws logs describe-log-streams \
  --log-group-name "/aws/lambda/hub-prod-master" \
  --order-by LastEventTime \
  --descending \
  --limit 10 \
  --query 'logStreams[*].[logStreamName,lastEventTimestamp]' \
  --output table
```

## Common Scenarios

### Scenario 1: User provides code folder name

```
User: "Search logs for lf-vero-prod-hub in prod around 3:30 PM EST"

1. Transform: lf-vero-prod-hub -> hub-prod-master
2. Profile: AWS_PROFILE=prod
3. Log group: /aws/lambda/hub-prod-master
4. Time: 3:25-3:35 PM EST -> epoch milliseconds in UTC
5. Search!
```

### Scenario 2: User provides partial info

```
User: "Check hub lambda logs"

Ask:
- Which environment? (dev/qa/prod)
- Which branch? (master, or feature branch like iwa-12345)
- What time range?
- Any specific text to search for?
```

### Scenario 3: User provides AWS lambda name directly

```
User: "Search hub-dev-iwa-12345 logs"

1. Already transformed - use directly
2. Profile: AWS_PROFILE=dev (inferred from -dev- in name)
3. Log group: /aws/lambda/hub-dev-iwa-12345
4. Search!
```

### Scenario 4: Log group not found

```
If /aws/lambda/hub-prod-master doesn't exist:

1. List all log groups containing "hub":
   aws logs describe-log-groups --query 'logGroups[*].logGroupName' --output text | tr '\t' '\n' | grep -i hub

2. Check if branch name is different (master vs main vs specific branch)

3. Verify you're in the correct AWS account:
   aws sts get-caller-identity
```

## Branch Naming Conventions

| Environment | Common Branches                                          |
| ----------- | -------------------------------------------------------- |
| prod        | `master` (production deployments)                        |
| qa          | `master` (QA testing)                                    |
| dev         | `dev`, `iwa-XXXXX` (feature branches), `{name}-{ticket}` |

**Note**: Dev environment often has MANY branches deployed. Each feature branch
gets its own lambda: `hub-dev-iwa-12345`, `hub-dev-iwa-13456`, etc.

## Time Range Tips

- For "just now" or "a few minutes ago": Use -5 minutes to +2 minutes from
  current time
- For "around X time": Use -5 to +5 minutes from specified time
- For "between X and Y": Convert both to epoch milliseconds
- Always account for timezone (user is typically EST/EDT)

## Filter Pattern Syntax

| Pattern                 | Matches                       |
| ----------------------- | ----------------------------- |
| `ERROR`                 | Lines containing "ERROR"      |
| `"exact phrase"`        | Lines containing exact phrase |
| `?ERROR ?WARN`          | Lines with ERROR OR WARN      |
| `[ip, user, ...]`       | Space-delimited log format    |
| `{ $.level = "error" }` | JSON logs with level field    |

## Troubleshooting

### "Log group not found"

1. Check AWS profile matches environment
2. Verify lambda name transformation is correct
3. List similar log groups to find the right one
4. Check if lambda exists:
   `aws lambda list-functions --query 'Functions[?contains(FunctionName, `hub`)].FunctionName'`

### "No log events found"

1. Expand time range
2. Verify timezone conversion is correct
3. Check if lambda was invoked during that time
4. Try without filter pattern first

### "Access denied"

1. Verify AWS SSO session is active: `aws sso login --profile {profile}`
2. Check you have CloudWatch Logs read permissions

## Example Full Workflow

```bash
# User: "I need to check the hub lambda logs in prod, I just triggered a bug at 3:29 PM EST"

# 1. Set profile for prod
export AWS_PROFILE=prod

# 2. Verify account
aws sts get-caller-identity
# Should show Account: 975740733715

# 3. Transform and verify log group
aws logs describe-log-groups --log-group-name-prefix "/aws/lambda/hub-prod" --query 'logGroups[*].logGroupName' --output text
# Returns: /aws/lambda/hub-prod-master

# 4. Convert time (3:29 PM EST on Feb 3, 2026, search 3:24-3:34 PM)
START_TIME=$(TZ=America/New_York date -d "2026-02-03 15:24:00" +%s)000
END_TIME=$(TZ=America/New_York date -d "2026-02-03 15:34:00" +%s)000

# 5. Search logs
aws logs filter-log-events \
  --log-group-name "/aws/lambda/hub-prod-master" \
  --start-time $START_TIME \
  --end-time $END_TIME \
  --output json | head -100
```

---

## Improving This Skill

**This skill is designed to improve over time as you use it.** After completing
a CloudWatch investigation, capture what you learned by **creating NEW FILES in
the subdirectories**.

**CRITICAL - DO NOT MODIFY SKILL.md**:

- ✅ **DO**: Create new files in subdirectories (examples/, templates/,
  mappings/, scripts/, docs/)
- ❌ **DON'T**: Modify this main SKILL.md file
- ✅ **DO**: Use Write tool to create new standalone files
- ❌ **DON'T**: Use Edit tool to add sections to SKILL.md

### When to Update

After any significant CloudWatch log investigation, especially:

- Bug investigations (found root cause in logs)
- Performance debugging (found slow operations)
- Error spike analysis (identified pattern)
- Integration issues (tracked API calls)

### How to Trigger Skill Improvement

**After completing a CloudWatch investigation, the user will say something
like:**

- "Update the cloudwatch-logs skill with what we learned"
- "Improve the /cloudwatch-logs skill based on this session"
- "Add this to the cloudwatch-logs examples"
- "Document this investigation for the skill"

**When you hear this, follow these steps:**

**CRITICAL - File Locations:**

- ✅ **Write to source repo**:
  `/home/aw-jwalker/repos/assetwatch-claude-plugins/aws/skills/cloudwatch-logs/`
- ❌ **NOT to cache**: `~/.claude/plugins/cache/assetwatch-claude-plugins/...`

Changes to cache are lost. Always update the source repository.

1. Review the conversation to identify 1-3 key learnings
2. Decide what to update:
   - **Investigation examples, query patterns, debugging workflows** → Create
     files in subdirectories
   - **Core instructions, AWS accounts, fundamental workflow changes** → May
     need SKILL.md edits
3. **Prefer subdirectories** for most learnings:
   - Use Write tool with full path:
     `/home/aw-jwalker/repos/assetwatch-claude-plugins/aws/skills/cloudwatch-logs/examples/2026-02-04-description.md`
   - Or:
     `/home/aw-jwalker/repos/assetwatch-claude-plugins/aws/skills/cloudwatch-logs/templates/query-patterns.json`
4. Only edit SKILL.md if core instructions truly need updating

**Most session learnings go into subdirectories, not SKILL.md.**

### What to Update (Create New Files)

#### 1. Add Examples (`examples/`)

Document successful investigations so you can reference them later.

**When:** After solving a problem using CloudWatch logs

**How:**

- Create a NEW markdown file in `examples/` directory
- Example file path: `examples/2026-02-03-hub-partnumber-validation-bug.md`
- Follow the template structure in `examples/README.md`
- Include: context, search commands used, findings, resolution

**Why:** Build institutional knowledge, avoid rediscovering patterns

#### 2. Add Query Templates (`templates/`)

Save filter patterns that worked well.

**When:** You create a complex filter pattern that you'll reuse

**How:**

- Create or update JSON files in `templates/` directory
- Example file path: `templates/bug-investigation-queries.json`
- Add query objects with: description, filter_pattern, time_range_minutes,
  use_cases, example
- See `templates/README.md` for JSON structure

**Why:** Avoid recreating successful queries from scratch

#### 3. Update Lambda Mappings (`mappings/`)

Keep lambda name transformations up-to-date.

**When:** You discover a missing or incorrect mapping **How:** Update the JSON
files in `mappings/` directory **Why:** Make lambda name resolution automatic
and accurate

#### 4. Create Helper Scripts (`scripts/`)

Automate repetitive tasks.

**When:** You run the same complex command multiple times **How:** Create a bash
script following guidelines in `scripts/README.md` **Why:** Speed up common
operations, reduce errors

#### 5. Add Documentation (`docs/`)

Document discoveries and best practices.

**When:** You learn something not covered in this skill **How:** Create focused
documentation on specific topics **Why:** Share knowledge, avoid repeating
mistakes

### Update Process

At the end of a CloudWatch investigation:

1. **Document the example** - Create a file in `examples/` with what you found
2. **Extract patterns** - If you used effective filter patterns, add them to
   `templates/`
3. **Update mappings** - If you discovered lambda mappings, update `mappings/`
4. **Consider automation** - If you repeated commands, create a script in
   `scripts/`

**Concrete Example:**

After investigating a hub PartNumber validation bug, you should:

```bash
# 1. Create an example document
# Use Write tool with full source repo path:
/home/aw-jwalker/repos/assetwatch-claude-plugins/aws/skills/cloudwatch-logs/examples/2026-02-03-hub-partnumber-validation.md

# 2. Add query patterns you used
# Use Write tool with full source repo path:
/home/aw-jwalker/repos/assetwatch-claude-plugins/aws/skills/cloudwatch-logs/templates/validation-debugging.json

# 3. Do NOT write to cache
# ❌ NOT: ~/.claude/plugins/cache/assetwatch-claude-plugins/...
# ✅ YES: /home/aw-jwalker/repos/assetwatch-claude-plugins/...
```

### Reading From Subdirectories

When this skill is invoked, Claude should:

- Check `templates/` for relevant saved queries
- Load `mappings/*.json` to transform lambda names
- Reference `examples/` for similar past investigations
- Suggest `scripts/` for common operations

This creates a feedback loop: use the skill → learn → update → improve for next
time.
