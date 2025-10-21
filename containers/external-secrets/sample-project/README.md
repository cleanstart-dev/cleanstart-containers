# 🔐 External Secrets - Hello World!!!

A simple project to test CleanStart External Secrets image.

## Manual Steps

### Step 1: Show Help
Run the external-secrets binary to see available commands:
```bash
docker run --rm cleanstart/external-secrets:latest-dev --help
```

**Expected Output:**
```
For more information visit https://external-secrets.io

Usage:
  external-secrets [flags]
  external-secrets [command]

Available Commands:
  certcontroller Controller to manage certificates for external secrets CRDs
  completion     Generate the autocompletion script
  help           Help about any command
  webhook        Webhook implementation for ExternalSecrets and SecretStores

Flags:
      --concurrent int                              The number of concurrent reconciles (default 1)
      --enable-cluster-external-secret-reconciler   Enable cluster external secret reconciler (default true)
      --enable-cluster-store-reconciler             Enable cluster store reconciler (default true)
      --metrics-addr string                         The address the metric endpoint binds to (default ":8080")
  -h, --help                                        help for external-secrets
      --loglevel string                             loglevel to use (default "info")
  ...
```

### Step 2: Certificate Controller Help
Check the certcontroller command options:
```bash
docker run --rm cleanstart/external-secrets:latest-dev certcontroller --help
```

**Expected Output:**
```
Controller to manage certificates for external secrets CRDs and ValidatingWebhookConfigs

Usage:
  external-secrets certcontroller [flags]

Flags:
  -h, --help   help for certcontroller
  ...
```

### Step 3: Webhook Help
Check the webhook command options:
```bash
docker run --rm cleanstart/external-secrets:latest-dev webhook --help
```

**Expected Output:**
```
Webhook implementation for ExternalSecrets and SecretStores

Usage:
  external-secrets webhook [flags]

Flags:
  -h, --help          help for webhook
      --port int      Webhook server port (default 9443)
  ...
```

### Step 4: Run Controller (Default Mode)
The main mode is the controller. When run without arguments, it shows the help:
```bash
docker run --rm cleanstart/external-secrets:latest-dev
```

This is the mode that would run in Kubernetes to sync secrets.

### Step 5: Build Custom Image (Optional)
If you want to create your own image based on CleanStart:
```bash
docker build -t my-external-secrets .
```

Test your custom image:
```bash
docker run --rm my-external-secrets --help
```

## What is External Secrets?

External Secrets Operator synchronizes secrets from external sources (like AWS Secrets Manager, HashiCorp Vault, Google Cloud Secrets Manager, Azure Key Vault) into Kubernetes.

**This binary** is the operator that runs inside Kubernetes to:
- Watch for ExternalSecret resources
- Fetch secrets from external providers
- Create/update Kubernetes Secrets automatically
- Keep secrets in sync

## Image Details

- **Image:** `cleanstart/external-secrets:latest-dev`
- **Entrypoint:** `/usr/bin/external-secrets`
- **User:** `clnstrt` (non-root)
- **Default Command:** `--help`
- **SSL Certificates:** `/etc/ssl/certs/ca-certificates.crt`

## Available Commands

- **Default (no command)** - Main controller mode that syncs secrets
- **`certcontroller`** - Manage certificates for external secrets CRDs
- **`webhook`** - Webhook server for validation
- **`completion`** - Generate shell autocompletion
- **`help`** - Help about any command

## Testing Success ✅

You've successfully tested the image if:
- ✅ `--help` shows available commands without errors
- ✅ `certcontroller --help` shows certificate controller options
- ✅ `webhook --help` shows webhook options
- ✅ No errors or crashes occur

## 📚 Resources

- [CleanStart Images](https://cleanstart.com/)
- [External Secrets Documentation](https://external-secrets.io/)
- [GitHub Repository](https://github.com/external-secrets/external-secrets)
