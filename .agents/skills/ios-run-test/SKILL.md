---
name: ios-run-test
description: >-
  Run iOS unit tests and report results.
  "テスト実行", "run tests", "テスト通るか確認", "unit test" 等で使用。
---

## When to use this skill

- When asked to run iOS unit tests
- After code changes to verify tests pass
- When test result reporting is requested

## Test Commands

### Run All Tests

```bash
xcodebuild \
  -project Donglish.xcodeproj \
  -scheme Donglish \
  -destination 'platform=iOS Simulator,name=iPhone 16e' \
  -derivedDataPath ./DerivedData \
  test 2>&1
```

### Run Specific Tests

```bash
xcodebuild \
  -project Donglish.xcodeproj \
  -scheme Donglish \
  -destination 'platform=iOS Simulator,name=iPhone 16e' \
  -derivedDataPath ./DerivedData \
  -only-testing:<TestTarget>/<TestClass>/<testMethod> \
  test 2>&1
```

### Examples

```bash
# Specific class
-only-testing:DonglishTests/SomeClassTests

# Specific method
-only-testing:DonglishTests/SomeClassTests/testSomeMethod
```

## Workflow

### 1. Execute Tests

Choose command based on user request:

| Request | Command |
|---------|---------|
| All tests | `xcodebuild test` (full) |
| Specific tests | `xcodebuild test -only-testing:...` |

### 2. Determine Result

- `** TEST SUCCEEDED **` → Success
- `** TEST FAILED **` → Failure

### 3. Report

**Success:**
```
TEST SUCCEEDED (X tests passed)
```

**Failure:**
```
TEST FAILED (X passed, Y failed)

Failed tests:
1. TestTarget/TestClass/testMethod - Failure reason
2. ...

Suggestion: [Fix proposal]
```

## Notes

- Do not create temporary log files (process via stdout)
- If many tests fail, first verify build succeeds with `ios-run-build`
