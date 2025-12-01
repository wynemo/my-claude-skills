---
name: nextjs-frontend
description: "创建 Next.js + shadcn/ui + Tailwind CSS 前端项目，配置静态导出。"
allowed-tools:
  - Write
  - Read
  - Edit
  - Bash
---

# Next.js 前端项目创建指南

## 概述

在本项目中创建 Next.js + shadcn/ui + Tailwind CSS 前端应用的标准流程。

## 技术栈

- **Next.js** - React 框架
- **shadcn/ui** - UI 组件库
- **Tailwind CSS v4** - CSS 框架
- **TypeScript** - 类型安全
- **pnpm** - 包管理器

## 创建步骤

### 1. 创建 Next.js 项目

```bash
npx create-next-app@latest frontend --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" --use-pnpm --no-turbopack << EOF
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
- `--use-pnpm` - 使用 pnpm
- `--no-turbopack` - 不使用 Turbopack
- `no` 输入用于拒绝 React Compiler（交互式问题）

### 2. 初始化 shadcn/ui

```bash
cd frontend && pnpm dlx shadcn@latest init -d
```

`-d` 参数使用默认配置。

### 3. 添加常用组件

```bash
pnpm dlx shadcn@latest add button card table badge input dialog -y
```

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

### 4. 配置静态导出

修改 `next.config.ts`：

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
└── package.json
```

## 常用命令

```bash
# 开发
pnpm dev

# 构建
pnpm build

# 预览构建结果
pnpm start
```

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
