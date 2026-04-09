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
Refer to `.agents/REVIEW.md`
