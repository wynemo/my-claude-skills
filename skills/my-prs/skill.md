---
name: my-prs
description: List my recent open and merged PRs across all adsgency-ai repos. Shows open time, draft status, and Greptile confidence score. Triggers include "my prs", "show my prs", "list my pull requests", "我的 PR".
---

List my recent open PRs across all adsgency-ai repos. 要给出什么时候打开的。以及机器人会给一个评分，1到5这样，你也要给我，它写在描述里的。Merged 的 PR 不需要显示评分，只显示标题和 URL 即可。

Use two commands to fetch PRs:
1. `gh search prs --author=zhangdadabin --sort=created --order=desc --limit=20 --state=open --json title,url,isDraft,state`
2. `gh search prs --author=zhangdadabin --sort=created --order=desc --limit=20 --merged --json title,url,isDraft,createdAt`

Combine and display results grouped by state: Open PRs first, then Merged PRs (with a `[MERGED]` header).

Mark draft PRs with a `[DRAFT]` prefix before the title.

Output format (title on one line, URL on next line, blank line between entries):

```
[DRAFT] <PR Title>
https://github.com/<org>/<repo>/pull/<number>/

<PR Title>
https://github.com/<org>/<repo>/pull/<number>/
```

Do not include tables, status, repo name columns, or markdown links. Just plain text title and URL.
