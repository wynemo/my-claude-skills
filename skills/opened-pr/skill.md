---
name: opened-pr
description: List all my open PRs across all repos sorted by creation time (newest first), with draft status and relative time. Triggers include "open prs", "opened prs", "list open prs", "我的开放 PR".
---

List all my open PRs across all repos with clickable links, sorted by creation time (newest first).

Run this command:

`gh search prs --author=@me --state=open --sort=created --order=desc --limit=30 --json repository,title,url,isDraft,createdAt`

Do NOT group by repo. Display as a flat list sorted by createdAt (newest first). Show relative time (e.g. "2天前", "3小时前").

Output format:

```
- <url> — <title> (DRAFT) · <repo-name> · <relative-time>
- <url> — <title> · <repo-name> · <relative-time>
```

Only show "(DRAFT)" suffix for draft PRs.

At the end show total count: "共 X 个 PR（Y 个 DRAFT，Z 个 OPEN）"
