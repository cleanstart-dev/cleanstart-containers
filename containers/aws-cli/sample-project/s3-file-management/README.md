# Basic S3 File Management - Sample Project

A beginner-friendly guide to getting started with AWS CLI operations using Docker containers. This project demonstrates basic AWS CLI commands and operations in a secure, containerized environment.


## 🏗️ What This Setup Does

This sample project provides:

- **AWS CLI Container**: A secure, containerized AWS CLI environment
- **Basic Operations**: Common AWS CLI commands and operations
- **Interactive Mode**: Interactive shell for learning and testing
- **Data Persistence**: Shared volumes for data and scripts
- **Security**: Non-root user execution and credential management


## 🚀 Quick Start

### Step 1: Prepare Your Environment

1. **Ensure Docker is running**
   ```bash
   docker --version
   docker-compose --version
   ```

2. **Build and Start the S3 File Management Project**
   ```bash
   docker compose up --build -d
   ```

3. **Stop the Services**
   ```bash
   docker compose down
   ```

## 🔧 Troubleshooting

### AWS CLI awscrt Import Error Fix

If you encounter the error:
```
ImportError: /usr/lib/python3.13/site-packages/_awscrt.abi3.so: undefined symbol: aws_checksums_crc64nvme
```

This project now includes a **custom Dockerfile** that fixes this compatibility issue by:
- Using Ubuntu 22.04 LTS as the base image
- Installing AWS CLI v2 with proper dependencies
- Ensuring all Python packages are compatible

### Test the Fix

Run the test script to verify everything works:
```bash
# On Linux/macOS
./test-fix.sh

# On Windows PowerShell
.\test-fix.ps1
```
