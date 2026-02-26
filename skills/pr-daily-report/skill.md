---
name: pr-daily-report
description: Generate a daily work report based on today's PRs grouped by feature/topic. Triggers include "daily report", "work report", "today's prs", "日报", "今日工作报告".
---

Generate a daily work report based on today's PRs.

## Steps

1. Fetch today's PRs: `gh search prs --author=zhangdadabin --sort=created --order=desc --limit=20 --json title,url,createdAt,repository,state | jq '[.[] | select(.createdAt | startswith("<today-date>"))]'`
2. Group related PRs by feature/topic
3. Output the report in the format below

## Output Format

```
**Daily Report**

**Date:** <YYYY-MM-DD>
**Name:** <name provided by user, default: Zhang Daibn>
**Role:** <role provided by user, default: Full Stack Engineer>

---

**Summary**

<1-2 sentences summarizing the day: what areas were worked on, how many PRs, across which repos>

**Work Completed**

1. **<Feature/Topic Title>**
   - <What was done, concise bullet points>
   - PRs: [repo#number](url), [repo#number](url)

2. **<Feature/Topic Title>**
   - <What was done>
   - PR: [repo#number](url)
```

## Rules

- Use English
- Group related frontend+backend PRs together under one topic
- Include both open and closed PRs, no need to show status
- PR links use format `[repo#number](url)`
- Keep bullet points concise
- If user provides name/role, use those; otherwise use defaults
