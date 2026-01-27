---
name: port-finder
description: 通过进程名或 PID 查询进程监听的端口。当用户想查看某个进程占用了哪些端口、某个服务监听在哪个端口、或者需要排查端口冲突时使用此技能。触发词包括：查端口、端口占用、进程端口、listening port、what port、端口监听。
---

# Port Finder - 进程端口查询

根据进程名或 PID 查询该进程的网络连接。

## 查询方法

1. **通过进程名找所有匹配的 PID**
```bash
# 列出所有匹配的进程及其 PID
pgrep -fl <进程名>
```

注意：一个应用可能有多个相关进程（如主进程、helper、dashboard 等），需要查询所有相关进程。

2. **批量查询多个进程的网络连接**
```bash
# 方法1：使用逗号分隔多个 PID
lsof -p <PID1>,<PID2>,<PID3> 2>/dev/null | grep -E 'IPv4|IPv6|UDP'

# 方法2：使用 lsof -c 按进程名查询（更简单）
lsof -c <进程名> 2>/dev/null | grep -E 'IPv4|IPv6|UDP'

# 如果是 root 进程需要 sudo
sudo lsof -p <PID> 2>/dev/null | grep -E 'IPv4|IPv6|UDP'
```

输出中 TYPE 为 IPv4/IPv6/UDP 的行就是网络连接，NAME 列显示地址:端口和状态。

3. **只查看监听端口（LISTEN 状态）**
```bash
lsof -c <进程名> 2>/dev/null | grep LISTEN
```

## 常见场景

- 查看 surge 所有进程端口: `lsof -c surge 2>/dev/null | grep -E 'IPv4|IPv6|UDP'`
- 查看 nginx 端口: `lsof -c nginx 2>/dev/null | grep LISTEN`
- 查看端口 8080 被谁占用: `lsof -i :8080`
