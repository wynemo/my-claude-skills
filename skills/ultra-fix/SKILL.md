---
name: ultra-fix
description: Automatically fix PR issues in a loop until Greptile Confidence Score exceeds 3 (i.e. 4/5 or 5/5). Triggers include "ultra fix", "ultra-fix", "fix until pass", "fix pr score".
---

Automatically fix PR review issues in a loop until the Greptile Confidence Score exceeds 3 (i.e. reaches 4/5 or 5/5).

## Input

If an argument is provided (e.g. `/ultra-fix 1231`), use that as the PR number.
Otherwise, use `gh pr view --json number` to detect the current branch's PR number.

## Loop Procedure

Repeat the following steps:

### Step 1: Check PR description and score

Run:
```
gh pr view <PR_NUMBER> --json body --jq '.body' | grep -E "Confidence Score"
```

Extract the current Confidence Score (e.g. "2/5"). Also extract the review summary text that describes what issues remain.

**Always print the PR link and current score to the user at the start of each round**, e.g.:
```
🔗 PR: https://github.com/{owner}/{repo}/pull/<PR_NUMBER>
📊 Current Score: 2/5
```

**Exit condition**: If score > 3 (i.e. 4/5 or 5/5), stop the loop and output the final score and PR link.

### Step 2: Read review comments

Fetch inline review comments to understand what needs fixing:
```
gh api repos/{owner}/{repo}/pulls/<PR_NUMBER>/comments
```

Parse each comment for file path, line number, and the suggested fix.

### Step 3: Fix the issues

- Read each file mentioned in the review comments
- Apply the suggested fixes or implement your own fix based on the review feedback
- Focus on security issues, error handling, and logic bugs first

### Step 4: Commit and push

- Stage only the changed files (not `git add -A`)
- Commit with a descriptive message in English
- Do NOT include Co-Authored-By signature
- Push to the PR branch

### Step 5: Request Greptile re-review (only if code was committed)

**Only request re-review if Step 4 actually committed and pushed new code.** If no changes were made (nothing to fix, or issues were not actionable), do NOT comment on the PR again — skip directly to asking the user what to do.

Comment on the PR:
```
gh pr comment <PR_NUMBER> --body "@greptile-apps plz review, and give Confidence Score"
```

Output the PR link: `https://github.com/{owner}/{repo}/pull/<PR_NUMBER>`

### Step 6: Wait and re-check

Wait 5 minutes, then go back to Step 1.

**Important**: If the score and description are identical to the previous round, Greptile hasn't finished reviewing yet. Wait another 5 minutes before checking again. Max 3 consecutive identical checks before asking the user what to do.

## Rules

- All code, comments, and commit messages in English
- Do NOT include Claude Co-Authored-By in commits
- Do NOT push to staging directly
- Read files before editing them
- Keep fixes minimal and focused on what the review flagged
- **Always print the PR link at the end of every round**, regardless of outcome (fix, wait, skip, exit, or error)
