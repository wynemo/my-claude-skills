#!/bin/bash
# 同步 Claude Code 配置到 OpenCode 和 Codex
# 用法: ./sync-claude.sh

CLAUDE_COMMANDS=~/.claude/commands
CLAUDE_SKILLS=~/.claude/skills
OPENCODE_COMMAND=~/.config/opencode/command
OPENCODE_AGENT=~/.config/opencode/agent
CODEX_SKILLS=~/.codex/skills
CODEX_PROMPTS=~/.codex/prompts

# 确保源目录存在
mkdir -p "$CLAUDE_COMMANDS" "$CLAUDE_SKILLS"
# 确保目标父目录存在
mkdir -p "$(dirname "$OPENCODE_COMMAND")" "$(dirname "$CODEX_SKILLS")" "$(dirname "$CODEX_PROMPTS")"

# Step 1: 同步 commands 到 OpenCode (格式兼容，直接链接)
echo "同步 commands 到 OpenCode..."
# 如果目标已存在（可能是目录或符号链接），先删除
[ -e "$OPENCODE_COMMAND" ] || [ -L "$OPENCODE_COMMAND" ] && rm -rf "$OPENCODE_COMMAND"
ln -sf "$CLAUDE_COMMANDS" "$OPENCODE_COMMAND"
echo "  -> 已链接 $CLAUDE_COMMANDS -> $OPENCODE_COMMAND"

# Step 3: 同步 skills 到 Codex (直接链接整个目录)
# Codex 使用 ~/.codex/skills 目录存放技能
# SKILL.md 格式与 Claude Code 兼容（需要 name 和 description 字段）
echo ""
echo "同步 skills 到 Codex..."
[ -e "$CODEX_SKILLS" ] || [ -L "$CODEX_SKILLS" ] && rm -rf "$CODEX_SKILLS"
ln -sf "$CLAUDE_SKILLS" "$CODEX_SKILLS"
echo "  -> 已链接 $CLAUDE_SKILLS -> $CODEX_SKILLS"

# Step 4: 同步 commands 到 Codex prompts (直接链接整个目录)
# Codex 使用 ~/.codex/prompts 目录存放自定义提示
# 格式与 Claude Code commands 兼容（都使用 description frontmatter）
echo ""
echo "同步 commands 到 Codex prompts..."
[ -e "$CODEX_PROMPTS" ] || [ -L "$CODEX_PROMPTS" ] && rm -rf "$CODEX_PROMPTS"
ln -sf "$CLAUDE_COMMANDS" "$CODEX_PROMPTS"
echo "  -> 已链接 $CLAUDE_COMMANDS -> $CODEX_PROMPTS"

echo ""
echo "完成！"
echo "Commands: $(ls -1 "$CLAUDE_COMMANDS"/*.md 2>/dev/null | wc -l | tr -d ' ') 个 (已同步到 OpenCode 和 Codex)"
echo "Skills: $(ls -1d "$CLAUDE_SKILLS"/*/ 2>/dev/null | wc -l | tr -d ' ') 个 (已同步到 Codex)"
