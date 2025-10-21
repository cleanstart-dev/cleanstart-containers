🚀 PostgreSQL on AWS EKS with Cleanstart Image

Production-ready PostgreSQL deployment for AWS EKS using cleanstart/postgres:latest.

## ⚠️ Important: Data Persistence

**This deployment uses temporary storage (`emptyDir`)**. Data will be **lost when the pod restarts**.

### To Enable Persistent Storage:

You need the **AWS EBS CSI Driver** installed on your cluster. If you have admin access or your cluster admin has installed it:

1. **Add PVC to deployment.yaml** (after the Secret section, before Deployment):

```yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
  namespace: postgres-sample
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: gp2  # or gp3
  resources:
    requests:
      storage: 1Gi
```

2. **Update the volumes section** in Deployment (lines 61-63):

```yaml
      volumes:
        - name: postgres-storage
          persistentVolumeClaim:
            claimName: postgres-pvc
```

3. **Verify EBS CSI driver is installed**:
```bash
kubectl get pods -n kube-system | grep ebs-csi
kubectl get storageclass  # Should show gp2 or gp3
```

See the **"Enable Persistent Storage"** section at the bottom for detailed instructions.

---

## Prerequisites

- ✅ AWS EKS cluster running
- ✅ `kubectl` configured to connect to your cluster
- ✅ Basic user permissions to create resources

## Quick Start

### Step 1: Deploy PostgreSQL

```bash
kubectl apply -f deployment.yaml
```

Creates: Namespace, Secret (password: postgres_pass), Deployment, Service

### Step 2: Verify Deployment

```bash
kubectl get pods -n postgres-sample -w
```

Wait for pod to show `Running`:
```
NAME                                   READY   STATUS    RESTARTS   AGE
postgres-deployment-xxxxxx-yyyyy       1/1     Running   0          1m
```

Press `Ctrl+C` when running.

### Step 3: Connect to PostgreSQL

```bash
kubectl run -it --rm pg-client \
  --image=postgres:17 \
  -n postgres-sample \
  --restart=Never \
  --env="PGPASSWORD=postgres_pass" -- \
  psql -h postgres-service -U postgres
```

### Step 4: Test Database

```sql
-- Create database and table
CREATE DATABASE sampledb;
\c sampledb;

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    role VARCHAR(50)
);

-- Insert data
INSERT INTO employees (name, role) VALUES 
  ('Alice', 'Engineer'),
  ('Bob', 'Manager');

-- Query data
SELECT * FROM employees;

-- Exit
\q
```

## Troubleshooting

### Pod CrashLoopBackOff or Error

Check logs:
```bash
kubectl logs -n postgres-sample deployment/postgres-deployment
```

Common fixes:
- Redeploy: `kubectl delete -f deployment.yaml && kubectl apply -f deployment.yaml`

### Cannot Connect to Database

Verify service:
```bash
kubectl get svc,endpoints -n postgres-sample
```

Test connectivity:
```bash
kubectl run test --image=busybox -n postgres-sample --rm -it --restart=Never -- nc -zv postgres-service 5432
```

### Image Pull Issues

Check if image is accessible:
```bash
kubectl describe pod -n postgres-sample -l app=cleanstart-postgres
```

Look for ImagePullBackOff errors in Events.

## Useful Commands

```bash
# Check all resources
kubectl get all -n postgres-sample

# Watch pod logs
kubectl logs -n postgres-sample deployment/postgres-deployment -f

# Get shell in pod
kubectl exec -it -n postgres-sample deployment/postgres-deployment -- /bin/sh

# Check PostgreSQL process
kubectl exec -n postgres-sample deployment/postgres-deployment -- ps aux | grep postgres

# Check pod details
kubectl describe pod -n postgres-sample -l app=cleanstart-postgres
```

## Enable Persistent Storage

To enable data persistence across pod restarts, you need AWS EBS CSI Driver installed.

### Step 1: Check if EBS CSI Driver is Installed

```bash
kubectl get pods -n kube-system | grep ebs-csi
kubectl get storageclass
```

**If you see `ebs-csi` pods and `gp2`/`gp3` storage class**, proceed to Step 3.

### Step 2: Install EBS CSI Driver (Admin Only)

If you have admin access or can request it:

```bash
export CLUSTER_NAME=your-cluster-name
export AWS_REGION=your-region
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Create IAM service account
eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster $CLUSTER_NAME \
  --region $AWS_REGION \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --role-name AmazonEKS_EBS_CSI_DriverRole

# Install driver addon
eksctl create addon \
  --name aws-ebs-csi-driver \
  --cluster $CLUSTER_NAME \
  --region $AWS_REGION \
  --service-account-role-arn arn:aws:iam::$AWS_ACCOUNT_ID:role/AmazonEKS_EBS_CSI_DriverRole \
  --force
```

**Verify installation:**
```bash
kubectl get pods -n kube-system | grep ebs-csi
# Should see: ebs-csi-controller and ebs-csi-node pods running
```

### Step 3: Update deployment.yaml

Edit `deployment.yaml` and add the PVC section after the Secret (line 14):

```yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
  namespace: postgres-sample
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: gp2  # Use gp3 for better performance/cost
  resources:
    requests:
      storage: 1Gi
---
```

Then update the volumes section (around line 61):

```yaml
      volumes:
        - name: postgres-storage
          persistentVolumeClaim:
            claimName: postgres-pvc
```

### Step 4: Redeploy

```bash
# Delete current deployment
kubectl delete -f deployment.yaml

# Apply updated deployment
kubectl apply -f deployment.yaml

# Verify PVC is bound
kubectl get pvc -n postgres-sample
# Should show: STATUS = Bound

# Verify pod is running
kubectl get pods -n postgres-sample
```

### Step 5: Test Data Persistence

```bash
# Connect and create data
kubectl run -it --rm pg-client \
  --image=postgres:17 \
  -n postgres-sample \
  --restart=Never \
  --env="PGPASSWORD=postgres_pass" -- \
  psql -h postgres-service -U postgres -c "CREATE DATABASE testdb;"

# Restart the pod
kubectl rollout restart deployment postgres-deployment -n postgres-sample

# Wait for pod to be running
kubectl get pods -n postgres-sample -w

# Verify data still exists
kubectl run -it --rm pg-client \
  --image=postgres:17 \
  -n postgres-sample \
  --restart=Never \
  --env="PGPASSWORD=postgres_pass" -- \
  psql -h postgres-service -U postgres -c "\l" | grep testdb
```

If you see `testdb` in the list, persistence is working! ✅

## Cleanup

```bash
kubectl delete -f deployment.yaml
```

