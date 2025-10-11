# Cosign Container

**Cosign** is a tool from the Sigstore project for signing and verifying container images.

## Image

```
cleanstart/cosign:latest-dev
```

## Quick Commands

```bash
# Check version
docker run --rm cleanstart/cosign:latest-dev version

# Generate keys
docker run --rm -v $(pwd):/workspace -w /workspace \
  cleanstart/cosign:latest-dev generate-key-pair

# Sign image
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/workspace -w /workspace \
  cleanstart/cosign:latest-dev sign --key cosign.key <registry>/<image>:tag

# Verify signature
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/workspace -w /workspace \
  cleanstart/cosign:latest-dev verify --key cosign.pub <registry>/<image>:tag
```


## Important Notes

- ⚠️ Images must be in a registry (not local-only)
- 🔒 Keep `cosign.key` secure - never commit to git
- ✅ Share `cosign.pub` - safe to distribute
- 📝 Login to registry first: `docker login`

Please go through sample-project for more details.
