---
name: git-commit
description: >-
  Create logical git commits following project conventions. Splits changes into meaningful units and generates proper commit messages.
  "コミットして", "commit changes", "変更をコミット", "commit and split" 等で使用。
---

## Constraints
- No PR creation
- No push to remote (commit only)
- 1 commit = 1-5 files, logical unit

## Workflow

### 1. Check Status (parallel)
```bash
git status
git diff --stat
git log --oneline -5
```

### 2. Split Criteria

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Format (no logic change) |
| `refactor` | Refactoring |
| `perf` | Performance improvement |
| `test` | Test addition/modification |
| `build` | Build system change |
| `ci` | CI configuration change |
| `chore` | Miscellaneous |

**Split points:**
- Separate feature add & bug fix
- Separate refactor & logic change

### 3. Message Format

```
<type>(<scope>): <description>

[optional body: explain WHY]

[optional footer: BREAKING CHANGE, etc]
```

- **type**: required (see table)
- **scope**: recommended (e.g., `Auth`, `Network`, `UI`)
- **description**: required, ≤50 chars, **日本語**、動詞終わり
- **body**: optional, 理由を**日本語**で説明

### 4. Commit

```bash
git add <files>
git commit -m "$(cat <<'EOF'
<type>(<scope>): <description>

[body]
EOF
)"
```

### 5. Verify (No Push)

```bash
git log --oneline -3
git status
```

**Note:** This skill does NOT push to remote. Commits remain local only. Use `git-commit-push` skill if you need to push.

## Example

```
fix(PushNotification): フォアグラウンド時に通知が表示されない問題を修正

デリゲート登録のタイミングを見直し、
SceneDelegate初期化時に確実に登録されるよう修正。
```
