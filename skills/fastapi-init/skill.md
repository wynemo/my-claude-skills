---
name: fastapi-init
description: 使用 uv 初始化 Python FastAPI 项目，包含完整的项目结构和常用配置。
allowed-tools:
  - Bash
  - Write
  - Edit
  - Read
---

# FastAPI 项目初始化 Skill

使用 uv 初始化 Python FastAPI 项目，包含完整的项目结构和常用配置。

## 执行步骤

### 1. 使用 uv 初始化项目

```bash
uv init --name <project-name>
```

### 2. 添加常用依赖

```bash
uv add "fastapi-toolbox>=0.6.4" "psycopg2-binary>=2.9.11" "pydantic-settings>=2.12.0" "requests>=2.32.5" "sqlmodel>=0.0.27"
```

### 3. 创建 main.py

使用以下模板创建 `main.py` 文件，根据项目名称调整 title 和 description：

```python
import argparse
import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi_toolbox import run_server, logger


@asynccontextmanager
async def lifespan(app: FastAPI):
    logger.info("Application starting up...")
    yield
    logger.info("Application shutting down...")


app = FastAPI(
    title="<Project Title>",
    description="<Project Title> API",
    version="1.0.0",
    lifespan=lifespan,
)

app.add_middleware(
    CORSMiddleware,
    allow_origin_regex=r".*",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def hello_world():
    return {"message": "Hello World"}


# uv run main.py --reload 开发模式
# uv run main.py --workers 2 部署模式
if __name__ == "__main__":
    # 创建命令行参数解析器
    parser = argparse.ArgumentParser()
    # 添加 workers 参数，默认为 1 个 worker
    parser.add_argument("--workers", type=int, default=1, help="Number of workers")
    # 添加 port 参数，默认端口为 8000
    parser.add_argument("--port", type=int, default=8080, help="Port number")
    # 添加 host 参数，默认 host 为 0.0.0.0
    parser.add_argument("--host", type=str, default="0.0.0.0", help="Host address")
    # 添加 reload 参数，默认为 False
    parser.add_argument("--reload", action="store_true", help="Enable auto-reload")
    # 解析命令行参数
    args = parser.parse_args()
    workers = args.workers
    port = args.port
    host = args.host
    reload = args.reload


    def filter_logs(record):
        # 过滤 SQLAlchemy 低级别日志
        if record.name.startswith("sqlalchemy"):
            if record.levelno < logging.ERROR:
                return True
        return False

    run_server(
        "main:app",
        host=host,
        port=port,
        workers=workers,
        reload=reload,
        log_file="logs/app.log", # 日志轮转
        filter_callbacks=[filter_logs]
    )
```

## 运行方式

- **开发模式**: `uv run main.py --reload`
- **部署模式**: `uv run main.py --workers 2`

## 注意事项

- 项目名称从目录名或用户指定的名称获取
- title 和 description 根据项目名称自动生成（转换为易读格式）
- 默认端口为 8080，可通过 `--port` 参数修改
