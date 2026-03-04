---
name: my-worktree
description: Create a git worktree based on origin/staging branch. Triggers include "create worktree", "new worktree", "创建 worktree", "新建 worktree".
---

Create a git worktree based on origin/staging branch.

The user provides a worktree name as the argument. If no name is provided, ask for one.

Steps:

1. Make sure you are in the project root (not already inside a worktree)
2. Fetch latest: `git fetch origin staging`
3. Create worktree: `git worktree add .claude/worktrees/<name> -b <name> origin/staging`
4. Tell the user the worktree is ready and how to enter it:
   ```
   cd .claude/worktrees/<name> && claude
   ```

Do NOT automatically cd into the worktree or start claude. Just print the command for the user.
