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

`references/review-comment-template.md` のテンプレートに従って出力する。

## Output Rules

- レビューコメントは **日本語** で記述する
- 文末は **「ドン」** で終える
- 各指摘は `<details>` トグルで折りたたむ
- 対応確認用の `- [ ]` チェックボックスを各指摘に付与する
- コード例がある場合は必ず修正前/修正後の両方を示す
- 該当なしのセクションは省略する（MUST FIX が 0 件なら見出しごと省略）
- 指摘にはコード例を添える
- 1 つの `<details>` に 1 つの指摘（複合させない）
- ファイル名は相対パスで記載する（例: `Models/DrillFlow.swift:42`）

## Severity Levels

| レベル | ラベル | 意味 | PR判定への影響 |
|---|---|---|---|
| 🚫 MUST FIX | `🚫 must` | 修正必須。セキュリティ、クラッシュ、データ破損等 | Request Changes |
| ⚠️ SHOULD FIX | `⚠️ should` | 強く推奨。品質・保守性に影響 | 件数が多ければ Request Changes |

## PR Decision Criteria

| 判定 | 条件 |
|---|---|
| ✅ **Approve** | MUST FIX が 0 件、かつ SHOULD FIX が 1 件以下 |
| 🔄 **Request Changes** | MUST FIX が 1 件以上、または SHOULD FIX が 2 件以上 |

## Notes

- Focus on actionable feedback
- Provide specific examples
- Suggest concrete solutions
- Prioritize critical issues (MUST FIX) over minor improvements (NIT)
