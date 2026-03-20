# Donglish

Claude Code を活用した iOS / Swift 開発向けのスキル・設定リポジトリです。
Git ワークフロー自動化、コードレビュー、ビルド・テスト実行などのスキルを提供します。

## Features

- **iOS 開発スキル** — SwiftUI・SwiftData・Swift Testing・Swift Concurrency のベストプラクティスレビュー
- **Git ワークフロー** — コミットメッセージ生成、PR 作成・レビューの自動化
- **ビルド / テスト** — iOS ビルド実行、テスト実行、ビルドエラー自動修正
- **GitHub Actions** — Claude Code Review・PR Assistant ワークフロー
- **MCP 統合** — Serena・Apple Docs・GitHub の MCP サーバー設定済み

## Project Structure

```
.
├── .agents/
│   └── skills/                    # Claude Code スキル定義
│       ├── GUIDELINES.md          # 命名規則ガイド
│       ├── git-commit/            # コミットメッセージ生成
│       ├── git-commit-push/       # コミット & プッシュ
│       ├── git-create-pr/         # PR 作成
│       ├── git-review-pr/         # PR レビュー
│       ├── ios-fix-build/         # ビルドエラー修正
│       ├── ios-review-code/       # iOS コードレビュー
│       ├── ios-run-build/         # ビルド実行
│       ├── ios-run-test/          # テスト実行
│       ├── swift-swiftconcurrency/ # Swift Concurrency レビュー
│       ├── swift-swiftdata/       # SwiftData レビュー
│       ├── swift-swifttesting/    # Swift Testing レビュー
│       └── swift-swiftui/         # SwiftUI レビュー
├── .claude/
│   └── settings.json              # Claude Code 設定
├── .github/
│   └── workflows/                 # GitHub Actions ワークフロー
├── .serena/                       # Serena MCP 設定
├── .mcp.json                      # MCP サーバー設定
├── AGENTS.md                      # エージェント向けプロジェクト指示
└── skills-lock.json               # スキルのバージョンロック
```

## Available Skills

| スキル | 説明 |
|--------|------|
| `git-commit` | 変更を論理的な単位に分割してコミット |
| `git-commit-push` | コミット & リモートへプッシュ |
| `git-create-pr` | PR 作成の全ワークフローを自動化 |
| `git-review-pr` | PR のコード品質・セキュリティレビュー |
| `ios-run-build` | iOS プロジェクトのビルド実行 |
| `ios-run-test` | iOS ユニットテストの実行 |
| `ios-fix-build` | ビルドエラーの自動検出・修正 |
| `ios-review-code` | Swift/SwiftUI のコードレビュー |
| `swift-swiftui` | SwiftUI ベストプラクティスレビュー |
| `swift-swiftdata` | SwiftData コードレビュー |
| `swift-swifttesting` | Swift Testing コードレビュー |
| `swift-swiftconcurrency` | Swift Concurrency レビュー |

## Requirements

- [Claude Code](https://claude.ai/claude-code)
- Xcode（iOS スキルを使用する場合）
- GitHub CLI (`gh`)

## License

MIT
