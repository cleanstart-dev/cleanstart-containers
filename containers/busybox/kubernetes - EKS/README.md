# BusyBox Kubernetes Deployment

Simple Kubernetes deployment for BusyBox HTTP server on AWS EKS.

## Prerequisites

- AWS EKS cluster configured and running
- `kubectl` configured to connect to your EKS cluster

## Files
- `namespace.yaml` - Creates namespace
- `deployment.yaml` - Deploys BusyBox pod with HTTP server
- `service.yaml` - Exposes service via ClusterIP (internal only)

## Deploy

```bash
# Apply in order to avoid namespace timing issues
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

## Test

```bash
# Check deployment status
kubectl get pods -n busybox-sample
kubectl get service -n busybox-sample

# Method 1: Port-forward to access locally
kubectl port-forward -n busybox-sample service/busybox-http-server-service 8080:80

# Then in another terminal or browser:
curl http://localhost:8080

# Method 2: Test from within the cluster
kubectl run test-curl --image=curlimages/curl:latest --rm -it --restart=Never -n busybox-sample -- curl http://busybox-http-server-service

# Expected response: <h1>Hello from BusyBox on Kubernetes!</h1>
```

## Access

The service uses ClusterIP, so it's only accessible from within the cluster. To access it:

### Option 1: Port Forward (Recommended for testing)
```bash
kubectl port-forward -n busybox-sample service/busybox-http-server-service 8080:80
```
Then access at: **http://localhost:8080**

### Option 2: From another pod in the cluster
```bash
kubectl run test-curl --image=curlimages/curl:latest --rm -it --restart=Never -n busybox-sample -- curl http://busybox-http-server-service
```

## Verify Deployment

```bash
# Check pod logs
kubectl logs -n busybox-sample -l app=busybox-http-server

# Check service details
kubectl describe service busybox-http-server-service -n busybox-sample

# Check deployment status
kubectl get deployment busybox-http-server -n busybox-sample
```

## Troubleshooting

### Cannot access the service
- **Verify pods are running**: `kubectl get pods -n busybox-sample`
- **Check service**: `kubectl describe service busybox-http-server-service -n busybox-sample`
- **Check pod logs**: `kubectl logs -n busybox-sample -l app=busybox-http-server`
- **Port-forward not working**: Make sure no other process is using port 8080 locally

## Cleanup

```bash
# Delete all resources
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
kubectl delete -f namespace.yaml

# Or delete all at once
kubectl delete -f .
```

