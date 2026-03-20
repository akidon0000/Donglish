---
name: git-create-pr
description: >-
  Automates the full pull request workflow by creating commits and opening a pull request.
  "PRを作成", "プルリクエスト作成", "create PR", "open pull request" 等で使用。
---

## Constraints
- Use `git-commit-push` skill for commit & push steps
- Follow PR template format
- Confirm before overwriting existing PR

## Workflow

### 1. Status Check & Branch Confirmation (parallel)

```bash
git status
git diff --stat
git log --oneline -5
git branch -r
git rev-parse --abbrev-ref HEAD
```

Present summary and confirm with user:
- Current branch: `<branch-name>`
- Changed files: X files

### 2. Commit & Push Changes

**Refer to `git-commit-push` skill for:**
- Commit creation (message format, types, split criteria)
- Push to remote

### 3. Determine Target Branch

Ask the user which branch to target. Common targets:
- `main` - Default branch
- `develop` - Development branch
- Feature branch parent

```bash
git branch -r | grep -E "(main|develop|release)"
```

### 4. Check Existing PR

```bash
gh pr list --head $(git rev-parse --abbrev-ref HEAD)
```

**If PR exists:** Confirm with user before overwriting.

### 5. Create PR

**PR Title Format:**
```
<type>(<scope>): <description>
```

**PR Body:**

```markdown
## Summary

[Brief description of changes and motivation]

## Changes

[Summarize commit log into a clear list of changes]

## Testing

- [ ] Build succeeds
- [ ] Tests pass
- [ ] Manual verification completed

## Notes

[Any additional context, screenshots for UI changes, etc.]
```

**Create PR:**
```bash
gh pr create --title "<title>" --body "$(cat <<'EOF'
[PR body]
EOF
)" --base <target-branch>
```

### 6. Verify

```bash
gh pr view
```

Display PR URL to user.

## Error Handling

**Commit failure:**
- Report conflict or pre-commit hook error
- Suggest resolution steps

**PR creation failure:**
- Analyze cause
- Provide manual creation steps
