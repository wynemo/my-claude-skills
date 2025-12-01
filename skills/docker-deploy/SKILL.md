---
name: docker-deploy
description: "创建 Docker 部署相关文件。包括 Dockerfile（使用 uv 多阶段构建）、.dockerignore 和 build.sh 构建脚本。用于容器化 Python FastAPI 项目并推送到火山引擎镜像仓库。"
allowed-tools:
  - Write
  - Read
  - Bash
---

# Docker 部署 Skill

这个 skill 用于为 Python FastAPI 项目创建 Docker 部署相关文件。

## 创建的文件

### 1. Dockerfile

使用多阶段构建，基于 `ghcr.io/astral-sh/uv:python3.12-bookworm-slim`：

```dockerfile
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS builder

# Copy the project into the image
ADD . /app

# Sync the project into a new environment, asserting the lockfile is up to date
WORKDIR /app
ENV UV_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple
#RUN uv sync --locked
RUN uv sync

FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

# RUN apt-get update && apt-get install -y procps && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app /app

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["uv run main.py"]
```

### 2. .dockerignore

排除不必要的文件以减小镜像体积：

```
# Logs
logs/
*.log

lid.176.bin

# Frontend - ignore everything except dist
frontend/*
!frontend/dist/

# Python cache and virtual environments
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
env/
venv/
.venv/
.env/

# IDE and editor files
.vscode/
.idea/
*.swp
*.swo
*~

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Git
.git/
.gitignore

# Docker
Dockerfile*
docker-compose*
.dockerignore

# Other common excludes
*.tmp
*.temp
.cache/
coverage/
```

### 3. build.sh

构建并推送镜像到火山引擎镜像仓库：

```bash
#!/bin/bash

set -e

# 镜像名称：将 PROJECT_NAME 替换为实际项目名（如 my-api、user-service 等）
PROJECT_NAME="your-project-name"
IMAGE_NAME="ai-demo-cn-beijing.cr.volces.com/ai/${PROJECT_NAME}"

docker build --platform linux/amd64 -t $IMAGE_NAME .
docker push $IMAGE_NAME

# docker run --env-file setting.env $IMAGE_NAME
# 然后直接在 sealos 的应用里去部署
```

## 使用方式

当用户请求创建 Docker 部署文件时：

1. 创建 `Dockerfile` - 使用 uv 多阶段构建
2. 创建 `.dockerignore` - 排除不必要文件
3. 创建 `build.sh` - 构建和推送脚本
   - **重要**：询问用户项目名称，将 `PROJECT_NAME` 变量替换为实际值
   - 如用户未指定，可根据项目目录名或 `pyproject.toml` 中的 `name` 字段推断

## 镜像仓库

默认使用火山引擎北京区镜像仓库：
- 格式：`ai-demo-cn-beijing.cr.volces.com/ai/{项目名}`
- 示例：`ai-demo-cn-beijing.cr.volces.com/ai/my-fastapi-app`
