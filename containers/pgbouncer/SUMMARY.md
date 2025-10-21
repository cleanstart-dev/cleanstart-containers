# PgBouncer Container - Complete Summary

## Overview

This directory contains production-ready configurations for deploying the `cleanstart/pgbouncer:latest` container image in Docker and Kubernetes environments.

## What Was Created

### 1. Docker Deployment (sample-project/)
Simple Docker-based deployment for local testing and development.

**Files:**
- `pgbouncer.ini` - PgBouncer configuration (plain text auth)
- `userlist.txt` - User authentication file
- `README.md` - Step-by-step guide (4 simple steps)
- `Dockerfile` - Example custom image build
- `.gitignore` - Standard ignore patterns

**Quick Start:**
```bash
cd sample-project
docker network create pgbouncer-net
docker run -d --name postgres-db --network pgbouncer-net \
  -e POSTGRES_DB=testdb -e POSTGRES_USER=testuser -e POSTGRES_PASSWORD=testpass \
  postgres:16-alpine
docker run -d --name pgbouncer --network pgbouncer-net -p 6432:6432 \
  -v $(pwd)/pgbouncer.ini:/etc/pgbouncer/pgbouncer.ini:ro \
  -v $(pwd)/userlist.txt:/etc/pgbouncer/userlist.txt:ro \
  cleanstart/pgbouncer:latest /etc/pgbouncer/pgbouncer.ini
docker run --rm --network pgbouncer-net -e PGPASSWORD=testpass postgres:16-alpine \
  psql -h pgbouncer -p 6432 -U testuser -d testdb -c "SELECT version();"
```

### 2. Kubernetes Deployment (kubernetes - AWS/)
Production-ready Kubernetes manifests for AWS EKS or any K8s cluster.

**Files:**
- `namespace.yaml` - Creates pgbouncer-demo namespace
- `deployment.yaml` - All resources (ConfigMap, Deployments, Services)
- `README.md` - Comprehensive guide with 5 steps

**Quick Start:**
```bash
cd kubernetes\ -\ AWS
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml
kubectl get pods -n pgbouncer-demo
```

## Configuration Details

### PgBouncer Settings
- **Pool Mode**: session (safest, default)
- **Max Connections**: 100 clients
- **Default Pool Size**: 20 connections
- **Authentication**: plain text (for demo; use MD5/SCRAM for production)
- **Port**: 6432 (standard PgBouncer port)

### Database Configuration
- **Database**: testdb
- **User**: testuser
- **Password**: testpass
- **PostgreSQL Version**: 16-alpine

## Testing Results

### ✅ Docker Deployment - Verified
- PostgreSQL + PgBouncer running successfully
- Connection pooling working
- Admin console accessible
- SHOW POOLS and SHOW STATS working

### ✅ Kubernetes Deployment - Verified
- Pods deployed and running (1/1 Ready)
- Services created (ClusterIP)
- Connection through PgBouncer service working
- Data operations (CREATE, INSERT, SELECT) successful
- Pool statistics accessible
- Logs showing proper connections

## Connection Methods

### Docker
```bash
# Direct connection
docker run --rm --network pgbouncer-net -e PGPASSWORD=testpass postgres:16-alpine \
  psql -h pgbouncer -p 6432 -U testuser -d testdb

# Admin console
docker run --rm --network pgbouncer-net -e PGPASSWORD=testpass postgres:16-alpine \
  psql -h pgbouncer -p 6432 -U testuser -d pgbouncer -c "SHOW POOLS;"
```

### Kubernetes
```bash
# Quick query
kubectl run test --image=postgres:16-alpine --namespace=pgbouncer-demo \
  --env="PGPASSWORD=testpass" --restart=Never \
  -- psql -h pgbouncer-service -p 6432 -U testuser -d testdb -c "SELECT 1;"
kubectl logs -n pgbouncer-demo test

# Interactive shell
kubectl run psql-shell --image=postgres:16-alpine --namespace=pgbouncer-demo -- sleep infinity
kubectl exec -it -n pgbouncer-demo psql-shell -- sh
PGPASSWORD=testpass psql -h pgbouncer-service -p 6432 -U testuser -d testdb

# Port forward for local access
kubectl port-forward -n pgbouncer-demo service/pgbouncer-service 6432:6432
PGPASSWORD=testpass psql -h localhost -p 6432 -U testuser -d testdb
```

## Cleanup

### Docker
```bash
docker stop pgbouncer postgres-db
docker rm pgbouncer postgres-db
docker network rm pgbouncer-net
```

### Kubernetes
```bash
kubectl delete -f deployment.yaml
kubectl delete -f namespace.yaml
# Or simply:
kubectl delete namespace pgbouncer-demo
```

## Production Considerations

When deploying to production, consider:

1. **Security**
   - Use Kubernetes Secrets for passwords (not ConfigMaps)
   - Enable MD5 or SCRAM-SHA-256 authentication
   - Configure TLS/SSL for encrypted connections
   - Use network policies for isolation

2. **High Availability**
   - Scale PgBouncer replicas (`kubectl scale deployment pgbouncer --replicas=3`)
   - Use StatefulSet for PostgreSQL
   - Configure PersistentVolumes for data
   - Set up proper backup strategies

3. **Monitoring**
   - Export metrics to Prometheus
   - Set up Grafana dashboards
   - Configure alerting rules
   - Monitor pool saturation

4. **Resource Management**
   - Adjust CPU/memory limits based on workload
   - Tune pool_size based on PostgreSQL max_connections
   - Monitor and adjust based on actual usage

5. **Performance Tuning**
   - Choose appropriate pool_mode (session/transaction/statement)
   - Adjust pool sizes (default_pool_size, reserve_pool_size)
   - Configure timeouts appropriately
   - Monitor query performance

## Common Use Cases

1. **Microservices Architecture**
   - Deploy PgBouncer as a sidecar or separate service
   - Limit connections per service
   - Improve connection efficiency

2. **Web Applications**
   - Handle variable traffic loads
   - Reduce connection overhead
   - Support autoscaling

3. **Legacy Application Modernization**
   - Add connection pooling without code changes
   - Reduce database connection load
   - Support gradual migration

## Troubleshooting

### Connection Issues
```bash
# Docker
docker logs pgbouncer
docker logs postgres-db

# Kubernetes
kubectl logs -n pgbouncer-demo -l app=pgbouncer
kubectl describe pod -n pgbouncer-demo -l app=pgbouncer
```

### Authentication Failures
- Verify userlist.txt format: `"username" "password"`
- Check auth_type matches password format
- Ensure password is correct

### Performance Issues
- Check SHOW POOLS for saturation
- Review SHOW STATS for query patterns
- Adjust pool_size if needed
- Consider changing pool_mode

## References

- [Main README](./README.md) - Overview and quick start
- [Sample Project README](./sample-project/README.md) - Docker deployment guide
- [Kubernetes README](./kubernetes%20-%20AWS/README.md) - K8s deployment guide
- [PgBouncer Official Docs](https://www.pgbouncer.org/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## Notes

- All configurations use plain text passwords for simplicity in demos
- For production, always use encrypted authentication and TLS
- PgBouncer runs as non-root user `clnstrt` for security
- Default configuration is optimized for development/testing
- Adjust settings based on your specific workload requirements

