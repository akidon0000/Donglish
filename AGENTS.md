# Project Structure
```
.
├── .agents
│   ├── agents                          # Custom subagents
│   │   ├── reviewer.md                 # コードレビュー (sonnet)
│   │   ├── researcher.md               # コードベース調査・読み取り専用 (sonnet)
│   │   ├── test-runner.md              # ビルド & テスト実行 (haiku)
│   │   ├── refactorer.md              # リファクタリング・worktree隔離 (sonnet)
│   │   ├── doc-writer.md              # ドキュメントコメント生成 (haiku)
│   │   └── debug-helper.md            # バグ調査・読み取り専用 (sonnet)
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
- Code review MUST be performed by the `reviewer` agent (`.agents/agents/reviewer.md`).

For detailed workflow and template, see:
- `.agents/skills/git-review-pr/SKILL.md`
- `.agents/skills/ios-review-code/SKILL.md` (iOS-specific criteria)
