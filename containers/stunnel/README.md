# Stunnel Container

## Overview

Stunnel is a proxy that adds TLS/SSL encryption to existing TCP connections without modifying application code. This container provides a production-ready stunnel image based on CleanStart base images.

## What is Stunnel?

Stunnel uses the OpenSSL library to wrap existing TCP connections with SSL/TLS encryption. It can act as either an SSL server (accepting encrypted connections) or an SSL client (creating encrypted connections).

## Use Cases

- Add SSL/TLS encryption to legacy applications
- Secure database connections (Redis, PostgreSQL, MySQL)
- Encrypt network services that don't natively support SSL
- Create secure tunnels between services

## Image Details

- **Base Image**: CleanStart base image
- **Image Name**: `cleanstart/stunnel:latest-dev`
- **Key Components**: Stunnel, OpenSSL library

## Directory Structure

```
stunnel/
├── kubernetes - AWS/       # Kubernetes deployment manifests for AWS EKS
├── sample-project/         # Docker-based sample project with Redis example
└── README.md              # This file
```

## Quick Links

- **[Sample Project](sample-project/)** - Docker-based examples with configuration files
- **[Kubernetes Deployment](kubernetes%20-%20AWS/)** - Deploy stunnel on AWS EKS with Redis example

## Basic Concepts

**Server Mode**: Accepts SSL/TLS encrypted connections and forwards decrypted traffic to backend service  
**Client Mode**: Accepts plain connections and forwards encrypted traffic to SSL/TLS server

## Documentation

For detailed deployment instructions and examples, refer to:
- [Sample Project README](sample-project/README.md) - Docker-based setup
- [Kubernetes README](kubernetes%20-%20AWS/README.md) - Kubernetes deployment

## Requirements

- SSL/TLS certificates (self-signed or CA-signed)
- Configuration file defining connection endpoints
- Backend service to encrypt/decrypt traffic for

