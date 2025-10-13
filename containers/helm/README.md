**CleanStart Container for Helm**

Official Helm container image optimized for enterprise Kubernetes environments. Includes the Helm package manager for managing Kubernetes applications through charts. Features security-hardened base image, minimal attack surface, and runs as non-root user. Supports both production deployments and development workflows with separate tagged versions. Essential tool for deploying, managing, and upgrading Kubernetes applications.

**Key Features**
* Complete Helm 3 environment for Kubernetes package management
* Non-root user execution (clnstrt) for enhanced security
* Minimal base image with SSL certificate support
* Optimized for cloud-native and CI/CD workflows

**Common Use Cases**
* Managing Kubernetes application deployments
* Creating and packaging Helm charts
* Automating Kubernetes application releases in CI/CD pipelines
* Template rendering and chart validation

**Pull Commands**
Download the runtime container images

```bash
docker pull cleanstart/helm:latest
docker pull cleanstart/helm:latest-dev
```

**Quick Start**
Display Helm version and help

```bash
docker run --rm cleanstart/helm:latest-dev version
docker run --rm cleanstart/helm:latest-dev --help
```

**Create a New Chart**
Generate a new Helm chart

```bash
docker run --rm -v $(pwd)/my-chart:/workspace cleanstart/helm:latest-dev create /workspace/my-app
```

**Interactive Development**
Start interactive session for development

```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/helm:latest-dev
```

**Kubernetes Integration**
Connect to Kubernetes cluster with kubeconfig

```bash
docker run --rm \
  -v ~/.kube:/home/clnstrt/.kube:ro \
  cleanstart/helm:latest-dev list
```

**Best Practices**
* Use specific image tags for production (avoid latest)
* Mount kubeconfig as read-only (:ro) for security
* Run with non-root user (default: clnstrt)
* Use volume mounts for persistent chart data
* Validate charts with lint before deployment

**Architecture Support**

**Multi-Platform Images**

```bash
docker pull --platform linux/amd64 cleanstart/helm:latest
docker pull --platform linux/arm64 cleanstart/helm:latest
```

**Resources & Documentation**

**Essential Links**
* [Helm Official Documentation](https://helm.sh/docs/)
* [Artifact Hub - Helm Charts](https://artifacthub.io/)
* [Sample Project](./sample-project/README.md) - Complete examples and test scripts
* [Kubernetes Deployment](./kubernetes%20-%20AWS/README.md) - Kubernetes deployment examples

**Support & Community**
For issues and questions, please refer to the main CleanStart Containers repository.

