# Helm on AWS EKS - Simple Deployment

This is a simple Kubernetes deployment to test the `cleanstart/helm:latest-dev` image on Amazon EKS.

## Overview

This deployment demonstrates running Helm operations as Kubernetes Jobs in your EKS cluster.

- **Image**: `cleanstart/helm:latest-dev`
- **Namespace**: `helm-test`
- **Resources**: Job for one-time Helm operations

## Prerequisites

- Amazon EKS cluster running
- `kubectl` configured to access your EKS cluster
- Basic familiarity with Kubernetes

## Deployment Steps

### Step 1: Create the Namespace

```bash
kubectl apply -f namespace.yaml
```

Verify the namespace:
```bash
kubectl get namespace helm-test
```

### Step 2: Deploy the Helm Version Check Job

```bash
kubectl apply -f job.yaml
```

### Step 3: Check Job Status

View the job:
```bash
kubectl get jobs -n helm-test
```

View the pod:
```bash
kubectl get pods -n helm-test
```

### Step 4: View Job Logs

```bash
kubectl logs -n helm-test -l job-name=helm-version-check
```

**Expected output:**
```
version.BuildInfo{Version:"v3.x.x", GitCommit:"...", GitTreeState:"clean", GoVersion:"go1.x.x"}
```

## Testing Different Helm Commands

### Test 1: Search for Charts

Update the job to search for charts:

```yaml
args:
  - "search"
  - "hub"
  - "nginx"
```

Apply and check logs:
```bash
kubectl delete job helm-version-check -n helm-test
kubectl apply -f job.yaml
kubectl logs -n helm-test -l job-name=helm-version-check
```

### Test 2: List Helm Help

Update the job to display help:

```yaml
args:
  - "--help"
```

### Test 3: Add a Repository

Update the job to add a repository:

```yaml
args:
  - "repo"
  - "add"
  - "bitnami"
  - "https://charts.bitnami.com/bitnami"
```

## Working with Charts

### Create a Simple Deployment Job

Create a file `helm-deploy.yaml`:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: helm-create-chart
  namespace: helm-test
spec:
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: helm
        image: cleanstart/helm:latest-dev
        command: ["helm"]
        args:
          - "create"
          - "/tmp/my-app"
        volumeMounts:
        - name: workspace
          mountPath: /tmp
        securityContext:
          runAsUser: 1000
          runAsNonRoot: true
          allowPrivilegeEscalation: false
      volumes:
      - name: workspace
        emptyDir: {}
```

Apply and verify:
```bash
kubectl apply -f helm-deploy.yaml
kubectl logs -n helm-test job/helm-create-chart
```

## Viewing Resources

### List all resources in namespace

```bash
kubectl get all -n helm-test
```

### Describe the job

```bash
kubectl describe job helm-version-check -n helm-test
```

### Get pod details

```bash
kubectl get pods -n helm-test -o wide
```

## Cleanup

### Delete the job

```bash
kubectl delete job helm-version-check -n helm-test
```

### Delete the namespace (removes everything)

```bash
kubectl delete namespace helm-test
```

Or delete all resources:
```bash
kubectl delete -f job.yaml
kubectl delete -f namespace.yaml
```

## Troubleshooting

### Job Not Starting

Check pod events:
```bash
kubectl describe pod -n helm-test -l job-name=helm-version-check
```

### Pod Fails

View pod logs:
```bash
kubectl logs -n helm-test -l job-name=helm-version-check --previous
```

### Image Pull Issues

Check image pull status:
```bash
kubectl get pods -n helm-test
kubectl describe pod -n helm-test <pod-name>
```

## Next Steps

Once the basic job is working, you can:
- Create jobs to deploy Helm charts
- Set up CronJobs for scheduled operations
- Add RBAC permissions for chart deployments
- Mount custom charts or values files

## Resources

- [Amazon EKS Documentation](https://docs.aws.amazon.com/eks/)
- [Kubernetes Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)
- [Helm Documentation](https://helm.sh/docs/)

## Summary

You have successfully deployed and tested the `cleanstart/helm:latest-dev` image on EKS by:
- ✅ Creating a namespace
- ✅ Running a Helm job
- ✅ Viewing job logs
- ✅ Verifying Helm version

The image is working correctly in your EKS cluster!
