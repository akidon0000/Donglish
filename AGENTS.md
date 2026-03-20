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
## Branch Strategy
Refer to `.agents/skills/git-branch-strategy/SKILL.md`

## Commit Message Rules
Refer to `.agents/skills/git-commit/SKILL.md`

## Pull Request Creation Rules
Refer to `.agents/skills/git-create-pr/SKILL.md`

## Review Guidelines
- Review comments must be written in Japanese.
- End sentences with "ドン".

Refer to the following based on the diff of this branch.
- iOS: `.agents/skills/ios-review-code/SKILL.md`
- PR: `.agents/skills/git-review-pr/SKILL.md`
