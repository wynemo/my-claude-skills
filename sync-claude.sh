#!/bin/bash
# 同步 Claude Code 配置到 OpenCode
# 用法: ./sync-claude.sh

CLAUDE_COMMANDS=~/.claude/commands
CLAUDE_SKILLS=~/.claude/skills
OPENCODE_COMMAND=~/.config/opencode/command
OPENCODE_AGENT=~/.config/opencode/agent

# 确保目录存在
mkdir -p "$OPENCODE_COMMAND" "$OPENCODE_AGENT"

# 同步 commands (格式兼容，直接链接)
echo "同步 commands..."
rm -f "$OPENCODE_COMMAND"
ln -sf "$CLAUDE_COMMANDS" "$OPENCODE_COMMAND"
echo "  -> 已链接 $CLAUDE_COMMANDS -> $OPENCODE_COMMAND"

echo "完成！"
echo "Commands: $(ls -1 "$OPENCODE_COMMAND"/*.md 2>/dev/null | wc -l | tr -d ' ') 个"
