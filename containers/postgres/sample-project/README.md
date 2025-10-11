# 🐘 PostgreSQL Sample Project

A simple **PostgreSQL** sample project demonstrating database operations with CleanStart containers.

## 🌟 Features

- **CleanStart PostgreSQL**: Uses `cleanstart/postgres:latest-dev` image
- **Simple Setup**: Direct Docker commands - no Docker Compose needed
- **Sample Data**: Pre-loaded with users and posts tables
- **Interactive Testing**: Direct SQL commands via psql

## 🚀 Quick Start

### Prerequisites
- Docker installed

### Step 1: Pull CleanStart PostgreSQL Image

```bash
docker pull cleanstart/postgres:latest-dev
```

**Why this command?** This downloads the CleanStart PostgreSQL image to your local machine.

### Step 2: Start PostgreSQL Container

```bash
docker run -d \
  --name postgres-sample \
  -e POSTGRES_DB=helloworld \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=password \
  -p 5432:5432 \
  -v postgres_data:/var/lib/postgresql/data \
  -v "$(pwd)/init.sql:/docker-entrypoint-initdb.d/init.sql" \
  cleanstart/postgres:latest-dev
```

**Why this command?**
- `--name postgres-sample`: Names the container for easy reference
- `-e`: Sets environment variables for database, user, and password
- `-p 5432:5432`: Maps PostgreSQL port to host
- `-v postgres_data:/var/lib/postgresql/data`: Persists database data
- `-v "$(pwd)/init.sql:..."`: Mounts init.sql to initialize database
- `-d`: Runs in background (detached mode)

**For Windows PowerShell, use:**
```powershell
docker run -d --name postgres-sample -e POSTGRES_DB=helloworld -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=password -p 5432:5432 -v postgres_data:/var/lib/postgresql/data -v "${PWD}/init.sql:/docker-entrypoint-initdb.d/init.sql" cleanstart/postgres:latest-dev
```

### Step 3: Verify Container is Running

```bash
docker ps
```

**Expected output:** You should see `postgres-sample` container with status "Up" on port 5432.

```bash
# Check container logs
docker logs postgres-sample
```

**Expected output:** Should show PostgreSQL initialization messages and "database system is ready to accept connections".

### Step 4: Connect to PostgreSQL

```bash
docker exec -it postgres-sample psql -U postgres -d helloworld
```

**Why this command?** Opens an interactive PostgreSQL shell (psql) connected to the `helloworld` database where you can run SQL commands.

**Important:** Make sure to specify `-d helloworld` to connect to the correct database where the tables exist!

**Alternative connection methods:**
```bash
# Using psql from host (if installed)
psql -h localhost -p 5432 -U postgres -d helloworld

# Using Docker with explicit connection
docker exec -it postgres-sample psql -h localhost -U postgres
```

### Step 5: Test Database Operations

Once connected to psql, try these commands:

#### View all tables:
```sql
\dt
```

**Expected output:** Shows `users` and `posts` tables.

#### View all users:
```sql
SELECT * FROM users;
```

**Expected output:** 3 users (Alice, Bob, Charlie).

#### View all posts:
```sql
SELECT * FROM posts;
```

**Expected output:** 3 sample posts.

#### View posts with author names (JOIN):
```sql
SELECT p.id, p.title, p.content, u.name as author, p.created_at 
FROM posts p 
LEFT JOIN users u ON p.user_id = u.id 
ORDER BY p.created_at DESC;
```

**Expected output:** Posts with corresponding author names.

#### Insert a new user:
```sql
INSERT INTO users (name, email) VALUES ('David Wilson', 'david@example.com');
SELECT * FROM users;
```

**Expected output:** 4 users now.

#### Insert a new post:
```sql
INSERT INTO posts (title, content, user_id) VALUES 
('My First Post', 'Learning PostgreSQL with CleanStart!', 1);
SELECT * FROM posts;
```

**Expected output:** 4 posts now.

#### Update a user:
```sql
UPDATE users SET name = 'Alice Williams' WHERE email = 'alice@example.com';
SELECT * FROM users WHERE email = 'alice@example.com';
```

**Expected output:** Alice's name updated to Alice Williams.

#### Delete a post:
```sql
DELETE FROM posts WHERE title = 'My First Post';
SELECT * FROM posts;
```

**Expected output:** Back to 3 posts.

#### Count records:
```sql
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM posts;
```

#### Exit psql:
```sql
\q
```

### Step 6: Stop the Container

```bash
# Stop the container
docker stop postgres-sample
```

**Why this command?** Gracefully stops the PostgreSQL container.

### Step 7: Start the Container Again (Data Persists!)

```bash
# Start existing container
docker start postgres-sample

# Connect and verify data is still there
docker exec -it postgres-sample psql -U postgres -d helloworld -c "SELECT * FROM users;"
```

