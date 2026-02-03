# Real-World Examples

This directory contains documented examples from actual CloudWatch log
investigations.

## Purpose

Build a knowledge base of solved problems that can guide future investigations.

## Structure

Create one markdown file per investigation:

````markdown
# Example: [Brief Title of Investigation]

## Context

- Date: YYYY-MM-DD
- Issue: What was the problem?
- Lambda: Which lambda was involved?
- Environment: dev/qa/prod

## Search Process

1. What information did you gather first?
2. What searches did you run?
3. What filters worked best?

## Commands Used

```bash
# Actual commands that were successful
```
````

## Findings

- What did you discover in the logs?
- What was the root cause?

## Resolution

- How was it fixed?
- What code changes were made?
- What did you learn?

## Reusable Patterns

- Query patterns that could be templates
- Lambda mappings that should be added
- Common mistakes to avoid

```

## When to Add an Example

After completing any significant CloudWatch investigation:
- Bug investigation
- Performance debugging
- Integration issue
- Error spike analysis

## Value

These examples help you:
- Remember what worked in similar situations
- Build query templates from proven patterns
- Train others on effective log searching
- Avoid repeating mistakes
```
