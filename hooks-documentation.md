# Claude Code Hooks 说明文档

## 当前配置的 Hooks

### 1. Stop Hook (停止钩子)

**触发时机：**
- Claude Code 停止工作时触发
- 可能的触发场景：
  - 用户按 Ctrl+C 中断 Claude 的执行
  - Claude 遇到错误而停止
  - Claude 完成任务并停止

**当前配置：**
```bash
osascript -e 'display notification "Claude 已停止工作 ⏸️" with title "Claude Code - Stop" sound name "Sosumi"'
```

**功能：**
- 显示 macOS 系统通知
- 标题：Claude Code - Stop
- 消息：Claude 已停止工作 ⏸️
- 音效：Sosumi

**已知问题：**
- 测试中发现此 hook 不会在用户按 Ctrl+C 时触发
- 可能需要特定的停止条件才能触发

---

### 2. Notification Hook (通知钩子)

**触发时机：**
- Claude 有通知需要提醒用户时触发
- 例如：长时间任务完成、需要用户输入、重要提示等

**当前配置：**
```bash
osascript -e 'display notification "Claude 有新通知 🔔" with title "Claude Code - 通知" sound name "Ping"'
```

**功能：**
- 显示 macOS 系统通知
- 标题：Claude Code - 通知
- 消息：Claude 有新通知 🔔
- 音效：Ping

**已知问题：**
- 有时候生效，有时候不生效
- 可能受 macOS 通知中心限制（短时间内重复通知会被忽略）

---

## 配置文件位置

```
~/.claude/settings.json
```

## 通知不生效的可能原因

1. **权限问题**
   - 需要在"系统设置 → 通知"中为以下应用启用通知权限：
     - Script Editor
     - osascript
     - claude / Claude Code

2. **勿扰模式**
   - 检查是否开启了勿扰模式或专注模式

3. **通知限制**
   - macOS 会限制短时间内相同应用的重复通知
   - 相同内容的通知可能不会重复显示

4. **Hook 触发条件**
   - 某些 hook 可能只在特定场景下触发
   - 需要进一步测试确认准确的触发时机

## 测试命令

手动测试通知是否工作：

```bash
# 测试 Stop hook 命令
osascript -e 'display notification "Claude 已停止工作 ⏸️" with title "Claude Code - Stop" sound name "Sosumi"'

# 测试 Notification hook 命令
osascript -e 'display notification "Claude 有新通知 🔔" with title "Claude Code - 通知" sound name "Ping"'

# 测试带时间戳的通知（避免重复限制）
osascript -e 'display notification "测试通知 - '"$(date +%H:%M:%S)"'" with title "测试" sound name "Glass"'
```

## macOS 可用的系统音效

常用音效名称：
- `Basso` - 低沉的音效
- `Blow` - 吹气声
- `Bottle` - 瓶子声
- `Frog` - 青蛙声
- `Funk` - 放克音效
- `Glass` - 玻璃声（默认）
- `Hero` - 英雄音效
- `Morse` - 摩斯电码
- `Ping` - 乒声
- `Pop` - 爆裂声
- `Purr` - 呼噜声
- `Sosumi` - 响亮的提示音
- `Submarine` - 潜水艇声
- `Tink` - 叮当声

## 修改配置

编辑 `~/.claude/settings.json` 文件中的 `hooks` 部分，修改后需要重启 Claude Code 才能生效。

## 更新日期

2026-01-26
