---
title: Deploying my WebUI Site to Cloudflare Pages
description: A brief overview of how to deploy static sites built with Swift to Cloudflare Pages.
published: May 1, 2025
---

WebUI is a tool I created for building static sites in Swift, in theory you could use this process for deploying sites built with other tools as well however this guide specifically focuses on Swift.

For a detailed guide on building a static site with WebUI, check out [Introduction to WebUI](https://maclong.uk/articles/introduction-to-webui).

## Setting Up a GitHub Action

To automate the build and deployment process, we'll set up a GitHub Action to compile the Swift project, generate the static site, and push the output to a dedicated `static` branch. Below are the steps to configure the GitHub Action workflow.

### Step 1: Create the Workflow File

Create `.github/workflows/build.yml` in your repository. This file defines the workflow that triggers on pushes or pull requests to the `main` branch and uses a macOS runner for Swift compatibility. With an intial step to checkout the repository code.

```yaml
name: Build and Deploy Static Site

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

permissions:
  contents: write # Grant write access to repository contents

jobs:
  build:
    runs-on: macos-15
    steps:
      - uses: actions/checkout@v4
```

### Step 2: Set Up Swift

Install Swift using the `SwiftyLab/setup-swift` action, make sure the version is set to `6.1` for compatibility.

```yaml
- name: Setup Swift 6.1
  uses: SwiftyLab/setup-swift@latest
  with:
    swift-version: "6.1"
```

### Step 3: Cache Swift Build Artifacts

Cache the Swift build artifacts to speed up future runs of this workflow.

```yaml
- name: Cache Swift Build
  uses: actions/cache@v4
  id: cache-swift-build
  with:
    path: .build
    key: ${{ runner.os }}-swift-build-${{ hashFiles('Package.swift', 'Sources/**') }}
    restore-keys: |
      ${{ runner.os }}-swift-build-
```

### Step 4: Build the Project

Build the Swift project, but only if the cache for build artifacts was not hit.

```yaml
- name: Build
  run: swift build -v
  if: steps.cache-swift-build.outputs.cache-hit != 'true'
```

### Step 5: Cache Generated Site Output

Cache the generated site output to avoid regenerating it unnecessarily.

```yaml
- name: Cache Generated Site
  uses: actions/cache@v4
  id: cache-site-output
  with:
    path: .output
    key: ${{ runner.os }}-site-output-${{ hashFiles('Sources/**', 'Resources/**') }}
    restore-keys: |
      ${{ runner.os }}-site-output-
```

### Step 6: Generate the Static Site

Run the static site generator using the `Portfolio` executable, but only if the site output cache was not hit.

```yaml
- name: Generate Site
  run: swift run Portfolio
  if: steps.cache-site-output.outputs.cache-hit != 'true'
```

### Step 7: Push to Static Branch

Push the generated site to the `static` branch, but only on pushes to the `main` branch.

```yaml
- name: Push to static branch
  if: github.event_name == 'push' && github.ref == 'refs/heads/main'
  run: |
    git config user.name "GitHub Actions Bot"
    git config user.email "actions@github.com"
    git checkout -B static
    rm -rf ./*
    mv .output/* .
    rm -rf .output .gitignore .github .build
    git add .
    git commit -m "release: update static site content"
    git push origin static --force
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

You can view the complete workflow file in my [Portfolio repository](https://github.com/maclong9/portfolio/blob/main/.github/workflows/build.yml).

## Deploying to Cloudflare Pages

Once your static site is built and pushed to the `static` branch, you can deploy it to Cloudflare Pages with the following steps:

1. Log in to your Cloudflare account and navigate to **Compute > Workers & Pages > Create > Pages**.
2. Choose **Connect to Git**, then select your GitHub repository containing the WebUI project.
3. Configure the project:
   1. Enter a **Project Name** (e.g., `my-webui-site`).
   2. Select the **static** branch as the deployment branch.
   3. Leave the build settings blank, as the site is pre-built by the GitHub Action.
   4. Click **Save and Deploy**.

Cloudflare Pages will automatically detect the static files in the `static` branch and deploy your site. Once the deployment is complete, you'll receive a URL (e.g., `my-webui-site.pages.dev`) where your site is live.

## Conclusion

By combining WebUI with a GitHub Action and Cloudflare Pages, you can automate the process of building and deploying a Swift-based static site. This setup ensures fast, reliable deployments with minimal manual intervention.

