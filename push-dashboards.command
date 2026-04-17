#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

echo "=========================================="
echo "  iGEM Dashboards — Push to GitHub"
echo "=========================================="

# Read token from .git-token file (not tracked by git)
if [ ! -f .git-token ]; then
    echo ""
    echo "ERROR: No .git-token file found."
    echo "Create it with:  echo 'YOUR_TOKEN' > .git-token"
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi
TOKEN=$(cat .git-token | tr -d '[:space:]')

# Clean lock files if they exist
rm -f .git/HEAD.lock .git/objects/maintenance.lock 2>/dev/null

# Configure git
git config user.name "Timothy Windham"
git config user.email "timothydds@gmail.com"

# Stage and commit any changes
git add -A
git commit -m "Update dashboard files" 2>/dev/null

# Set remote with token and push
git remote set-url origin "https://twindha2:${TOKEN}@github.com/twindha2/igem-dashboards.git"
echo ""
echo "Pushing to GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "SUCCESS! Site updating at:"
    echo "https://twindha2.github.io/igem-dashboards/"
else
    echo ""
    echo "Push failed. See error above."
fi

# Clean token from remote
git remote set-url origin "https://github.com/twindha2/igem-dashboards.git"

echo ""
read -p "Press Enter to close..."
