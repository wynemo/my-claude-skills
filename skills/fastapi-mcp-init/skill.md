---
name: fastapi-mcp-init
description: 使用 uv 初始化 FastAPI MCP Server 项目。当用户想创建一个基于 FastAPI 的 MCP 服务、MCP Server、或使用 fastapi_mcp 库时使用此 skill。触发词包括：mcp server、mcp 服务、fastapi mcp、创建 mcp。
allowed-tools:
  - Bash
  - Write
  - Edit
  - Read
---

# FastAPI MCP Server 项目初始化 Skill

使用 uv 初始化一个 FastAPI MCP Server 项目。

## 执行步骤

### 1. 使用 uv 初始化项目

```bash
uv init --name <project-name>
```

### 2. 添加依赖

```bash
uv add fastapi fastapi_mcp
```

### 3. 创建 main.py

使用以下模板创建 `main.py`，根据项目名称调整 `title`：

```python
import uvicorn
from fastapi import FastAPI, HTTPException
from fastapi.responses import StreamingResponse
from fastapi_mcp import FastApiMCP

import multiprocessing

mcp_app = FastAPI(title="<Project Title>")

mcp = FastApiMCP(mcp_app)
mcp.mount(mcp_app)

def run_mcp_app():
    """启动 FastAPI mcp_app"""
    uvicorn.run(
        "main:mcp_app",
        host="0.0.0.0",
        port=8001,
    )

if __name__ == "__main__":
    process_mcp_app = multiprocessing.Process(target=run_mcp_app)
    process_mcp_app.start()
```

### 4. 删除 uv init 生成的 hello.py

```bash
rm hello.py
```

## 运行方式

```bash
uv run main.py
```

MCP Server 启动后监听 `0.0.0.0:8001`，MCP SSE 端点为 `/mcp`。

## 注意事项

- 项目名称从目录名或用户指定的名称获取
- 在 `mcp_app` 上定义的 FastAPI 路由会自动暴露为 MCP tools
- 默认端口为 8001，可根据需要修改
