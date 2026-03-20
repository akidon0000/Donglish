---
name: git-review-pr
description: >-
  Review pull request code for quality, readability, consistency, performance, and security.
  "PRをレビューして", "review this PR", "コードレビュー", "pull requestを見て" 等で使用。
---

## Review Criteria

### Code Quality
- Reliability (error handling, edge cases)
- Extensibility (future modifications)
- Testability (unit test coverage)
- Reusability (DRY principle)

### Code Readability
- Naming (variables, functions, classes)
- Comments (necessary only, not redundant)
- Formatting (consistent style)
- Structure (logical organization)
- Dependencies (minimal coupling)

### Consistency
- Implementation patterns with existing codebase
- Architecture alignment
- Naming conventions
- Error handling patterns

### Performance
- Algorithm efficiency
- Memory usage
- Network calls optimization
- UI responsiveness

### Security
- Input validation
- Data encryption
- Sensitive data handling

## Workflow

### 1. Get PR Information

```bash
gh pr view <pr-number>
gh pr diff <pr-number> --name-only
```

### 2. Read Changed Files

```bash
gh pr diff <pr-number>
```

Use Read tool to examine full file context if needed.

### 3. Analyze Code

Review each file against criteria:
- Read code carefully
- Check against review criteria
- Note good practices
- Identify improvements
- Detect problems

### 4. Output Review

**出力フォーマットはレビューコメントテンプレートに従うこと。**

参照: `references/review-comment-template.md`

## Notes

- Focus on actionable feedback
- Provide specific examples
- Suggest concrete solutions
- Prioritize critical issues (MUST FIX) over minor improvements (NIT)
