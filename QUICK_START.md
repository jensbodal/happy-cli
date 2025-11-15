# Quick Start - Branch Strategy Setup

**Context**: You want to keep `main` clean but use Claude Code GitHub features in development.

## TL;DR

Run this for automated setup:
```bash
./BRANCH_SETUP_COMMANDS.sh
```

Or manually follow these steps:

## Manual Steps

### 1. Create `dev` branch
```bash
git checkout main
git pull origin main
git checkout -b dev
git push origin dev
```

### 2. Merge Claude Code workflows into `dev`
```bash
git fetch origin add-claude-github-actions-1763162899128
git merge origin/add-claude-github-actions-1763162899128
git push origin dev
```

### 3. Delete temporary branch
```bash
git push origin --delete add-claude-github-actions-1763162899128
```

### 4. Rebase current feature onto `dev`
```bash
git checkout upgrade/claude-code-2.0.41
git rebase dev
git push origin upgrade/claude-code-2.0.41 --force-with-lease
```

### 5. Create PR
- Create PR: `upgrade/claude-code-2.0.41` → `dev` (not main!)
- Claude Code will review it automatically
- After merge, cherry-pick to main if needed

## Result

```
main (clean, minimal workflows)
  └── dev (full Claude Code features)
       └── upgrade/claude-code-2.0.41 (your current work)
```

See `BRANCH_STRATEGY.md` for full details and future workflow.
