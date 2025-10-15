# 📨 CleanStart Container for NATS

High-performance, lightweight NATS messaging server optimized for cloud-native applications, microservices, and IoT. Features security-hardened base image with minimal attack surface.

## 🌟 Overview

**Key Features:**
- Complete NATS messaging server with monitoring capabilities
- Support for pub/sub, request-reply, and queue groups
- Built-in HTTP monitoring endpoints
- Minimal resource footprint with high throughput

**Common Use Cases:**
- Microservices communication and service mesh
- Event-driven architectures and real-time messaging
- IoT device communication and distributed system coordination

## 🚀 Quick Start

### Link to DockerHub

https://hub.docker.com/r/cleanstart/nats

### Pull Commands

Download the container images:

```bash
docker pull cleanstart/nats:latest
docker pull cleanstart/nats:latest-dev
```

### Interactive Development

Start interactive session for development:

```bash
docker run --rm -it --entrypoint /bin/sh cleanstart/nats:latest-dev
```

### Container Start

Start the NATS server with proper configuration:

```bash
docker run -d \
  --name nats-server \
  -p 4222:4222 \
  -p 8222:8222 \
  cleanstart/nats:latest
```

### Access URLs

* **NATS Client Port**: `nats://localhost:4222` - For client connections
* **HTTP Monitoring**: `http://localhost:8222` - Server monitoring and stats
* **Server Info**: `http://localhost:8222/varz` - Detailed server information

### Container Management

```bash
# Check container status
docker ps | grep nats

# View logs
docker logs nats-server

# Follow logs in real-time
docker logs -f nats-server

# Stop container
docker stop nats-server

# Remove container
docker rm nats-server
```

## 📊 Monitoring Endpoints

Access these URLs to monitor your NATS server:

| Endpoint | Description |
|----------|-------------|
| `/varz` | General server information, version, uptime |
| `/connz` | Detailed connection information |
| `/routez` | Routing and cluster information |
| `/subsz` | Subscription information |
| `/healthz` | Health check endpoint |

Example:
```bash
curl http://localhost:8222/varz
curl http://localhost:8222/connz
```

## 🎯 Best Practices

* Use specific image tags for production (avoid `:latest`)
* Configure resource limits: memory and CPU constraints
* Enable monitoring endpoint for production deployments
* Use persistent storage for JetStream (if enabled)
* Implement proper security with authentication tokens
* Monitor server metrics regularly via HTTP endpoints

## 🌐 Client Libraries

NATS has official client libraries for many languages:

- **Go**: https://github.com/nats-io/nats.go
- **Python**: https://github.com/nats-io/nats.py
- **Node.js**: https://github.com/nats-io/nats.js
- **Java**: https://github.com/nats-io/nats.java
- **C**: https://github.com/nats-io/nats.c
- **Rust**: https://github.com/nats-io/nats.rs
- **C#**: https://github.com/nats-io/nats.net

## 💻 Architecture Support

### Multi-Platform Images

```bash
docker pull --platform linux/amd64 cleanstart/nats:latest
docker pull --platform linux/arm64 cleanstart/nats:latest
```

## 📚 Resources & Documentation

### Essential Links

* **CleanStart Website**: https://www.cleanstart.com
* **NATS Official**: https://nats.io/
* **NATS Documentation**: https://docs.nats.io/
* **NATS GitHub**: https://github.com/nats-io

### Sample Project

Check out the `sample-project` directory for a complete working example with:
- Docker Compose configuration
- Test scripts for Linux/Mac and Windows
- Comprehensive README with examples
- Pub/Sub demonstration

## 🔗 Related Containers

- **NATS Streaming**: For persistent streaming
- **NATS JetStream**: For advanced streaming features
- **NATS Surveyor**: For monitoring and observability

---

**Need help?** Visit https://www.cleanstart.com for support and documentation.

