#!/bin/bash
# 同步 Claude Code 配置到 OpenCode
# 用法: ./sync-claude.sh

CLAUDE_COMMANDS=~/.claude/commands
CLAUDE_SKILLS=~/.claude/skills
OPENCODE_COMMAND=~/.config/opencode/command
OPENCODE_AGENT=~/.config/opencode/agent

# 确保目录存在
mkdir -p "$CLAUDE_COMMANDS" "$OPENCODE_COMMAND" "$OPENCODE_AGENT"

# Step 1: 为所有 skills 生成 skill-xx commands
echo "生成 skill commands..."
skill_count=0
for skill_dir in "$CLAUDE_SKILLS"/*/; do
    [ -d "$skill_dir" ] || continue

    skill_name=$(basename "$skill_dir")
    command_file="$CLAUDE_COMMANDS/skill-${skill_name}.md"

    # 从 skill 的 md 文件中提取 description
    skill_md=$(find "$skill_dir" -maxdepth 1 -name "*.md" | head -1)
    if [ -f "$skill_md" ]; then
        desc=$(grep "^description:" "$skill_md" | head -1 | sed 's/^description:[[:space:]]*//' | tr -d '"')
        [ -z "$desc" ] && desc="运行此 skill"
    else
        desc="运行此 skill"
    fi

    # 生成 command 文件
    echo "运行 /${skill_name} skill ${desc}" > "$command_file"
    echo "  -> skill-${skill_name}"
    ((skill_count++))
done
echo "生成了 ${skill_count} 个 skill commands"
echo ""

# Step 2: 同步 commands 到 OpenCode (格式兼容，直接链接)
echo "同步 commands 到 OpenCode..."
rm -f "$OPENCODE_COMMAND"
ln -sf "$CLAUDE_COMMANDS" "$OPENCODE_COMMAND"
echo "  -> 已链接 $CLAUDE_COMMANDS -> $OPENCODE_COMMAND"

echo ""
echo "完成！"
echo "Commands: $(ls -1 "$OPENCODE_COMMAND"/*.md 2>/dev/null | wc -l | tr -d ' ') 个"
