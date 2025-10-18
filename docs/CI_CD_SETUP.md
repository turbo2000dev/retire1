# CI/CD Setup Guide

This document explains the CI/CD pipeline for the Retire1 application using GitHub Actions and Firebase Hosting.

## Overview

The CI/CD pipeline automatically:
1. **Runs tests** on every push and pull request
2. **Builds the web app** when tests pass
3. **Deploys to Test environment** when pushing to `develop` branch
4. **Deploys to Production** when pushing to `main` branch

## Architecture

### Branches

- **`main`** - Production branch, deploys to live site
- **`develop`** - Development branch, deploys to test environment
- **Feature branches** - Run tests only, no deployment

### Environments

- **Production**: https://retire1-1a558.web.app
  - Deploys from `main` branch
  - Live Firebase Hosting site

- **Test**: https://retire1-1a558--test-nj5kgv89.web.app
  - Deploys from `develop` branch
  - Preview channel, expires after 30 days

## GitHub Actions Workflow

The workflow is defined in `.github/workflows/ci-cd.yml` and consists of 4 jobs:

### 1. Test Job

Runs on every push and pull request:

```yaml
- Checkout code
- Setup Flutter 3.9.2
- Get dependencies
- Verify code formatting
- Run static analysis
- Run all tests (217 tests)
- Upload test results as artifacts
```

**Success criteria**: All tests must pass before proceeding to build/deploy.

### 2. Build Web Job

Runs after tests pass, only on push events:

```yaml
- Checkout code
- Setup Flutter
- Get dependencies
- Build web app (--release --web-renderer canvaskit)
- Upload build artifacts
```

### 3. Deploy to Test Job

Runs after build, only for `develop` branch:

```yaml
- Download build artifacts
- Deploy to Firebase Hosting test channel
- URL: https://retire1-1a558--test-nj5kgv89.web.app
- Expires: 30 days
```

### 4. Deploy to Production Job

Runs after build, only for `main` branch:

```yaml
- Download build artifacts
- Deploy to Firebase Hosting live channel
- URL: https://retire1-1a558.web.app
```

## Setup Instructions

### Prerequisites

1. Firebase CLI installed: `npm install -g firebase-tools`
2. Firebase project: `retire1-1a558`
3. GitHub repository with appropriate permissions

