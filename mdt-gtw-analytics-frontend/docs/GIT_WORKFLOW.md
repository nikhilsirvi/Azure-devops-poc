# Git Workflow

This project follows a **GitFlow-inspired branching model** with protected long-lived branches and short-lived feature branches.

---

## Branch Map

```
main          ← production (tagged releases only)
│
stage         ← staging / pre-production
│
develop       ← integration branch (all features merge here first)
│
feature/*     ← one branch per feature/ticket
fix/*         ← bug fixes for develop
hotfix/*      ← critical fixes that skip straight to main
release/*     ← release stabilisation (develop → stage → main)
```

---

## Long-lived Protected Branches

| Branch | Purpose | Direct push |
|--------|---------|-------------|
| `main` | Production — tagged releases only | Never |
| `stage` | Staging environment | Never |
| `develop` | Integration of all completed features | Never |

All merges into protected branches must go through a **Pull Request** with at least one approval.

---

## Daily Development Flow

### 1. Start a feature

```bash
# Always branch from develop
git checkout develop
git pull origin develop
git checkout -b feature/DASH-42-revenue-chart
```

### 2. Commit frequently with conventional commits

```bash
git add src/features/dashboard/components/RevenueChart.tsx
git commit -m "feat(dashboard): add monthly revenue line chart"
```

Commitlint enforces format: `<type>(<scope>): <subject>`

Pre-commit hook runs automatically:
- Lint (ESLint on staged files via lint-staged)
- Format (Prettier on staged files)

### 3. Push and open a Pull Request into `develop`

```bash
git push -u origin feature/DASH-42-revenue-chart
# Open PR: feature/DASH-42-revenue-chart → develop
```

Pre-push hook runs automatically:
- Full test suite (`pnpm test:ci`)
- Security audit (`pnpm audit:ci` — fails on high/critical)

### 4. Merge into develop

- Squash and merge preferred for small features (clean history on develop).
- Regular merge for large features (preserves individual commits).
- Delete the feature branch after merge.

---

## Release Flow

```
develop  →  release/x.y.z  →  stage  →  main  →  tag vx.y.z
```

### 1. Cut a release branch from develop

```bash
git checkout develop
git pull origin develop
git checkout -b release/1.4.0
```

### 2. Stabilise (bug fixes only — no new features)

```bash
git commit -m "fix(checkout): correct rounding on tax calculation"
```

### 3. Merge into stage for QA

```bash
# Open PR: release/1.4.0 → stage
# Deploy to staging environment for final verification
```

### 4. Merge into main and tag

```bash
# Open PR: release/1.4.0 → main
# After merge:
git checkout main
git pull origin main
git tag -a v1.4.0 -m "Release v1.4.0"
git push origin v1.4.0
```

### 5. Back-merge into develop

```bash
# Open PR: release/1.4.0 → develop
# Keeps develop in sync with any fixes made during release stabilisation
```

---

## Hotfix Flow

For production bugs that cannot wait for the next release cycle.

```
main  →  hotfix/DASH-100-crash-on-load  →  main  →  tag  →  develop
```

```bash
# Branch from main
git checkout main
git pull origin main
git checkout -b hotfix/DASH-100-crash-on-load

# Fix and commit
git commit -m "fix(charts): prevent null dereference on empty dataset"

# Open PR: hotfix/* → main
# After merge, tag:
git tag -a v1.4.1 -m "Hotfix v1.4.1"
git push origin v1.4.1

# Open PR: hotfix/* → develop (keep develop in sync)
```

---

## Versioning (Semantic Versioning)

`MAJOR.MINOR.PATCH` — e.g. `v2.1.3`

| Increment | When |
|-----------|------|
| `PATCH` | Backwards-compatible bug fix |
| `MINOR` | New backwards-compatible feature |
| `MAJOR` | Breaking change |

Tag format: `v1.4.0` (lowercase `v` prefix).

---

## Pull Request Checklist

Before requesting review, verify:

- [ ] Branch is up to date with `develop` (rebase or merge)
- [ ] All pre-push hooks passed (tests + audit)
- [ ] TypeScript has no errors (`pnpm type-check`)
- [ ] New feature has at least one test
- [ ] i18n strings added for all supported locales
- [ ] `.env.example` updated if new env vars were added
- [ ] No `console.log` left (only `console.warn` / `console.error` allowed)

---

## Commit Message Reference

```
feat(scope): add new thing
fix(scope): correct broken thing
docs(scope): update documentation
style(scope): formatting only, no logic change
refactor(scope): restructure without behaviour change
test(scope): add or update tests
chore(scope): tooling, deps, build changes
perf(scope): performance improvement
ci(scope): CI/CD pipeline changes
build(scope): build system changes
revert(scope): revert a prior commit
```

Scope is optional but recommended. Use the feature area: `auth`, `dashboard`, `charts`, `i18n`, `router`, etc.

---

## Protecting Branches (GitHub)

Configure in GitHub → Settings → Branches → Branch protection rules:

**For `main`, `stage`, `develop`:**
- [x] Require pull request reviews before merging (min 1)
- [x] Require status checks to pass (CI: lint, test, build)
- [x] Require branches to be up to date before merging
- [x] Restrict who can push directly
- [x] Do not allow force pushes
