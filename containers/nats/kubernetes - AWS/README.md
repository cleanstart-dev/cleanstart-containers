# NATS on Kubernetes (AWS)

This directory contains Kubernetes manifests to deploy NATS messaging server on AWS EKS or any Kubernetes cluster.

## Overview

This deployment provides a high-performance NATS messaging server using the CleanStart NATS container image. NATS is a lightweight, high-performance messaging system ideal for microservices, IoT, and cloud-native applications.

**Key Features:**
- **Client Port (4222)**: For NATS client connections
- **Monitoring Port (8222)**: HTTP endpoint for server monitoring and health checks
- **LoadBalancer Service**: Exposes NATS externally for easy access
- **Health Checks**: Automatic liveness and readiness probes

## Prerequisites

- Kubernetes cluster (AWS EKS, minikube, kind, etc.)
- `kubectl` configured to access your cluster
- Access to `cleanstart/nats:latest-dev` image

## Quick Start

### Deploy NATS

```bash
# Deploy all resources at once
kubectl apply -f .

# Verify deployment
kubectl get pods -n nats-demo
kubectl get service -n nats-demo
```

Expected output:
```
NAME                          READY   STATUS    RESTARTS   AGE
nats-server-xxxxxxxxxx-xxxxx  1/1     Running   0          30s

NAME           TYPE           CLUSTER-IP      EXTERNAL-IP
nats-service   LoadBalancer   10.100.xxx.xxx  xxxxx.elb.amazonaws.com
```

### Access NATS Server

Wait for the LoadBalancer EXTERNAL-IP to be assigned, then test:

```bash
# Get the external endpoint
export NATS_LB=$(kubectl get service nats-service -n nats-demo -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "NATS Server: nats://$NATS_LB:4222"
echo "Monitoring: http://$NATS_LB:8222"

# Test monitoring endpoint
curl http://$NATS_LB:8222/healthz
```

### Test with NATS Client

**Interactive Testing (Recommended for Learning)**
```bash
# Terminal 1: Start subscriber (will wait silently for messages)
kubectl run nats-subscriber \
  --image=natsio/nats-box:latest \
  --namespace=nats-demo \
  --restart=Never \
  --rm -i --tty \
  -- nats sub -s nats://nats-service:4222 "test.>"

# Terminal 2: Send message (subscriber will receive and display it)
kubectl run nats-publisher \
  --image=natsio/nats-box:latest \
  --namespace=nats-demo \
  --restart=Never \
  --rm -i --tty \
  -- nats pub -s nats://nats-service:4222 test.message "Hello from NATS!"
```

**Expected Behavior:**
- Subscriber will connect and wait silently (no output until message received)
- When publisher sends message, subscriber will display it
- Press `Ctrl+C` to terminate subscriber (pod will be deleted automatically)
- Any "Unhandled Error" messages on termination are normal and can be ignored


```

## Monitoring and Health Checks

### Health Endpoints

| Endpoint | Description |
|----------|-------------|
| `/healthz` | Health check endpoint |
| `/varz` | General server information |
| `/connz` | Connection information |
| `/subsz` | Subscription information |
| `/routez` | Routing information |

### View Logs

```bash
# View NATS server logs
kubectl logs -n nats-demo -l app=nats

# Follow logs in real-time
kubectl logs -n nats-demo -l app=nats -f
```

### Check Pod Status

```bash
# Get pod details
kubectl get pods -n nats-demo

# Describe pod for more info
kubectl describe pod -n nats-demo -l app=nats
```

## Additional Commands

```bash
# Scale deployment
kubectl scale deployment nats-server -n nats-demo --replicas=3

# Access container shell
kubectl exec -it -n nats-demo \
  $(kubectl get pod -n nats-demo -l app=nats -o jsonpath='{.items[0].metadata.name}') \
  -- /bin/sh

# Test different message patterns
kubectl run nats-pub-orders \
  --image=natsio/nats-box:latest \
  --namespace=nats-demo \
  --restart=Never \
  -- nats pub -s nats://nats-service:4222 orders.new "Order #12345 created"

# Clean up test pods manually if needed
kubectl delete pod nats-pub-orders -n nats-demo

# Monitor server stats
curl http://$NATS_LB:8222/varz | jq .
curl http://$NATS_LB:8222/connz | jq .
```

## Troubleshooting

```bash
# Check pod status and logs
kubectl get pods -n nats-demo
kubectl logs -n nats-demo -l app=nats

# Verify service and endpoints
kubectl get service,endpoints -n nats-demo

# Test connection from within cluster
kubectl run test-connection \
  --image=busybox \
  --namespace=nats-demo \
  --restart=Never \
  --rm -i --tty \
  -- telnet nats-service 4222
```

**Common Issues:**
- LoadBalancer pending: Check AWS Load Balancer Controller and IAM permissions
- Pod not running: Check logs with `kubectl logs -n nats-demo -l app=nats`
- Subscriber appears "stuck": This is normal - it's waiting for messages. Use `Ctrl+C` to exit
- "Unhandled Error" on subscriber termination: Normal kubectl behavior when closing streams

## Cleanup

```bash
# Remove all resources
kubectl delete namespace nats-demo
```

## Production Considerations

- **Clustering**: Configure NATS cluster mode for high availability
- **Persistence**: Enable JetStream for message persistence
- **Authentication**: Add auth tokens or JWT-based security
- **TLS**: Enable TLS for encrypted connections
- **Monitoring**: Integrate with Prometheus for metrics
- **Service Type**: Use `ClusterIP` with Ingress for internal services

## Resources

- **NATS Documentation**: https://docs.nats.io/
- **Client Libraries**: Go, Python, Node.js, Java, C#, Rust - https://github.com/nats-io
- **CleanStart Website**: https://www.cleanstart.com
- **Sample Project**: See `../sample-project` for Docker examples

