---
name: apple-notes
description: "Manage Apple Notes via osascript on macOS (create, view, edit, delete, search, move, and export notes). Use when a user asks OpenClaw to add a note, list notes, search notes, or manage note folders."
allowed-tools:
  - Bash
---

# Apple Notes - osascript 操作

通过 osascript (AppleScript) 直接操作 Apple Notes，无需第三方工具。

## 列出笔记

### 列出所有文件夹
```bash
osascript -e '
tell application "Notes"
    set folderNames to {}
    repeat with f in folders
        set end of folderNames to name of f
    end repeat
    return folderNames
end tell
'
```

### 列出某个文件夹下的笔记（标题 + 创建时间）
```bash
osascript -e '
tell application "Notes"
    set output to ""
    repeat with n in notes of folder "Notes"
        set output to output & name of n & " | " & (creation date of n as string) & linefeed
    end repeat
    return output
end tell
'
```

### 列出所有笔记（标题）
```bash
osascript -e '
tell application "Notes"
    set output to ""
    repeat with n in every note
        set output to output & name of n & linefeed
    end repeat
    return output
end tell
'
```

## 创建笔记

### 在默认文件夹创建笔记
默认文件夹为 **"Notes"**，未指定文件夹时一律保存到此处。
```bash
osascript -e '
tell application "Notes"
    make new note at folder "Notes" with properties {name:"标题", body:"<h1>标题</h1><br>正文内容"}
end tell
'
```

### 在指定文件夹创建笔记
```bash
osascript -e '
tell application "Notes"
    make new note at folder "指定文件夹" with properties {name:"标题", body:"<h1>标题</h1><br>正文内容"}
end tell
'
```

### 创建富文本笔记（支持 HTML）
body 支持 HTML 标签：
- `<h1>` ~ `<h6>` 标题
- `<br>` 换行
- `<b>` 粗体, `<i>` 斜体, `<u>` 下划线
- `<ul><li>` 无序列表, `<ol><li>` 有序列表
- `<code>` 行内代码
- `<a href="url">` 链接
- `<table><tr><td>` 表格

示例：
```bash
osascript -e '
tell application "Notes"
    set noteBody to "<h1>会议记录</h1><br><b>日期:</b> 2024-01-15<br><br><h2>要点</h2><ul><li>第一项</li><li>第二项</li><li>第三项</li></ul><br><h2>待办</h2><ol><li>完成设计</li><li>代码实现</li></ol>"
    make new note at folder "Notes" with properties {name:"会议记录", body:noteBody}
end tell
'
```

## 查看笔记内容

### 按标题查看
```bash
osascript -e '
tell application "Notes"
    repeat with n in every note
        if name of n is "笔记标题" then
            return body of n
        end if
    end repeat
    return "未找到"
end tell
'
```

## 搜索笔记

### 按关键词搜索标题
```bash
osascript -e '
tell application "Notes"
    set output to ""
    repeat with n in every note
        if name of n contains "关键词" then
            set output to output & name of n & " | " & (name of container of n as string) & linefeed
        end if
    end repeat
    if output is "" then return "未找到匹配的笔记"
    return output
end tell
'
```

### 搜索笔记内容（全文搜索）
```bash
osascript -e '
tell application "Notes"
    set output to ""
    repeat with n in every note
        if plaintext of n contains "关键词" then
            set output to output & name of n & " | " & (name of container of n as string) & linefeed
        end if
    end repeat
    if output is "" then return "未找到匹配的笔记"
    return output
end tell
'
```

## 编辑笔记

### 追加内容到笔记末尾
```bash
osascript -e '
tell application "Notes"
    repeat with n in every note
        if name of n is "笔记标题" then
            set currentBody to body of n
            set body of n to currentBody & "<br>追加的新内容"
            return "已追加"
        end if
    end repeat
    return "未找到"
end tell
'
```

### 替换笔记全部内容
```bash
osascript -e '
tell application "Notes"
    repeat with n in every note
        if name of n is "笔记标题" then
            set body of n to "<h1>新标题</h1><br>全新内容"
            return "已替换"
        end if
    end repeat
    return "未找到"
end tell
'
```

## 删除笔记

```bash
osascript -e '
tell application "Notes"
    repeat with n in every note
        if name of n is "笔记标题" then
            delete n
            return "已删除"
        end if
    end repeat
    return "未找到"
end tell
'
```

## 移动笔记

```bash
osascript -e '
tell application "Notes"
    repeat with n in every note
        if name of n is "笔记标题" then
            move n to folder "目标文件夹"
            return "已移动"
        end if
    end repeat
    return "未找到"
end tell
'
```

## 创建文件夹

```bash
osascript -e '
tell application "Notes"
    make new folder with properties {name:"新文件夹"}
end tell
'
```

## 注意事项

- macOS 专用，需要 Notes.app
- 首次使用可能需要授权：系统设置 > 隐私与安全 > 自动化
- body 使用 HTML 格式，不是纯文本
- 在 osascript 中使用单引号包裹整个脚本，内部字符串用双引号
- 如果笔记标题或内容包含双引号，需要转义为 `\"`
- 笔记数量多时，遍历操作可能较慢
