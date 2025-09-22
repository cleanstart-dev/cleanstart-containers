# 🚀 ArgoCD Basic Extensions

```bash
# Pull the ArgoCD Extension Installer image from Docker Hub
docker pull cleanstart/argocd-extension-installer:latest-dev
```

**What this means:**
- `docker pull` = "Download a program from the internet"
- `cleanstart/argocd-extension-installer:latest` = "The name of the extension manager we want to download"

### Step 3: Start the Extension Manager
**What we're doing:** We're going to start your ArgoCD extension manager using Docker.

```bash
# Navigate to the project folder
cd images/argocd-extension-installer/sample-project/basic-extensions

# Start the extension manager by compose yaml
```bash
docker-compose build
```
```bash
docker-compose up -d
```

**What this means:**
- `docker-compose up` = "Start all the services we need"
- `-d` = "Run in the background (like starting an app and letting it run)"
- This starts the extension manager and makes it ready to use

### Step 4: Verify Everything is Working
**What we're doing:** We're checking that the extension manager started correctly.

```bash
# Check if the container is running
docker ps


### Step 5: Use-Case
**What we're doing:** We're making sure you can dependancy packages are getting installed and image running perfectly.

### Step 6:Output
```bash
 ✔ Network basic-extensions_default         Created                                                                                                                              0.1s 
 ✔ Container my-argocd-extension-container  Created                                                                                                                              0.2s 
Attaching to my-argocd-extension-container
my-argocd-extension-container  | Starting extension installation...
my-argocd-extension-container  | fetch https://clnpkgs.clnstrt.dev/main/x86_64/APKINDEX.tar.gz
my-argocd-extension-container  | (1/6) Installing libffi (3.4.6-r0)
my-argocd-extension-container  | (2/6) Installing libpanelw (6.5_p20241006-r0)
my-argocd-extension-container  | (3/6) Installing python3 (3.13.2-r2)
my-argocd-extension-container  | (4/6) Installing python3-pycache-pyc0 (3.13.2-r2)
my-argocd-extension-container  | (5/6) Installing pyc (3.13.2-r2)
my-argocd-extension-container  | (6/6) Installing python3-pyc (3.13.2-r2)
my-argocd-extension-container  | Executing busybox-1.37.0-r30.trigger
my-argocd-extension-container  | Executing glibc-clnstrt-2.41-r0.trigger
my-argocd-extension-container  | running ldconfig ...done
my-argocd-extension-container  | OK: 423 MiB in 167 packages
my-argocd-extension-container  | Extension 'hello_world' installed successfully!
my-argocd-extension-container exited with code 0
```

### Installing ArgoCD Image Updater
1. Find "ArgoCD Image Updater" in the list
2. Click "Install" next to it
3. This extension helps automatically update container images
4. Wait for the installation to complete

### Understanding the Configuration

**docker-compose.yml** - The setup instructions:
```yaml
# This tells Docker what services to start
services:
  my-extension:
    build: .
    image: my-argocd-extension
    container_name: my-argocd-extension-container
```

# Stop the current containers
```bash
docker-compose down
```

2. **Learn more about ArgoCD:**
   - [ArgoCD Official Documentation](https://argo-cd.readthedocs.io/)]
   - [ArgoCD Extensions Guide](https://argo-cd.readthedocs.io/en/stable/operator-manual/extensions/)]

3. **Learn more about GitOps:**
   - GitOps principles and practices
   - Kubernetes deployment strategies
   - CI/CD pipeline integration

## 🤝 Getting Help

If you get stuck:
1. **Check the troubleshooting section above**
2. **Ask your classmates or teacher**
3. **Search online** (Google is your friend!)
4. **Join programming communities** (Reddit r/learnprogramming, Discord servers)


