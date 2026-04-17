#!/bin/bash
# One-click script to push dashboard files to GitHub
# Double-click this file in Finder to run it

cd "$(dirname "$0")"
echo "========================================="
echo "  Pushing dashboards to GitHub..."
echo "========================================="
echo ""

# Check if git is available
if ! command -v git &> /dev/null; then
    echo "Git not found. Installing via Xcode Command Line Tools..."
    xcode-select --install
    echo "Please re-run this script after Xcode tools install."
    read -p "Press Enter to close..."
    exit 1
fi

# Initialize git repo in this folder
git init
git remote add origin https://github.com/twindha2/igem-dashboards.git 2>/dev/null || git remote set-url origin https://github.com/twindha2/igem-dashboards.git

# Pull existing README
git fetch origin main
git checkout -b main origin/main 2>/dev/null || git checkout main

# Stage all HTML files
git add index.html project-lead.html coordinator.html hp-lead.html

# Commit
git commit -m "Add dashboard HTML files — landing page, project lead, coordinator, HP lead"

# Push
echo ""
echo "Pushing to GitHub..."
git push origin main

echo ""
echo "========================================="
echo "  Done! Your dashboards are uploaded."
echo "========================================="
echo ""
echo "Next step: Enable GitHub Pages in repo settings."
echo ""
read -p "Press Enter to close..."
