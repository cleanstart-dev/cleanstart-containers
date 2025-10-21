# 🚀 Redis Exporter - Hello World!!! 

A simple project to test CleanStart Redis Exporter with a Redis instance.

## Quick Start Manual Steps

### Step 1: Create a Docker Network
Create a network so Redis and Redis Exporter can communicate:
```bash
docker network create redis-network
```
**Why?** Containers on the same network can talk to each other using container names.

### Step 2: Start Redis Server
Run a Redis instance:
```bash
docker run -d \
  --name redis \
  --network redis-network \
  -p 6379:6379 \
  redis:7-alpine
```
**Explanation:**
- `-d` = Run in background (detached mode)
- `--name redis` = Name the container "redis"
- `--network redis-network` = Connect to our network
- `-p 6379:6379` = Expose Redis port to host
- `redis:7-alpine` = Use lightweight Redis 7 image

### Step 3: Start Redis Exporter
Run the CleanStart Redis Exporter:
```bash
docker run -d \
  --name redis-exporter \
  --network redis-network \
  -p 9121:9121 \
  -e REDIS_ADDR=redis://redis:6379 \
  cleanstart/redis-exporter:latest-dev
```
**Explanation:**
- `-e REDIS_ADDR=redis://redis:6379` = Tell exporter where Redis is (using container name "redis")
- `-p 9121:9121` = Expose metrics port to host
- `cleanstart/redis-exporter:latest-dev` = Use CleanStart Redis Exporter development image

### Step 4: Add Test Data to Redis
Add some data to see it reflected in metrics:
```bash
docker exec -it redis redis-cli SET mykey "Hello Redis!"
docker exec -it redis redis-cli GET mykey
docker exec -it redis redis-cli INCR counter
docker exec -it redis redis-cli INCR counter
docker exec -it redis redis-cli INCR counter
```
**Explanation:**
- `docker exec -it redis redis-cli` = Execute Redis CLI inside the running container
- These commands create keys and increment counters

### Step 5: View Metrics
Open your browser: **http://localhost:9121/metrics**

You'll see Prometheus-format metrics like:
- `redis_up 1` - Redis instance is up and running
- `redis_connected_clients` - Number of connected clients
- `redis_db_keys` - Total number of keys in database
- `redis_memory_used_bytes` - Memory used by Redis
- `redis_commands_processed_total` - Total commands processed

**Or use curl:**
```bash
curl http://localhost:9121/metrics | grep redis_
```

## Cleanup

Stop and remove all containers:
```bash
docker stop redis-exporter redis
docker rm redis-exporter redis
docker network rm redis-network
```

## What's Running?

- **Redis Server**: localhost:6379 (stores data)
- **Redis Exporter**: localhost:9121 (exposes metrics)
- **Network**: redis-network (connects them)

## 📚 Resources

- [CleanStart Images](https://cleanstart.com/)
- [Redis Exporter Documentation](https://github.com/oliver006/redis_exporter)


