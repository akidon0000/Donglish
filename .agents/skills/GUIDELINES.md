# Skills ガイドライン

本プロジェクトのスキルは [Agent Skills 仕様](https://agentskills.io/home) に準拠する。
Claude Code / Gemini CLI / Codex / Cursor など複数のエージェントで統一的に動作する形式を採用している。

---

## ディレクトリ構成

```
{skill-name}/
├── SKILL.md          # 必須: スキル定義（instructions + metadata）
├── scripts/          # 任意: 実行可能なスクリプト
├── references/       # 任意: 参照ドキュメント
└── assets/           # 任意: テンプレート、リソース
```

- `SKILL.md` のみが必須。最小構成はディレクトリ + `SKILL.md`
- `README.md` は SKILL.md と内容が重複する場合は作成しない

## スキルのライフサイクル

1. **Discovery（検出）**: 起動時に `name` と `description` のみを読み込む。スキルが関連するかの判定に使われる
2. **Activation（起動）**: タスクが `description` と一致すると `SKILL.md` 全体をコンテキストに読み込む
3. **Execution（実行）**: 指示に従い、references や scripts を必要に応じて読み込み・実行する

---

## SKILL.md の frontmatter

```yaml
---
name: {ディレクトリ名と同一}
description: {スキルの機能と使用タイミングの説明}
---
```

### フィールド仕様

| フィールド | 必須 | 制約 |
|---|---|---|
| `name` | Yes | 最大64文字。小文字・数字・ハイフンのみ。先頭末尾にハイフン不可。連続ハイフン不可 |
| `description` | Yes | 最大1024文字。スキルの機能と使用タイミングを記載 |
| `license` | No | ライセンス名またはバンドルファイルへの参照 |
| `compatibility` | No | 最大500文字。環境要件（対象製品、パッケージ、ネットワーク等） |
| `metadata` | No | 追加メタデータのキーバリューマッピング |
| `allowed-tools` | No | スキルが使用可能なツールのスペース区切りリスト（実験的） |

### description の書き方

Discovery で `name` と `description` だけが読まれるため、description の質がスキルの起動精度を決める。

- スキルが **何をするか** と **いつ使うか** の両方を含める
- ユーザーが発する可能性のあるフレーズを含める

```yaml
# 良い例
description: >-
  iOSのビルドエラーを自動検出して修正する。エラーログを分析し適切な修正を適用する。
  "ビルドエラーを直して", "buildが通らない", "fix build error" 等で使用。

# 悪い例
description: ビルドエラーを直す
```

## SKILL.md 本文の書き方

### 推奨セクション構成

```markdown
# スキル名

## When to use this skill
（使用タイミングの説明）

## Workflow
（ステップバイステップの手順）

## Examples
（入出力の例）

## Edge cases
（エッジケースの対処）
```

---

## 命名規則

### ディレクトリ名

`{prefix}-{機能名}` の形式で kebab-case を使用する。

#### プレフィックス一覧

| プレフィックス | 対象 | 例 |
|---|---|---|
| `ios-` | iOS 固有 | `ios-fix-build`, `ios-review-code` |
| `swift-` | Swift 言語固有 | `swift-swiftui`, `swift-swiftconcurrency` |
| `git-` | Git 操作 | `git-commit`, `git-create-pr` |
| `common-` | プラットフォーム共通 | `common-sync-docs` |

### 機能名の命名パターン

#### アクション系: `{prefix}-{動詞}-{対象}`

```
git-create-pr        # create(動詞) + pr(対象)
ios-fix-build        # fix(動詞) + build(対象)
ios-review-code      # review(動詞) + code(対象)
```

#### ナレッジ/参照系: `{prefix}-{対象}`

```
swift-concurrency    # concurrency(対象)
swift-swiftui        # swiftui(対象)
```
