---
name: repo-explorer
description: 将 git 仓库 clone 到临时目录，然后在仓库中搜索代码和文件，回答用户关于该仓库的问题。当用户提供一个 git 仓库 URL 并想了解其中的内容时使用此 skill。
allowed-tools:
  - Bash
  - Read
  - Grep
  - Glob
  - Task
---

# Git 仓库探索 Skill

将远程 git 仓库 clone 到临时目录，并在其中搜索代码、阅读文件来回答用户的问题。

## 使用场景

- 用户想了解某个开源项目的实现细节
- 用户想在某个仓库中搜索特定的代码模式
- 用户想了解某个仓库的架构或功能

## 执行步骤

### 1. 获取用户提供的仓库信息

用户需要提供：
- Git 仓库 URL（必需）
- 要探索的问题或关键词（必需）

### 2. Clone 仓库到临时目录

```bash
# 生成唯一的临时目录名
REPO_DIR="/tmp/repo-$(date +%s)"

# Clone 仓库（使用 --depth 1 加速，只获取最新代码）
git clone --depth 1 <repo-url> "$REPO_DIR"

# 进入目录
cd "$REPO_DIR"
```

### 3. 探索仓库

根据用户的问题，使用以下方法探索仓库：

#### 3.1 查看项目结构
```bash
# 查看目录结构
ls -la
# 查看 README
cat README.md
```

#### 3.2 搜索代码
使用 Grep 工具搜索关键词：
- 搜索函数定义
- 搜索特定的代码模式
- 搜索配置文件

#### 3.3 阅读关键文件
使用 Read 工具阅读：
- 入口文件（main.py, index.js, etc.）
- 配置文件（package.json, pyproject.toml, etc.）
- 用户感兴趣的特定文件

### 4. 回答用户问题

根据搜索和阅读的结果，总结并回答用户的问题。

## 注意事项

- 使用 `--depth 1` 进行浅克隆以节省时间和空间
- 临时目录位于 `/tmp`，系统重启后会自动清理
- 如果仓库较大，优先使用 Grep 搜索而不是全量阅读
- 回答问题时引用具体的文件路径和代码行号

## 示例对话

用户: 帮我看看 https://github.com/example/project 这个仓库是怎么处理用户认证的

执行流程:
1. Clone 仓库到 /tmp/repo-xxx
2. 搜索 "auth", "login", "authenticate" 等关键词
3. 阅读相关文件
4. 总结认证机制并回答用户
