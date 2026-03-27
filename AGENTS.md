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

### 自動修正（@claude auto-patch）
- インラインコメント内に `@claude` を含めないこと。
- 修正が明確な指摘（MUST FIX / SHOULD FIX）ごとに、PRコメント（issue comment）として `@claude auto-patch <具体的指示>` を個別に投稿すること。
- 1つの指摘につき1つのPRコメントを投稿すること。複数の指摘をまとめないこと。
- スコープが広すぎる・曖昧な指摘にはPRコメントを投稿しないこと。
#### フォーマット

```
@claude auto-patch <何を・どのように直すか（具体的に）>
```

##### 良い例

```
@claude auto-patch HogeViewModel の 44行目 guard let に変更して、強制アンラップを除去してください
@claude auto-patch FugaStore の 123行目 TTSService.speak() の continuation をアクター分離に合わせて @MainActor で保護してください
```

##### 悪い例（避けること）

```
@claude auto-patch これを直して   # 指示が曖昧すぎる
@claude auto-patch コード全体をリファクタリング   # スコープが広すぎる
```

# GitHub Actions 上での Claude の動作ルール（全コマンド共通）

## 絶対ルール: 直接プッシュ禁止
- **元PRのブランチへの直接コミット・直接プッシュは一切禁止。例外なし。**
- コード修正が必要な場合は、必ず新しいブランチを作成し、修正PRを作成すること。
- `git push origin <元PRのブランチ>` は絶対に実行しないこと。

## 修正PRの作成手順
1. 元PRのブランチをベースに、新しいブランチを作成する
   - ブランチ名: `claude/fix/<元PR番号>-<短い説明>`（例: `claude/fix/42-guard-let`）
2. 新しいブランチで修正をコミットする
3. 元PRのブランチに向けてPRを作成する
4. 元コメントへのリプライ: `🔧 修正PRを作成しました → #<PR番号>` の1行のみ

# @claude auto-patch コマンド仕様
レビューコメントに @claude auto-patch が書かれた場合、上記の「修正PRの作成手順」に従って修正PRを自動作成する。


# コーディング規約（iOS / Swift）

このプロジェクトは **iOS（Swift）のみ**で構成されます。

## Swift

- **Swift Concurrency**: `async/await`・`@MainActor`・`Sendable` を積極的に使用する
- **オプショナル**: `guard let` / `if let` を推奨。強制アンラップ（`!`）は原則禁止
- **値型優先**: `struct` を優先し、`class` は `@MainActor` などの参照セマンティクスが必要な場合のみ
- **アクセス制御**: 外部公開が不要なプロパティ・メソッドは `private` にする
- **SwiftUI**: `@State` / `@StateObject` / `@EnvironmentObject` を適切に使い分ける
