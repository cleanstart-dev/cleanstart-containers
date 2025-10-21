# 📨 NATS Sample Project

A simple **NATS** messaging sample project demonstrating pub/sub operations with CleanStart containers.

## 🌟 Features

- **CleanStart NATS**: Uses `cleanstart/nats:latest-dev` as base image
- **Simple Setup**: Build and run with Docker
- **Message Broker**: Lightweight, high-performance messaging system
- **Pub/Sub Pattern**: Demonstrates publishing and subscribing to topics

## 🚀 Quick Start

### Prerequisites
- Docker installed

### Step 1: Build the Docker Image

```bash
docker build -t my-nats-server .
```

### Step 2: Run the Container

```bash
docker run -d \
  --name nats-server \
  -p 4222:4222 \
  -p 8222:8222 \
  my-nats-server
```

**Port mappings:**
- `4222`: NATS client connections
- `8222`: HTTP monitoring endpoint

### Step 3: Verify It's Running

```bash
# Check container status
docker ps

# Check logs
docker logs nats-server

# Test monitoring endpoint
curl http://localhost:8222/varz
```

### Step 4: Test NATS Server

**Check server status:**
```bash
# View server info
curl http://localhost:8222/varz

# Check connections
curl http://localhost:8222/connz

# View in browser
# Open http://localhost:8222 in your browser
```

**To test pub/sub messaging:**

Connect using any NATS client library:
- **Connection URL**: `nats://localhost:4222`
- **Languages**: Go, Python, Node.js, Java, Rust, C#, etc.
- **Docs**: https://docs.nats.io/using-nats/developer

### Step 5: Clean Up

```bash
docker stop nats-server
docker rm nats-server

# Optional: Remove the built image
docker rmi my-nats-server
```

## 📁 Project Structure

```
sample-project/
├── Dockerfile          # Docker build configuration
└── README.md          # This file
```

## 🔍 Monitoring Endpoints

| Endpoint | Description |
|----------|-------------|
| `http://localhost:8222/varz` | General server information |
| `http://localhost:8222/connz` | Connection information |
| `http://localhost:8222/subsz` | Subscription information |

## 🔧 Troubleshooting

**Check logs:**
```bash
docker logs nats-server
```

**Port already in use:**
```bash
# Use different ports
docker run -d --name nats-server -p 4223:4222 -p 8223:8222 my-nats-server
```

**Interactive shell:**
```bash
docker exec -it nats-server sh
```

## 📚 NATS Concepts

**Subjects (Topics):** Hierarchical strings separated by dots
- Example: `orders.new`, `time.us.east`

**Wildcards:**
- `*` matches single token: `time.*.east`
- `>` matches multiple tokens: `time.>`

**Messaging Patterns:**
- Publish-Subscribe (one-to-many)
- Request-Reply (synchronous)
- Queue Groups (load balancing)

## 🔗 Resources

- **NATS Documentation**: https://docs.nats.io
- **CleanStart Website**: https://www.cleanstart.com
- **NATS GitHub**: https://github.com/nats-io


