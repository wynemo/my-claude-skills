#!/usr/bin/env bash
set -euo pipefail

# Get the main repo path (first entry in worktree list)
MAIN_REPO=$(git worktree list | head -1 | awk '{print $1}')
CURRENT=$(pwd)

if [ "$MAIN_REPO" = "$CURRENT" ]; then
    echo "Not in a worktree, already in main repo"
    exit 1
fi
echo "Main repo: $MAIN_REPO"
echo "Worktree:  $CURRENT"

# Copy config files
for f in .env .env.local; do
    if [ -f "$MAIN_REPO/$f" ]; then
        cp "$MAIN_REPO/$f" "$f"
        echo "Copied $f"
    else
        echo "Skip $f (not found in main repo)"
    fi
done

# Copy uv.pyproject.toml as pyproject.toml
if [ -f "$MAIN_REPO/uv.pyproject.toml" ]; then
    cp "$MAIN_REPO/uv.pyproject.toml" "pyproject.toml"
    echo "Copied uv.pyproject.toml -> pyproject.toml"
else
    echo "Skip uv.pyproject.toml (not found in main repo)"
fi

# Install dependencies
if [ -f "$MAIN_REPO/pyproject.toml" ]; then
    echo "Installing Python dependencies..."
    uv sync
elif [ -f "$MAIN_REPO/package.json" ]; then
    echo "Installing Node dependencies..."
    pnpm install
else
    echo "No pyproject.toml or package.json found, skipping install"
fi

# Copy and run build_canvas.sh if exists
if [ -f "$MAIN_REPO/build_canvas.sh" ]; then
    cp "$MAIN_REPO/build_canvas.sh" "build_canvas.sh"
    echo "Copied build_canvas.sh"
    echo "Running build_canvas.sh..."
    bash build_canvas.sh
else
    echo "Skip build_canvas.sh (not found in main repo)"
fi

echo "Done"
