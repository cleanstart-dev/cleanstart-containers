# 🔐 Cosign - Kubernetes AWS Deployment

Kubernetes deployment for CleanStart Cosign container on AWS EKS for container image signing and verification.

## 📁 Files

- `namespace.yaml` - Creates the cosign-sample namespace
- `deployment.yaml` - Deploys a persistent Cosign pod
- `job.yaml` - Runs a one-time Cosign demo job
- `README.md` - This documentation

## 🚀 Quick Deploy

### Option 1: Run Demo Job (Recommended)

```bash
kubectl apply -f namespace.yaml
kubectl apply -f job.yaml

# View logs
kubectl logs -n cosign-sample -l app=cosign-demo
```

### Option 2: Deploy Persistent Pod

```bash
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml

# Check status
kubectl get pods -n cosign-sample
```

---

## 🧪 Basic Usage

### Get Pod Name
```bash
export POD_NAME=$(kubectl get pods -n cosign-sample -l app=cosign -o jsonpath='{.items[0].metadata.name}')
```

### 1. Check Version
```bash
kubectl exec -n cosign-sample $POD_NAME -- cosign version
```

### 2. Generate Key Pair
```bash
kubectl exec -n cosign-sample $POD_NAME -- sh -c "echo -e '\n\n' | cosign generate-key-pair"

# Verify keys created
kubectl exec -n cosign-sample $POD_NAME -- ls -la /keys/
```

**Generated:**
- `cosign.key` - 🔒 Private signing key (keep secure!)
- `cosign.pub` - ✅ Public verification key (safe to share)

### 3. Check Image Signature
```bash
# Check if image is signed
kubectl exec -n cosign-sample $POD_NAME -- cosign tree cleanstart/cosign:latest-dev

# Find signature location
kubectl exec -n cosign-sample $POD_NAME -- cosign triangulate cleanstart/cosign:latest-dev
```

### 4. Interactive Shell
```bash
kubectl exec -it -n cosign-sample $POD_NAME -- sh
```

---

## 🔐 Signing & Verifying Images in AWS ECR

**Important:** Images must be in a registry (AWS ECR, Docker Hub, etc.). Local images cannot be signed.

### Setup AWS ECR

```bash
# Set variables
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
export AWS_REGION="us-east-1"
export IMAGE_NAME="test-image"

# Create ECR repository
aws ecr create-repository --repository-name $IMAGE_NAME --region $AWS_REGION

# Login to ECR
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Push test image
docker pull nginx:alpine
docker tag nginx:alpine $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:v1
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:v1
```

### Sign an Image

```bash
export IMAGE_URI="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_NAME:v1"

# Sign the image
kubectl exec -n cosign-sample $POD_NAME -- sh -c \
  "echo '' | cosign sign --key /keys/cosign.key $IMAGE_URI"
```

### Verify an Image

```bash
# Verify signature
kubectl exec -n cosign-sample $POD_NAME -- \
  cosign verify --key /keys/cosign.pub $IMAGE_URI

# Check signature tree
kubectl exec -n cosign-sample $POD_NAME -- cosign tree $IMAGE_URI
```

---

## 📋 Quick Command Reference

```bash
# Version
kubectl exec -n cosign-sample $POD_NAME -- cosign version

# Generate keys
kubectl exec -n cosign-sample $POD_NAME -- sh -c "echo -e '\n\n' | cosign generate-key-pair"

# Check if signed
kubectl exec -n cosign-sample $POD_NAME -- cosign tree <image:tag>

# Sign image
kubectl exec -n cosign-sample $POD_NAME -- sh -c \
  "echo '' | cosign sign --key /keys/cosign.key <image:tag>"

# Verify signature
kubectl exec -n cosign-sample $POD_NAME -- \
  cosign verify --key /keys/cosign.pub <image:tag>
```

---

## 🔍 Troubleshooting

### Pod Not Starting
```bash
kubectl describe pod -n cosign-sample -l app=cosign
kubectl logs -n cosign-sample -l app=cosign
```

### Job Failing
```bash
kubectl describe job -n cosign-sample cosign-demo
kubectl logs -n cosign-sample -l app=cosign-demo
```

### Key Generation Issues
```bash
# Delete existing keys
kubectl exec -n cosign-sample $POD_NAME -- rm -f /keys/cosign.key /keys/cosign.pub

# Regenerate
kubectl exec -n cosign-sample $POD_NAME -- sh -c \
  "cd /keys && echo -e '\n\n' | cosign generate-key-pair"
```

### Cannot Sign Images
- Ensure image is in a registry (not local)
- Authenticate to registry first
- Verify network connectivity from pod

---

---

## 🧹 Cleanup

```bash
# Delete all resources
kubectl delete -f job.yaml
kubectl delete -f deployment.yaml
kubectl delete -f namespace.yaml

# Or delete namespace (removes everything)
kubectl delete namespace cosign-sample

# Clean up ECR (if created)
aws ecr delete-repository --repository-name $IMAGE_NAME --force --region $AWS_REGION
```

---

## 🎯 Use Cases

- **Supply Chain Security** - Sign all container images before deployment
- **Image Verification** - Verify signatures in CI/CD pipelines
- **Compliance** - Meet security requirements for signed artifacts
- **Policy Enforcement** - Use with Kyverno/OPA to enforce signature policies

---

## 📝 Important Notes

- ⚠️ Images must be in a registry (not local-only)
- 🔒 Keep `cosign.key` secure - never commit to git
- ✅ Share `cosign.pub` - safe to distribute
- 📦 Signatures are stored in the OCI registry

---

**Image:** `cleanstart/cosign:latest-dev`  
**Cosign Version:** v2.6.0  
**Platform:** Kubernetes on AWS EKS