**Expected output:** All your data should still be there thanks to the volume mount!

### Step 8: Clean Up (Optional)

```bash
# Stop and remove container
docker stop postgres-sample
docker rm postgres-sample

# Remove volume (this will delete all data!)
docker volume rm postgres_data
```

## 📁 Project Structure

```
sample-project/
├── init.sql              # Database initialization script
├── Dockerfile            # PostgreSQL container definition (optional)
└── README.md            # This file
```

## 🗄️ Database Schema

### Users Table
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Sample Data:**
- Alice Johnson (alice@example.com)
- Bob Smith (bob@example.com)
- Charlie Brown (charlie@example.com)

### Posts Table
```sql
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    user_id INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Sample Data:**
- First Post by Alice
- Database Testing by Bob
- Hello World by Alice

## 🔧 Configuration

- **Image**: `cleanstart/postgres:latest-dev`
- **Database Name**: `helloworld`
- **User**: `postgres`
- **Password**: `password`
- **Port**: `5432`
- **Container Name**: `postgres-sample`

## 🔧 Troubleshooting

### Check Container Status
```bash
docker ps -a
```

### Check Container Logs
```bash
docker logs postgres-sample

# Follow logs in real-time
docker logs -f postgres-sample
```

### Container Keeps Restarting
```bash
# Check detailed logs
docker logs postgres-sample

# Inspect container
docker inspect postgres-sample

# Verify image is correct
docker images | grep cleanstart/postgres
```

### Port Already in Use
```bash
# Find what's using port 5432
# Linux/Mac:
sudo lsof -i :5432

# Windows PowerShell:
netstat -ano | findstr :5432

# Use different port
docker run -d --name postgres-sample -p 5433:5432 ...
# Then connect with: psql -h localhost -p 5433 ...
```

### Tables Not Found / "relation does not exist"

**Problem:** You see "Did not find any relations" or "ERROR: relation 'users' does not exist"

**Solution:** You're connected to the wrong database! Make sure to connect to `helloworld`:

```bash
# Exit current psql session
\q

# Connect to the correct database
docker exec -it postgres-sample psql -U postgres -d helloworld

# Or switch database from within psql
\c helloworld

# Verify tables exist
\dt
```

### Cannot Connect to Database
```bash
# Wait a few seconds for container to fully start
docker logs postgres-sample

# Check if container is running
docker ps

# Try connecting with explicit host
docker exec -it postgres-sample psql -h localhost -U postgres -d helloworld
```

### Permission Issues with init.sql
```bash
# On Linux/Mac, ensure file is readable
chmod 644 init.sql

# Alternative: Copy file into container
docker cp init.sql postgres-sample:/tmp/init.sql
docker exec -it postgres-sample psql -U postgres -d helloworld -f /tmp/init.sql
```

## 📚 Useful PostgreSQL Commands

| Command | Description |
|---------|-------------|
| `\l` | List all databases |
| `\dt` | List all tables in current database |
| `\d table_name` | Describe table structure |
| `\d+ table_name` | Detailed table description with stats |
| `\du` | List all users/roles |
| `\c database_name` | Connect to different database |
| `\conninfo` | Display connection information |
| `\timing` | Toggle query execution time display |
| `\x` | Toggle expanded display (easier to read) |
| `\q` | Exit psql |
| `\?` | Help on psql commands |
| `\h SQL_COMMAND` | Help on SQL commands |

## 🎯 Testing Checklist

- [ ] Pull CleanStart PostgreSQL image
- [ ] Container starts successfully with `docker run`
- [ ] Can see container running with `docker ps`
- [ ] Logs show "database system is ready to accept connections"
- [ ] Can connect via `docker exec` psql
- [ ] Tables are created (users, posts)
- [ ] Sample data is loaded (3 users, 3 posts)
- [ ] Can run SELECT queries
- [ ] Can INSERT new records
- [ ] Can UPDATE existing records
- [ ] Can DELETE records
- [ ] JOIN queries work correctly
- [ ] Data persists after stopping and starting container
- [ ] Can clean up with `docker stop` and `docker rm`

## 💡 Quick Tips

**Check if init.sql was executed:**
```bash
docker exec -it postgres-sample psql -U postgres -d helloworld -c "\dt"
```

**Run SQL file from host:**
```bash
docker exec -i postgres-sample psql -U postgres -d helloworld < init.sql
```

**Export database:**
```bash
docker exec postgres-sample pg_dump -U postgres helloworld > backup.sql
```

**Import database:**
```bash
docker exec -i postgres-sample psql -U postgres -d helloworld < backup.sql
```

**Access PostgreSQL as shell user:**
```bash
docker exec -it postgres-sample bash
# Now you're inside the container
psql -U postgres -d helloworld
```

## 🤝 Contributing

Feel free to contribute by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

