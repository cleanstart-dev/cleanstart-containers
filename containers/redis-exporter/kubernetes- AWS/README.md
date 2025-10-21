# 🚀 Redis Exporter - Kubernetes AWS EKS Deployment

Kubernetes deployment for CleanStart Redis Exporter on AWS EKS for monitoring Redis instances with Prometheus.

## 📁 Files

- `namespace.yaml` - Creates the redis-exporter namespace
- `deployment.yaml` - Deploys Redis Exporter and Redis instance
- `README.md` - This documentation

## 🎯 What This Deploys

- **Redis Server** - Redis 7 Alpine instance for data storage
- **Redis Exporter** - CleanStart Redis Exporter for Prometheus metrics
- **Services** - LoadBalancer for metrics access and ClusterIP for Redis

## 🚀 Quick Deploy

### Prerequisites

- AWS EKS cluster running
- kubectl configured to access your cluster
- AWS CLI configured

### Step 0: Connect to Your EKS Cluster

```bash
aws eks update-kubeconfig --name <your-cluster-name> --region <your-region>
```

**Example:**
```bash
aws eks update-kubeconfig --name my-eks-cluster --region us-east-1
```

### Step 1: Create the Namespace

```bash
kubectl apply -f namespace.yaml
```

**Output:**
```
namespace/redis-exporter created
```

### Step 2: Deploy Redis and Redis Exporter

```bash
kubectl apply -f deployment.yaml
```

**Output:**
```
deployment.apps/redis-exporter created
service/redis-exporter-service created
deployment.apps/redis created
service/redis-service created
```

### Step 3: Verify Deployment

```bash
kubectl get all -n redis-exporter
```

**Expected Output:**
```
NAME                                  READY   STATUS    RESTARTS   AGE
pod/redis-5d8f7c9b4d-xxxxx           1/1     Running   0          1m
pod/redis-exporter-7b8c6d5f4-xxxxx   1/1     Running   0          1m

NAME                              TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)          AGE
service/redis-service             ClusterIP      10.100.200.50    <none>           6379/TCP         1m
service/redis-exporter-service    LoadBalancer   10.100.200.51    a1b2c3...        9121:30000/TCP   1m

NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/redis            1/1     1            1           1m
deployment.apps/redis-exporter   1/1     1            1           1m
```

### Step 4: Get the LoadBalancer URL

```bash
kubectl get svc redis-exporter-service -n redis-exporter
```

Wait for the EXTERNAL-IP to be assigned (may take 2-3 minutes on AWS).

```bash
export EXPORTER_URL=$(kubectl get svc redis-exporter-service -n redis-exporter -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "Metrics URL: http://$EXPORTER_URL:9121/metrics"
```

### Step 5: Add Test Data to Redis

Get the Redis pod name:
```bash
export REDIS_POD=$(kubectl get pods -n redis-exporter -l app=redis -o jsonpath='{.items[0].metadata.name}')
```

Add some test data:
```bash
kubectl exec -n redis-exporter $REDIS_POD -- redis-cli SET mykey "Hello from EKS!"
kubectl exec -n redis-exporter $REDIS_POD -- redis-cli GET mykey
kubectl exec -n redis-exporter $REDIS_POD -- redis-cli INCR counter
kubectl exec -n redis-exporter $REDIS_POD -- redis-cli INCR counter
kubectl exec -n redis-exporter $REDIS_POD -- redis-cli INCR counter
```

### Step 6: View Metrics

**Option 1: Using curl from your local machine**
```bash
curl http://$EXPORTER_URL:9121/metrics | grep redis_
```

**Option 2: Open in browser**
```bash
echo "Open this URL in your browser: http://$EXPORTER_URL:9121/metrics"
```

**Key Metrics to Look For:**
- `redis_up 1` - Redis instance is up and running
- `redis_connected_clients` - Number of connected clients
- `redis_db_keys` - Total number of keys in database
- `redis_memory_used_bytes` - Memory used by Redis
- `redis_commands_processed_total` - Total commands processed
- `redis_keyspace_hits_total` - Number of successful key lookups
- `redis_keyspace_misses_total` - Number of failed key lookups

---

## 🔐 Using with Authentication (Optional)

If your Redis instance requires authentication, update the deployment with password:

```yaml
env:
- name: REDIS_ADDR
  value: "redis://redis-service:6379"
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: redis-secret
      key: password
```

Create the secret:
```bash
kubectl create secret generic redis-secret \
  --from-literal=password=yourpassword \
  -n redis-exporter
```

---

## 📊 Prometheus Integration

### Add Redis Exporter as Prometheus Target

If you have Prometheus running in your cluster, add this scrape config:

```yaml
scrape_configs:
  - job_name: 'redis-exporter'
    kubernetes_sd_configs:
      - role: service
        namespaces:
          names:
            - redis-exporter
    relabel_configs:
      - source_labels: [__meta_kubernetes_service_name]
        action: keep
        regex: redis-exporter-service
```

