# External Secrets Operator - Kubernetes Deployment

Simple Kubernetes deployment to test CleanStart External Secrets Operator on AWS/EKS.

## Prerequisites

- Kubernetes cluster (EKS, Minikube, Kind, or any cluster)
- kubectl configured and connected to your cluster

## Manual Deployment Steps

### Step 1: Verify kubectl Connection
```bash
kubectl cluster-info
```

**Expected Output:**
```
Kubernetes control plane is running at https://...
CoreDNS is running at https://...
```

### Step 2: Deploy External Secrets Operator
Apply the deployment manifest:
```bash
kubectl apply -f deployment.yaml
```

**Expected Output:**
```
namespace/external-secrets-test created
serviceaccount/external-secrets created
role.rbac.authorization.k8s.io/external-secrets created
rolebinding.rbac.authorization.k8s.io/external-secrets created
deployment.apps/external-secrets created
service/external-secrets created
```

### Step 3: Check Pod Status
Check pod status:
```bash
kubectl get pods -n external-secrets-test
```

**Expected Output (without CRDs installed):**
```
NAME                                READY   STATUS   RESTARTS   AGE
external-secrets-xxxxxxxxxx-xxxxx   0/1     Error    1-2        30s
```

**⚠️ Note:** The pod will show `Error` status because the operator requires CRDs (CustomResourceDefinitions) to run. This is **expected and normal** for basic testing.

### Step 4: Check Pod Logs
View the operator logs:
```bash
kubectl logs -n external-secrets-test -l app=external-secrets
```

**Expected Output:**
```
{"level":"error","ts":...,"msg":"unable to create controller","controller":"ExternalSecret","error":"no matches for kind \"ExternalSecret\" in version \"external-secrets.io/v1\""}
```

**This error confirms:**
- ✅ The pod started successfully
- ✅ The image is working correctly
- ✅ The operator binary executed properly
- ℹ️ The operator exits because CRDs are not installed (expected behavior)

### Step 5: Verify Service
Check the service:
```bash
kubectl get svc -n external-secrets-test
```

**Expected Output:**
```
NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
external-secrets   ClusterIP   10.100.x.x      <none>        8080/TCP   1m
```

### Step 6: Check All Resources
View all resources in the namespace:
```bash
kubectl get all -n external-secrets-test
```

## What's Deployed

- **Namespace:** `external-secrets-test` - Isolated namespace for testing
- **ServiceAccount:** `external-secrets` - Identity for the operator
- **Role & RoleBinding:** Permissions to manage secrets and configmaps
- **Deployment:** External Secrets Operator with 1 replica
- **Service:** ClusterIP service exposing metrics on port 8080

## Testing Success ✅

The deployment is **successful** if:
- ✅ All 6 resources created without errors
- ✅ Pod starts and shows the CRD error in logs
- ✅ The error message indicates the operator is looking for ExternalSecret CRDs
- ✅ Service is created

**The pod Error status and CRD error in logs are expected - they confirm the image is working!**

## Understanding the Behavior

Without CRDs installed, the operator:
1. Starts up
2. Looks for ExternalSecret CRDs
3. Logs an error: "no matches for kind ExternalSecret"
4. Exits (causing pod to show Error status)
5. Kubernetes restarts the pod (normal behavior)

**This is expected and proves the CleanStart image works correctly!**

For the operator to run continuously, you would need to:
1. Install External Secrets CRDs first
2. Then deploy the operator

But for **basic image testing**, seeing the CRD error confirms everything works!

## Cleanup

Remove all resources:
```bash
kubectl delete namespace external-secrets-test
```

Verify cleanup:
```bash
kubectl get namespace external-secrets-test
```

**Expected:** `Error from server (NotFound): namespaces "external-secrets-test" not found`

## Troubleshooting

### Pod Shows CrashLoopBackOff
If the pod status changes to `CrashLoopBackOff` after multiple restarts, this is expected behavior when CRDs are not installed. The operator will keep restarting and looking for CRDs.

This is **normal** and confirms the image is working as designed.

### Verify Image is Working
```bash
# Check that the container started
kubectl describe pod -n external-secrets-test -l app=external-secrets

# Look for "Started container" in Events section
# This confirms the image runs successfully
```

### Check Logs
```bash
# View logs to confirm the error message
kubectl logs -n external-secrets-test -l app=external-secrets

# Should show the CRD error, confirming the operator executed
```

## Configuration Details

**Image:** `cleanstart/external-secrets:latest-dev`

**Arguments:**
- `--concurrent=1` - Number of concurrent reconciles
- `--loglevel=info` - Log level (debug, info, warn, error)
- `--metrics-addr=:8080` - Metrics endpoint address

**Resources:**
- CPU: 50m request, 100m limit
- Memory: 64Mi request, 128Mi limit

**Security:**
- Runs as non-root user (`clnstrt`)
- No privilege escalation
- All capabilities dropped

## Next Steps (Optional)

To use this operator for real secret management:

### 1. Install External Secrets CRDs
```bash
kubectl apply -f https://raw.githubusercontent.com/external-secrets/external-secrets/main/deploy/crds/bundle.yaml
```

After installing CRDs, the pod will run successfully without errors.

### 2. Create a SecretStore
Example for AWS Secrets Manager, Vault, GCP, etc.

### 3. Create ExternalSecret Resources
Define which secrets to sync from your external provider.

## 📚 Resources

- [External Secrets Documentation](https://external-secrets.io/)
- [Installing CRDs](https://external-secrets.io/latest/introduction/getting-started/)
- [AWS Provider Setup](https://external-secrets.io/latest/provider/aws-secrets-manager/)
- [CleanStart Images](https://cleanstart.com/)