### Step 1: Generate Firebase Service Account

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select project: `retire1-1a558`
3. Navigate to **Project Settings** → **Service Accounts**
4. Click **Generate New Private Key**
5. Save the JSON file securely (you'll need it for GitHub secrets)

### Step 2: Add GitHub Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add the following secret:

**Name**: `FIREBASE_SERVICE_ACCOUNT_RETIRE1_1A558`
**Value**: Paste the entire contents of the service account JSON file

Example JSON structure:
```json
{
  "type": "service_account",
  "project_id": "retire1-1a558",
  "private_key_id": "...",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
  "client_email": "...",
  "client_id": "...",
  ...
}
```

### Step 3: Create GitHub Environments (Optional but Recommended)

1. Go to **Settings** → **Environments**
2. Create two environments:

**Test Environment**:
- Name: `test`
- Deployment branches: `develop` only
- No protection rules needed

**Production Environment**:
- Name: `production`
- Deployment branches: `main` only
- **Recommended**: Add required reviewers for production deployments
- **Recommended**: Add deployment protection rules

### Step 4: Initialize Firebase Hosting

If not already initialized, run locally:

```bash
firebase login
firebase init hosting
```

Select:
- Project: `retire1-1a558`
- Public directory: `build/web`
- Single-page app: Yes
- Set up automatic builds: No (we use GitHub Actions)

### Step 5: Test the Pipeline

1. Create a feature branch:
   ```bash
   git checkout -b feature/test-ci-cd
   ```

2. Make a small change and push:
   ```bash
   git add .
   git commit -m "Test CI/CD pipeline"
   git push origin feature/test-ci-cd
   ```

3. Check GitHub Actions tab - should see tests running

4. Merge to `develop`:
   ```bash
   git checkout develop
   git merge feature/test-ci-cd
   git push origin develop
   ```

5. Check GitHub Actions - should deploy to test environment

6. Verify test deployment: https://retire1-1a558--test-nj5kgv89.web.app

7. When ready, merge to `main` for production deployment

## Workflow Triggers

### Automatic Triggers

- **Push to `main`**: Runs tests → Build → Deploy to Production
- **Push to `develop`**: Runs tests → Build → Deploy to Test
- **Push to any branch**: Runs tests only
- **Pull request to `main` or `develop`**: Runs tests only

### Manual Deployment (if needed)

You can manually deploy using Firebase CLI:

**Test environment**:
```bash
flutter build web --release
firebase hosting:channel:deploy test --expires 30d
```

**Production**:
```bash
flutter build web --release
firebase deploy --only hosting
```

## Firebase Hosting Configuration

The `firebase.json` file configures:

### Routing
- All routes redirect to `/index.html` (SPA routing)

### Caching
- Images: 2 hours (7200s)
- JS/CSS: 1 hour (3600s)

### Headers
```json
{
  "source": "**/*.@(jpg|jpeg|gif|png|svg|webp|ico)",
  "headers": [{"key": "Cache-Control", "value": "max-age=7200"}]
},
{
  "source": "**/*.@(js|css)",
  "headers": [{"key": "Cache-Control", "value": "max-age=3600"}]
}
```

## Monitoring

### GitHub Actions

- View workflow runs: **Actions** tab in GitHub
- View deployment status: **Environments** tab
- Download artifacts: Available for 5 days after build

### Firebase Hosting

- View deployments: [Firebase Console](https://console.firebase.google.com/) → Hosting
- View analytics: Firebase Console → Analytics
- View logs: Firebase Console → Functions (if using cloud functions)

## Troubleshooting

### Tests Fail in CI but Pass Locally

**Cause**: Environment differences (timezone, dependencies, etc.)

**Solution**:
```bash
# Run tests with same settings as CI
flutter test --no-sound-null-safety
```

### Deployment Fails with "Permission Denied"

**Cause**: Invalid or expired service account

**Solution**:
1. Generate new service account JSON from Firebase Console
2. Update GitHub secret `FIREBASE_SERVICE_ACCOUNT_RETIRE1_1A558`

### Build Artifacts Not Found

**Cause**: Build job failed or artifact expired

**Solution**:
1. Check build job logs in GitHub Actions
2. Artifacts expire after 5 days - re-run workflow if needed

### Firebase Hosting Returns 404

**Cause**: Routing not configured correctly

**Solution**:
Verify `firebase.json` has the rewrite rule:
```json
"rewrites": [
  {
    "source": "**",
    "destination": "/index.html"
  }
]
```

## Best Practices

### Development Workflow

1. **Feature Development**:
   ```bash
   git checkout develop
   git checkout -b feature/your-feature
   # Make changes
   git commit -m "Add feature"
   git push origin feature/your-feature
   # Create PR to develop
   ```

2. **Testing in Test Environment**:
   ```bash
   # After PR is merged to develop
   git checkout develop
   git pull origin develop
   # Automatic deployment to test environment
   # Verify at https://retire1-1a558--test-nj5kgv89.web.app
   ```

3. **Production Release**:
   ```bash
   # When ready for production
   git checkout main
   git merge develop
   git push origin main
   # Automatic deployment to production
   ```

### Code Quality

All code must pass before deployment:
- ✅ Dart formatting (`dart format`)
- ✅ Static analysis (`flutter analyze`)
- ✅ All 217 tests passing (`flutter test`)

### Security

- **Never commit** service account keys to the repository
- **Use GitHub secrets** for all sensitive credentials
- **Enable required reviewers** for production deployments
- **Use deployment protection rules** for production environment

## Cost Considerations

### Firebase Hosting

- **Free tier**: 10 GB storage, 360 MB/day bandwidth
- **Spark plan**: Free hosting for moderate traffic
- **Blaze plan**: Pay-as-you-go for high traffic

### GitHub Actions

- **Public repos**: Unlimited minutes
- **Private repos**: 2,000 minutes/month free (per organization)
- **Typical workflow**: ~5-10 minutes per run

## Maintenance

### Monthly Tasks

- Review Firebase Hosting usage in Firebase Console
- Clean up old preview channels (test deployments)
- Review GitHub Actions usage

### Quarterly Tasks

- Rotate service account keys
- Review and update Flutter/dependencies versions
- Update GitHub Actions workflow if needed

## Support

- Firebase Hosting: https://firebase.google.com/docs/hosting
- GitHub Actions: https://docs.github.com/en/actions
- Flutter Web: https://docs.flutter.dev/platform-integration/web

---

*Last Updated: 2025-10-18*
*Pipeline Status: Configured and Ready*
