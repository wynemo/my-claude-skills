# Claude Code 配置

我的 Claude Code 自定义命令和技能配置。

## 命令 (Commands)

- `/catchup` - 读取当前 git 分支中所有变更的文件
- `/git-commit` - 分析 git 改动并自动创建提交
- `/daily-summary` - 生成今日工作总结

## 技能 (Skills)

- `fastapi-init` - 使用 uv 初始化 Python FastAPI 项目
- `database-setup` - 为 FastAPI 项目添加 PostgreSQL + SQLModel 数据库支持
- `docker-deploy` - 创建 Docker 部署文件（Dockerfile、.dockerignore、build.sh）
- `nextjs-frontend` - 创建 Next.js + shadcn/ui + Tailwind CSS 前端项目（pnpm）
- `bun-nextjs` - 使用 Bun 创建 Next.js + shadcn/ui + Tailwind CSS 前端项目

## 使用技能

```
use fastapi-init skill
use database-setup skill
use docker-deploy skill
```

或者使用自动生成的 skill commands：

```
/skill-fastapi-init
/skill-database-setup
/skill-docker-deploy
```

## 工具脚本

### sync-claude.sh

将 Claude Code 的配置同步到 OpenCode。

**功能**：
- 自动为每个 skill 生成对应的 command 文件（`skill-{name}.md`）
- 创建符号链接，将 `~/.claude/commands` 链接到 `~/.config/opencode/command`
- 自动创建目标目录（如果不存在）
- 显示同步结果统计

**使用方法**：
```bash
./sync-claude.sh
```

这样可以让 Claude Code 和 OpenCode 共享同一套命令配置，并且可以通过 `/skill-xxx` 快速调用技能。
