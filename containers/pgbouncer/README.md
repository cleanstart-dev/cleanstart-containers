# PgBouncer Container

## Overview

PgBouncer is a lightweight connection pooler for PostgreSQL databases. It reduces connection overhead by maintaining a pool of active connections that can be reused by client applications.

## Image Information

- **Image Name**: `cleanstart/pgbouncer:latest`
- **Base User**: `clnstrt` (non-root)
- **Entrypoint**: `/usr/bin/pgbouncer`
- **Default Port**: 6432

## What is pgbouncer.ini?

`pgbouncer.ini` is PgBouncer's main configuration file containing:
- **[databases]**: PostgreSQL database connection details
- **[pgbouncer]**: Pool settings, authentication, ports, timeouts, and logging

## Quick Start

See the [sample-project](./sample-project/) directory for a complete working example.

```bash
cd sample-project

# Create network
docker network create pgbouncer-net

# Start PostgreSQL
docker run -d --name postgres-db --network pgbouncer-net \
  -e POSTGRES_DB=testdb -e POSTGRES_USER=testuser -e POSTGRES_PASSWORD=testpass \
  postgres:16-alpine

# Start PgBouncer
docker run -d --name pgbouncer --network pgbouncer-net -p 6432:6432 \
  -v $(pwd)/pgbouncer.ini:/etc/pgbouncer/pgbouncer.ini:ro \
  -v $(pwd)/userlist.txt:/etc/pgbouncer/userlist.txt:ro \
  cleanstart/pgbouncer:latest /etc/pgbouncer/pgbouncer.ini

# Test connection
docker run --rm -it --network pgbouncer-net postgres:16-alpine \
  psql -h pgbouncer -p 6432 -U testuser -d testdb
```

## Pool Modes

- **session**: Connection released when client disconnects (default, safest)
- **transaction**: Connection released after each transaction
- **statement**: Connection released after each statement (highest performance)

## Use Cases

- Web applications with variable load
- Microservices limiting connections to PostgreSQL
- Reducing connection overhead without code changes
- High-availability setups

## Basic Usage

```bash
docker run -d \
  --name pgbouncer \
  -p 6432:6432 \
  -v $(pwd)/pgbouncer.ini:/etc/pgbouncer/pgbouncer.ini:ro \
  -v $(pwd)/userlist.txt:/etc/pgbouncer/userlist.txt:ro \
  cleanstart/pgbouncer:latest /etc/pgbouncer/pgbouncer.ini
```

## Required Configuration Files

### 1. pgbouncer.ini

Example configuration:
```ini
[databases]
mydb = host=postgres-host port=5432 dbname=mydb

[pgbouncer]
listen_addr = 0.0.0.0
listen_port = 6432
auth_type = md5
auth_file = /etc/pgbouncer/userlist.txt
pool_mode = session
default_pool_size = 20
max_client_conn = 100
```

### 2. userlist.txt

Format: `"username" "password"`

Example for plain text (development):
```
"myuser" "mypassword"
```

For MD5 authentication (production):
```
"myuser" "md5abc123..."
```

Generate MD5 password:
```bash
echo -n "passwordusername" | md5sum
```

## Admin Console

Connect to the special `pgbouncer` database:

```bash
psql -h localhost -p 6432 -U admin_user -d pgbouncer
```

Useful commands:
- `SHOW POOLS;` - Pool statistics
- `SHOW STATS;` - Query statistics
- `SHOW DATABASES;` - Configured databases
- `SHOW CLIENTS;` - Client connections
- `SHOW SERVERS;` - Server connections
- `RELOAD;` - Reload configuration

## Security

- Runs as non-root user (`clnstrt`)
- Supports MD5, SCRAM-SHA-256 authentication
- Use Docker networks for isolation
- Configure TLS/SSL for encrypted connections

## Troubleshooting

**View logs:**
```bash
docker logs pgbouncer
```

**Check configuration:**
Verify pgbouncer.ini syntax and userlist.txt format

**Connection issues:**
- Ensure PostgreSQL is accessible from PgBouncer container
- Verify network connectivity
- Check authentication credentials

## Resources

- [Sample Project](./sample-project/README.md) - Working example
- [PgBouncer Documentation](https://www.pgbouncer.org/)
- [Configuration Reference](https://www.pgbouncer.org/config.html)

## Directory Structure

```
pgbouncer/
├── README.md                    # This file
├── kubernetes - AWS/            # Kubernetes deployment files
└── sample-project/              # Working example
    ├── README.md                # Usage instructions
    ├── pgbouncer.ini            # Configuration example
    ├── userlist.txt             # Authentication example
    └── Dockerfile               # Custom image example
```
