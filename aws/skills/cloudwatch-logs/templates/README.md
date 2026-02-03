# Query Templates

This directory contains reusable CloudWatch Logs query templates.

## Structure

Save templates as JSON files with this format:

```json
{
  "query_name": {
    "description": "Brief description of what this query finds",
    "filter_pattern": "CloudWatch filter pattern syntax",
    "time_range_minutes": 30,
    "use_cases": ["When to use this query"],
    "example": "Example of what this finds"
  }
}
```

## When to Add a Template

Add a new template when you:

- Find yourself running the same search multiple times
- Create a complex filter pattern that works well
- Solve a common debugging scenario

## Example Templates to Add

- Error investigation queries
- Performance/timeout searches
- Integration/API call patterns
- Specific bug patterns (e.g., validation errors, null checks)
