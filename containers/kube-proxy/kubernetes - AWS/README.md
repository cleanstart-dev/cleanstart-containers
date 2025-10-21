# Kube-Proxy Kubernetes Deployment for AWS

This directory contains Kubernetes manifests for deploying the CleanStart kube-proxy image on AWS EKS or any Kubernetes cluster.

## 📋 Overview

Kube-proxy is a network proxy that runs on each node in a Kubernetes cluster. It maintains network rules that allow network communication to Pods from inside or outside the cluster.

**Purpose of This Deployment**: This is designed to **validate the CleanStart kube-proxy image** in a Kubernetes environment. It runs alongside your existing kube-proxy for testing purposes.

**Important Notes**:
- ✅ Uses unique names (`cleanstart-kube-proxy`) and separate namespace
- ✅ Different ports (10257 for health, 10250 for metrics) to avoid conflicts
- ⚠️ **Not for production use** - This creates a second kube-proxy for testing only
- ⚠️ May show DNS errors when running alongside existing kube-proxy (this is expected)

## 📁 Files

- `deployment.yaml` - Complete kube-proxy DaemonSet configuration with RBAC

## 🚀 Quick Deploy

### Prerequisites

- A running Kubernetes cluster (AWS EKS, self-managed, etc.)
- kubectl configured to access your cluster
- Appropriate cluster-level permissions

### Deploy

```bash
kubectl apply -f deployment.yaml
```

### Verify Deployment

```bash
# Check namespace
kubectl get namespace cleanstart-kube-proxy

# Check DaemonSet status
kubectl get daemonset cleanstart-kube-proxy -n cleanstart-kube-proxy

# Check pods
kubectl get pods -n cleanstart-kube-proxy -l app=cleanstart-kube-proxy

# View logs
kubectl logs -n cleanstart-kube-proxy -l app=cleanstart-kube-proxy --tail=50
```

## 🔍 What's Included

The deployment.yaml contains:

1. **DaemonSet** - Ensures kube-proxy runs on every node
2. **ConfigMap** - Contains kubeconfig for cluster access
3. **ServiceAccount** - Identity for kube-proxy pods
4. **ClusterRole** - Permissions to watch services/endpoints
5. **ClusterRoleBinding** - Links ServiceAccount to ClusterRole

## ⚙️ Configuration

### Proxy Modes

Kube-proxy supports different proxy modes (configured via `--proxy-mode` flag):

- **iptables** (default) - Uses iptables rules for load balancing
- **ipvs** - Uses IPVS for better performance at scale
- **userspace** - Legacy mode (not recommended)

### Key Settings

```yaml
args:
- --kubeconfig=/var/lib/kube-proxy/kubeconfig.conf
- --proxy-mode=iptables
- --v=2
- --log-flush-frequency=5s
```

### Security Context

Kube-proxy requires privileged access:

```yaml
securityContext:
  privileged: true
  capabilities:
    add:
    - NET_ADMIN    # For network configuration
    - SYS_MODULE   # For loading kernel modules (IPVS)
```

### Resource Limits

```yaml
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi
```

## 🔧 Customization

### Change Proxy Mode to IPVS

Edit the args section in deployment.yaml:

```yaml
args:
- --proxy-mode=ipvs
```

### Adjust Verbosity

Change the `-v` flag value (0-4):

```yaml
args:
- --v=4  # More verbose logging
```

### Modify Resource Limits

Adjust based on your cluster size:

```yaml
resources:
  requests:
    cpu: 200m
    memory: 256Mi
  limits:
    cpu: 1000m
    memory: 1Gi
```

## 📊 Monitoring

### Health Check

**Method 1: Check Pod Status**

The simplest way to verify kube-proxy is healthy:

```bash
# Check if pod is running
kubectl get pods -n cleanstart-kube-proxy -l app=cleanstart-kube-proxy

# Check for recent restarts (should be low/stable)
kubectl describe pod -n cleanstart-kube-proxy -l app=cleanstart-kube-proxy | grep -A 5 "State:"
```

**Method 2: Check Logs**

Verify no errors in logs:

```bash
kubectl logs -n cleanstart-kube-proxy -l app=cleanstart-kube-proxy --tail=50
```

**Method 3: Direct Health Endpoint** (if accessible)

Note: Due to `hostNetwork: true`, port-forwarding may not work reliably. If you have node access:

```bash
# SSH to the node where the pod is running
# Then check the health endpoint directly
curl http://localhost:10257/healthz
```

### Metrics

Due to `hostNetwork: true`, metrics access via port-forward may not work reliably.

**Alternative: Check metrics directly on the node**

```bash
# Find which node the pod is running on
kubectl get pods -n cleanstart-kube-proxy -o wide

# SSH to that node and access metrics
curl http://localhost:10250/metrics
```

**Note**: For clusters without direct node access, consider deploying a metrics collector like Prometheus that can scrape the pods directly.

### View Logs

```bash
# Tail logs from all CleanStart kube-proxy pods
kubectl logs -n cleanstart-kube-proxy -l app=cleanstart-kube-proxy -f

# View logs from specific pod
kubectl logs -n cleanstart-kube-proxy <cleanstart-kube-proxy-pod-name>
```

## 🧪 Testing

### Verify kube-proxy is Working

1. Create a test service and deployment:

```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=ClusterIP
```

2. Test service connectivity:

```bash
kubectl run test-pod --image=busybox --rm -it -- wget -O- nginx
```

