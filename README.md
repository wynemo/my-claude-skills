# Claude Code Configuration

中文版本: [README.zh.md](README.zh.md)

My Claude Code custom commands and skills configuration.

## Commands

- `/catchup` - Read all changed files in the current git branch
- `/git-commit` - Analyze git changes and automatically create a commit
- `/daily-summary` - Generate today’s work summary

## Skills

- `fastapi-init` - Initialize a Python FastAPI project with uv
- `database-setup` - Add PostgreSQL + SQLModel database support to a FastAPI project
- `docker-deploy` - Create Docker deployment files (Dockerfile, .dockerignore, build.sh)
- `nextjs-frontend` - Create a Next.js + shadcn/ui + Tailwind CSS frontend project (pnpm)
- `bun-nextjs` - Create a Next.js + shadcn/ui + Tailwind CSS frontend project with Bun

## Using Skills

```
use fastapi-init skill
use database-setup skill
use docker-deploy skill
```

Or use the auto-generated skill commands:

```
/skill-fastapi-init
/skill-database-setup
/skill-docker-deploy
```

## Tool Scripts

### sync-claude.sh

Sync Claude Code configuration to OpenCode and Codex.

**Features**:
- Generate a command file for each skill (`skill-{name}.md`)
- Sync commands and skills to OpenCode and Codex
- Create target directories automatically if missing
- Show sync result statistics

**Sync targets**:
| Source | OpenCode | Codex |
|--------|----------|-------|
| Commands | Symlink to `~/.config/opencode/command` | Symlink to `~/.codex/prompts/` |
| Skills | - | Symlink to `~/.codex/skills/` |

**Usage**:
```bash
./sync-claude.sh
```

This lets Claude Code, OpenCode, and Codex share skills configuration, and enables quick access via `/skill-xxx`.

**References**:
- [Codex Custom Prompts](https://developers.openai.com/codex/custom-prompts/)
- [Codex Agent Skills](https://developers.openai.com/codex/skills/)
- [Codex AGENTS.md Custom Instructions](https://developers.openai.com/codex/guides/agents-md/)
