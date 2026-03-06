---
name: my-prs
description: List my recent open PRs across all repos of the current gh-authenticated user. Shows open time in Beijing time (UTC+8) and draft status. Optionally shows Greptile confidence score with --score flag. Triggers include "my prs", "show my prs", "list my pull requests", "我的 PR".
---

List my recent open PRs across all repos of the current gh-authenticated user. 要给出什么时候打开的（统一使用北京时间，UTC+8）。

用户可以通过参数指定 PR 数量，例如 `/my-prs 10` 表示只查看 10 条。默认数量为 20。将用户指定的数量记为 `$LIMIT`。

默认只显示 Open PR。只有用户明确要求查看 merged PR 时，才额外执行：
`gh search prs --author=@me --sort=created --order=desc --limit=$LIMIT --merged --json title,url,isDraft,createdAt`
并在 Open PR 列表后面追加 `[MERGED]` 分组（Merged PR 不需要显示评分，只显示标题和 URL）。

在输出 PR 列表之前，先打印当前北京时间（UTC+8），格式为：`当前时间: 2026-03-05 16:30`（使用 `date -u -v+8H '+%Y-%m-%d %H:%M'` 获取）。

Fetch open PRs:
`gh search prs --author=@me --sort=created --order=desc --limit=$LIMIT --state=open --json title,url,isDraft,state,createdAt`

Mark draft PRs with a `[DRAFT]` prefix before the title.

## Greptile Confidence Score（默认不获取）

只有当用户明确要求评分时（例如参数中包含 `--score`、`score`、`评分`），才获取评分。

获取方式：For each **open** PR, fetch the PR description (body) using `gh pr view <number> --repo <org/repo> --json body --jq '.body'` and extract the Greptile Confidence Score. The score is inside an HTML tag like `<h3>Confidence Score: 4/5</h3>`. Use macOS-compatible grep: `grep -oE 'Confidence Score: [0-9]/[0-9]'`. Show it as `[Score: 4/5]` after the title. If no score found, show `[Score: -]`.

Output format (title on one line, URL on next line, blank line between entries):

```
[DRAFT] <PR Title>
https://github.com/<org>/<repo>/pull/<number>/

<PR Title>
https://github.com/<org>/<repo>/pull/<number>/
```

When score is enabled, append `[Score: 4/5]` or `[Score: -]` after the title.

Do not include tables, status, repo name columns, or markdown links. Just plain text title and URL.
