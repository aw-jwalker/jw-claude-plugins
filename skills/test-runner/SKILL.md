---
name: test-runner
description: Run automated tests without polluting context. Uses test-runner agent for context isolation and compares results to baseline captured at session start to distinguish NEW failures from pre-existing issues.
---

# Smart Test Runner

## When to Use

- After implementing code changes during a plan
- When verifying success criteria
- When user asks to "run tests" or "verify changes"
- Before marking a phase as complete

## How It Works

```
Session Start (automatic)
         │
         ▼
┌─────────────────────────────┐
│  capture-baseline.sh        │
│  - Check git hash           │
│  - If changed: run tests    │
│  - Save .test-baseline.json │
└─────────────────────────────┘
         │
         ▼ (runs in background)

─────────── Later in Session ───────────

User: "Run tests"
         │
         ▼
┌─────────────────────┐     ┌─────────────────────┐
│   Main Context      │     │  Agent Context      │
│                     │     │  (isolated)         │
│  Invoke agent ──────┼────►│                     │
│                     │     │  1. Read baseline   │
│                     │     │  2. Run tests       │
│                     │     │  3. Compare results │
│                     │     │  4. Create summary  │
│                     │     │                     │
│  Receives SUMMARY ◄─┼─────│  "2 NEW failures,   │
│  (20-30 lines)      │     │   3 pre-existing"   │
└─────────────────────┘     └─────────────────────┘
```

## Key Features

1. **Context Isolation**: Full test output analyzed in separate context
2. **Baseline Comparison**: Distinguishes NEW failures from pre-existing
3. **Hash-Based Caching**: Only re-runs baseline when code changes between sessions
4. **Background Capture**: Baseline runs in background, doesn't block session start

## Invocation

```
Use the test-runner agent to run all tests and summarize results
```

## Expected Summary Format

**With baseline (can distinguish NEW vs pre-existing):**
```markdown
## Test Results Summary

**Project**: fullstack.assetwatch (fullstack)
**Baseline**: Captured 2025-12-23T10:00:00 (git abc123)
**Overall**: ❌ NEW failures detected

### Results vs Baseline

| Check | Baseline | Current | Status |
|-------|----------|---------|--------|
| TypeScript | ✅ pass | ✅ pass | No change |
| Unit Tests | ⚠️ fail (2) | ❌ fail (4) | 🆕 2 NEW failures |

### NEW Failures (from your changes)
1. **frontend/src/Alert.test.tsx:45** - props changed
2. **frontend/src/Alert.test.tsx:67** - handler not connected

### Pre-existing Failures
- lambdas/src/sync.test.ts - 2 failures (same as baseline)
```

**Without baseline:**
```markdown
## Test Results Summary

**Baseline**: Not available
⚠️ Cannot distinguish NEW vs pre-existing failures.

| Check | Status |
|-------|--------|
| Unit Tests | ❌ 4 failed |

### All Failures
1. ...
```

## Baseline Cache Behavior

| Scenario | Baseline Action |
|----------|-----------------|
| New session, same git hash | Use cached (instant) |
| New session, different hash | Re-run in background |
| Mid-session | Baseline stays fixed |

**File**: `.test-baseline.json` in project root

```json
{
  "git_hash": "abc123",
  "timestamp": "2025-12-23T10:00:00",
  "results": {
    "typecheck": { "status": "pass" },
    "lint": { "status": "pass" },
    "test": { "status": "fail", "error_preview": "..." }
  }
}
```

## Supported Project Types

| Type | Detection | Checks |
|------|-----------|--------|
| **fullstack** | `frontend/` + `lambdas/` | tsc, lint, vitest |
| **fullstack-backend** | `frontend/` + `backend/` | tsc, lint, vitest |
| **node** | `package.json` | tsc, eslint, npm test |
| **python** | `requirements.txt` | mypy, ruff, pytest |
| **flutter** | `pubspec.yaml` | dart analyze, flutter test |

## Manual Script Usage

```bash
# Run tests (full output - use agent for summaries)
${CLAUDE_PLUGIN_ROOT}/scripts/run-tests.sh all

# Manually capture baseline
${CLAUDE_PLUGIN_ROOT}/scripts/capture-baseline.sh
```