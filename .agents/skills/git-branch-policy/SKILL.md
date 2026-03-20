---
name: git-branch-policy
description: >-
  ブランチ運用戦略のナレッジ。ブランチ作成時やPR作成時に参照し、正しいブランチ名とマージ先を決定する。
  "ブランチ戦略", "branch policy", "ブランチ名", "ブランチ運用" 等で使用。
---

# Git Branch Policy

Gitflow ベースのブランチ運用戦略。

## Branch Types

| ブランチ | パターン | 用途 | マージ先 |
|---|---|---|---|
| main | `main` | リリース済みの安定コード | - |
| feature | `feature/<name>` | 新機能開発 | `main` |
| maintenance | `maintenance/<name>` | バグ修正・保守作業 | `main` |
| bot | `bot/<name>` | CI/bot による自動生成 | `main` |

## Naming Convention

```
feature/add-quiz-screen
feature/improve-tts-service
maintenance/fix-crash-on-launch
maintenance/update-dependencies
bot/dependabot-swift-packages
```

- kebab-case を使用
- 簡潔かつ内容が分かる名前にする

## Workflow

```
main ─────────────────────────────────────
  ├── feature/xxx   → PR → main
  ├── maintenance/xxx → PR → main
  └── bot/xxx       → PR → main
```

1. `main` から新しいブランチを切る
2. 作業してコミット
3. PR を作成し `main` にマージ
4. マージ後、ブランチを削除

## When to use this skill

- 新しいブランチを作成するとき
- PR のマージ先を決めるとき
- ブランチ名の命名に迷ったとき
