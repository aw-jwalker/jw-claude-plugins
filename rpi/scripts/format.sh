#!/bin/bash
set -euo pipefail

# Read hook input from stdin
INPUT=$(cat)

# Extract file path from tool input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [[ -z "$FILE_PATH" ]] || [[ ! -f "$FILE_PATH" ]]; then
  exit 0  # No file to format
fi

# Only format supported file types
case "$FILE_PATH" in
  *.ts|*.tsx|*.js|*.jsx|*.json|*.css|*.scss|*.md|*.html|*.yaml|*.yml)
    # Check if prettier is available
    if command -v npx &> /dev/null; then
      npx prettier --write "$FILE_PATH" 2>/dev/null || true
    fi
    ;;
esac

exit 0
