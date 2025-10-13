# Helm Sample Project - Testing Guide

This is a simple project to test the `cleanstart/helm:latest-dev` container image.

## Overview

Helm is a package manager for Kubernetes. This container provides a secure, minimal Helm environment running as a non-root user (`clnstrt`).

- **Image**: `cleanstart/helm:latest-dev`
- **User**: `clnstrt` (non-root, UID 1000)
- **Entrypoint**: `/usr/bin/helm`

## Prerequisites

- Docker installed and running

## Testing the Image

### Step 1: Pull the Image

```bash
docker pull cleanstart/helm:latest-dev
```

### Step 2: Verify Helm Version

```bash
docker run --rm cleanstart/helm:latest-dev version
```

**Expected output:**
```
version.BuildInfo{Version:"v3.x.x", GitCommit:"...", GitTreeState:"clean", GoVersion:"go1.x.x"}
```

### Step 3: Display Help

```bash
docker run --rm cleanstart/helm:latest-dev --help
```

This shows all available Helm commands and options.

### Step 4: Search for Charts

Search the Helm Hub for available charts:

```bash
docker run --rm cleanstart/helm:latest-dev search hub nginx
```

```bash
docker run --rm cleanstart/helm:latest-dev search hub wordpress
```

## Testing Chart Creation

### Step 1: Create a Working Directory

```bash
mkdir helm-test
cd helm-test
```

### Step 2: Generate a New Chart

**Linux/Mac:**
```bash
docker run --rm -v $(pwd):/workspace cleanstart/helm:latest-dev create /workspace/my-app
```

**Windows (PowerShell):**
```powershell
docker run --rm -v ${PWD}:/workspace cleanstart/helm:latest-dev create /workspace/my-app
```

This creates a `my-app` directory with a complete chart structure.

### Step 3: Lint the Chart

Validate the chart for issues:

**Linux/Mac:**
```bash
docker run --rm -v $(pwd):/workspace cleanstart/helm:latest-dev lint /workspace/my-app
```

**Windows (PowerShell):**
```powershell
docker run --rm -v ${PWD}:/workspace cleanstart/helm:latest-dev lint /workspace/my-app
```

**Expected output:**
```
==> Linting /workspace/my-app
[INFO] Chart.yaml: icon is recommended
1 chart(s) linted, 0 chart(s) failed
```

### Step 4: View Chart Details

Display chart metadata:

**Linux/Mac:**
```bash
docker run --rm -v $(pwd):/workspace cleanstart/helm:latest-dev show chart /workspace/my-app
```

**Windows (PowerShell):**
```powershell
docker run --rm -v ${PWD}:/workspace cleanstart/helm:latest-dev show chart /workspace/my-app
```

View default values:

**Linux/Mac:**
```bash
docker run --rm -v $(pwd):/workspace cleanstart/helm:latest-dev show values /workspace/my-app
```

**Windows (PowerShell):**
```powershell
docker run --rm -v ${PWD}:/workspace cleanstart/helm:latest-dev show values /workspace/my-app
```

### Step 5: Render Templates (Dry Run)

Preview the Kubernetes manifests without deploying:

**Linux/Mac:**
```bash
docker run --rm -v $(pwd):/workspace cleanstart/helm:latest-dev template test-release /workspace/my-app
```

**Windows (PowerShell):**
```powershell
docker run --rm -v ${PWD}:/workspace cleanstart/helm:latest-dev template test-release /workspace/my-app
```

### Step 6: Package the Chart

Create a versioned chart archive:

**Linux/Mac:**
```bash
docker run --rm -v $(pwd):/workspace cleanstart/helm:latest-dev package /workspace/my-app --destination /workspace
```

**Windows (PowerShell):**
```powershell
docker run --rm -v ${PWD}:/workspace cleanstart/helm:latest-dev package /workspace/my-app --destination /workspace
```

This creates a `.tgz` file (e.g., `my-app-0.1.0.tgz`).

Verify the package was created:

**Linux/Mac:**
```bash
ls -lh *.tgz
```

**Windows:**
```cmd
dir *.tgz
```

## Testing with Helm Repositories

### Step 1: Add a Repository

```bash
docker run --rm cleanstart/helm:latest-dev repo add bitnami https://charts.bitnami.com/bitnami
```

**Expected output:**
```
"bitnami" has been added to your repositories
```

### Step 2: Update Repository Cache

```bash
docker run --rm cleanstart/helm:latest-dev repo update
```

### Step 3: Search Repository

```bash
docker run --rm cleanstart/helm:latest-dev search repo nginx
```

### Step 4: View Chart Information

```bash
docker run --rm cleanstart/helm:latest-dev show chart bitnami/nginx
```

```bash
docker run --rm cleanstart/helm:latest-dev show values bitnami/nginx
```

## Advanced Usage

### Interactive Shell Access

```bash
docker run -it --rm --entrypoint /bin/sh cleanstart/helm:latest-dev
```

Inside the shell, you can run Helm commands directly:
```sh
helm version
helm --help
```

### Using with CI/CD

Example for GitLab CI:

```yaml
deploy:
  image: cleanstart/helm:latest-dev
  script:
    - helm version
    - helm lint ./chart
    - helm template ./chart
```

## Troubleshooting

### Permission Issues

If you encounter permission issues with mounted volumes:

**Linux/Mac:**
```bash
chmod -R 755 helm-test/
```

**Windows:**
Run PowerShell as Administrator and adjust permissions as needed.

### Chart Path Issues

When mounting volumes, ensure paths are absolute or use `$(pwd)` / `${PWD}` for current directory.

## Cleanup

Remove the test directory when done:

**Linux/Mac:**
```bash
cd ..
rm -rf helm-test
```

**Windows:**
```cmd
cd ..
rmdir /s /q helm-test
```

## Resources

- [Helm Official Documentation](https://helm.sh/docs/)
- [Artifact Hub - Chart Repository](https://artifacthub.io/)
- [Helm Best Practices](https://helm.sh/docs/chart_best_practices/)

## Summary

You have successfully tested the `cleanstart/helm:latest-dev` image by:
- ✅ Verifying Helm version
- ✅ Creating and validating a chart
- ✅ Rendering templates
- ✅ Packaging charts
- ✅ Working with repositories

The image is working correctly and ready for use!
