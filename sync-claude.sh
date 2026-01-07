#!/bin/bash
# 同步 Claude Code 配置到 OpenCode 和 Codex
# 用法: ./sync-claude.sh

CLAUDE_COMMANDS=~/.claude/commands
CLAUDE_SKILLS=~/.claude/skills
OPENCODE_COMMAND=~/.config/opencode/command
OPENCODE_AGENT=~/.config/opencode/agent
CODEX_SKILLS=~/.codex/skills

# 确保目录存在
mkdir -p "$CLAUDE_COMMANDS" "$OPENCODE_COMMAND" "$OPENCODE_AGENT" "$CODEX_SKILLS"

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

    # 生成 command 文件（带 frontmatter）
    cat > "$command_file" <<EOF
---
description: 运行 /${skill_name} skill ${desc}
---

运行 /${skill_name} skill ${desc}
EOF
    echo "  -> skill-${skill_name}"
    ((skill_count++))
done
echo "生成了 ${skill_count} 个 skill commands"
echo ""

# Step 2: 同步 commands 到 OpenCode (格式兼容，直接链接)
echo "同步 commands 到 OpenCode..."
# 如果目标已存在（可能是目录或符号链接），先删除
[ -e "$OPENCODE_COMMAND" ] || [ -L "$OPENCODE_COMMAND" ] && rm -rf "$OPENCODE_COMMAND"
ln -sf "$CLAUDE_COMMANDS" "$OPENCODE_COMMAND"
echo "  -> 已链接 $CLAUDE_COMMANDS -> $OPENCODE_COMMAND"

# Step 3: 同步 skills 到 Codex
# Codex 使用 ~/.codex/skills 目录存放技能
# SKILL.md 格式与 Claude Code 兼容（需要 name 和 description 字段）
echo ""
echo "同步 skills 到 Codex..."
skill_sync_count=0
for skill_dir in "$CLAUDE_SKILLS"/*/; do
    [ -d "$skill_dir" ] || continue

    skill_name=$(basename "$skill_dir")
    codex_skill_dir="$CODEX_SKILLS/$skill_name"

    # 创建 Codex skill 目录
    mkdir -p "$codex_skill_dir"

    # 查找 skill 的 md 文件 (skill.md 或 SKILL.md)
    skill_md=$(find "$skill_dir" -maxdepth 1 -iname "skill.md" | head -1)

    if [ -f "$skill_md" ]; then
        # 复制为 SKILL.md (Codex 标准命名)
        cp "$skill_md" "$codex_skill_dir/SKILL.md"
        echo "  -> $skill_name"
        ((skill_sync_count++))
    fi
done
echo "同步了 ${skill_sync_count} 个 skills 到 Codex"

echo ""
echo "完成！"
echo "Commands: $(ls -1 "$OPENCODE_COMMAND"/*.md 2>/dev/null | wc -l | tr -d ' ') 个"
echo "Codex Skills: $(ls -1d "$CODEX_SKILLS"/*/ 2>/dev/null | wc -l | tr -d ' ') 个"
