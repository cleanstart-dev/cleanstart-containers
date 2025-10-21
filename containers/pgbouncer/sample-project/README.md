# PgBouncer Sample Project

This sample project demonstrates how to use the `cleanstart/pgbouncer:latest` image as a connection pooler for PostgreSQL.

## What is PgBouncer?

PgBouncer is a lightweight connection pooler for PostgreSQL. It sits between your application and PostgreSQL database, reusing database connections to improve performance and reduce overhead.

## What is pgbouncer.ini?

`pgbouncer.ini` is the main configuration file for PgBouncer. It contains:
- **[databases]** section: Defines which PostgreSQL databases to connect to
- **[pgbouncer]** section: PgBouncer settings like pool size, ports, authentication, timeouts, etc.

## Project Files

```
sample-project/
├── pgbouncer.ini          # PgBouncer configuration file
├── userlist.txt           # User authentication (username/password)
├── Dockerfile             # Example custom image build
└── README.md              # This file
```

## Configuration

**Database Credentials:**
- Username: `testuser`
- Password: `testpass`
- Database: `testdb`

**Ports:**
- PostgreSQL: 5432
- PgBouncer: 6432

## Quick Start

### Step 1: Start PostgreSQL Database

First, run a PostgreSQL database:

```bash
docker run -d \
  --name postgres-db \
  --network pgbouncer-net \
  -e POSTGRES_DB=testdb \
  -e POSTGRES_USER=testuser \
  -e POSTGRES_PASSWORD=testpass \
  postgres:16-alpine
```

Create the network first if needed:
```bash
docker network create pgbouncer-net
```

### Step 2: Start PgBouncer

Run PgBouncer with the configuration files:

```bash
docker run -d \
  --name pgbouncer \
  --network pgbouncer-net \
  -p 6432:6432 \
  -v $(pwd)/pgbouncer.ini:/etc/pgbouncer/pgbouncer.ini:ro \
  -v $(pwd)/userlist.txt:/etc/pgbouncer/userlist.txt:ro \
  cleanstart/pgbouncer:latest /etc/pgbouncer/pgbouncer.ini
```

### Step 3: Test Connection

Connect to PostgreSQL through PgBouncer:

```bash
# Interactive mode (will prompt for password: testpass)
docker run --rm -it --network pgbouncer-net postgres:16-alpine \
  psql -h pgbouncer -p 6432 -U testuser -d testdb

# Or non-interactive with password
docker run --rm --network pgbouncer-net -e PGPASSWORD=testpass postgres:16-alpine \
  psql -h pgbouncer -p 6432 -U testuser -d testdb \
  -c "SELECT 'Hello from PgBouncer!' as message;"
```

Create test data:
```bash
docker run --rm --network pgbouncer-net -e PGPASSWORD=testpass postgres:16-alpine \
  psql -h pgbouncer -p 6432 -U testuser -d testdb \
  -c "CREATE TABLE test (id SERIAL, name TEXT); INSERT INTO test (name) VALUES ('test1'), ('test2'); SELECT * FROM test;"
```

### Step 4: Check PgBouncer Stats

View pool statistics:

```bash
docker run --rm --network pgbouncer-net -e PGPASSWORD=testpass postgres:16-alpine \
  psql -h pgbouncer -p 6432 -U testuser -d pgbouncer -c "SHOW POOLS;"
```

View query statistics:
```bash
docker run --rm --network pgbouncer-net -e PGPASSWORD=testpass postgres:16-alpine \
  psql -h pgbouncer -p 6432 -U testuser -d pgbouncer -c "SHOW STATS;"
```

For interactive admin console:
```bash
docker run --rm -it --network pgbouncer-net -e PGPASSWORD=testpass postgres:16-alpine \
  psql -h pgbouncer -p 6432 -U testuser -d pgbouncer
```

## Key PgBouncer Admin Commands

- `SHOW POOLS;` - View connection pool status
- `SHOW STATS;` - View query statistics  
- `SHOW DATABASES;` - List configured databases
- `SHOW CLIENTS;` - Show client connections
- `SHOW SERVERS;` - Show server connections
- `RELOAD;` - Reload configuration

## Cleanup

```bash
docker stop pgbouncer postgres-db
docker rm pgbouncer postgres-db
docker network rm pgbouncer-net
```

## Troubleshooting

**Cannot connect:**
```bash
docker logs pgbouncer
docker logs postgres-db
```

**Check if containers are running:**
```bash
docker ps
```

**Verify network:**
```bash
docker network inspect pgbouncer-net
```

## Notes

- The `userlist.txt` contains plain text password for simplicity in this sample
- For production, use MD5 or SCRAM-SHA-256 authentication
- PgBouncer runs as non-root user `clnstrt`
- Default pool mode is `session` (safest option)
- Use `PGPASSWORD` environment variable for non-interactive commands
- For production, use secure passwords and proper TLS/SSL configuration
