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

### Step 1: Check PR description, score, and last reviewed commit

Run:
```
gh pr view <PR_NUMBER> --json body --jq '.body'
```

Extract the following from the PR body:
1. **Confidence Score** (e.g. "2/5") — found in `<h3>Confidence Score: X/5</h3>`
2. **Last reviewed commit** — found in `<sub>Last reviewed commit: abc1234</sub>`
3. The review summary text that describes what issues remain

Also get the current PR HEAD commit:
```
gh api repos/{owner}/{repo}/pulls/<PR_NUMBER> --jq '.head.sha'
```

**Compare `Last reviewed commit` with the PR HEAD commit** to determine whether Greptile has already reviewed the latest code.

**Always print the PR link, current score, last reviewed commit, and HEAD commit to the user at the start of each round**, e.g.:
```
PR: https://github.com/{owner}/{repo}/pull/<PR_NUMBER>
Current Score: 2/5
Last reviewed commit: abc1234
PR HEAD: def5678
```

**Score history**: Maintain a running list that maps each commit to its Greptile score. Every time a score is confirmed (i.e. `Last reviewed commit` matches the commit), record it. Print the full history at the start of each round, e.g.:
```
Score history:
  abc1234 → 2/5
  def5678 → 3/5
  ghi9012 → 4/5
```

**Exit condition**: If score > 3 (i.e. 4/5 or 5/5), stop the loop and output the final score, score history, and PR link.

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

### Step 5: Request Greptile re-review (STRICT: exactly once per push)

**CRITICAL: You must NEVER request a re-review more than once per push.**

- **Only request re-review if Step 4 actually committed and pushed new code.**
- If no changes were made (nothing to fix, or issues were not actionable), do NOT comment on the PR — skip to the next wait cycle.
- **Never duplicate review requests.** Use the `Last reviewed commit` from the PR body (extracted in Step 1) to verify. If it already matches your pushed commit, Greptile has already reviewed it — do NOT comment again.

Comment on the PR (exactly once per new push):
```
gh pr comment <PR_NUMBER> --body "@greptile-apps plz review, and give Confidence Score"
```

Output the PR link: `https://github.com/{owner}/{repo}/pull/<PR_NUMBER>`

### Step 6: Wait and re-check

Wait 5 minutes, then go back to Step 1.

**Important**: Use two methods to determine Greptile's review status:

#### Method 1: Compare `Last reviewed commit` with PR HEAD
- If `Last reviewed commit` **matches** PR HEAD → Greptile has reviewed. The current score is final for this round. Proceed to fix more issues or exit.
- If `Last reviewed commit` **does not match** PR HEAD → Greptile hasn't reviewed the latest code yet.

#### Method 2: Check if Greptile is actively reviewing via check-runs API
```
gh api repos/{owner}/{repo}/commits/<HEAD_SHA>/check-runs --jq '.check_runs[] | select(.name=="Greptile Review") | {status, conclusion, started_at}'
```
- `status: "in_progress"` → Greptile is currently reviewing. Wait.
- `status: "completed"` → Greptile has finished. The score in the PR body is up to date.
- No check-run found → Greptile hasn't started yet.

**Do NOT request another review while Greptile is in progress or has already reviewed the current commit. Just wait another 5 minutes.**

Max 3 consecutive waits — if still not reviewed after 3 waits, stop and report the status.

## Rules

- All code, comments, and commit messages in English
- Do NOT include Claude Co-Authored-By in commits
- Do NOT push to staging directly
- Read files before editing them
- Keep fixes minimal and focused on what the review flagged
- **Always print the PR link at the end of every round**, regardless of outcome (fix, wait, skip, exit, or error)
