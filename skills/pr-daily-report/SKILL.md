---
name: pr-daily-report
description: Generate a daily work report based on today's PRs grouped by feature/topic. Triggers include "daily report", "work report", "today's prs", "日报", "今日工作报告".
---

Generate a daily work report based on today's PRs.

## Steps

1. Fetch today's PRs: `gh search prs --author=@me --sort=created --order=desc --limit=20 --json title,url,createdAt,repository,state | jq '[.[] | select(.createdAt | startswith("<today-date>"))]'`
2. Group related PRs by feature/topic
3. Output the report in the format below

## Output Format

```
Daily Report
Date: <YYYY/MM/DD>
Name: <name provided by user, default: run `gh api user --jq '.name'`>
Team / Project: <team or project info provided by user, default: infer from PR context>
Role: <role provided by user, default: run `gh api user --jq '.bio'`>

🟢 1. Today's Progress
<Group related PRs by feature/topic>
🔹 <Feature/Topic Title>
• <What was done, concise bullet point>
<PR URL>
• <What was done>
<PR URL>

🔹 <Feature/Topic Title>
• <What was done>
<PR URL>

🟡 2. In Progress
<What is currently being worked on but not yet completed, infer from open/draft PRs or ask user>

🔴 3. Blockers / Issues
<Any blockers or issues encountered, ask user if not obvious>

🔵 4. Tomorrow's Plan
<Planned work for tomorrow, ask user if not obvious>

🧠 5. Notes
<Any additional notes or observations>
```

## Rules

- Use English
- Keep it short and concise, no long texts
- Group related frontend+backend PRs together under one topic
- Include both open and closed PRs, no need to show status
- PR links as plain URLs on their own line under the bullet point
- Keep bullet points concise, one line each
- Use emoji section headers exactly as shown (🟢 🔹 🟡 🔴 🔵 🧠)
- If user provides name/role/team, use those; otherwise use defaults
- Sections 2-5: if user doesn't provide info, make reasonable inferences from PR context or ask
