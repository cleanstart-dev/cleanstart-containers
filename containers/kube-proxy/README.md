**CleanStart Container for Kube-Proxy**

Kube-proxy is a network proxy that runs on each node in a Kubernetes cluster, maintaining network rules on nodes and enabling network communication to Pods. It implements the Kubernetes Service concept by maintaining network rules and performing connection forwarding.

**Key Features**
* Kubernetes v1.34.0 network proxy
* Supports iptables, ipvs, and nftables proxy modes
* Health and metrics endpoints included
* Optimized for cloud-native environments

**Common Use Cases**
* Kubernetes cluster network proxy
* Service load balancing and routing
* Network rule management on cluster nodes

**Pull Commands**
Download the container image

```bash
docker pull cleanstart/kube-proxy:latest-dev
```

**Quick Test**
Verify the image works

```bash
docker run --rm cleanstart/kube-proxy:latest-dev --version
```

**Best Practices**
* Use specific image tags for production (avoid latest-dev)
* Configure required capabilities: NET_ADMIN and SYS_MODULE
* Run as DaemonSet in Kubernetes (one pod per node)
* Monitor health endpoint on port 10256

**Resources & Documentation**

**Essential Links**
* **CleanStart Website**: https://www.cleanstart.com
* **Kubernetes kube-proxy Docs**: https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy/

**Reference:**

CleanStart Community Images: https://hub.docker.com/u/cleanstart 

Get more from CleanStart images from https://github.com/clnstrt/cleanstart-containers/tree/main/containers, 

  -  how-to-Run sample projects using dockerfile 
  -  how-to-Deploy via Kubernetes YAML 
  -  how-to-Migrate from public images to CleanStart images
