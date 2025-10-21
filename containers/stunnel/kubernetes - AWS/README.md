# Stunnel on Kubernetes (AWS)

This directory contains Kubernetes manifests to deploy Stunnel with Redis on AWS EKS or any Kubernetes cluster.

## Overview

This deployment demonstrates how to use Stunnel to add SSL/TLS encryption to Redis connections in Kubernetes.

**Architecture:**
- **Redis Backend**: Plain Redis instance (no SSL)
- **Stunnel Server**: SSL terminator - accepts encrypted connections and forwards to Redis
- **Stunnel Client**: SSL wrapper - accepts plain connections and encrypts them

## Prerequisites

- Kubernetes cluster (EKS, minikube, kind, etc.)
- `kubectl` configured to access your cluster
- Access to `cleanstart/stunnel:latest-dev` image

## Quick Start

### Step 1: Generate SSL Certificate

First, generate a self-signed certificate for stunnel:

```bash
# Generate self-signed certificate
openssl req -new -x509 -days 365 -nodes \
  -out stunnel-cert.pem \
  -keyout stunnel-key.pem \
  -subj "/C=US/ST=State/L=City/O=Cleanstart/CN=stunnel-server"

# Combine key and cert into single PEM file
cat stunnel-key.pem stunnel-cert.pem > stunnel.pem
```

### Step 2: Create Namespace and Secret

```bash
# Create namespace
kubectl apply -f namespace.yaml

# Create secret with SSL certificate
kubectl create secret generic stunnel-certs \
  --from-file=stunnel.pem=stunnel.pem \
  -n stunnel-demo
```

### Step 3: Deploy Resources

```bash
# Deploy all resources
kubectl apply -f deployment.yaml

# Verify all pods are running
kubectl get pods -n stunnel-demo
```

Expected output:
```
NAME                              READY   STATUS    RESTARTS   AGE
redis-backend-xxxxxxxxxx-xxxxx    1/1     Running   0          1m
stunnel-client-xxxxxxxxxx-xxxxx   1/1     Running   0          1m
stunnel-server-xxxxxxxxxx-xxxxx   1/1     Running   0          1m
```

### Step 4: Test Encrypted Connection

```bash
# Test through stunnel (encrypted connection)
kubectl run stunnel-test \
  --image=redis:7-alpine \
  --namespace=stunnel-demo \
  --restart=Never \
  --rm -i --tty \
  -- redis-cli -h stunnel-client-service -p 6379 PING
```

Expected output: `PONG`

### Step 5: Test Data Operations

```bash
# Set a value
kubectl run data-test \
  --image=redis:7-alpine \
  --namespace=stunnel-demo \
  --restart=Never \
  -- redis-cli -h stunnel-client-service -p 6379 SET mykey "Hello Stunnel on K8s"

# Get the value
kubectl run data-test-2 \
  --image=redis:7-alpine \
  --namespace=stunnel-demo \
  --restart=Never \
  -- redis-cli -h stunnel-client-service -p 6379 GET mykey

# View results
sleep 2
kubectl logs -n stunnel-demo data-test
kubectl logs -n stunnel-demo data-test-2

# Cleanup test pods
kubectl delete pod data-test data-test-2 -n stunnel-demo
```

## Interactive Testing

For interactive Redis CLI:

```bash
kubectl run redis-interactive \
  --image=redis:7-alpine \
  --namespace=stunnel-demo \
  --restart=Never \
  --rm -i --tty \
  -- redis-cli -h stunnel-client-service -p 6379

# Try commands: PING, SET key value, GET key, etc.
```

## View Logs

```bash
# Stunnel server logs
kubectl logs -n stunnel-demo -l app=stunnel-server

# Stunnel client logs
kubectl logs -n stunnel-demo -l app=stunnel-client

# Redis logs
kubectl logs -n stunnel-demo -l app=redis
```

## Troubleshooting

**Check pod status:**
```bash
kubectl get pods -n stunnel-demo
kubectl describe pod -n stunnel-demo <pod-name>
```

**Common issues:**
- Pods not running: Check logs with `kubectl logs -n stunnel-demo <pod-name>`
- Connection refused: Verify all pods are running and services exist
- SSL errors: Check stunnel-server logs for certificate issues

## Cleanup

```bash
# Delete all resources
kubectl delete namespace stunnel-demo
```

## Production Notes

- Replace self-signed certificate with proper CA-signed cert or use cert-manager
- Enable certificate verification (`verify = 2`) in client configuration
- Adjust resource limits based on workload
- Use NetworkPolicies to restrict traffic
- Monitor stunnel logs and connection metrics

