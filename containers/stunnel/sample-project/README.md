# Stunnel Sample Project

This sample project demonstrates how to use the `cleanstart/stunnel:latest-dev` image to add TLS/SSL encryption to TCP connections.

## What is Stunnel?

Stunnel is a proxy designed to add TLS encryption functionality to existing clients and servers without any changes in the programs' code. It uses the OpenSSL library for cryptography, so it can support whatever cryptographic algorithms are available in the compiled-in OpenSSL library.

## Use Cases

- Add SSL/TLS encryption to legacy applications that don't support it
- Secure Redis, PostgreSQL, or other database connections
- Create secure tunnels for network services
- Act as SSL/TLS client or server wrapper

## Project Files

```
sample-project/
├── stunnel-server.conf    # Server-side configuration (accepts SSL, forwards plain)
├── stunnel-client.conf    # Client-side configuration (accepts plain, sends SSL)
├── Dockerfile             # Example custom image build
├── .gitignore             # Git ignore file
└── README.md              # This file
```

## Configuration Overview

**stunnel-server.conf**: Acts as an SSL server, decrypts incoming connections and forwards to backend service  
**stunnel-client.conf**: Acts as an SSL client, encrypts outgoing connections to SSL server

## Prerequisites

- Docker installed and running
- OpenSSL (for generating certificates)
- Basic understanding of SSL/TLS concepts

## Quick Start with Redis Example

This example shows how to encrypt Redis connections using stunnel.

### Step 1: Generate SSL Certificate

```bash
# Generate private key and certificate
openssl req -new -x509 -days 365 -nodes \
  -out stunnel-cert.pem \
  -keyout stunnel-key.pem \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Combine into single PEM file
cat stunnel-key.pem stunnel-cert.pem > stunnel.pem
chmod 644 stunnel.pem
```

### Step 2: Create Docker Network

```bash
docker network create stunnel-net
```

### Step 3: Start Redis Backend

```bash
docker run -d \
  --name redis-backend \
  --network stunnel-net \
  redis:7-alpine
```

### Step 4: Start Stunnel Server

Run stunnel server (accepts SSL connections and forwards to Redis):

```bash
docker run -d \
  --name stunnel-server \
  --network stunnel-net \
  -p 6380:6380 \
  -v $(pwd)/stunnel-server.conf:/etc/stunnel/stunnel.conf:ro \
  -v $(pwd)/stunnel.pem:/etc/stunnel/stunnel.pem:ro \
  cleanstart/stunnel:latest-dev /etc/stunnel/stunnel.conf
```

### Step 5: Test the Connection

**Option A: Direct SSL connection test**

```bash
# Using openssl s_client
openssl s_client -connect localhost:6380 -crlf
# Type: PING
# Expected: +PONG
# Type: QUIT
```

**Option B: Using Stunnel Client**

Start stunnel client (accepts plain connections and forwards via SSL):

```bash
docker run -d \
  --name stunnel-client \
  --network stunnel-net \
  -p 6379:6379 \
  -v $(pwd)/stunnel-client.conf:/etc/stunnel/stunnel.conf:ro \
  -v $(pwd)/stunnel.pem:/etc/stunnel/stunnel.pem:ro \
  cleanstart/stunnel:latest-dev /etc/stunnel/stunnel.conf
```

Test with redis-cli through encrypted tunnel:

```bash
# Connect to Redis through stunnel (encrypted)
docker run --rm -it \
  --network stunnel-net \
  redis:7-alpine \
  redis-cli -h stunnel-client -p 6379

# Or run a single command
docker run --rm \
  --network stunnel-net \
  redis:7-alpine \
  redis-cli -h stunnel-client -p 6379 PING
```

### Step 6: Store and Retrieve Data

```bash
# Set a value
docker run --rm --network stunnel-net redis:7-alpine \
  redis-cli -h stunnel-client -p 6379 SET mykey "Hello Stunnel"

# Get the value
docker run --rm --network stunnel-net redis:7-alpine \
  redis-cli -h stunnel-client -p 6379 GET mykey
```

## Configuration Files Explained

### Server Configuration (stunnel-server.conf)

```ini
[redis-ssl]
accept = 6380                    # Listen on port 6380 for SSL connections
connect = redis-backend:6379     # Forward to Redis backend (unencrypted)
cert = /etc/stunnel/stunnel.pem  # SSL certificate
```

**What it does**: Accepts SSL/TLS connections on port 6380, decrypts them, and forwards to Redis on port 6379.

### Client Configuration (stunnel-client.conf)

```ini
[redis-client]
client = yes                     # Act as SSL client
accept = 0.0.0.0:6379           # Listen on port 6379
connect = stunnel-server:6380   # Connect to SSL server
```

**What it does**: Accepts local plain connections on port 6379, encrypts them, and sends to stunnel server on port 6380.

## Common Stunnel Options

- `foreground = yes` - Run in foreground (useful for containers)
- `debug = 5` - Enable debug logging (0-7, higher = more verbose)
- `output = /dev/stdout` - Log output destination
- `client = yes` - Run in client mode (default is server)
- `accept = host:port` - Listen address and port
- `connect = host:port` - Backend service address and port
- `cert = /path/to/cert.pem` - SSL certificate file
- `verify = 2` - Verify peer certificate
- `CAfile = /path/to/ca.pem` - CA certificate for verification

## Viewing Stunnel Help

```bash
# View all stunnel options and help
docker run --rm cleanstart/stunnel:latest-dev

# View version information
docker run --rm --entrypoint /usr/bin/stunnel cleanstart/stunnel:latest-dev -version
```

## Cleanup

```bash
# Stop and remove containers
docker stop stunnel-server stunnel-client redis-backend
docker rm stunnel-server stunnel-client redis-backend

# Remove network
docker network rm stunnel-net

# Remove generated certificates (optional)
rm -f stunnel.pem stunnel-key.pem stunnel-cert.pem
```
