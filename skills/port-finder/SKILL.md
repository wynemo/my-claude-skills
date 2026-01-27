---
name: port-finder
description: 通过进程名或 PID 查询进程监听的端口。当用户想查看某个进程占用了哪些端口、某个服务监听在哪个端口、或者需要排查端口冲突时使用此技能。触发词包括：查端口、端口占用、进程端口、listening port、what port、端口监听。
---

# Port Finder - 进程端口查询

根据进程名或 PID 查询该进程的网络连接。

## 查询方法

1. **通过进程名找 PID**
```bash
pgrep -f <进程名>
```

2. **查询进程所有网络连接**
```bash
# 直接查，root 进程需要 sudo
lsof -p <PID>

# 或者加 sudo
sudo lsof -p <PID>
```

输出中 TYPE 为 IPv4/IPv6/UDP 的行就是网络连接，NAME 列显示地址:端口和状态。

## 常见场景

- 查看 nginx 端口: `pgrep nginx` 然后 `lsof -p <PID>`
- 查看端口 8080 被谁占用: `lsof -i :8080`
