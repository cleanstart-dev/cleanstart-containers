# Syft & Trivy Vulnerability Scanner

A comprehensive bash script for scanning Docker images for vulnerabilities using Syft and Trivy, with side-by-side comparison capabilities.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Output Structure](#output-structure)
- [Comparison Reports](#comparison-reports)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)

## 🔍 Overview

This tool automates the process of:
1. Generating Software Bill of Materials (SBOM) for Docker images using Syft
2. Scanning SBOMs for vulnerabilities using Trivy
3. Creating timestamped vulnerability reports
4. Comparing vulnerabilities between two Docker images side-by-side

## ⚙️ Prerequisites

Before running the script, ensure you have the following tools installed:

### Required Tools

1. **Syft** - SBOM generation tool
   ```bash
   # Installation on Linux
   curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin
   
   # Verify installation
   syft version
   ```

2. **Trivy** - Vulnerability scanner
   ```bash
   # Installation on Linux
   wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
   echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
   sudo apt-get update
   sudo apt-get install trivy
   
   # Verify installation
   trivy --version
   ```

3. **Python 3** - For comparison report generation
   ```bash
   # Verify installation
   python3 --version
   ```

4. **Docker** - To pull and manage Docker images
   ```bash
   # Verify installation
   docker --version
   ```

## ✨ Features

- **Automated SBOM Generation**: Creates SPDX 2.3 format SBOMs for each Docker image
- **Multi-Severity Scanning**: Scans for LOW, MEDIUM, HIGH, and CRITICAL vulnerabilities
- **Timestamped Reports**: All reports include IST timezone timestamps
- **Batch Processing**: Scan multiple Docker images in a single run
- **Side-by-Side Comparison**: Compare vulnerabilities between any two scanned images
- **Organized Output**: Auto-creates timestamped directories for easy report management
- **CSV Format**: Reports in table/CSV format for easy analysis

## 📥 Installation

1. Clone or download the script:
   ```bash
   cd syft_trivy_scan
   chmod +x syft_trivy_scan_reports.sh
   ```

2. Ensure all prerequisites are installed (see [Prerequisites](#prerequisites))

## 🚀 Usage

### Basic Usage

```bash
./syft_trivy_scan_reports.sh
```

### Step-by-Step Execution

1. **Run the script**:
   ```bash
   ./syft_trivy_scan_reports.sh
   ```

2. **Wait for scans to complete**:
   - The script will scan each image defined in the IMAGES array
   - Progress messages will display for each image
   - SBOM and vulnerability reports will be generated

3. **Select images for comparison**:
   - After all scans complete, you'll see a list of scanned images
   - Enter the first image name (e.g., `nginx:latest`)
   - Enter the second image name (e.g., `cleanstart/nginx:latest`)

4. **View results**:
   - Check the timestamped output directory for all reports
   - View the comparison report in the `comparison` subdirectory

## ⚙️ Configuration

### Adding Images to Scan

Edit the `IMAGES` array in the script to add or remove images:

```bash
IMAGES=(
    "nginx:latest"
    "cleanstart/nginx:latest"
    "cleanstart/postgres:latest"
    # Add more images here
)
```

### Modifying Vulnerability Severity Levels

To change which severity levels are scanned, edit line 96:

```bash
trivy sbom "$SBOM_FILE" --severity HIGH,CRITICAL,MEDIUM,LOW --format table --output "$REPORT_FILE"
```

Options: `LOW`, `MEDIUM`, `HIGH`, `CRITICAL`, `UNKNOWN`

### Changing Timezone

The script uses IST (Asia/Kolkata) timezone. To change it, modify line 66:

```bash
TIMESTAMP=$(TZ='Asia/Kolkata' date +'%Y-%m-%d_%H-%M-%S_IST')
```

Replace `'Asia/Kolkata'` with your timezone (e.g., `'UTC'`, `'America/New_York'`)

## 📂 Output Structure

```
syft_trivy_scan/
├── syft_trivy_scan_reports.sh
└── syft_trivy_scan_reports/
    └── syft_trivy_scan_reports_2025-10-13_16-29-26_IST/
        ├── nginx_latest_sbom.json
        ├── nginx_latest_2025-10-13.csv
        ├── cleanstart_nginx_latest_sbom.json
        ├── cleanstart_nginx_latest_2025-10-13.csv
        └── comparison/
            └── nginx_latest_vs_cleanstart_nginx_latest_2025-10-13.csv
```

### Output Files

1. **SBOM Files** (`*_sbom.json`):
   - Software Bill of Materials in SPDX 2.3 JSON format
   - Contains package inventory and metadata

2. **Vulnerability Reports** (`*_YYYY-MM-DD.csv`):
   - Table/CSV format vulnerability scan results
   - Includes vulnerability details, severity, and affected packages

3. **Comparison Reports** (`comparison/*_vs_*_YYYY-MM-DD.csv`):
   - Side-by-side comparison of two image vulnerabilities
   - 160-character wide format for easy reading

## 📊 Comparison Reports

The comparison feature creates a side-by-side view of vulnerabilities for two images:

### Format

```
================================================================================
                    VULNERABILITY COMPARISON REPORT
================================================================================

Image 1: nginx:latest                    Image 2: cleanstart/nginx:latest
Generated: 2025-10-13 16:29:26

--------------------------------------------------------------------------------
[Image 1 Vulnerabilities]                [Image 2 Vulnerabilities]
...                                       ...
================================================================================
```

### Benefits

- **Easy Identification**: Quickly spot differences in vulnerabilities
- **Security Comparison**: Compare original vs. hardened images
- **Compliance Reporting**: Document security improvements

## 📝 Examples

### Example 1: Scan Official vs Cleanstart Images

```bash
# Edit the script to include both versions
IMAGES=(
    "postgres:latest"
    "cleanstart/postgres:latest"
)

# Run the script
./syft_trivy_scan_reports.sh

# When prompted for comparison:
# First image: postgres:latest
# Second image: cleanstart/postgres:latest
```

### Example 2: Scan Multiple Images

```bash
IMAGES=(
    "nginx:latest"
    "cleanstart/nginx:latest"
    "redis:latest"
    "cleanstart/redis:latest"
)

./syft_trivy_scan_reports.sh
```

### Example 3: Focus on Critical Vulnerabilities Only

Edit the Trivy scan command (line 96):
```bash
trivy sbom "$SBOM_FILE" --severity CRITICAL,HIGH --format table --output "$REPORT_FILE"
```

## 🔧 Troubleshooting

### Common Issues

1. **"Command not found: syft"**
   - Install Syft using the installation command in [Prerequisites](#prerequisites)

2. **"Command not found: trivy"**
   - Install Trivy using the installation command in [Prerequisites](#prerequisites)

3. **"Error: Report file not found"**
   - Ensure the image was successfully scanned
   - Check the output directory for the report files
   - Verify the image name matches exactly

4. **"Permission denied"**
   ```bash
   chmod +x syft_trivy_scan_reports.sh
   ```

5. **Docker Image Pull Failures**
   ```bash
   # Manually pull the image first
   docker pull <image-name>
   ```

6. **Python Script Errors**
   - Ensure Python 3 is installed: `python3 --version`
   - Check file permissions on output directory

### Debugging

Enable verbose mode by adding to the top of the script:
```bash
set -x  # Enable debug mode
```

View detailed Trivy output:
```bash
trivy sbom "$SBOM_FILE" --severity HIGH,CRITICAL,MEDIUM,LOW --format table --output "$REPORT_FILE" --debug
```

## 📌 Notes

- Reports are timestamped with IST timezone by default
- Image names with special characters are sanitized for filenames
- The script validates that selected images were actually scanned before comparison
- All output directories are created automatically
- Existing reports are not overwritten due to timestamp naming

## 🔐 Security Best Practices

1. **Regular Scanning**: Run scans regularly to catch new vulnerabilities
2. **Version Pinning**: Use specific image tags instead of `latest` in production
3. **Baseline Comparison**: Compare against known-good baselines
4. **Track Trends**: Keep historical reports to track vulnerability trends
5. **Automate**: Integrate into CI/CD pipelines for continuous scanning

## 📄 License

This script is part of the Harbor Pipeline project. See the LICENSE file in the root directory.

## 🤝 Contributing

To add new features or improve the script:
1. Test changes thoroughly with various Docker images
2. Ensure backward compatibility
3. Update this README with new features or changes
4. Document any new configuration options

---

**Last Updated**: October 2025

