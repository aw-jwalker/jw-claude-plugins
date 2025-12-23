#!/bin/bash
# Capture test baseline at session start
# Only re-runs if git hash changed since last baseline
set -euo pipefail

BASELINE_FILE=".test-baseline.json"
LOCK_FILE=".test-baseline.lock"

# Get current git hash (or "no-git" if not a repo)
get_git_hash() {
    git rev-parse HEAD 2>/dev/null || echo "no-git-$(date +%Y%m%d)"
}

# Check if baseline is still valid
is_baseline_valid() {
    if [ ! -f "$BASELINE_FILE" ]; then
        return 1  # No baseline exists
    fi

    local stored_hash
    stored_hash=$(jq -r '.git_hash // empty' "$BASELINE_FILE" 2>/dev/null)
    local current_hash
    current_hash=$(get_git_hash)

    if [ "$stored_hash" = "$current_hash" ]; then
        return 0  # Valid
    else
        return 1  # Stale
    fi
}

# Run tests and capture results (simplified - just status codes)
capture_results() {
    local results="{}"

    # Detect project type
    local project_type="unknown"
    if [ -f "frontend/package.json" ] && [ -d "lambdas" ]; then
        project_type="fullstack"
    elif [ -f "frontend/package.json" ] && [ -d "backend" ]; then
        project_type="fullstack-backend"
    elif [ -f "pubspec.yaml" ]; then
        project_type="flutter"
    elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
        project_type="python"
    elif [ -f "package.json" ]; then
        project_type="node"
    fi

    # TypeScript check
    local tsc_status="skipped"
    local tsc_output=""
    if [ "$project_type" = "fullstack" ] || [ "$project_type" = "fullstack-backend" ]; then
        if [ -f "frontend/tsconfig.json" ]; then
            tsc_output=$(cd frontend && npx tsc --noEmit 2>&1) && tsc_status="pass" || tsc_status="fail"
        fi
    elif [ "$project_type" = "node" ] && [ -f "tsconfig.json" ]; then
        tsc_output=$(npx tsc --noEmit 2>&1) && tsc_status="pass" || tsc_status="fail"
    fi

    # Lint check
    local lint_status="skipped"
    local lint_output=""
    if [ "$project_type" = "fullstack" ] || [ "$project_type" = "fullstack-backend" ]; then
        if [ -f "frontend/package.json" ] && grep -q '"lint"' frontend/package.json 2>/dev/null; then
            lint_output=$(cd frontend && npm run lint 2>&1) && lint_status="pass" || lint_status="fail"
        fi
    elif [ "$project_type" = "node" ]; then
        if grep -q '"lint"' package.json 2>/dev/null; then
            lint_output=$(npm run lint 2>&1) && lint_status="pass" || lint_status="fail"
        fi
    fi

    # Unit tests
    local test_status="skipped"
    local test_output=""
    local test_summary=""
    if [ "$project_type" = "fullstack" ]; then
        if [ -f "frontend/package.json" ] && grep -q '"test"' frontend/package.json 2>/dev/null; then
            test_output=$(cd frontend && npm test -- --run 2>&1) && test_status="pass" || test_status="fail"
            # Try to extract pass/fail counts from vitest output
            test_summary=$(echo "$test_output" | grep -E "Tests.*passed|Tests.*failed" | tail -1 || echo "")
        fi
    elif [ "$project_type" = "node" ]; then
        if grep -q '"test"' package.json 2>/dev/null; then
            test_output=$(npm test -- --run 2>&1) && test_status="pass" || test_status="fail"
            test_summary=$(echo "$test_output" | grep -E "Tests.*passed|Tests.*failed" | tail -1 || echo "")
        fi
    fi

    # Build JSON result
    local current_hash
    current_hash=$(get_git_hash)

    cat > "$BASELINE_FILE" << EOF
{
  "git_hash": "$current_hash",
  "timestamp": "$(date -Iseconds)",
  "project_type": "$project_type",
  "directory": "$(pwd)",
  "results": {
    "typecheck": {
      "status": "$tsc_status",
      "error_preview": $(echo "$tsc_output" | head -5 | jq -Rs .)
    },
    "lint": {
      "status": "$lint_status",
      "error_preview": $(echo "$lint_output" | head -5 | jq -Rs .)
    },
    "test": {
      "status": "$test_status",
      "summary": $(echo "$test_summary" | jq -Rs .),
      "error_preview": $(echo "$test_output" | grep -A2 "FAIL\|Error\|failed" | head -10 | jq -Rs .)
    }
  }
}
EOF

    echo "Baseline captured: typecheck=$tsc_status, lint=$lint_status, test=$test_status"
}

# Main
main() {
    # Prevent concurrent runs
    if [ -f "$LOCK_FILE" ]; then
        lock_age=$(($(date +%s) - $(stat -c %Y "$LOCK_FILE" 2>/dev/null || echo 0)))
        if [ "$lock_age" -lt 300 ]; then
            echo "Baseline capture already in progress (lock age: ${lock_age}s)"
            exit 0
        fi
        # Stale lock, remove it
        rm -f "$LOCK_FILE"
    fi

    # Check if baseline is valid
    if is_baseline_valid; then
        echo "Baseline is current (git hash unchanged)"
        exit 0
    fi

    # Create lock
    echo $$ > "$LOCK_FILE"
    trap 'rm -f "$LOCK_FILE"' EXIT

    echo "Capturing new baseline..."
    capture_results

    echo "Baseline saved to $BASELINE_FILE"
}

main "$@"