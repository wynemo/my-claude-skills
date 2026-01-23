# Claude Code 配置

English version: [README.md](README.md)

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
- `clean-wechat-msg` - 清理微信导出数据旧文件和插件旧版本（Windows）
- `repo-explorer` - 克隆 git 仓库到临时目录，搜索代码回答问题
- `video-frame-text` - 使用 ffmpeg 从视频提取帧并添加文字叠加

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

将 Claude Code 的配置同步到 OpenCode 和 Codex。

**功能**：
- 自动为每个 skill 生成对应的 command 文件（`skill-{name}.md`）
- 同步 commands 和 skills 到 OpenCode 和 Codex
- 自动创建目标目录（如果不存在）
- 显示同步结果统计

**同步目标**：
| 来源 | OpenCode | Codex |
|------|----------|-------|
| Commands | 符号链接到 `~/.config/opencode/command` | 符号链接到 `~/.codex/prompts/` |
| Skills | - | 符号链接到 `~/.codex/skills/` |

**使用方法**：
```bash
./sync-claude.sh
```

这样可以让 Claude Code、OpenCode 和 Codex 共享技能配置，并且可以通过 `/skill-xxx` 快速调用技能。

**参考文档**：
- [Codex Custom Prompts](https://developers.openai.com/codex/custom-prompts/)
- [Codex Agent Skills](https://developers.openai.com/codex/skills/)
- [Codex AGENTS.md 自定义指令](https://developers.openai.com/codex/guides/agents-md/)
