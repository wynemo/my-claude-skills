---
name: create-pr
description: 用 gh 创建 GitHub PR，默认目标分支为 staging，并请求 Greptile bot review。触发词包括：create pr、open pr、创建 PR、提 PR。
---

用gh创建GitHub PR

default Target branch is staging

before create branch, pull first

Don't add test plan

Use English

Don't include Claude signature

然后在pr里评论：
`@greptile-apps plz review ， and give Confidence Score`

如果是已经有的评论，就直接评论让机器人review

创建完PR后不要切换分支，保持在当前分支
