#!/bin/bash
 
# Define the list of Docker images to scan
# Add all images you want to scan and compare
IMAGES=(
    "nginx:latest"
    "cleanstart/nginx:latest"
    "cleanstart/argocd-extension-installer:latest"
    "cleanstart/argo-workflow-exec:latest"
    "cleanstart/aws-cli:latest"
    "cleanstart/busybox:latest"
    "cleanstart/cadvisor:latest"
    "cleanstart/cert-manager-acmesolver:latest"
    "cleanstart/cert-manager-cainjector:latest"
    "cleanstart/cert-manager-controller:latest"
    "cleanstart/cert-manager-startupapicheck:latest"
    "cleanstart/cert-manager-webhook:latest"
    "cleanstart/cloudnative-pg:latest"
    "cleanstart/cortex:latest"
    "cleanstart/cosign:latest"
    "cleanstart/curl:latest"
    "cleanstart/external-secrets:latest"    
    "cleanstart/glibc:latest"   
    "cleanstart/go:latest"
    "cleanstart/helm:latest"
    "cleanstart/helm-operator:latest"
    "cleanstart/jdk:latest"
    "cleanstart/jre:latest"
    "cleanstart/kube-proxy:latest"
    "cleanstart/kube-vip:latest"
    "cleanstart/kyverno-background-controller:latest"
    "cleanstart/kyverno-kyvernopre:latest"
    "cleanstart/logstash-exporter:latest"
    "cleanstart/memcached:latest"
    "cleanstart/metallb-controller:latest"
    "cleanstart/metallb-speaker:latest"
    "cleanstart/minio:latest"
    "cleanstart/minio-operator-sidecar:latest"
    "cleanstart/nats:latest"
    "cleanstart/openldap:latest"
    "cleanstart/pgbouncer:latest"
    "cleanstart/postgres:latest"
    "cleanstart/python:latest"
    "cleanstart/redis-exporter:latest"  
    "cleanstart/sqlite3:latest"
    "cleanstart/stakater-reloader:latest"
    "cleanstart/step-cli:latest"
    "cleanstart/step-issuer:latest"
    "cleanstart/stunnel:latest"
    "cleanstart/thanos:latest"  
    "cleanstart/tigera-operator:latest"
    "cleanstart/trust-manager:latest"
    "cleanstart/vault-k8s:latest"
    "cleanstart/velero-plugin-for-aws:latest"
    "cleanstart/velero-plugin-for-csi:latest"
    "cleanstart/wave:latest"

    "argocd-extension-installer:latest"
    "argo-workflow-exec:latest"
    "aws-cli:latest"
    "busybox:latest"
    "cadvisor:latest"
    "cert-manager-acmesolver:latest"
    "cert-manager-cainjector:latest"
    "cert-manager-controller:latest"
    "cert-manager-startupapicheck:latest"
    "cert-manager-webhook:latest"
    "cloudnative-pg:latest"
    "cortex:latest"
    "cosign:latest"
    "curl:latest"
    "external-secrets:latest"    
    "glibc:latest"   
    "go:latest"
    "helm:latest"
    "helm-operator:latest"
    "jdk:latest"
    "jre:latest"
    "kube-proxy:latest"
    "kube-vip:latest"
    "kyverno-background-controller:latest"
    "kyverno-kyvernopre:latest"
    "logstash-exporter:latest"
    "memcached:latest"
    "metallb-controller:latest"
    "metallb-speaker:latest"
    "minio:latest"
    "minio-operator-sidecar:latest"
    "nats:latest"
    "openldap:latest"
    "pgbouncer:latest"
    "postgres:latest"
    "python:latest"
    "redis-exporter:latest"  
    "sqlite3:latest"
    "stakater-reloader:latest"
    "step-cli:latest"
    "step-issuer:latest"
    "stunnel:latest"
    "thanos:latest"  
    "tigera-operator:latest"
    "trust-manager:latest"
    "vault-k8s:latest"
    "velero-plugin-for-aws:latest"
    "velero-plugin-for-csi:latest"
    "wave:latest"
)
 
# Define output directory for scan reports

# Base directory name
BASE_DIR="syft_trivy_scan_reports"

# Create timestamp (e.g., 2025-10-11_14-05-32)
# TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
TIMESTAMP=$(TZ='Asia/Kolkata' date +'%Y-%m-%d_%H-%M-%S_IST')


OUTPUT_DIR="${BASE_DIR}/syft_trivy_scan_reports_${TIMESTAMP}"



# Combine base name with timestamp
# OUTPUT_DIR="${BASE_DIR}_${TIMESTAMP}"

# OUTPUT_DIR="syft_trivy_scan_reports" 
mkdir -p "$OUTPUT_DIR"

# Define log file for console output
 
echo "Starting Trivy scans for specified Docker images..."
 
