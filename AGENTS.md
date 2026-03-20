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
Refer to `.agents/skills/git-review-pr/SKILL.md`

For iOS-specific review criteria, also refer to `.agents/skills/ios-review-code/SKILL.md`
