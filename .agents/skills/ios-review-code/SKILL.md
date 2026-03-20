---
name: ios-review-code
description: >-
  Review iOS code changes for Swift/SwiftUI best practices, architecture alignment, and platform-specific issues.
  Use when reviewing iOS diffs.
  "iOSコードレビュー", "review iOS code", "Swiftのレビュー" 等で使用。
---

# iOS Review Guidelines

Review iOS code changes from the following perspectives:

1. **Coding Standards** - Naming conventions, code formatting, access control
2. **Architecture** - Project architecture alignment, separation of concerns
3. **Swift/SwiftUI Best Practices** - Modern API usage, proper data flow, view composition
4. **Platform-Specific** - iOS lifecycle, memory management, background execution
5. **Performance** - Efficient rendering, lazy loading, appropriate caching
6. **Testing** - Test coverage, testable design, proper use of Swift Testing

## Output Format

**出力フォーマットは `common-review-format` スキルに従うこと。**

参照: `.agents/skills/common-review-format/SKILL.md`

## Related Skills
- SwiftUI details: `.agents/skills/swift-swiftui/SKILL.md`
- Swift Concurrency: `.agents/skills/swift-swiftconcurrency/SKILL.md`
- Swift Testing: `.agents/skills/swift-swifttesting/SKILL.md`
