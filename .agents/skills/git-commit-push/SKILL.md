---
name: git-commit-push
description: >-
  Create logical git commits and push to remote. Extends git-commit skill with push step.
  "コミットしてプッシュ", "commit and push", "pushして" 等で使用。
---

## Constraints
- Use `git-commit` skill for commit creation workflow
- Push to remote after committing

## Workflow

### 1. Commit Changes

**Refer to `git-commit` skill for:**
- Status check
- Split criteria
- Message format
- Commit execution

### 2. Push to Remote

```bash
# First push (set upstream)
git push -u origin <branch-name>

# Subsequent pushes
git push
```

### 3. Verify

```bash
git log --oneline -3
git status
```