### Verify Prometheus Scraping

```bash
# Port-forward to Prometheus
kubectl port-forward -n monitoring svc/prometheus 9090:9090

# Open http://localhost:9090/targets
# Look for redis-exporter target (should be UP)
```

---

## 🔍 Troubleshooting

### Check Pod Status
```bash
kubectl get pods -n redis-exporter
kubectl describe pod <pod-name> -n redis-exporter
```

### View Logs

**Redis Exporter Logs:**
```bash
kubectl logs -n redis-exporter -l app=redis-exporter --tail=50 -f
```

**Redis Logs:**
```bash
kubectl logs -n redis-exporter -l app=redis --tail=50 -f
```

### Test Redis Connectivity

```bash
# From Redis Exporter pod
export EXPORTER_POD=$(kubectl get pods -n redis-exporter -l app=redis-exporter -o jsonpath='{.items[0].metadata.name}')
kubectl exec -n redis-exporter $EXPORTER_POD -- sh -c 'apk add redis && redis-cli -h redis-service ping'
```

### LoadBalancer Not Getting External IP

```bash
# Check service events
kubectl describe svc redis-exporter-service -n redis-exporter

# Ensure your EKS cluster has proper IAM roles for LoadBalancer creation
# Check AWS CloudFormation events for the LoadBalancer stack
```

### Metrics Not Showing

```bash
# Test locally from exporter pod
kubectl exec -n redis-exporter $EXPORTER_POD -- wget -qO- http://localhost:9121/metrics

# Check if Redis is accessible
kubectl exec -n redis-exporter $EXPORTER_POD -- nc -zv redis-service 6379
```

---

## 📋 Useful Commands

```bash
# Get all resources
kubectl get all -n redis-exporter

# Watch pod status
kubectl get pods -n redis-exporter -w

# Get detailed pod info
kubectl describe pod -n redis-exporter -l app=redis-exporter

# Interactive shell into Redis
kubectl exec -it -n redis-exporter $REDIS_POD -- redis-cli

# Interactive shell into Redis Exporter
kubectl exec -it -n redis-exporter $EXPORTER_POD -- sh

# View events
kubectl get events -n redis-exporter --sort-by='.lastTimestamp'

# Scale deployment
kubectl scale deployment redis-exporter --replicas=2 -n redis-exporter
```

---

## 🧹 Cleanup

### Delete All Resources

```bash
kubectl delete -f deployment.yaml
kubectl delete -f namespace.yaml
```

**Or delete the namespace (removes everything):**
```bash
kubectl delete namespace redis-exporter
```

**Verify cleanup:**
```bash
kubectl get all -n redis-exporter
# Should return: No resources found in redis-exporter namespace.
```

---

## 🎯 Use Cases

- **Redis Monitoring** - Monitor Redis performance and health
- **Prometheus Integration** - Export Redis metrics to Prometheus
- **Alerting** - Set up alerts based on Redis metrics (memory usage, connection counts)
- **Capacity Planning** - Track Redis resource usage over time
- **Multi-Instance Monitoring** - Monitor multiple Redis instances from one exporter

---

## ⚙️ Configuration Options

Environment variables you can configure in the deployment:

| Variable | Description | Default |
|----------|-------------|---------|
| `REDIS_ADDR` | Redis server address | `redis://redis-service:6379` |
| `REDIS_PASSWORD` | Redis password | (none) |
| `REDIS_USER` | Redis user for ACL | (none) |
| `REDIS_EXPORTER_CHECK_KEYS` | Comma-separated list of keys to export | (none) |
| `REDIS_EXPORTER_CHECK_SINGLE_KEYS` | Comma-separated list of single keys | (none) |
| `REDIS_EXPORTER_SKIP_TLS_VERIFICATION` | Skip TLS verification | `false` |

---

## 🌐 Production Best Practices

1. **Resource Limits** - Already configured in deployment
2. **High Availability** - Increase replicas for Redis Exporter
3. **Persistent Storage** - Add PersistentVolumeClaim for Redis data
4. **Security** - Use Redis authentication
5. **Monitoring** - Set up Grafana dashboards for Redis metrics
6. **Network Policies** - Restrict access to Redis service

### Example: Add Persistent Storage to Redis

```yaml
volumeMounts:
- name: redis-data
  mountPath: /data
volumes:
- name: redis-data
  persistentVolumeClaim:
    claimName: redis-pvc
```

---

## 📚 Resources

- [CleanStart Website](https://www.cleanstart.com)
- [Redis Exporter Official](https://github.com/oliver006/redis_exporter)
- [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [Redis Documentation](https://redis.io/documentation)
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/)

---

**Image:** `cleanstart/redis-exporter:latest-dev`  
**Redis Version:** 7-alpine  
**Platform:** Kubernetes on AWS EKS  
**Metrics Port:** 9121

