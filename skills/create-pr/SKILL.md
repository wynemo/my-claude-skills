---
name: create-pr
description: 用 gh 创建 GitHub PR，默认目标分支为 staging，并请求 Greptile bot review。触发词包括：create pr、open pr、创建 PR、提 PR。
---

Before creating PR, check if the repo is a Python project (e.g., has pyproject.toml, setup.py, or .py files in the root). If it is a Python project, run `ruff check .` in the repo root first. If ruff check fails (has errors), stop and fix the issues — do NOT proceed to create the PR until ruff check passes. If it is not a Python project, skip this step.

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

默认状态为draft 除非用户说不是
