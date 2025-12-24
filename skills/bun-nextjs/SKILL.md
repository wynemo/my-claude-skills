---
name: bun-nextjs
description: "使用 Bun 创建 Next.js + shadcn/ui + Tailwind CSS 前端项目。"
allowed-tools:
  - Write
  - Read
  - Edit
  - Bash
---

# Bun + Next.js 前端项目创建指南

## 概述

使用 Bun 作为包管理器和运行时创建 Next.js + shadcn/ui + Tailwind CSS 前端应用的标准流程。

## 技术栈

- **Bun** - 包管理器和 JavaScript 运行时
- **Next.js** - React 框架
- **shadcn/ui** - UI 组件库
- **Tailwind CSS v4** - CSS 框架
- **TypeScript** - 类型安全

## 创建步骤

### 1. 创建 Next.js 项目

```bash
bun create next-app@latest frontend --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" << EOF
no
EOF
```

说明：
- `--typescript` - 使用 TypeScript
- `--tailwind` - 包含 Tailwind CSS
- `--eslint` - 包含 ESLint
- `--app` - 使用 App Router
- `--src-dir` - 使用 src 目录结构
- `--import-alias "@/*"` - 设置导入别名
- `no` 输入用于拒绝 React Compiler（交互式问题）

### 2. 修改 package.json 使用 Bun 运行时

进入项目目录后，修改 `package.json` 中的 scripts：

```json
{
  "scripts": {
    "dev": "bun --bun next dev",
    "build": "bun --bun next build",
    "start": "bun --bun next start",
    "lint": "next lint"
  }
}
```

`bun --bun` 前缀确保 Next.js 使用 Bun 运行时而非 Node.js。

### 3. 初始化 shadcn/ui

```bash
cd frontend && bunx --bun shadcn@latest init -d
```

参数说明：
- `bunx` - Bun 的 npx 替代品
- `--bun` - 强制使用 Bun 运行时
- `-d` - 使用默认配置

### 4. 添加常用组件

```bash
bunx --bun shadcn@latest add button card table badge input dialog -y
```

参数说明：
- `-y` - 自动确认，跳过交互式提示

根据需要添加其他组件，常用组件：
- `button` - 按钮
- `card` - 卡片
- `table` - 表格
- `badge` - 徽章
- `input` - 输入框
- `dialog` - 对话框
- `select` - 下拉选择
- `form` - 表单
- `toast` - 提示

### 5. 配置静态导出（可选）

如需生成纯静态文件，修改 `next.config.ts`：

```typescript
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "export",
  distDir: "dist",
};

export default nextConfig;
```

- `output: "export"` - 生成纯静态文件
- `distDir: "dist"` - 输出到 dist 目录

## 项目结构

```
frontend/
├── src/
│   ├── app/
│   │   ├── globals.css      # 全局样式（含 shadcn 变量）
│   │   ├── layout.tsx       # 根布局
│   │   └── page.tsx         # 首页
│   ├── components/
│   │   └── ui/              # shadcn/ui 组件
│   └── lib/
│       └── utils.ts         # 工具函数（cn 函数）
├── next.config.ts
├── tailwind.config.ts
├── components.json          # shadcn 配置
├── bun.lock                 # Bun 锁文件
└── package.json
```

## 常用命令

```bash
# 开发
bun run dev

# 构建
bun run build

# 预览构建结果
bun run start

# 安装依赖
bun install

# 添加新依赖
bun add <package>

# 添加开发依赖
bun add -d <package>
```

## Bun 相比其他包管理器的优势

- **更快的安装速度** - Bun 的包安装速度通常比 npm/yarn/pnpm 快 10-100 倍
- **内置运行时** - 无需单独安装 Node.js
- **原生 TypeScript 支持** - 无需编译即可直接运行 .ts 文件
- **兼容 npm** - 可以使用现有的 npm 生态系统

## 注意事项

1. 使用 `output: "export"` 时不支持以下功能：
   - 服务端 API 路由
   - 动态路由（需要 `generateStaticParams`）
   - 中间件
   - Image Optimization（需配置 `unoptimized: true`）

2. 如需使用图片优化，添加配置：
   ```typescript
   const nextConfig: NextConfig = {
     output: "export",
     distDir: "dist",
     images: {
       unoptimized: true,
     },
   };
   ```

3. 确保系统已安装 Bun：
   ```bash
   # macOS/Linux
   curl -fsSL https://bun.sh/install | bash

   # Windows (PowerShell)
   powershell -c "irm bun.sh/install.ps1 | iex"
   ```
