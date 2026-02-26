---
name: review-pr
description: Request Greptile bot to review a GitHub PR and give a Confidence Score. Triggers include "review pr", "review this pr", "ask greptile to review", "让机器人 review".
---

Request Greptile bot to review a GitHub PR.

Use `gh pr view --json number` to get the current PR number, then comment on it:

`@greptile-apps plz review, and give Confidence Score`

If an argument is provided (e.g. `/review-pr 1584`), use that as the PR number directly.
