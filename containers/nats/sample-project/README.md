# 📨 NATS Sample Project

A simple **NATS** messaging sample project demonstrating pub/sub operations with CleanStart containers.

## 🌟 Features

- **CleanStart NATS**: Uses `cleanstart/nats:latest-dev` image
- **Simple Setup**: Direct Docker commands and Docker Compose
- **Message Broker**: Lightweight, high-performance messaging system
- **Pub/Sub Pattern**: Demonstrates publishing and subscribing to topics

## 🚀 Quick Start

### Prerequisites
- Docker installed

### Step 1: Pull CleanStart NATS Image

```bash
docker pull cleanstart/nats:latest-dev
```

**Why this command?** This downloads the CleanStart NATS image to your local machine.

### Step 2: Start NATS Server

#### Option A: Using Docker Run

```bash
docker run -d \
  --name nats-server \
  -p 4222:4222 \
  -p 8222:8222 \
  cleanstart/nats:latest-dev
```

**Why this command?**
- `--name nats-server`: Names the container for easy reference
- `-p 4222:4222`: Maps NATS client port to host
- `-p 8222:8222`: Maps NATS monitoring/HTTP port to host
- `-d`: Runs in background (detached mode)

#### Option B: Using Docker Compose

```bash
docker-compose up -d
```

**Why this command?** Starts NATS using the provided docker-compose.yml configuration.

### Step 3: Verify Container is Running

```bash
docker ps
```

**Expected output:** You should see `nats-server` container with status "Up" on ports 4222 and 8222.

```bash
# Check container logs
docker logs nats-server
```

**Expected output:** Should show NATS server startup messages indicating it's listening on port 4222.

### Step 4: Check NATS Server Status

Access the NATS monitoring endpoint:

```bash
curl http://localhost:8222/varz
```

**Expected output:** JSON response with NATS server statistics including version, connections, and server info.

Alternatively, open in your browser: **http://localhost:8222**

### Step 5: Test NATS Pub/Sub

#### Interactive Testing (from within container)

**Start a subscriber in one terminal:**

```bash
docker exec -it nats-server sh
nats-sub test.topic
```

**In another terminal, publish a message:**

```bash
docker exec -it nats-server sh
nats-pub test.topic "Hello from NATS!"
```

**Expected output:** The subscriber terminal should display the received message.

#### Using the Test Script

If you have NATS CLI installed on your host:

```bash
# Subscribe to a topic
nats sub "demo.>"

# In another terminal, publish messages
nats pub demo.hello "Hello World"
nats pub demo.test "Testing NATS"
```

### Step 6: Advanced Testing

#### Request-Reply Pattern

**Start a responder in one terminal:**

```bash
docker exec -it nats-server sh
# Inside container (if nats CLI is available):
# nats reply help.service "I can help you!"
```

**Send a request in another terminal:**

```bash
docker exec -it nats-server sh
# nats request help.service "Need help"
```

#### Test with Python (if you have NATS Python client)

Create a simple publisher:

```python
import asyncio
from nats.aio.client import Client as NATS

async def main():
    nc = NATS()
    await nc.connect("nats://localhost:4222")
    await nc.publish("test.topic", b'Hello from Python!')
    await nc.close()

if __name__ == '__main__':
    asyncio.run(main())
```

### Step 7: Stop the Container

```bash
# Stop the container
docker stop nats-server
```

**Why this command?** Gracefully stops the NATS server container.

### Step 8: Start the Container Again

```bash
# Start existing container
docker start nats-server

# Verify it's running
docker ps
docker logs nats-server
```

### Step 9: Clean Up (Optional)

```bash
# Stop and remove container
docker stop nats-server
docker rm nats-server

# Or using Docker Compose
docker-compose down
```

## 📁 Project Structure

```
sample-project/
├── docker-compose.yml    # Docker Compose configuration
├── test-nats.sh          # Simple test script
└── README.md            # This file
```

## 🔧 Configuration

- **Image**: `cleanstart/nats:latest-dev`
- **Client Port**: `4222` (NATS client connections)
- **HTTP Monitoring Port**: `8222` (Server monitoring/info)
- **Cluster Port**: `6222` (For NATS clustering - not exposed by default)
- **Container Name**: `nats-server`

