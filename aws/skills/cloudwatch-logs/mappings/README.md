# Lambda Name Mappings

This directory contains mappings between code folder names and AWS Lambda names.

## Purpose

AssetWatch code folder names don't match AWS Lambda names. These JSON files
define the transformation rules.

## Structure

Create one JSON file per repository:

```json
{
  "repository": "fullstack.assetwatch",
  "last_updated": "2026-02-03",
  "mappings": [
    {
      "code_folder": "lf-vero-prod-hub",
      "aws_pattern": "hub-{env}-{branch}",
      "description": "Hub diagnostic and configuration lambda"
    }
  ]
}
```

## When to Update

- New lambda is added to a repository
- Lambda naming convention changes
- You discover a mapping that's missing or incorrect

## How to Use

The cloudwatch-logs skill should read these JSON files instead of using
hardcoded tables.
