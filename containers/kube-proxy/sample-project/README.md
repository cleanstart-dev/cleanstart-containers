# 🔌 Kube-Proxy Sample Project

A simple project to test the CleanStart kube-proxy container image.

## 📦 Image Details

- **Image**: `cleanstart/kube-proxy:latest-dev`
- **Entrypoint**: `/usr/bin/kube-proxy`
- **Size**: ~464 MB
- **Architecture**: amd64
- **Version**: Kubernetes v1.34.0

## 🚀 Quick Tests

### Check Version
```bash
docker run --rm cleanstart/kube-proxy:latest-dev --version
```

**Expected output:**
```
Kubernetes v1.34.0
```

### Display Help
```bash
docker run --rm cleanstart/kube-proxy:latest-dev --help
```

### Inspect Image
```bash
docker inspect cleanstart/kube-proxy:latest-dev
```

### Run with Sample Config
```bash
docker run --rm \
  -v $(pwd)/kubeconfig.yaml:/etc/kubernetes/kubeconfig.yaml \
  cleanstart/kube-proxy:latest-dev \
  --kubeconfig=/etc/kubernetes/kubeconfig.yaml \
  --v=2
```

## 📁 Files

- `README.md` - This documentation
- `kubeconfig.yaml` - Sample Kubernetes configuration for testing
- `Dockerfile` - Example of extending the base image (optional)

## 🔍 Common Commands

### Check Proxy Mode Options
```bash
docker run --rm cleanstart/kube-proxy:latest-dev --help | grep proxy-mode
```

### Verify SSL Certificates
```bash
docker inspect cleanstart/kube-proxy:latest-dev --format='{{range .Config.Env}}{{println .}}{{end}}' | grep SSL
```

### Run with Verbose Logging
```bash
docker run --rm cleanstart/kube-proxy:latest-dev --v=4 --help
```

## 📝 Notes

- This is a development image (`:latest-dev` tag)
- Kube-proxy requires a Kubernetes cluster to be fully functional
- The sample kubeconfig is for testing only - not for production use
- For production deployment, use the manifests in `../kubernetes - AWS/`

## ⚙️ Image Configuration

**Environment Variables:**
- `PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin`
- `SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt`

**Entrypoint:**
- `/usr/bin/kube-proxy`

**Required Capabilities (for actual proxy operation):**
- `NET_ADMIN` - For network configuration
- `SYS_MODULE` - For loading kernel modules (IPVS mode)
