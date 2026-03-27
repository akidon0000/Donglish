# Project Structure
```
.
├── .agents
│   └── skills                          # Claude Code skill definitions
│       ├── GUIDELINES.md               # Naming conventions guide
│       └── {prefix}-{skill-name}/      # Each skill (see GUIDELINES.md)
├── .claude
│   └── settings.json
├── .serena                             # Serena MCP configuration
└── .mcp.json
```


# GitHub Related
## Commit Message Rules
Refer to `.agents/skills/git-commit/SKILL.md`

## Pull Request Creation Rules
Refer to `.agents/skills/git-create-pr/SKILL.md`

## Review Guidelines
- Review comments must be written in Japanese.
- Use severity levels: 🚫 MUST FIX / ⚠️ SHOULD FIX
- Wrap each item in `<details>` toggle with `- [ ]` checkbox.

For detailed workflow and template, see:
- `.agents/skills/git-review-pr/SKILL.md`
- `.agents/skills/ios-review-code/SKILL.md` (iOS-specific criteria)

### コメントルール
- 指摘事項がある場合: 各指摘をガイドラインの観点に基づき日本語で具体的に説明し、改善提案を含めてコメントすること。
- 指摘事項がない場合: そのPRにはコメントしないこと。
- インラインコメント内に `@claude` を含めないこと。

### 自動修正PR作成
- レビュー完了後、修正が明確な指摘（MUST FIX / SHOULD FIX）がある場合、レビューコメントに加えて修正PRも同時に作成すること。
- **指摘ごとに個別の修正PRを作成すること。1つのPRに複数の指摘の修正をまとめないこと。**
- スコープが広すぎる・曖昧な指摘は修正PRに含めず、レビューコメントのみにすること。

# GitHub Actions 上での Claude の動作ルール（全コマンド共通）

## 絶対ルール: 直接プッシュ禁止
- **元PRのブランチへの直接コミット・直接プッシュは一切禁止。例外なし。**
- コード修正が必要な場合は、必ず新しいブランチを作成し、修正PRを作成すること。
- `git push origin <元PRのブランチ>` は絶対に実行しないこと。

## 修正PRの作成手順（指摘ごとに繰り返す）
1. 元PRのブランチをベースに、新しいブランチを作成する
   - ブランチ名: `claude/fix/<元PR番号>-<短い説明>`（例: `claude/fix/42-guard-let`, `claude/fix/42-add-private`）
2. その指摘の修正のみをコミットする
3. 元PRのブランチに向けてPRを作成する
4. 対応するレビューコメント（インラインコメント）への返信として `🔧 修正PRを作成しました → #<PR番号>` を投稿
5. 次の指摘の修正PRを作成する前に、元PRのブランチに戻ること

# @claude auto-patch コマンド仕様
PRコメントに @claude auto-patch が書かれた場合、上記の「修正PRの作成手順」に従って修正PRを自動作成する。
レビューワークフローでは、レビューと修正PRの作成を同時に行うため、このコマンドは人間が手動で修正を依頼する場合に使用する。


# コーディング規約（iOS / Swift）

このプロジェクトは **iOS（Swift）のみ**で構成されます。

## Swift

- **Swift Concurrency**: `async/await`・`@MainActor`・`Sendable` を積極的に使用する
- **オプショナル**: `guard let` / `if let` を推奨。強制アンラップ（`!`）は原則禁止
- **値型優先**: `struct` を優先し、`class` は `@MainActor` などの参照セマンティクスが必要な場合のみ
- **アクセス制御**: 外部公開が不要なプロパティ・メソッドは `private` にする
- **SwiftUI**: `@State` / `@StateObject` / `@EnvironmentObject` を適切に使い分ける
