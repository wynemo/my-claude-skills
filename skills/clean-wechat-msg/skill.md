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

---

# Clean WeChat Plugin Old Versions

清理微信插件目录中的旧版本文件，释放磁盘空间。

## 目录位置

微信插件目录（需要清理两个位置）：
1. `C:\Users\{用户名}\AppData\Roaming\Tencent\WeChat\XPlugin\Plugins`
2. `C:\Users\{用户名}\AppData\Roaming\Tencent\xwechat\xplugin\Plugins`

## 版本管理模式

微信插件使用多版本共存机制：
```
Plugins/
└── {插件名}/
    ├── {版本号1}/
    │   └── extracted/
    ├── {版本号2}/
    │   └── extracted/
    └── {版本号3}/
        └── extracted/
```

**规则**:
- 版本号为纯数字，数字越大版本越新
- 每个版本目录包含完整的插件文件
- 更新后旧版本不会自动删除（用于回滚）
- 目录修改时间 = 该版本的安装时间

## 主要占空间的插件

| 插件名称 | 功能 | 单版本大小 |
|---------|------|-----------|
| **RadiumWMPF** | 小程序运行框架 | ~400MB |
| ThumbPlayer | 缩略图播放器 | ~46MB |
| WeChatUtility | 实用工具集 | ~49MB |
| WeChatOCR | 文字识别 | ~61MB |

## 清理策略

**保留规则**: 每个插件只保留版本号最大的目录（最新版本）

**清理步骤**:
1. 遍历 Plugins 目录下的所有插件
2. 对于每个插件，识别所有版本号目录
3. 找出版本号最大的目录（最新版）
4. 删除其他旧版本目录
5. 统计释放的空间

## 执行逻辑

```bash
# 定义两个插件目录
plugin_dirs=(
    "C:\Users\{用户名}\AppData\Roaming\Tencent\WeChat\XPlugin\Plugins"
    "C:\Users\{用户名}\AppData\Roaming\Tencent\xwechat\xplugin\Plugins"
)

# 遍历两个目录
for plugin_root in "${plugin_dirs[@]}"; do
    if [ -d "$plugin_root" ]; then
        echo "清理目录: $plugin_root"
        cd "$plugin_root"

        # 对每个插件目录
        for plugin in */; do
            cd "$plugin"

            # 获取所有版本号（纯数字目录）
            versions=$(ls -d [0-9]* 2>/dev/null | sort -n)

            # 如果有多个版本
            if [ $(echo "$versions" | wc -l) -gt 1 ]; then
                # 保留最新版本（最后一个）
                keep_version=$(echo "$versions" | tail -1)

                # 删除其他旧版本
                for ver in $versions; do
                    if [ "$ver" != "$keep_version" ]; then
                        echo "删除 $plugin$ver"
                        rm -rf "$ver"
                    fi
                done
            fi

            cd ..
        done
    else
        echo "目录不存在，跳过: $plugin_root"
    fi
done
```

## 预期效果

以 RadiumWMPF 为例：
- 删除前：13839 (402MB) + 14315 (402MB) = 804MB
- 删除后：14315 (402MB) = 402MB
- 节省空间：402MB

## 安全性

- **低风险**: 保留最新版本，删除旧版本
- **建议**: 删除前先关闭微信客户端
- **回滚**: 如删除后出现问题，重启微信会自动重新下载

## 执行示例

如果当前有以下插件版本：
- RadiumWMPF: 13839, 14315
- UpdateNotify: 6440, 6488, 6526

清理后保留：
- RadiumWMPF: 14315（删除13839）
- UpdateNotify: 6526（删除6440, 6488）
