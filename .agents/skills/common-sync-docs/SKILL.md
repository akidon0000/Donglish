---
name: common-sync-docs
description: >-
  リポジトリの現在の状態に合わせて AGENTS.md や GUIDELINES.md を更新する。
  ディレクトリ構造、スキル一覧、設定ファイルの変更を検出して反映する。
  "ドキュメント更新", "AGENTS.md更新", "sync docs", "ドキュメント同期" 等で使用。
---

## When to use this skill

- スキルの追加・削除・リネーム後
- プロジェクト構造（ディレクトリ）が変わった後
- AGENTS.md や GUIDELINES.md が実態と乖離しているとき
- ユーザーが「ドキュメント更新して」「AGENTS.md直して」等と指示したとき

## Workflow

### 1. 現状把握 (parallel)

以下を並列で取得する:

```bash
# プロジェクトのディレクトリ構造（深さ3、隠しファイル含む、node_modules等除外）
find . -maxdepth 3 -not -path '*/node_modules/*' -not -path '*/.git/*' -not -name '.DS_Store' | sort

# スキル一覧と各 SKILL.md の name/description
for d in .agents/skills/*/; do
  echo "=== $(basename $d) ==="
  head -6 "$d/SKILL.md" 2>/dev/null
done

# 現在の AGENTS.md
cat AGENTS.md

# 現在の GUIDELINES.md
cat .agents/skills/GUIDELINES.md
```

### 2. 差分検出

以下の観点で現状と既存ドキュメントを比較する:

| 対象 | チェック内容 |
|------|-------------|
| **Project Structure** (AGENTS.md) | ディレクトリツリーが実際の構造と一致しているか |
| **Skills 一覧** (AGENTS.md) | スキルの参照パスが正しいか、新規スキルの記載漏れがないか |
| **命名規則** (GUIDELINES.md) | プレフィックス一覧・例が実際のスキル名と一致しているか |
| **参照パス** | `.agents/skills/xxx/SKILL.md` 等のパスが存在するか |

### 3. 更新

差分がある場合のみ、該当ファイルを更新する。

**更新ルール:**
- 既存の構造・フォーマットを維持する
- 不要なセクションを追加しない
- 実態に合わない記述を削除・修正する
- コメント (`# ...`) の整合性も確認する
- CLAUDE.md は `@AGENTS.md` の参照のみなので変更しない

### 4. 変更確認

更新後、変更内容をユーザーに報告する:

```bash
git diff AGENTS.md .agents/skills/GUIDELINES.md
```

## Edge cases

- **AGENTS.md が存在しない場合**: 新規作成する
- **GUIDELINES.md が存在しない場合**: 新規作成しない（ユーザーに確認する）
- **スキルに SKILL.md がない場合**: 警告を出して該当スキルはスキップする
- **変更がない場合**: 「既に最新です」と報告して終了する
