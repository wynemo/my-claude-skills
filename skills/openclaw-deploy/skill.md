---
name: openclaw-deploy
description: "在远程服务器上部署 OpenClaw（Claude AI 代理 + Telegram Bot + Gateway）。需要提供 SSH 服务器地址、Claude API 代理信息和 Telegram Bot 配置。"
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
---

# OpenClaw 部署 Skill

在远程 Linux 服务器上通过 SSH 部署 OpenClaw 服务，包括 Claude API 代理、Telegram Bot 和 Gateway。

## 前置条件

- 远程服务器已安装 Docker 和 Docker Compose
- 本机可以通过 SSH 免密登录远程服务器
- 已准备好 Claude API 代理地址和 Key
- 已创建 Telegram Bot 并获取 Token

## 收集参数

在开始部署之前，**必须**通过 AskUserQuestion 收集以下信息：

1. **SSH 服务器地址** - 例如 `root@your-server.example.com`
2. **Claude API 代理 Base URL** - 例如 `http://1.2.3.4:8787`
3. **Claude API Key** - 例如 `sk-xxxxxxxxxxxxxxxx`
4. **Telegram Bot Token** - 例如 `123456789:AAxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
5. **Telegram 允许的用户 ID 列表** - 例如 `12345678`（逗号分隔多个）
6. **Gateway 端口**（可选，默认 `18789`）

## 部署步骤

所有操作通过 `ssh <SERVER>` 远程执行。

### 步骤 1：克隆仓库

```bash
ssh <SERVER> "cd /opt && git clone https://github.com/openclaw/openclaw.git openclaw"
```

如果已存在则拉取最新代码：

```bash
ssh <SERVER> "cd /opt/openclaw && git pull"
```

### 步骤 2：生成 Gateway Token

在本机生成一个随机 token：

```bash
GATEWAY_TOKEN=$(openssl rand -hex 32)
echo "Gateway Token: $GATEWAY_TOKEN"
```

### 步骤 3：创建 `.env` 文件

```bash
ssh <SERVER> "cat > /opt/openclaw/.env << 'EOF'
OPENCLAW_CONFIG_DIR=/root/.openclaw
OPENCLAW_WORKSPACE_DIR=/root/.openclaw/workspace
OPENCLAW_GATEWAY_PORT=<GATEWAY_PORT>
OPENCLAW_BRIDGE_PORT=<BRIDGE_PORT>
OPENCLAW_GATEWAY_BIND=lan
OPENCLAW_GATEWAY_TOKEN=<GATEWAY_TOKEN>
OPENCLAW_IMAGE=openclaw:local
OPENCLAW_EXTRA_MOUNTS=
OPENCLAW_HOME_VOLUME=
OPENCLAW_DOCKER_APT_PACKAGES=
ANTHROPIC_BASE_URL=<API_BASE_URL>
ANTHROPIC_AUTH_TOKEN=<API_KEY>
ANTHROPIC_API_KEY=<API_KEY>
EOF"
```

### 步骤 4：构建 Docker 镜像

```bash
ssh <SERVER> "cd /opt/openclaw && docker build -t openclaw:local -f Dockerfile ."
```

注意：构建可能需要较长时间，使用较大 timeout。

### 步骤 5：创建配置目录并设置权限

容器内以 `node` 用户（uid 1000）运行，目录权限必须正确：

```bash
ssh <SERVER> "mkdir -p /root/.openclaw/workspace /root/.openclaw/credentials && chown -R 1000:1000 /root/.openclaw && chmod 700 /root/.openclaw"
```

### 步骤 6：运行 Onboard

```bash
ssh <SERVER> "cd /opt/openclaw && docker compose run --rm \
  -e ANTHROPIC_BASE_URL=<API_BASE_URL> \
  -e ANTHROPIC_API_KEY=<API_KEY> \
  openclaw-cli onboard \
  --non-interactive \
  --accept-risk \
  --flow quickstart \
  --mode local \
  --auth-choice apiKey \
  --anthropic-api-key <API_KEY> \
  --gateway-port <GATEWAY_PORT> \
  --gateway-bind lan \
  --gateway-auth token \
  --gateway-token <GATEWAY_TOKEN> \
  --no-install-daemon \
  --skip-channels \
  --skip-skills \
  --skip-ui"
