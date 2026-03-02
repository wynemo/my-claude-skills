---
name: codex-review
description: Use OpenAI Codex to review code changes via a sub-agent. Triggers include "codex review", "codex-review", "用 codex review", "让 codex 看看".
---

Use OpenAI Codex CLI (`codex review`) to review code changes by running it as a sub-agent via the Bash tool.

## Input

- If an argument is provided (e.g. `/codex-review staging`), use that as the base branch.
- Otherwise, detect the base branch automatically:
  1. Use `gh pr view --json baseRefName --jq '.baseRefName'` to get the PR's target branch.
  2. If no PR exists, default to `origin/staging`.

## Procedure

### Step 1: Determine what to review

Detect the current state:

1. Check if there are uncommitted changes (`git status --porcelain`).
2. Check if we're on a PR branch.

Decision logic:
- If there are **uncommitted changes**, use `codex review --uncommitted`.
- If on a **PR branch** with commits, use `codex review --base <base_branch>`.
- If a **specific commit SHA** is provided as argument, use `codex review --commit <sha>`.

### Step 2: Run Codex review via sub-agent

Launch a **background Bash command** to run the codex review. The command may take 1-3 minutes.

```bash
codex review --base <base_branch>
```

Or for uncommitted changes:
```bash
codex review --uncommitted
```

**Important**: Set a timeout of 300000ms (5 minutes) for this command. Codex review can be slow.

### Step 3: Present the results

Once the codex review completes:

1. Display the full review output to the user in a clear, readable format.
2. Highlight any critical issues (security, bugs, logic errors) at the top.
3. If the review found no issues, say so clearly.

## Options

The user can customize behavior with additional arguments:
- `--base <branch>`: Override the base branch
- `--uncommitted`: Force review of uncommitted changes
- `--commit <sha>`: Review a specific commit

## Rules

- Always run codex review as a background task so the user can see progress
- Present results in a clear, organized manner
- Do NOT auto-fix issues — just present the review findings
- If codex is not installed, tell the user to install it with `npm install -g @openai/codex`
