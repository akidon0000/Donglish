---
name: ios-run-build
description: >-
  Execute iOS project build and report results.
  "iOSビルドして", "ビルド実行", "build iOS", "ビルド通るか確認して", "xcodebuild" 等で使用。
---

## When to use this skill

- Check if iOS project builds successfully
- After code changes when build verification is requested
- When delegated from other skills (ios-fix-build, etc.)

## Build Commands

### Standard Build

```bash
xcodebuild \
  -project Donglish.xcodeproj \
  -scheme Donglish \
  -destination 'platform=iOS Simulator,name=iPhone 16e' \
  -derivedDataPath ./DerivedData \
  build 2>&1
```

### Clean Build

Use when cache-related build failures occur:

```bash
xcodebuild \
  -project Donglish.xcodeproj \
  -scheme Donglish \
  -destination 'platform=iOS Simulator,name=iPhone 16e' \
  -derivedDataPath ./DerivedData \
  clean build 2>&1
```

## Workflow

### 1. Execute Build

Run standard build. Focus on error summary at the end of output.

### 2. Determine Result

- `** BUILD SUCCEEDED **` → Success
- `** BUILD FAILED **` → Failure (report errors)

### 3. Report

**Success:**
```
BUILD SUCCEEDED
```

**Failure:**
```
BUILD FAILED (X errors)

Errors:
1. file:line - Error description
2. ...

Suggestion: [Fix proposal or redirect to ios-fix-build skill]
```

## Notes

- Do not create temporary log files (process via stdout)
- For automatic build error fixing, use `ios-fix-build` skill
- Suggest clean build for cache-related issues
