# CI/CD Setup Checklist

Quick checklist to get the CI/CD pipeline up and running.

## ✅ Prerequisites

- [ ] Firebase project exists: `retire1-1a558`
- [ ] Firebase CLI installed: `npm install -g firebase-tools`
- [ ] GitHub repository created and code pushed
- [ ] Firebase Hosting enabled in Firebase Console

## ✅ GitHub Configuration

### 1. Generate Firebase Service Account

- [ ] Go to [Firebase Console](https://console.firebase.google.com/)
- [ ] Select project: `retire1-1a558`
- [ ] Navigate to: **Project Settings** → **Service Accounts**
- [ ] Click: **Generate New Private Key**
- [ ] Save JSON file securely

### 2. Add GitHub Secret

- [ ] Go to GitHub repo: **Settings** → **Secrets and variables** → **Actions**
- [ ] Click: **New repository secret**
- [ ] Name: `FIREBASE_SERVICE_ACCOUNT_RETIRE1_1A558`
- [ ] Value: Paste entire service account JSON
- [ ] Click: **Add secret**

### 3. Create GitHub Environments (Recommended)

**Test Environment**:
- [ ] Go to: **Settings** → **Environments**
- [ ] Click: **New environment**
- [ ] Name: `test`
- [ ] Deployment branches: Add `develop`

**Production Environment**:
- [ ] Click: **New environment**
- [ ] Name: `production`
- [ ] Deployment branches: Add `main`
- [ ] **Optional**: Add required reviewers
- [ ] **Optional**: Add deployment protection rules

## ✅ Local Firebase Setup

- [ ] Login to Firebase: `firebase login`
- [ ] Verify project: `firebase projects:list` (should see `retire1-1a558`)
- [ ] Test local build: `flutter build web --release`

## ✅ Test the Pipeline

### Phase 1: Test Job Only

- [ ] Create feature branch: `git checkout -b feature/test-pipeline`
- [ ] Make small change (e.g., add comment in README)
- [ ] Commit and push: `git add . && git commit -m "Test pipeline" && git push origin feature/test-pipeline`
- [ ] Go to GitHub **Actions** tab
- [ ] Verify test job runs and passes (should show green checkmark)

### Phase 2: Deploy to Test Environment

- [ ] Merge feature branch to develop (or push directly to develop)
- [ ] Go to GitHub **Actions** tab
- [ ] Verify workflow runs: Test → Build → Deploy to Test
- [ ] Check deployment URL: https://retire1-1a558--test-nj5kgv89.web.app
- [ ] Verify app loads correctly

### Phase 3: Deploy to Production

- [ ] When ready, merge develop to main: `git checkout main && git merge develop && git push origin main`
- [ ] Go to GitHub **Actions** tab
- [ ] Verify workflow runs: Test → Build → Deploy to Production
- [ ] Check production URL: https://retire1-1a558.web.app
- [ ] Verify app loads correctly

## ✅ Post-Setup Verification

- [ ] All 217 tests pass in CI
- [ ] Test environment accessible
- [ ] Production environment accessible
- [ ] Deployments visible in Firebase Console → Hosting

## 🚨 Troubleshooting

If something goes wrong, check:

1. **Tests fail**: Review test logs in GitHub Actions
2. **Deployment fails**: Check Firebase service account secret is correct
3. **404 errors**: Verify `firebase.json` has correct rewrite rules
4. **Permission denied**: Re-generate service account key

See full documentation: `docs/CI_CD_SETUP.md`

## 📊 Pipeline Summary

Once setup is complete, your workflow will be:

```
┌─────────────────┐
│  Push to main   │ → Tests → Build → Deploy to Production
└─────────────────┘

┌─────────────────┐
│ Push to develop │ → Tests → Build → Deploy to Test
└─────────────────┘

┌─────────────────┐
│ Feature branch  │ → Tests only
└─────────────────┘

┌─────────────────┐
│  Pull Request   │ → Tests only
└─────────────────┘
```

---

*Setup Time: ~15-20 minutes*
*Status: Ready to configure*
