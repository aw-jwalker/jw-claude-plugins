# Helper Scripts

This directory contains bash scripts that encapsulate common CloudWatch Logs
operations.

## Purpose

Scripts make it easier to run common searches without remembering complex AWS
CLI syntax.

## Guidelines

Each script should:

- Have a clear, descriptive name
- Include usage comments at the top
- Handle errors gracefully
- Support common use cases

## Example Script Structure

```bash
#!/bin/bash
# search-logs.sh - Quick CloudWatch Logs search wrapper
#
# Usage: ./search-logs.sh <lambda-name> <env> <pattern> [minutes-ago]
#
# Examples:
#   ./search-logs.sh hub prod ERROR 10
#   ./search-logs.sh asset dev "PartNumber" 30

set -e

# Script implementation...
```

## When to Add a Script

Create a script when you:

- Run the same complex command repeatedly
- Need to combine multiple AWS CLI calls
- Want to automate common workflows (e.g., time conversion, profile switching)

## Ideas for Scripts

- `search-logs.sh` - Wrapper for filter-log-events with time range
- `tail-lambda.sh` - Tail logs for a specific lambda
- `find-errors.sh` - Search for errors with context
- `compare-environments.sh` - Compare logs across dev/qa/prod
