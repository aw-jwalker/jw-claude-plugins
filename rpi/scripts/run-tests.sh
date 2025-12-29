#!/bin/bash
# Test runner - captures full output for agent analysis
# Supports: fullstack (TS), node, python, flutter, lambda-multi, infra-only
set -o pipefail

# Detect project type based on AssetWatch repo patterns
detect_project() {
    # Fullstack TypeScript (frontend + lambdas)
    if [ -f "frontend/package.json" ] && [ -d "lambdas" ]; then
        echo "fullstack"
    # Fullstack with backend (frontend + backend)
    elif [ -f "frontend/package.json" ] && [ -d "backend" ]; then
        echo "fullstack-backend"
    # Flutter/Dart
    elif [ -f "pubspec.yaml" ]; then
        echo "flutter"
    # Python
    elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
        echo "python"
    # Multi-lambda (like assetwatch-mobile-backend)
    elif [ -d "lambda" ] && ls lambda/*/package.json &>/dev/null; then
        echo "lambda-multi"
    # Single Node/TypeScript
    elif [ -f "package.json" ]; then
        echo "node"
    # Infrastructure only (terraform, mysql, etc)
    elif [ -d "terraform" ] || [ -d "mysql" ]; then
        echo "infra-only"
    else
        echo "unknown"
    fi
}

# Run command and capture full output
run_check() {
    local name="$1"
    local cmd="$2"

    echo "### $name"
    echo ""
    echo "Command: \`$cmd\`"
    echo ""

    # Run command and capture full output
    local output
    local exit_code
    output=$(eval "$cmd" 2>&1)
    exit_code=$?

    if [ $exit_code -eq 0 ]; then
        echo "**Status**: PASS"
        echo ""
        if [ -n "$output" ]; then
            echo "<details>"
            echo "<summary>Output ($(echo "$output" | wc -l) lines)</summary>"
            echo ""
            echo '```'
            echo "$output"
            echo '```'
            echo "</details>"
        fi
    else
        echo "**Status**: FAIL (exit code $exit_code)"
        echo ""
        echo '```'
        echo "$output"
        echo '```'
    fi
    echo ""
    return $exit_code
}

# Check if command/tool exists
check_command() {
    local cmd="$1"
    if ! command -v "$cmd" &> /dev/null; then
        echo "**Status**: SKIPPED ('$cmd' not found)"
        echo ""
        return 1
    fi
    return 0
}

# Run typecheck based on project type
run_typecheck() {
    local project_type=$(detect_project)

    echo "## TypeScript/Type Check"
    echo ""

    case "$project_type" in
        fullstack|fullstack-backend)
            # Check frontend first
            if [ -f "frontend/package.json" ]; then
                if [ -f "frontend/tsconfig.json" ]; then
                    (cd frontend && run_check "Frontend tsc" "npx tsc --noEmit")
                elif grep -q '"typecheck"' frontend/package.json 2>/dev/null; then
                    (cd frontend && run_check "Frontend typecheck" "npm run typecheck")
                else
                    echo "### Frontend tsc"
                    echo "**Status**: SKIPPED (no tsconfig.json)"
                    echo ""
                fi
            fi
            # Check lambdas
            if [ -f "lambdas/tsconfig.json" ]; then
                (cd lambdas && run_check "Lambdas tsc" "npx tsc --noEmit")
            fi
            # Check backend
            if [ -f "backend/tsconfig.json" ]; then
                (cd backend && run_check "Backend tsc" "npx tsc --noEmit")
            fi
            ;;
        node)
            if ! check_command "npx"; then return 0; fi
            if [ -f "tsconfig.json" ]; then
                run_check "tsc --noEmit" "npx tsc --noEmit"
            elif grep -q '"typecheck"' package.json 2>/dev/null; then
                run_check "npm run typecheck" "npm run typecheck"
            else
                echo "### TypeScript Check"
                echo "**Status**: SKIPPED (no tsconfig.json)"
                echo ""
            fi
            ;;
        python)
            echo "### Python Type Check"
            if command -v mypy &> /dev/null; then
                run_check "mypy" "mypy ."
            elif command -v pyright &> /dev/null; then
                run_check "pyright" "pyright"
            else
                echo "**Status**: SKIPPED (no mypy/pyright)"
                echo ""
            fi
            ;;
        flutter)
            echo "### Dart Analyze"
            if command -v dart &> /dev/null; then
                run_check "dart analyze" "dart analyze"
            else
                echo "**Status**: SKIPPED (dart not found)"
                echo ""
            fi
            ;;
        *)
            echo "### Type Check"
            echo "**Status**: SKIPPED (project type '$project_type')"
            echo ""
            ;;
    esac
}

# Run lint based on project type
run_lint() {
    local project_type=$(detect_project)

    echo "## Lint Check"
    echo ""

    case "$project_type" in
        fullstack|fullstack-backend)
            # Check frontend
            if [ -f "frontend/package.json" ]; then
                if grep -q '"lint"' frontend/package.json 2>/dev/null; then
                    (cd frontend && run_check "Frontend lint" "npm run lint")
                else
                    echo "### Frontend lint"
                    echo "**Status**: SKIPPED (no lint script)"
                    echo ""
                fi
            fi
            # Check lambdas
            if [ -f "lambdas/package.json" ] && grep -q '"lint"' lambdas/package.json 2>/dev/null; then
                (cd lambdas && run_check "Lambdas lint" "npm run lint")
            fi
            # Check backend
            if [ -f "backend/package.json" ] && grep -q '"lint"' backend/package.json 2>/dev/null; then
                (cd backend && run_check "Backend lint" "npm run lint")
            fi
            ;;
        node)
            if ! check_command "npx"; then return 0; fi
            if [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] || [ -f ".eslintrc" ] || [ -f "eslint.config.js" ] || [ -f "eslint.config.mjs" ]; then
                run_check "ESLint" "npx eslint . --max-warnings=0"
            elif grep -q '"lint"' package.json 2>/dev/null; then
                run_check "npm run lint" "npm run lint"
            else
                echo "### Lint"
                echo "**Status**: SKIPPED (no eslint config)"
                echo ""
            fi
            ;;
        python)
            echo "### Python Lint"
            if command -v ruff &> /dev/null; then
                run_check "ruff" "ruff check ."
            elif command -v flake8 &> /dev/null; then
                run_check "flake8" "flake8 ."
            elif command -v pylint &> /dev/null; then
                run_check "pylint" "pylint src/"
            else
                echo "**Status**: SKIPPED (no ruff/flake8/pylint)"
                echo ""
            fi
            ;;
        flutter)
            echo "### Dart Format"
            if command -v dart &> /dev/null; then
                run_check "dart format" "dart format --set-exit-if-changed ."
            else
                echo "**Status**: SKIPPED (dart not found)"
                echo ""
            fi
            ;;
        *)
            echo "### Lint"
            echo "**Status**: SKIPPED (project type '$project_type')"
            echo ""
            ;;
    esac
}

# Run tests based on project type
run_test() {
    local project_type=$(detect_project)

    echo "## Unit Tests"
    echo ""

    case "$project_type" in
        fullstack)
            # Check frontend
            if [ -f "frontend/package.json" ] && grep -q '"test"' frontend/package.json 2>/dev/null; then
                (cd frontend && run_check "Frontend tests" "npm test -- --run")
            else
                echo "### Frontend tests"
                echo "**Status**: SKIPPED (no test script)"
                echo ""
            fi
            # Check lambdas
            if [ -f "lambdas/package.json" ] && grep -q '"test"' lambdas/package.json 2>/dev/null; then
                (cd lambdas && run_check "Lambda tests" "npm test -- --run")
            fi
            ;;
        fullstack-backend)
            # Check frontend
            if [ -f "frontend/package.json" ] && grep -q '"test"' frontend/package.json 2>/dev/null; then
                (cd frontend && run_check "Frontend tests" "npm test -- --run")
            fi
            # Check backend
            if [ -f "backend/package.json" ] && grep -q '"test"' backend/package.json 2>/dev/null; then
                (cd backend && run_check "Backend tests" "npm test -- --run")
            fi
            ;;
        node)
            if ! check_command "npm"; then return 0; fi
            if grep -q '"test"' package.json 2>/dev/null; then
                run_check "Tests" "npm test -- --run"
            else
                echo "### Tests"
                echo "**Status**: SKIPPED (no test script)"
                echo ""
            fi
            ;;
        python)
            echo "### Python Tests"
            if command -v pytest &> /dev/null; then
                run_check "pytest" "pytest -v"
            elif command -v python3 &> /dev/null; then
                run_check "unittest" "python3 -m unittest discover -v"
            else
                echo "**Status**: SKIPPED (no pytest/python3)"
                echo ""
            fi
            ;;
        flutter)
            echo "### Flutter Tests"
            if command -v flutter &> /dev/null; then
                run_check "flutter test" "flutter test"
            else
                echo "**Status**: SKIPPED (flutter not found)"
                echo ""
            fi
            ;;
        lambda-multi)
            echo "Multi-lambda project - testing individual lambdas:"
            echo ""
            for lambda_dir in lambda/*/; do
                if [ -f "${lambda_dir}package.json" ] && grep -q '"test"' "${lambda_dir}package.json" 2>/dev/null; then
                    lambda_name=$(basename "$lambda_dir")
                    (cd "$lambda_dir" && run_check "$lambda_name" "npm test -- --run")
                fi
            done
            ;;
        infra-only)
            echo "### Tests"
            echo "**Status**: SKIPPED (infrastructure-only project)"
            echo ""
            ;;
        *)
            echo "### Tests"
            echo "**Status**: SKIPPED (project type '$project_type')"
            echo ""
            ;;
    esac
}

