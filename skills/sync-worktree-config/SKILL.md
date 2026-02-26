---
name: sync-worktree-config
description: "Sync config files (.env etc.) from main repo to current worktree and install dependencies. Use when working in a git worktree and need to set up the environment. Triggers: sync worktree, setup worktree, worktree config, 同步worktree配置."
---

# Sync Worktree Config

Sync configuration files from the main repository to the current git worktree and install dependencies.

## Steps

1. **Verify we're in a worktree**
```bash
# Get the main repo path (first entry in worktree list)
MAIN_REPO=$(git worktree list | head -1 | awk '{print $1}')
CURRENT=$(pwd)
if [ "$MAIN_REPO" = "$CURRENT" ]; then
    echo "❌ Not in a worktree, already in main repo"
    exit 1
fi
echo "Main repo: $MAIN_REPO"
echo "Worktree:  $CURRENT"
```

2. **Copy config files**
```bash
for f in .env; do
    if [ -f "$MAIN_REPO/$f" ]; then
        cp "$MAIN_REPO/$f" "$f"
        echo "✓ $f"
    else
        echo "✗ $f not found in main repo"
    fi
done
```

3. **Install dependencies**

Check the **main repo's** config files to detect the package manager, then install in the worktree:
- If `$MAIN_REPO/pyproject.toml` contains `[tool.poetry]` → `poetry install`
- If `$MAIN_REPO/package.json` exists → `pnpm install`
