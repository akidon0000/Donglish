---
name: ios-fix-build
description: >-
  Automatically detect and fix iOS build errors. Analyzes error logs and applies appropriate fixes.
  "ビルドエラーを直して", "buildが通らない", "fix build error", "ビルド失敗を修正して" 等で使用。
---

## When to use this skill

- iOS build fails and you want to auto-fix errors
- Given build error logs and asked to fix them
- After `ios-run-build` fails

## Workflow

### 1. Build & Get Errors

```bash
xcodebuild \
  -project Donglish.xcodeproj \
  -scheme Donglish \
  -destination 'platform=iOS Simulator,name=iPhone 16e' \
  -derivedDataPath ./DerivedData \
  build 2>&1
```

### 2. Error Classification

Extract `error:` lines from build output and classify into categories below.

---

## Error Categories & Fix Logic

### A. SwiftLint Errors

**Detection:** `warning:` or `error:` containing SwiftLint rule names

**Fix:**
1. Auto-fix first:
```bash
swiftlint --fix --config .swiftlint.yml <target-file>
```
2. Manual fix for rules that `--fix` cannot resolve

### B. SwiftFormat Errors

**Fix:**
```bash
swiftformat --config .swiftformat <target-file>
```

### C. Compile Errors (Type/Scope)

| Pattern | Example | Fix |
|---------|---------|-----|
| Missing import | `Cannot find type 'X' in scope` | Add the appropriate `import` |
| Type mismatch | `Cannot convert value of type 'A' to 'B'` | Add type conversion, handle Optional with `?`, `!`, `??` |
| Missing member | `Value of type 'X' has no member 'Y'` | Check API changes, use correct member name |
| Deprecated API | `'old()' is deprecated: use 'new()'` | Replace with new API as indicated |
| Argument mismatch | `Missing argument for parameter 'X'` | Check function signature, add missing argument |
| Access control | `'X' is inaccessible due to 'private'` | Adjust access level appropriately |

### D. Syntax Errors

**Detection:** `expected '}'`, `unexpected token`, `unterminated string literal`

**Fix:**
1. Check bracket/brace matching around the error line
2. Compare with `git diff` to identify the cause
3. Fix mismatched brackets, typos, or invalid characters

### E. Linker Errors

**Detection:** `ld:`, `Undefined symbol`, `duplicate symbol`, `library not found`

| Pattern | Fix |
|---------|-----|
| `Undefined symbol` | Add missing framework/library to target |
| `duplicate symbol` | Find and resolve duplicate definitions |
| `library not found` | Check library path settings, resolve SPM packages |

### F. SPM Errors

**Detection:** `Package resolution failed`, `dependency graph is invalid`

**Fix:**
```bash
rm -rf DerivedData/SourcePackages
xcodebuild -resolvePackageDependencies \
  -project Donglish.xcodeproj \
  -scheme Donglish
```

### G. Code Signing Errors

**Detection:** `Signing requires a development team`, `No profiles for`

**Fix:** Cannot auto-fix. Report to user with guidance:
- Check Signing & Capabilities in Xcode
- Verify provisioning profiles

---

## Fix Priority Order

1. **Format** (A, B) → Tool auto-fix
2. **Compile** (C, D) → Individual code fixes
3. **Linker** (E) → Project settings
4. **SPM** (F) → Cache clear & version adjust
5. **Signing** (G) → Report to user

### 3. Verify Fix

Re-run build after applying fixes:

```bash
xcodebuild \
  -project Donglish.xcodeproj \
  -scheme Donglish \
  -destination 'platform=iOS Simulator,name=iPhone 16e' \
  -derivedDataPath ./DerivedData \
  build 2>&1
```

### 4. Report

```markdown
## Build Error Fix Report

### Detected Errors (X total)
| Category | Count | Action |
|----------|-------|--------|
| SwiftLint | N | Auto-fixed |
| Compile | N | Manual fix |

### Applied Fixes (Y total)
1. file:line - Fix description

### Build Result
BUILD SUCCEEDED / BUILD FAILED (Z remaining)
```

## Notes

- Do not create temporary log files (process via stdout)
- Keep fixes minimal and preserve original code style
- If not resolved in one cycle, report remaining errors to user