# Run build based on project type
run_build() {
    local project_type=$(detect_project)

    echo "## Build Check"
    echo ""

    case "$project_type" in
        fullstack|fullstack-backend)
            if [ -f "frontend/package.json" ] && grep -q '"build"' frontend/package.json 2>/dev/null; then
                (cd frontend && run_check "Frontend build" "npm run build")
            else
                echo "### Build"
                echo "**Status**: SKIPPED (no build script)"
                echo ""
            fi
            ;;
        node)
            if ! check_command "npm"; then return 0; fi
            if grep -q '"build"' package.json 2>/dev/null; then
                run_check "Build" "npm run build"
            else
                echo "### Build"
                echo "**Status**: SKIPPED (no build script)"
                echo ""
            fi
            ;;
        flutter)
            echo "### Build"
            echo "**Status**: SKIPPED (use 'flutter build' manually)"
            echo ""
            ;;
        *)
            echo "### Build"
            echo "**Status**: SKIPPED (project type '$project_type')"
            echo ""
            ;;
    esac
}

# Main
PROJECT_TYPE=$(detect_project)

echo "# Test Runner Output"
echo ""
echo "**Project type**: $PROJECT_TYPE"
echo "**Directory**: $(pwd)"
echo "**Timestamp**: $(date -Iseconds)"
echo ""

case "${1:-all}" in
    typecheck|tsc)
        run_typecheck
        ;;
    lint)
        run_lint
        ;;
    test)
        run_test
        ;;
    build)
        run_build
        ;;
    all)
        run_typecheck
        run_lint
        run_test
        ;;
    *)
        echo "Usage: $0 {typecheck|lint|test|build|all}"
        echo ""
        echo "Commands:"
        echo "  typecheck  Run TypeScript/type checker"
        echo "  lint       Run linter (ESLint, ruff, dart)"
        echo "  test       Run unit tests"
        echo "  build      Run build"
        echo "  all        Run typecheck, lint, and test (default)"
        echo ""
        echo "Supported project types:"
        echo "  fullstack        - frontend/ + lambdas/ (TypeScript)"
        echo "  fullstack-backend - frontend/ + backend/"
        echo "  node             - Single package.json"
        echo "  python           - pyproject.toml or requirements.txt"
        echo "  flutter          - pubspec.yaml"
        echo "  lambda-multi     - lambda/*/ directories"
        echo "  infra-only       - terraform/mysql only"
        exit 1
        ;;
esac

echo "---"
echo "**End of test output**"
