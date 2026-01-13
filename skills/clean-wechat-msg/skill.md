---
name: clean-wechat-msg
description: This skill should be used when the user asks to "clean wechat messages", "delete old wechat files", "清理微信消息", "删除微信旧文件", or discusses wechat data cleanup in xwechat_files directory.
version: 1.0.0
platform: windows
---

# Clean WeChat Messages

清理微信导出数据中的旧消息文件。

**平台要求**: Windows (支持 Git Bash / MINGW64 / PowerShell)

## 目录位置

微信数据目录位于 Windows 用户主目录下的 `xwechat_files` 文件夹。

**路径表示**：
- Git Bash / MINGW64：`~/xwechat_files/`
- PowerShell：`$env:USERPROFILE\xwechat_files\`
- Windows 完整路径：`C:\Users\{用户名}\xwechat_files\`

## 目录结构

微信导出目录结构：
```
~/xwechat_files/
└── {wxid}/
    └── msg/
        ├── file/       # 文件消息，按月份分组
        ├── video/      # 视频消息，按月份分组
        ├── attach/     # 附件
        └── migrate/    # 迁移文件
```

月份目录命名格式：`YYYY-MM`，例如 `2025-12`、`2026-01`

## 清理逻辑

1. 获取当前日期（格式：YYYY-MM-DD）
2. 上个月 = 当前月份 - 1
3. 删除上个月及之前的所有月份目录
4. 保留当前月份的目录

## 执行步骤

```bash
# 获取当前日期并计算上个月
# 在 file 目录删除旧目录
cd "xwechat_files/{wxid}/msg/file"
rm -rf {old-months}/*

# 在 video 目录删除旧目录
cd "xwechat_files/{wxid}/msg/video"
rm -rf {old-months}/*

# 验证删除结果
ls -la "xwechat_files/{wxid}/msg/file"
ls -la "xwechat_files/{wxid}/msg/video"
```

## 示例

如果当前日期是 `2026-01-13`：
- 上个月是 `2025-12`
- 删除：`2025-12` 及之前（如 `2025-11`、`2025-10` 等）
- 保留：`2026-01`

## 注意事项

- 操作不可逆，删除前建议确认
- `{wxid}` 是微信用户标识符，格式如 `lozhang_a76f`
- 仅删除 file 和 video 目录下的月份子目录，不删除其他内容
