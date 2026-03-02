---
name: add-note
description: "往 tech-notes 仓库中添加新的技术笔记文件。触发词：添加笔记、新建笔记、add note、新增文档。"
allowed-tools:
  - Read
  - Write
  - Glob
  - Bash
---

# 添加技术笔记

根据用户提供的内容和主题，在合适的目录下创建新的 Markdown 笔记文件。

## 目录结构

根据笔记主题选择合适的目录：

| 目录 | 适用内容 |
|------|----------|
| `AI/` | AI 工具、开发助手（Claude、Cursor、Gemini 等） |
| `apple/` | macOS 软件、Apple 相关配置和技巧 |
| `net_utils/` | 网络工具（EasyTier、Tailscale 等） |
| `programming/` | 通用编程工具、编辑器配置 |
| `python/` | Python 工具链、类型注解、调试等 |
| `science/` | 网络代理工具和配置（Sing-box、Shadowrocket 等） |
| `software/` | 软件推荐和通用配置 |
| `tampermonkey/` | 浏览器用户脚本 |

## 操作步骤

1. **确认主题和目录**：根据用户描述的内容，判断应放入哪个目录
2. **确定文件名**：使用小写字母和连字符，如 `tool-name.md`
3. **检查是否已存在**：用 Glob 检查目标目录下有无同名或相似文件
4. **创建文件**：使用 Write 工具创建 Markdown 文件
5. **确认结果**：告知用户文件路径

## 笔记模板

```markdown
# 工具/主题名称

简短描述这个工具或主题是什么。

## 安装

```bash
# 安装命令
```

## 基本用法

## 常用配置

## 参考资料

- [官方文档](https://example.com)
```

## 写作规范

- 中文笔记面向中文用户，技术术语可保留英文
- 包含实际可用的命令和配置示例
- 文件名与内容主题保持一致
- 图片资源放在对应目录的 `assets/` 子目录下

## 示例

用户说：「帮我添加一篇关于 Homebrew 使用技巧的笔记」

→ 创建文件：`apple/homebrew-tips.md`
