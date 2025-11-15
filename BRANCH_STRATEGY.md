# Happy CLI Branch Management Strategy

**Date**: 2025-11-14
**Context**: Need to manage GitHub Actions workflows while keeping main branch clean

## Current Branch State

### Remote Branches
1. **`main`** (3b44d80)
   - Clean production branch
   - Contains: `.github/workflows/smoke-test.yml` only
   - Latest: "chore: upgrade @anthropic-ai/claude-code to 2.0.36"

2. **`upgrade/claude-code-2.0.41`** (454116e)
   - Current feature branch
   - Contains: `.github/workflows/smoke-test.yml` only
   - Ready to merge: Claude Code 2.0.41 upgrade with refactored path resolution

3. **`add-claude-github-actions-1763162899128`** (7bce8fe)
   - Claude Code generated branch
   - Contains: 3 workflow files
     - `claude-code-review.yml` - PR review automation
     - `claude.yml` - PR assistant
     - `smoke-test.yml` - existing test workflow
   - Commits:
     - "Claude Code Review workflow"
     - "Claude PR Assistant workflow"
     - Based on main at 3b44d80

## Recommended Strategy: Development Branch Pattern

### Branch Structure
```
main (production-ready, minimal workflows)
  |
  └── dev (development, includes all Claude Code workflows)
       |
       ├── upgrade/claude-code-2.0.41 (current feature)
       └── [future feature branches]
```

### Implementation Plan

#### Phase 1: Create Development Branch (Immediate)

1. **Create `dev` branch from main**
   ```bash
   git checkout main
   git pull origin main
   git checkout -b dev
   git push origin dev
   ```

2. **Merge Claude Code workflows into `dev`**
   ```bash
   git merge origin/add-claude-github-actions-1763162899128
   # Resolve conflicts if any (likely none)
   git push origin dev
   ```

3. **Delete the temporary actions branch**
   ```bash
   git push origin --delete add-claude-github-actions-1763162899128
   ```

#### Phase 2: Merge Current Feature Branch

1. **Rebase current feature onto `dev`**
   ```bash
   git checkout upgrade/claude-code-2.0.41
   git rebase dev
   git push origin upgrade/claude-code-2.0.41 --force-with-lease
   ```

2. **Create PR: `upgrade/claude-code-2.0.41` → `dev`**
   - This will have Claude Code review enabled
   - Merge when ready

3. **Separately merge to `main` (without workflows)**
   ```bash
   git checkout main
   git pull origin main

   # Cherry-pick the commits, excluding workflow changes
   git cherry-pick <commit-sha-from-dev>

   # OR: Merge and remove workflows
   git merge dev
   git rm .github/workflows/claude-code-review.yml
   git rm .github/workflows/claude.yml
   git commit --amend -m "Merge dev (excluding Claude Code workflows)"

   git push origin main
   ```

#### Phase 3: Update Branch Protection Rules (GitHub Settings)

**For `main`:**
- Require PR reviews
- No direct pushes
- Status checks: smoke-test only

**For `dev`:**
- Allow Claude Code workflows
- Require PR reviews
- Status checks: smoke-test + Claude Code reviews

### Workflow Files Summary

**Keep in main** (production):
- `smoke-test.yml` - Essential CI/CD testing

**Keep in dev only** (development):
- `claude-code-review.yml` - Automated PR reviews
- `claude.yml` - PR assistant features
- `smoke-test.yml` - Same as main

### Future Workflow

#### For New Features:
1. Create feature branch from `dev`
   ```bash
   git checkout dev
   git pull origin dev
   git checkout -b feature/my-feature
   ```

2. Develop with Claude Code assistance (workflows active)

3. Create PR to `dev` (gets Claude Code review)

4. After merge to `dev`, cherry-pick to `main` if needed
   ```bash
   git checkout main
   git cherry-pick <commit-sha>  # Excludes workflow files
   git push origin main
   ```

#### For Releases:
- Tag releases from `main` branch
- `main` stays clean for production deployments
- `dev` has full developer experience

## Alternative Strategy: Branch-Specific Workflows

If you prefer NOT to maintain two branches, you can keep workflows in all branches but configure them to skip `main`:

### Option: Conditional Workflow Execution

Edit each Claude Code workflow file:
```yaml
# .github/workflows/claude-code-review.yml
on:
  pull_request:
    branches-ignore:
      - main
```

**Pros:**
- Single branch to maintain
- Workflows exist everywhere but only run on non-main branches

**Cons:**
- Workflow files clutter main branch
- Less explicit separation of concerns

## Immediate Next Steps

1. **Decide on strategy**: Development branch (recommended) OR conditional workflows
2. **Create `dev` branch** if using development branch strategy
3. **Merge GitHub Actions branch** into appropriate location
4. **Clean up temporary branch** (`add-claude-github-actions-1763162899128`)
5. **Update current feature branch** to work with chosen strategy
6. **Document in README** which branch developers should use

## Questions to Answer

- [ ] Do you want production deploys from `main` only?
- [ ] Should `dev` be the default branch for PRs?
- [ ] Do you want Claude Code features for all development?
- [ ] Should releases be tagged from `main` or `dev`?

---

**Recommendation**: Use the development branch pattern. It provides:
- Clean `main` for production
- Full Claude Code features in `dev`
- Clear separation of concerns
- Flexibility to cherry-pick features to main
