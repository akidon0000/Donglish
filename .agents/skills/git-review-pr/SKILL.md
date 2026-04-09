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
- レビューは **Review Body（サマリー）** と **Inline Comment（各指摘）** の2層構成で投稿する
- Review Body にはレビュー結果の判定と件数サマリーのみを記載する
- 各指摘は該当コード行への **インラインコメント** として投稿する
- 各インラインコメントには必ず **`suggestion` ブロック** を含めること（ワンクリック適用可能な修正提案）
- 1 つのインラインコメントに 1 つの指摘（複合させない）
- 該当なしのセクションは省略する（MUST FIX が 0 件なら見出しごと省略）

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