for IMAGE in "${IMAGES[@]}"; do
    echo "----------------------------------------------------"
    echo "Scanning image: $IMAGE"
   
    SBOM_FILE="$OUTPUT_DIR/$(echo "$IMAGE" | sed 's/[^a-zA-Z0-9_.-]/_/g')_sbom.json"
    # Define the output file for the current image
    REPORT_FILE="$OUTPUT_DIR/$(echo "$IMAGE" | sed 's/[^a-zA-Z0-9_.-]/_/g')_$(date +'%Y-%m-%d').csv"

   
    # Run Syft to generate SBOM
    syft "$IMAGE" -o spdx-json@2.3 > "$SBOM_FILE"
 
    # Run Trivy scan - save only table format (CSV)
    trivy sbom "$SBOM_FILE" --severity HIGH,CRITICAL,MEDIUM,LOW --format table --output "$REPORT_FILE"

    if [ $? -eq 0 ]; then
        echo "Scan of $IMAGE completed successfully. Report saved to $REPORT_FILE"
    else
        echo "Trivy scan of $IMAGE failed or found vulnerabilities. Report saved to $REPORT_FILE"
    fi
done

echo "----------------------------------------------------"
echo "All scans completed!"
echo "----------------------------------------------------"

# ----------------------------
# Create comparison folder
# ----------------------------
COMPARE_DIR="${OUTPUT_DIR}/comparison"
mkdir -p "$COMPARE_DIR"

# ----------------------------
# Ask user for two images to compare
# ----------------------------
echo ""
echo "Now let's create a vulnerability comparison between two images..."
echo "Available scanned images:"
for i in "${!IMAGES[@]}"; do
    echo "  $((i+1)). ${IMAGES[$i]}"
done
echo ""

read -p "Enter first image name (must be from the scanned list above): " IMAGE1
read -p "Enter second image name (must be from the scanned list above): " IMAGE2

# Validate that both images were actually scanned
if [[ ! " ${IMAGES[@]} " =~ " ${IMAGE1} " ]]; then
    echo "❌ Error: $IMAGE1 was not scanned. Please select from the available images above."
    exit 1
fi

if [[ ! " ${IMAGES[@]} " =~ " ${IMAGE2} " ]]; then
    echo "❌ Error: $IMAGE2 was not scanned. Please select from the available images above."
    exit 1
fi

# Generate CSV filename with first image name and date
SAFE_IMAGE1=$(echo "$IMAGE1" | sed 's/[^a-zA-Z0-9_.-]/_/g')
SAFE_IMAGE2=$(echo "$IMAGE2" | sed 's/[^a-zA-Z0-9_.-]/_/g')
CSV_FILE="${COMPARE_DIR}/${SAFE_IMAGE1}_vs_${SAFE_IMAGE2}_$(date +'%Y-%m-%d').csv"

# Get paths to the table report files
REPORT1="$OUTPUT_DIR/${SAFE_IMAGE1}_$(date +'%Y-%m-%d').csv"
REPORT2="$OUTPUT_DIR/${SAFE_IMAGE2}_$(date +'%Y-%m-%d').csv"

# Check if CSV report files exist
if [ ! -f "$REPORT1" ]; then
    echo "❌ Error: Report file for $IMAGE1 not found at $REPORT1"
    echo "Please make sure the image was scanned first."
    exit 1
fi

if [ ! -f "$REPORT2" ]; then
    echo "❌ Error: Report file for $IMAGE2 not found at $REPORT2"
    echo "Please make sure the image was scanned first."
    exit 1
fi

# Create side-by-side comparison
python3 -c "
import sys
import os

def read_file_lines(filepath):
    try:
        with open(filepath, 'r') as f:
            return f.readlines()
    except:
        return ['Report not found\n']

def format_line(line, width=80):
    return line.rstrip().ljust(width)

# Read both reports
lines1 = read_file_lines('$REPORT1')
lines2 = read_file_lines('$REPORT2')

# Create comparison header
output = []
output.append('=' * 160)
output.append('                    VULNERABILITY COMPARISON REPORT'.center(160))
output.append('=' * 160)
output.append('')
output.append('Image 1: $IMAGE1'.ljust(80) + 'Image 2: $IMAGE2')
output.append('Generated: $(date +\"%Y-%m-%d %H:%M:%S\")'.ljust(80) + '')
output.append('')
output.append('-' * 80 + '|' + '-' * 79)

# Get max lines
max_lines = max(len(lines1), len(lines2))

# Create side-by-side layout
for i in range(max_lines):
    line1 = lines1[i] if i < len(lines1) else ''
    line2 = lines2[i] if i < len(lines2) else ''
    
    # Format lines for side-by-side display
    formatted_line1 = format_line(line1.rstrip())
    formatted_line2 = format_line(line2.rstrip())
    
    output.append(formatted_line1 + '|' + formatted_line2)

output.append('=' * 160)

# Write to comparison file
with open('$CSV_FILE', 'w') as f:
    f.write('\n'.join(output))
"

echo ""
echo "✅ Comparison report created successfully!"
echo "📁 Location: $CSV_FILE"
echo ""
echo "The comparison report contains both vulnerability reports in the same format,"
echo "showing Image 1 and Image 2 vulnerabilities sequentially for easy comparison."
echo ""


