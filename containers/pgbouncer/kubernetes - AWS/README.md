# PgBouncer on Kubernetes (AWS)

This directory contains Kubernetes manifests to deploy PgBouncer with PostgreSQL on AWS EKS or any Kubernetes cluster.

## Overview

This deployment includes:
- PostgreSQL database (single pod)
- PgBouncer connection pooler
- ConfigMap for PgBouncer configuration
- Services for internal communication

## Prerequisites

- Kubernetes cluster (EKS, minikube, kind, etc.)
- `kubectl` configured to access your cluster
- Access to `cleanstart/pgbouncer:latest` image

## Files

- `namespace.yaml` - Creates pgbouncer-demo namespace
- `deployment.yaml` - All resources (ConfigMap, Deployments, Services)

## Quick Start

### Step 1: Create Namespace

```bash
kubectl apply -f namespace.yaml
```

### Step 2: Deploy Resources

```bash
kubectl apply -f deployment.yaml
```

### Step 3: Verify Deployment

Check if all pods are running:

```bash
kubectl get pods -n pgbouncer-demo
```

Expected output:
```
NAME                         READY   STATUS    RESTARTS   AGE
pgbouncer-xxxxxxxxxx-xxxxx   1/1     Running   0          1m
postgres-xxxxxxxxxx-xxxxx    1/1     Running   0          1m
```

Check services:

```bash
kubectl get svc -n pgbouncer-demo
```

### Step 4: Test Connection

Run a test query through PgBouncer:

```bash
kubectl run postgres-test \
  --image=postgres:16-alpine \
  --namespace=pgbouncer-demo \
  --env="PGPASSWORD=testpass" \
  --restart=Never \
  -- psql -h pgbouncer-service -p 6432 -U testuser -d testdb \
  -c "SELECT 'Hello from PgBouncer on Kubernetes!' as message;"
```

View the output:
```bash
kubectl logs -n pgbouncer-demo postgres-test
```

Create test data:
```bash
kubectl run data-test \
  --image=postgres:16-alpine \
  --namespace=pgbouncer-demo \
  --env="PGPASSWORD=testpass" \
  --restart=Never \
  -- psql -h pgbouncer-service -p 6432 -U testuser -d testdb \
  -c "CREATE TABLE test (id SERIAL, name TEXT); INSERT INTO test (name) VALUES ('k8s-test1'), ('k8s-test2'); SELECT * FROM test;"

kubectl logs -n pgbouncer-demo data-test
```

Clean up test pods:
```bash
kubectl delete pod postgres-test data-test -n pgbouncer-demo
```

### Step 5: Check PgBouncer Stats

View pool statistics:

```bash
kubectl run stats-check \
  --image=postgres:16-alpine \
  --namespace=pgbouncer-demo \
  --env="PGPASSWORD=testpass" \
  --restart=Never \
  -- psql -h pgbouncer-service -p 6432 -U testuser -d pgbouncer -c "SHOW POOLS;"

kubectl logs -n pgbouncer-demo stats-check
kubectl delete pod stats-check -n pgbouncer-demo
```

View query statistics:

```bash
kubectl run query-stats \
  --image=postgres:16-alpine \
  --namespace=pgbouncer-demo \
  --env="PGPASSWORD=testpass" \
  --restart=Never \
  -- psql -h pgbouncer-service -p 6432 -U testuser -d pgbouncer -c "SHOW STATS;"

kubectl logs -n pgbouncer-demo query-stats
kubectl delete pod query-stats -n pgbouncer-demo
```

## Configuration Details

### Database Credentials
- **Database**: testdb
- **Username**: testuser
- **Password**: testpass (stored in ConfigMap)

### PgBouncer Settings
- **Pool Mode**: session
- **Max Connections**: 100
- **Pool Size**: 20
- **Authentication**: plain text (for demo purposes)

### Services
- **postgres-service**: ClusterIP on port 5432
- **pgbouncer-service**: ClusterIP on port 6432

## Basic Database Operations

Once connected to the database, you can run these SQL commands:

### Create Tables
```sql
-- Create a users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Create a products table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2),
    stock INT DEFAULT 0
);
```

### Insert Data
```sql
INSERT INTO users (username, email) VALUES 
    ('alice', 'alice@example.com'),
    ('bob', 'bob@example.com');

INSERT INTO products (name, price, stock) VALUES 
    ('Laptop', 999.99, 10),
    ('Mouse', 29.99, 50);
```

### Query Data
```sql
-- Select all
SELECT * FROM users;

-- With conditions
SELECT * FROM products WHERE price > 50;

-- Join tables
SELECT u.username, COUNT(*) as order_count
FROM users u
GROUP BY u.username;

-- Aggregate functions
SELECT AVG(price) FROM products;
SELECT COUNT(*) FROM users;
```

### Update and Delete
```sql
-- Update
UPDATE products SET price = 899.99 WHERE name = 'Laptop';

-- Delete
DELETE FROM products WHERE stock = 0;
```

### Useful PostgreSQL Commands
```sql
-- List tables
\dt

-- Describe table
\d users

-- Current database
SELECT current_database();

-- Exit psql
\q
```

## View Logs

PgBouncer logs:
```bash
kubectl logs -n pgbouncer-demo -l app=pgbouncer -f
```

PostgreSQL logs:
```bash
kubectl logs -n pgbouncer-demo -l app=postgres -f
```

## Cleanup

Delete all resources:

```bash
kubectl delete -f deployment.yaml
kubectl delete -f namespace.yaml
```

Or delete namespace (removes everything):
```bash
kubectl delete namespace pgbouncer-demo
```

## Production Considerations

For production deployments:

1. **Use Secrets** for passwords instead of ConfigMap
2. **Enable TLS/SSL** for encrypted connections
3. **Use StatefulSet** for PostgreSQL with persistent volumes
4. **Configure resource limits** based on your workload
5. **Set up monitoring** with Prometheus/Grafana
6. **Use MD5 or SCRAM-SHA-256** authentication instead of plain text
7. **Configure proper backup** strategies for PostgreSQL
8. **Use LoadBalancer** or Ingress for external access if needed