```

### 步骤 7：写入 `openclaw.json` 配置

将 Telegram 用户 ID 列表格式化为 JSON 数组（如 `["12345678", "87654321"]`）。

```bash
ssh <SERVER> "cat > /root/.openclaw/openclaw.json << 'ENDOFCONFIG'
{
  \"env\": {
    \"ANTHROPIC_API_KEY\": \"<API_KEY>\"
  },
  \"models\": {
    \"mode\": \"merge\",
    \"providers\": {
      \"anthropic-proxy\": {
        \"baseUrl\": \"<API_BASE_URL>\",
        \"apiKey\": \"\${ANTHROPIC_API_KEY}\",
        \"api\": \"anthropic-messages\",
        \"models\": [
          {
            \"id\": \"claude-opus-4-5-20251101\",
            \"name\": \"Claude Opus 4.5\",
            \"reasoning\": true,
            \"input\": [\"text\"],
            \"cost\": { \"input\": 0, \"output\": 0, \"cacheRead\": 0, \"cacheWrite\": 0 },
            \"contextWindow\": 200000,
            \"maxTokens\": 16000
          },
          {
            \"id\": \"claude-sonnet-4-5-20250514\",
            \"name\": \"Claude Sonnet 4.5\",
            \"reasoning\": true,
            \"input\": [\"text\"],
            \"cost\": { \"input\": 0, \"output\": 0, \"cacheRead\": 0, \"cacheWrite\": 0 },
            \"contextWindow\": 200000,
            \"maxTokens\": 16000
          },
          {
            \"id\": \"claude-sonnet-4-20250514\",
            \"name\": \"Claude Sonnet 4\",
            \"reasoning\": false,
            \"input\": [\"text\"],
            \"cost\": { \"input\": 0, \"output\": 0, \"cacheRead\": 0, \"cacheWrite\": 0 },
            \"contextWindow\": 200000,
            \"maxTokens\": 16000
          },
          {
            \"id\": \"claude-3-7-sonnet-20250219\",
            \"name\": \"Claude 3.7 Sonnet\",
            \"reasoning\": true,
            \"input\": [\"text\"],
            \"cost\": { \"input\": 0, \"output\": 0, \"cacheRead\": 0, \"cacheWrite\": 0 },
            \"contextWindow\": 200000,
            \"maxTokens\": 16000
          }
        ]
      }
    }
  },
  \"agents\": {
    \"defaults\": {
      \"model\": {
        \"primary\": \"anthropic-proxy/claude-opus-4-5-20251101\"
      },
      \"workspace\": \"/home/node/.openclaw/workspace\",
      \"maxConcurrent\": 4,
      \"subagents\": {
        \"maxConcurrent\": 8
      }
    }
  },
  \"channels\": {
    \"telegram\": {
      \"enabled\": true,
      \"botToken\": \"<TELEGRAM_BOT_TOKEN>\",
      \"dmPolicy\": \"allowlist\",
      \"allowFrom\": <TELEGRAM_ALLOW_FROM>,
      \"groupPolicy\": \"disabled\"
    }
  },
  \"gateway\": {
    \"mode\": \"local\",
    \"auth\": {
      \"mode\": \"token\",
      \"token\": \"<GATEWAY_TOKEN>\"
    },
    \"port\": <GATEWAY_PORT>,
    \"bind\": \"lan\",
    \"tailscale\": {
      \"mode\": \"off\",
      \"resetOnExit\": false
    }
  }
}
ENDOFCONFIG
chown 1000:1000 /root/.openclaw/openclaw.json"
```

### 步骤 8：启动 Gateway

```bash
ssh <SERVER> "cd /opt/openclaw && docker compose up -d openclaw-gateway"
```

### 步骤 9：验证部署

```bash
ssh <SERVER> "cd /opt/openclaw && docker compose logs --tail=20 openclaw-gateway"
```

## 占位符说明

| 占位符 | 说明 |
|--------|------|
| `<SERVER>` | SSH 服务器地址，如 `root@your-server.example.com` |
| `<API_BASE_URL>` | Claude API 代理 Base URL |
| `<API_KEY>` | Claude API Key |
| `<GATEWAY_PORT>` | Gateway 端口，默认 `18789` |
| `<BRIDGE_PORT>` | Bridge 端口，默认为 Gateway 端口 + 1 |
| `<GATEWAY_TOKEN>` | 自动生成的 Gateway 认证 Token |
| `<TELEGRAM_BOT_TOKEN>` | Telegram Bot Token |
| `<TELEGRAM_ALLOW_FROM>` | Telegram 允许用户 ID 的 JSON 数组，如 `["12345678"]` |

## 常用运维命令

部署完成后，告知用户以下常用命令：

```bash
# 查看日志
ssh <SERVER> "cd /opt/openclaw && docker compose logs -f openclaw-gateway"

# 重启
ssh <SERVER> "cd /opt/openclaw && docker compose restart openclaw-gateway"

# 停止
ssh <SERVER> "cd /opt/openclaw && docker compose down"

# 健康检查
ssh <SERVER> "cd /opt/openclaw && docker compose exec openclaw-gateway node dist/index.js health --token '<GATEWAY_TOKEN>'"

# 查看状态
ssh <SERVER> "cd /opt/openclaw && docker compose run --rm openclaw-cli status"

# 更新（拉取代码 + 重新构建 + 重启）
ssh <SERVER> "cd /opt/openclaw && git pull && docker build -t openclaw:local -f Dockerfile . && docker compose restart openclaw-gateway"
```
