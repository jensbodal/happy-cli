#!/bin/bash
# Happy CLI Branch Setup - Quick Reference Commands
# Run these commands to set up the development branch strategy

set -e  # Exit on error

echo "=== Happy CLI Branch Setup ==="
echo ""
echo "Current branches on remote:"
git ls-remote --heads origin

echo ""
echo "This script will:"
echo "1. Create 'dev' branch from main"
echo "2. Merge Claude Code workflows into dev"
echo "3. Delete temporary actions branch"
echo "4. Rebase current feature branch onto dev"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# Step 1: Create dev branch from main
echo ""
echo "=== Step 1: Creating dev branch from main ==="
git checkout main
git pull origin main
git checkout -b dev
git push origin dev
echo "✓ Created dev branch"

# Step 2: Merge Claude Code workflows into dev
echo ""
echo "=== Step 2: Merging Claude Code workflows into dev ==="
git fetch origin add-claude-github-actions-1763162899128
git merge origin/add-claude-github-actions-1763162899128 -m "Merge Claude Code GitHub Actions workflows into dev"
git push origin dev
echo "✓ Merged workflows into dev"

# Step 3: Delete temporary branch
echo ""
echo "=== Step 3: Deleting temporary actions branch ==="
git push origin --delete add-claude-github-actions-1763162899128
echo "✓ Deleted temporary branch"

# Step 4: Rebase current feature branch
echo ""
echo "=== Step 4: Rebasing upgrade/claude-code-2.0.41 onto dev ==="
git checkout upgrade/claude-code-2.0.41
git rebase dev

echo ""
echo "=== IMPORTANT ==="
echo "You now need to force push the rebased branch:"
echo "  git push origin upgrade/claude-code-2.0.41 --force-with-lease"
echo ""
echo "Then create a PR from upgrade/claude-code-2.0.41 to dev (not main)"
echo ""
echo "Setup complete! See BRANCH_STRATEGY.md for full documentation."