## 🔍 Monitoring Endpoints

Access these URLs in your browser or with curl:

| Endpoint | Description |
|----------|-------------|
| `http://localhost:8222/varz` | General server information |
| `http://localhost:8222/connz` | Connection information |
| `http://localhost:8222/routez` | Route information |
| `http://localhost:8222/subsz` | Subscription information |

Example:
```bash
# Get server info
curl http://localhost:8222/varz

# Get connections
curl http://localhost:8222/connz

# Get subscriptions
curl http://localhost:8222/subsz
```

## 🔧 Troubleshooting

### Check Container Status
```bash
docker ps -a
```

### Check Container Logs
```bash
docker logs nats-server

# Follow logs in real-time
docker logs -f nats-server
```

### Container Keeps Restarting
```bash
# Check detailed logs
docker logs nats-server

# Inspect container
docker inspect nats-server

# Verify image is correct
docker images | grep cleanstart/nats
```

### Port Already in Use
```bash
# Find what's using port 4222
# Linux/Mac:
sudo lsof -i :4222

# Windows PowerShell:
netstat -ano | findstr :4222

# Use different port
docker run -d --name nats-server -p 4223:4222 -p 8223:8222 cleanstart/nats:latest-dev
# Then connect with: nats://localhost:4223
```

### Cannot Connect to NATS
```bash
# Wait a few seconds for container to fully start
docker logs nats-server

# Check if container is running
docker ps

# Test connection
curl http://localhost:8222/varz
```

## 📚 NATS Concepts

### Subjects (Topics)
NATS uses a subject-based messaging system. Subjects are hierarchical strings separated by dots:
- `time.us.east`
- `weather.europe.london`
- `orders.new`

### Wildcards
- `*` - Matches a single token: `time.*.east` matches `time.us.east`
- `>` - Matches one or more tokens: `time.>` matches `time.us.east` and `time.us`

### Messaging Patterns

1. **Publish-Subscribe**: One-to-many message distribution
2. **Request-Reply**: Synchronous request/response
3. **Queue Groups**: Load balancing across subscribers

## 💡 Quick Tips

**Test if NATS is responding:**
```bash
curl -s http://localhost:8222/varz | grep -o '"version":"[^"]*"'
```

**Interactive shell inside container:**
```bash
docker exec -it nats-server sh
```

**Run NATS in debug mode:**
```bash
docker run -d --name nats-server -p 4222:4222 -p 8222:8222 cleanstart/nats:latest-dev -DV
```
The `-DV` flags enable debug and trace logging.

**Connect from host applications:**
Use connection string: `nats://localhost:4222`

## 📦 Client Libraries

NATS has official client libraries for many languages:

- **Go**: https://github.com/nats-io/nats.go
- **Python**: https://github.com/nats-io/nats.py
- **Node.js**: https://github.com/nats-io/nats.js
- **Java**: https://github.com/nats-io/nats.java
- **C**: https://github.com/nats-io/nats.c
- **Rust**: https://github.com/nats-io/nats.rs

## 🎯 Testing Checklist

- [ ] Pull CleanStart NATS image
- [ ] Container starts successfully with `docker run`
- [ ] Can see container running with `docker ps`
- [ ] Logs show NATS server listening on port 4222
- [ ] Can access monitoring endpoint at http://localhost:8222
- [ ] Can view server stats with `/varz` endpoint
- [ ] Can publish and subscribe to topics (if CLI available)
- [ ] Container stops gracefully with `docker stop`
- [ ] Can clean up with `docker rm`

## 🌐 Use Cases

- **Microservices Communication**: Lightweight messaging between services
- **Event Streaming**: Real-time event distribution
- **IoT Messaging**: Device-to-cloud communication
- **Request-Reply**: Synchronous service interactions
- **Data Pipelines**: Stream processing and data flow

## 🔗 Resources

- **NATS Official Documentation**: https://docs.nats.io
- **CleanStart Website**: https://www.cleanstart.com
- **NATS GitHub**: https://github.com/nats-io

## 🤝 Contributing

Feel free to contribute by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

---

**Happy Messaging with NATS! 📨**

