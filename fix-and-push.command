#!/bin/bash
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

echo "=========================================="
echo "  iGEM Dashboards — Clean Push"
echo "=========================================="

# Clean ALL lock files
echo "Cleaning lock files..."
find .git -name "*.lock" -delete 2>/dev/null
find .git -name "tmp_obj_*" -delete 2>/dev/null
echo "Done."

# Configure git
git config user.name "Timothy Windham"
git config user.email "timothydds@gmail.com"

# Add push_to_github.command to gitignore (contains old token)
if ! grep -q "push_to_github.command" .gitignore 2>/dev/null; then
    echo "push_to_github.command" >> .gitignore
fi

# Remove push_to_github.command from git tracking if present
git rm --cached push_to_github.command 2>/dev/null

# Stage all changes
git add -A

# Check if there's anything to commit
if git diff --cached --quiet; then
    echo "Nothing new to commit."
else
    git commit -m "Hub title page: CRISPR DNA animation, scarlet gradient wash, art opacity boost

- CRISPR guide RNA strands radiate from logo following grid lines like a maze
- Strands randomly turn at intersections, fade with distance — scanning for sequences
- Double-helix rendering with backbone dots, rungs, and glowing leading edge
- Scarlet-to-cream gradient wash behind hero section for depth
- Boosted vignette (0.06→0.15), helix (0.6→0.85), registration marks (0.75→0.9)
- Helix node/rung opacity increased for stronger presence
- Design system font fixes across all four dashboards (prior commit)

Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
    echo "Committed."
fi

# Read token
if [ ! -f .git-token ]; then
    echo ""
    echo "ERROR: No .git-token file found."
    echo "Create it with:  echo 'YOUR_TOKEN' > .git-token"
    read -p "Press Enter to close..."
    exit 1
fi
TOKEN=$(cat .git-token | tr -d '[:space:]')

# Set remote with token
git remote set-url origin "https://twindha2:${TOKEN}@github.com/twindha2/igem-dashboards.git"

# Pull first
echo ""
echo "Pulling remote changes..."
git pull --rebase origin main 2>&1

# Push
echo ""
echo "Pushing to GitHub..."
if git push origin main 2>&1; then
    echo ""
    echo "✅ Push complete! Site updating at:"
    echo "   https://twindha2.github.io/igem-dashboards/"
else
    echo ""
    echo "❌ Push failed. See error above."
fi

# Clean token from remote URL
git remote set-url origin "https://github.com/twindha2/igem-dashboards.git"

echo ""
read -p "Press Enter to close..."
