---
name: bun-frontend-docker
description: "为 Bun + Next.js 前端项目创建 Docker 打包部署文件。包括 Dockerfile（多阶段构建，输出静态文件）、.dockerignore 和 build.sh 构建脚本。"
allowed-tools:
  - Write
  - Read
  - Edit
  - Bash
---

# Bun 前端 Docker 打包 Skill

为 Bun + Next.js 前端项目创建 Docker 构建文件，产出静态文件（dist 目录）。

## 创建的文件

### 1. Dockerfile

使用多阶段构建，基于 `oven/bun:1`，最终仅保留构建产物：

```dockerfile
# syntax=docker/dockerfile:1

# 使用官方 Bun 镜像进行构建
FROM oven/bun:1 AS builder

WORKDIR /app

# 复制依赖文件
COPY package.json bun.lock* ./

# 安装依赖
RUN bun install --frozen-lockfile

# 复制源代码
COPY . .

# 构建应用
RUN bun run build

# 最终阶段：仅包含构建产物
FROM busybox:latest

WORKDIR /app

# 从构建阶段复制 dist 目录
COPY --from=builder /app/dist ./dist

# 默认命令（用于 docker run 时复制文件）
CMD ["sh", "-c", "echo 'Build complete. Use: docker run --rm -v $(pwd)/output:/output <image> cp -r /app/dist/. /output'"]
```

### 2. .dockerignore

排除不必要的文件以减小构建上下文：

```
# 依赖目录
node_modules

# 构建产物
dist
.dist-build-tmp
.next

# Git
.git
.gitignore

# 开发配置
.env.local
.env.development
.env.development.local

# IDE
.vscode
.idea
*.swp
*.swo

# 日志
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# 测试
coverage
.nyc_output

# 其他
*.md
LICENSE
.DS_Store
Thumbs.db
```

### 3. build.sh

本地构建脚本，使用 Docker 构建并输出静态文件到 dist 目录：

```bash
#!/bin/bash
set -e

# 确保 .env.production 文件存在（根据项目实际环境变量调整）
if [ ! -f .env.production ]; then
    echo "Creating .env.production..."
    touch .env.production
    echo 'NEXT_PUBLIC_API_BASE_URL=""' > .env.production
fi

# 使用中间目录构建，避免构建过程中 dist 目录不可用
BUILD_TMP_DIR=".dist-build-tmp"
rm -rf "${BUILD_TMP_DIR}"

echo "Building Docker image..."

# 构建 Docker 镜像并运行，输出到中间目录
docker build -t frontend-build . && docker run --rm -v "$(pwd)/${BUILD_TMP_DIR}:/output" frontend-build cp -r /app/dist/. /output

echo "Replacing dist directory..."

# 构建成功后，替换 dist 目录内容（保留 dist 目录本身）
mkdir -p dist
rm -rf dist/*
cp -r "${BUILD_TMP_DIR}"/. dist/
rm -rf "${BUILD_TMP_DIR}"

echo "Build completed successfully! Output: dist/"
```

## 使用方式

当用户请求为 Bun 前端项目创建 Docker 打包文件时：

1. 创建 `Dockerfile` - Bun 多阶段构建，产出静态文件
2. 创建 `.dockerignore` - 排除不必要文件
3. 创建 `build.sh` - 本地构建脚本，并设置可执行权限 `chmod +x build.sh`
4. 检查 `.env.production` 中的环境变量名是否与项目实际使用的一致（如 `NEXT_PUBLIC_API_BASE_URL`），如不一致则调整

## 前提条件

- 项目使用 Bun 作为包管理器（存在 `bun.lock`）
- `next.config.ts` 已配置 `output: "export"` 和 `distDir: "dist"`
- 系统已安装 Docker

## 构建流程说明

1. `build.sh` 使用 Docker 在容器内完成 `bun install` + `bun run build`
2. 构建产物通过 volume mount 复制到宿主机的临时目录
3. 临时目录内容替换到 `dist/`，确保构建过程中 dist 目录始终可用
4. 最终产出纯静态文件，可直接部署到 Nginx / CDN
