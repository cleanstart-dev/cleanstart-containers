# Cosign - Tested Working Steps

All steps tested on: October 10, 2025

## ✅ Step 1: Pull the Cosign Image

**Command:**
```bash
docker pull cleanstart/cosign:latest-dev
```

**Status:** ✅ **WORKS**

**Output:** Successfully pulls the cosign image from the registry.

---

## ✅ Step 2: Check Version

**Command:**
```bash
docker run --rm cleanstart/cosign:latest-dev version
```

**Status:** ✅ **WORKS**

**Output:**
```
  ______   ______        _______. __    _______ .__   __.
 /      | /  __  \      /       ||  |  /  _____||  \ |  |
|  ,----'|  |  |  |    |   (----`|  | |  |  __  |   \|   |
|  |     |  |  |  |     \   \    |  | |  | |_ | |  . `  |
|  `----.|  `--'  | .----)   |   |  | |  |__| | |  |\   |
 \______| \______/  |_______/    |__|  \______| |__| \__|
cosign: A tool for Container Signing, Verification and Storage in an OCI registry.

GitVersion:    v2.6.0
GitCommit:     unknown
GitTreeState:  unknown
BuildDate:     unknown
GoVersion:     go1.25.1
Compiler:      gc
Platform:      linux/amd64
```

---

## ✅ Step 3: Generate Key Pair

**Command (Linux/WSL):**
```bash
cd /home/......./containers/cosign/sample-project
```
```bash
echo -e '\n\n' | docker run -i --rm \
  -v /home/......./containers/cosign/sample-project:/workspace \
  -w /workspace \
  cleanstart/cosign:latest-dev generate-key-pair
```

**Command (Simplified):**
```bash
# From the sample-project directory
echo -e '\n\n' | docker run -i --rm -v $(pwd):/workspace -w /workspace \
  cleanstart/cosign:latest-dev generate-key-pair
```

**Status:** ✅ **WORKS**

**Output:** Creates two files:
- `cosign.key` (653 bytes) - Private key
- `cosign.pub` (178 bytes) - Public key

**Note:** The `echo -e '\n\n'` pipes empty passwords to avoid interactive prompts.

**⚠️ If keys already exist:**
If you see "WARNING: File cosign.key already exists. Overwrite?" error, use one of these options:

Option 1 - Delete existing keys first (recommended):
```bash
rm cosign.key cosign.pub
echo -e '\n\n' | docker run -i --rm -v $(pwd):/workspace -w /workspace \
  cleanstart/cosign:latest-dev generate-key-pair
```

Option 2 - Confirm overwrite:
```bash
echo -e 'y\n\n\n' | docker run -i --rm -v $(pwd):/workspace -w /workspace \
  cleanstart/cosign:latest-dev generate-key-pair
```

**Verification:**
```bash
ls -la cosign.*
```

Output:
```
-rw------- 1 komal syslog 653 Oct 10 12:34 cosign.key
-rw-r--r-- 1 komal syslog 178 Oct 10 12:34 cosign.pub
```

---

## ✅ Step 4: Check Image Signature Status

**Command:**
```bash
docker run --rm cleanstart/cosign:latest-dev tree cleanstart/cosign:latest-dev
```

**Status:** ✅ **WORKS**

**Output:**
```
📦 Supply Chain Security Related artifacts for an image: cleanstart/cosign:latest-dev
No Supply Chain Security Related Artifacts found for image cleanstart/cosign:latest-dev,
 start creating one with simply running$ cosign sign <img>
```

**What it does:** Inspects the cosign image itself for signatures and attestations. The output shows the image is not signed (which is expected).

**Additional command:**
```bash
docker run --rm cleanstart/cosign:latest-dev triangulate cleanstart/cosign:latest-dev
```

This command shows where signatures would be stored in the registry if the image were signed.

If returned silently with no output, then image has no signatures

---

## Commands Summary

1. **Pull cosign image:**
   ```bash
   docker pull cleanstart/cosign:latest-dev
   ```

2. **Check version:**
   ```bash
   docker run --rm cleanstart/cosign:latest-dev version
   ```

3. **Generate keys:**
   ```bash
   echo -e '\n\n' | docker run -i --rm -v $(pwd):/workspace -w /workspace \
     cleanstart/cosign:latest-dev generate-key-pair
   ```

4. **Check signature status:**
   ```bash
   docker run --rm cleanstart/cosign:latest-dev tree cleanstart/cosign:latest-dev
   ```

5. **Find signature location:**
   ```bash
   docker run --rm cleanstart/cosign:latest-dev triangulate cleanstart/cosign:latest-dev
   ```

---

## Signing Your Own Images (Optional)

To sign your own images, you need to push them to a registry first:

```bash
# Sign an image in a registry
echo '' | docker run -i --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/workspace -w /workspace \
  cleanstart/cosign:latest-dev sign --key cosign.key your-registry/your-image:tag

# Verify the signature
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/workspace -w /workspace \
  cleanstart/cosign:latest-dev verify --key cosign.pub your-registry/your-image:tag
```

> **Note:** Local-only images cannot be signed. Cosign stores signatures in the registry.

---

After running Step 3, you'll have:

```
sample-project/
├── cosign.key  (653 bytes)  - 🔒 Private signing key (keep secure!)
├── cosign.pub  (178 bytes)  - ✅ Public verification key (safe to share)
└── README.md
```

---

## Troubleshooting Notes

1. **Volume mounting issues on Windows:**
   - Use absolute Linux paths: `/home/...`
   - Or run from WSL: `wsl bash -c "..."`

2. **Interactive password prompts:**
   - Use: `echo -e '\n\n' | docker run -i ...`
   - Or set: `COSIGN_PASSWORD=''` environment variable

3. **Keys already exist (Overwrite prompt):**
   - **Error:** "WARNING: File cosign.key already exists. Overwrite? Error: user declined the prompt"
   - **Solution 1:** Delete existing keys first: `rm cosign.key cosign.pub`
   - **Solution 2:** Send "y" to confirm: `echo -e 'y\n\n\n' | docker run ...`
   - **Explanation:** The `echo -e '\n\n'` sends newlines (interpreted as "N"), which declines the overwrite prompt. Add `y` at the beginning to confirm.

4. **Permission denied on key generation:**
   - Ensure proper volume mount permissions
   - Run from WSL for Linux filesystem

5. **Cannot sign local images:**
   - This is expected behavior
   - Cosign requires images to be in a registry
   - Signatures are stored in the OCI registry

---

## Conclusion

✅ **All commands work perfectly!**
- Image pulling ✅
- Version checking ✅
- Key generation ✅
- Signature inspection ✅

**Note:** Signing and verification require images to be in a registry.