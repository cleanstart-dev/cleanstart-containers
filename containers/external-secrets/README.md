# 🔐 CleanStart External Secrets Operator

**External Secrets Operator** is a Kubernetes operator that integrates external secret management systems (like AWS Secrets Manager, HashiCorp Vault, Google Secrets Manager, Azure Key Vault) and automatically synchronizes them as Kubernetes Secrets.

## 📦 What's Included

This CleanStart container provides the External Secrets Operator binary for managing secrets in Kubernetes.

## 🖼️ Image Details

**Image:** `cleanstart/external-secrets:latest-dev`

**Key Features:**
- **User:** `clnstrt` (non-root)
- **Entrypoint:** `/usr/bin/external-secrets`
- **Default Command:** `--help`
- **Base:** CleanStart minimal container
- **SSL Certificates:** Pre-configured at `/etc/ssl/certs/ca-certificates.crt`

## 🚀 Quick Start

### Test the Image

```bash
# Show help
docker run --rm cleanstart/external-secrets:latest-dev --help

# Certificate controller help
docker run --rm cleanstart/external-secrets:latest-dev certcontroller --help

# Webhook help
docker run --rm cleanstart/external-secrets:latest-dev webhook --help
```

## 📁 Directory Structure

```
external-secrets/
├── README.md                    # This file
├── kubernetes - AWS/            # Kubernetes manifests for AWS deployment
└── sample-project/              # Simple test project
    ├── README.md               # Manual testing steps
    └── Dockerfile              # Sample Dockerfile
```

## 🔧 Available Commands

- **Default (no command)** - Main controller mode that syncs External Secrets
- **`certcontroller`** - Manage certificates for external secrets CRDs
- **`webhook`** - Webhook server for validation
- **`completion`** - Generate shell autocompletion
- **`help`** - Help about any command

## 🔐 Supported Providers

The External Secrets Operator supports many secret backends:

- AWS Secrets Manager
- AWS Systems Manager Parameter Store
- HashiCorp Vault
- Google Cloud Secrets Manager
- Azure Key Vault
- IBM Cloud Secrets Manager
- And many more!

## 📚 Resources

- **[Sample Project](./sample-project/)** - Simple image test with manual steps
- **[Official Documentation](https://external-secrets.io/)** - External Secrets Operator docs
- **[GitHub Repository](https://github.com/external-secrets/external-secrets)** - Source code
- **[CleanStart Images](https://cleanstart.com/)** - Official CleanStart registry

## 🛡️ Security

This image follows security best practices:

- ✅ Runs as non-root user (`clnstrt`)
- ✅ Minimal attack surface
- ✅ SSL certificates pre-configured
- ✅ No unnecessary tools or packages

## 📄 License

External Secrets Operator is licensed under Apache 2.0.

---

**Need Help?** Check out the [sample-project](./sample-project/) for simple manual tests!
