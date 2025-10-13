# CleanStart Container Images - Sample Projects Index

## 📚 Documentation

Each sample project includes comprehensive How-to-Guides:

- **Detailed README** - Complete setup and usage instructions
- **Setup Scripts** - Automated environment setup
- **Docker Compose** - Multi-container orchestration
- **Example Code** - Working code examples
- **Test Scripts** - Validation and testing tools

## 🐳 Available Docker Images

| Sr No | Image Name | Use Case | Dockerfile-Based Projects | Kubernetes-Based Projects | Helm-Based Projects |
|:---:|:---|:---|:---:|:---:|:---:|
| 1 | `argocd-workflow-exec` | Execute ArgoCD Workflows | ✅ | ❌ | ❌ |
| 2 | `argocd-extension-installer` | ArgoCD Extensions & Plugins Installation | ✅ | ✅ | ✅ |
| 3 | `aws-cli` | AWS Command Line Interface | ✅ | ✅ | ❌ |
| 4 | `busybox` | Lightweight Utility | ✅ | ❌ | ❌ |
| 5 | `cadvisor` | Container Resource Monitoring | ✅ | ✅ | ✅ |
| 6 | `cortex` | Scalable Prometheus-Compatible Monitoring | ✅ | ✅ | ✅ |
| 7 | `curl` | Data Transfer | ✅ | ❌ | ❌ |
| 8 | `glibc` | GNU C Library Runtime Support | ✅ | ❌ | ❌ |
| 9 | `go` | Web Applications & Microservices | ✅ | ✅ | ❌ |
| 10 | `jdk` | Java Development Kit | ✅ | ❌ | ❌ |
| 11 | `jre` | Java Runtime | ✅ | ❌ | ❌ |
| 12 | `kyverno-kyvernopre` | Kubernetes Policy Engine | ✅ | ❌ | ✅ |
| 13 | `logstash-exporter` | Elasticsearch Metrics Exporter | ✅ | ❌ | ❌ |
| 14 | `memcached` | In-Memory Caching | ✅ | ❌ | ❌ |
| 15 | `metallb-controller` | Kubernetes Load Balancer | ✅ | ❌ | ✅ |
| 16 | `minio` | Object Storage Server | ✅ | ❌ | ✅ |
| 17 | `minio-operator-sidecar` | MinIO Storage Operator | ✅ | ❌ | ✅ |
| 18 | `nginx` | Web Server & Reverse Proxy | ✅ | ❌ | ❌ |
| 19 | `postgres` | Relational Database | ✅ | ❌ | ❌ |
| 20 | `python` | Data Science & Web Apps | ✅ | ✅ | ✅ |
| 21 | `sqlite3` | Lightweight SQL Database | ✅ | ❌ | ❌ |
| 22 | `step-cli` | PKI & Certificates | ✅ | ❌ | ❌ |

## 🛠️ Development

### Building Images

```bash
# Build a specific container
cd containers/go
docker build -t cleanstart/go:latest .
```

### Running Sample Projects

```bash
# Navigate to any sample project
cd containers/go/sample-project/go-web

# Build and run
docker build -t go-web-app .
docker run -p 8080:8080 go-web-app
```

### Using Docker Compose

```bash
# Navigate to any sample project
cd containers/[container-name]/sample-project

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## 🧪 Testing Your Setup

### Health Checks

```bash
# Check if services are running
docker-compose ps

# Test web endpoints
curl http://localhost:8080/health

# View service logs
docker-compose logs -f [service-name]
```

### Common Test Commands

```bash
# Test Docker installation
docker --version
docker-compose --version

# Test container functionality
docker run --rm cleanstart/[container-name] --version
```

## 🤝 Contributing

We welcome contributions to improve these sample projects! Here's how you can contribute:

1. **Fork** the repository
2. **Create** your feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add some amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

The CleanStart community team will review your changes and once approved, your changes will be merged.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 💬 Support

For questions and support, please open an issue in the GitHub repository.

---

**Happy Containerizing! 🚀**
