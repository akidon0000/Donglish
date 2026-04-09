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


# コーディング規約（iOS / Swift）

このプロジェクトは **iOS（Swift）のみ**で構成されます。

## Swift

- **Swift Concurrency**: `async/await`・`@MainActor`・`Sendable` を積極的に使用する
- **オプショナル**: `guard let` / `if let` を推奨。強制アンラップ（`!`）は原則禁止
- **値型優先**: `struct` を優先し、`class` は `@MainActor` などの参照セマンティクスが必要な場合のみ
- **アクセス制御**: 外部公開が不要なプロパティ・メソッドは `private` にする
- **SwiftUI**: `@State` / `@StateObject` / `@EnvironmentObject` を適切に使い分ける


# Review Guidelines
- Review comments must be written in Japanese.
- Use severity levels: 🚫 MUST FIX / ⚠️ SHOULD FIX
- レビューは **Review Body（サマリー）** と **Inline Comment（各指摘）** の2層構成で投稿する。
- 各インラインコメントには必ず `suggestion` ブロックを含めること。
- If there are issues, comment with the details. If no issues found, comment "コードレビュー結果: 問題なし".

For detailed workflow and template, see:
- `.agents/skills/git-review-pr/SKILL.md`
- `.agents/skills/ios-review-code/SKILL.md` (iOS-specific criteria)

レビューコメント例

**Review Body（レビュー結果サマリー）:**

````markdown
レビュー結果

**判定: 🔄 Request Changes**

| レベル | 件数 |
|---|---|
| 🚫 MUST FIX | 1 |
| ⚠️ SHOULD FIX | 1 |
````

**Inline Comment 例1: 🚫 MUST FIX**

````markdown
🚫 MUST FIX: 強制アンラップの使用

`user.name!` で強制アンラップしていますが、`nil` の場合にクラッシュするドン。`guard let` を使用して安全にアンラップしてくださいドン。

```suggestion
guard let name = user.name else { return }
```
````

**Inline Comment 例2: ⚠️ SHOULD FIX**

````markdown
⚠️ SHOULD FIX: アクセス制御の不足

`fetchData()` メソッドはこの View 内でのみ使用されているため、`private` を付与してスコープを限定してくださいドン。

```suggestion
private func fetchData() async { ... }
```
````

自動修正PR作成
- レビュー完了後、修正が明確な指摘（MUST FIX / SHOULD FIX）がある場合、レビューコメントに加えて修正PRも同時に作成すること。
- **指摘ごとに個別の修正PRを作成すること。1つのPRに複数の指摘の修正をまとめないこと。**
- スコープが広すぎる・曖昧な指摘は修正PRは作成しないかつ作成しなかった理由をレビューコメントすること(インラインコメント)。
- 修正PR作成後、対応するレビューコメント（インラインコメント）への返信として `🔧 修正PRを作成しました → #<PR番号>` を投稿すること。

# GitHub Actions 上での Claude, Codexの動作ルール（全コマンド共通）

## 絶対ルール: 直接プッシュ禁止
- **元PRのブランチへの直接コミット・直接プッシュは一切禁止。例外なし。**
- コード修正が必要な場合は、必ず新しいブランチを作成し、修正PRを作成すること。

## 修正PRの作成手順（指摘ごとに繰り返す）
1. 元PRのブランチをベースに、新しいブランチを作成する
   - ブランチ名: `claude/fix/<元PR番号>-<短い説明>`（例: `claude/fix/42-guard-let`, `claude/fix/42-add-private`）
2. その指摘の修正のみをコミットする
3. 元PRのブランチに向けてPRを作成する
4. 対応するレビューコメント（インラインコメント）への返信として `🔧 修正PRを作成しました → #<PR番号>` を投稿
5. 次の指摘の修正PRを作成する前に、元PRのブランチに戻ること
