---
name: database-setup
description: "为 FastAPI 项目添加 PostgreSQL 数据库支持，使用 SQLModel 作为 ORM。"
allowed-tools:
  - Write
  - Read
  - Edit
  - Bash
---

# 数据库配置技能

为 FastAPI 项目添加 PostgreSQL 数据库支持，使用 SQLModel 作为 ORM。

## 技术栈

- **ORM**: SQLModel (基于 SQLAlchemy + Pydantic)
- **数据库驱动**: psycopg2-binary
- **数据库**: PostgreSQL

## 实现步骤

### 1. 添加依赖

在 `pyproject.toml` 中添加:

```toml
dependencies = [
    "psycopg2-binary>=2.9.11",
    "sqlmodel>=0.0.27",
]
```

然后运行 `uv sync` 更新依赖。

### 2. 配置数据库连接

找到项目中继承自 `pydantic_settings.BaseSettings` 的配置类，添加数据库连接配置：

```python
DATABASE_URL: str = "postgresql://user:password@host:port/database"
```

### 3. 创建数据库模块

在项目根目录创建 `db.py`：

```python
from sqlmodel import Session, SQLModel, create_engine

# 从项目配置中导入 settings 实例
# 根据实际项目结构调整导入路径，例如：
# from config import settings
# from core.config import settings
# from app.config import settings

engine = create_engine(settings.DATABASE_URL)


def get_session():
    with Session(engine) as session:
        yield session


def create_db_and_tables():
    SQLModel.metadata.create_all(engine)
```

### 4. 应用启动时初始化数据库

在 `main.py` 中添加启动事件:

```python
from db import create_db_and_tables

@app.on_event("startup")
async def startup_event():
    try:
        create_db_and_tables()
    except Exception:
        logger.exception("数据库初始化失败")
```

## 使用方式

### 定义模型

```python
from sqlmodel import Field, SQLModel

class User(SQLModel, table=True):
    id: int | None = Field(default=None, primary_key=True)
    name: str
    email: str
```

### 在路由中使用

```python
from fastapi import Depends
from sqlmodel import Session
from db import get_session

@app.get("/users")
def get_users(session: Session = Depends(get_session)):
    users = session.exec(select(User)).all()
    return users
```

## 注意事项

- 生产环境中应使用环境变量配置 DATABASE_URL，不要硬编码密码
- 建议使用连接池配置 (`pool_size`, `max_overflow` 等参数)
- 对于大型项目，考虑使用 Alembic 进行数据库迁移管理