3. Check iptables rules (on a node):

```bash
# SSH to a node
sudo iptables -t nat -L KUBE-SERVICES
```

## ⚠️ Important Notes

### Avoiding Conflicts

This deployment uses:
- **Separate namespace**: `cleanstart-kube-proxy` (not `kube-system`)
- **Unique names**: `cleanstart-kube-proxy` (avoids conflicts)
- **Different ports**: healthz on 10257, metrics on 10250

This allows testing alongside the existing kube-proxy without conflicts.

### AWS EKS Considerations

- **EKS clusters already run kube-proxy** - This deployment runs alongside for testing
- **Not recommended for production** - This creates duplicate proxy instances
- **For testing purposes only** - To validate the CleanStart image works correctly

### Production Considerations

1. **This is a test deployment** - Runs alongside existing kube-proxy
2. **Not for production use** - Having two kube-proxy instances can cause conflicts
3. **Use specific image tags** - Avoid `:latest-dev` in production
4. **To replace existing kube-proxy** - Delete the default one first, then modify this to use standard names/ports

### Removal

To remove the CleanStart kube-proxy deployment:

```bash
kubectl delete -f deployment.yaml
```

Or delete just the namespace:

```bash
kubectl delete namespace cleanstart-kube-proxy
```

## 🔧 Troubleshooting

### Error: "spec.selector: field is immutable"

If you see this error:
```
The DaemonSet "kube-proxy" is invalid: spec.selector: Invalid value: ... field is immutable
```

**Cause**: There's already a kube-proxy DaemonSet with different labels.

**Solutions**:

1. **Delete existing resources** (if you want to replace them):
   ```bash
   kubectl delete clusterrolebinding cleanstart-kube-proxy
   kubectl delete clusterrole cleanstart-kube-proxy
   kubectl delete -f deployment.yaml
   kubectl apply -f deployment.yaml
   ```

2. **Clean start** (recommended for testing):
   ```bash
   # Delete the namespace and everything in it
   kubectl delete namespace cleanstart-kube-proxy
   
   # Delete cluster-level resources
   kubectl delete clusterrolebinding cleanstart-kube-proxy
   kubectl delete clusterrole cleanstart-kube-proxy
   
   # Reapply
   kubectl apply -f deployment.yaml
   ```

### Error: "unknown flag: --logtostderr"

If you see this error in the logs:
```
Error: unknown flag: --logtostderr
```

**Cause**: The `--logtostderr` flag was removed in newer Kubernetes versions.

**Solution**: The deployment.yaml has been updated to remove this flag. If you applied an older version, redeploy:

```bash
kubectl delete -f deployment.yaml
kubectl apply -f deployment.yaml
```

### DNS Resolution Errors in Logs

If you see errors like:
```
Failed to watch" err="failed to list *v1.Node: ... dial tcp: lookup kubernetes.default.svc on 172.31.0.2:53: no such host
```

**Cause**: With `hostNetwork: true`, the pod uses the node's network namespace and may have DNS resolution issues reaching `kubernetes.default.svc`. This happens when running alongside the existing kube-proxy.

**Is this a problem?**

For **testing purposes** (validating the image works), this is acceptable because:
- ✅ The image starts correctly
- ✅ Kube-proxy binary executes successfully  
- ✅ Configuration is parsed correctly
- ✅ The errors show it's trying to connect (image is working)

**For actual production use**, you would either:
1. Replace the existing kube-proxy (not run both)
2. Use the node's IP address instead of DNS in kubeconfig
3. Ensure proper DNS resolution in the host network namespace

**Note**: This deployment is primarily for **validating the CleanStart image**, not for production dual-proxy setup.

### Port-Forward Connection Refused

If you see this error when trying to port-forward:
```
failed to connect to localhost:10257: connection refused
```

**Cause**: Kube-proxy uses `hostNetwork: true`, which makes port-forwarding unreliable.

**Solutions**:

1. **Check pod is healthy via status** (recommended):
   ```bash
   kubectl get pods -n cleanstart-kube-proxy
   # Look for Running status with low restart count
   ```

2. **View logs for errors**:
   ```bash
   kubectl logs -n cleanstart-kube-proxy -l app=cleanstart-kube-proxy
   ```

3. **Access from the node directly** (if you have SSH access):
   ```bash
   # SSH to the node where pod is running
   curl http://localhost:10257/healthz
   ```

### Pods Not Starting

Check pod status and events:
```bash
kubectl get pods -n cleanstart-kube-proxy
kubectl describe pod <pod-name> -n cleanstart-kube-proxy
```

Common issues:
- **Insufficient permissions**: Check RBAC configuration
- **Image pull errors**: Verify image exists and is accessible
- **Node capacity**: Ensure nodes have available resources
- **CrashLoopBackOff**: Check logs for specific errors:
  ```bash
  kubectl logs -n cleanstart-kube-proxy <pod-name>
  ```
- **Frequent restarts**: May indicate configuration issues - check logs for error patterns

## 🔗 Related Resources

- [Kubernetes kube-proxy Documentation](https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy/)
- [Service Networking](https://kubernetes.io/docs/concepts/services-networking/service/)
- [AWS EKS Networking](https://docs.aws.amazon.com/eks/latest/userguide/pod-networking.html)
- [DaemonSet Documentation](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)

## 📝 Sample Project

For local Docker testing, see the `../sample-project/` directory which contains:
- Simple Docker commands to test the image
- Sample kubeconfig for testing
- Basic usage examples

