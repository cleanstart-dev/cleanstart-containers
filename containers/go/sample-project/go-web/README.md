# Execute Go Database Web Application on CleanStart Container - Go

A modern web interface for SQLite database operations built with **Go**, **Gin**, and **Bootstrap**.

## Objective

The objective of this project is to utilize CleanStart Container Image - Go and build a lightweight, containerized web application in Go that provides a user-friendly interface and REST APIs for performing SQLite database operations.

## Summary

This project demonstrates how to combine Go, Gin, SQLite, and Bootstrap to create a modern database management system. It offers both a web-based dashboard and API endpoints to manage users—supporting create, read, update, and delete (CRUD) operations—packaged in a Dockerized environment for easy deployment and scalability.

## Quick Start - Run Locally

### Prerequisites
Pull CleanStart Go image from [Docker Hub - CleanStart](https://hub.docker.com/u/cleanstart) 
```bash
docker pull cleanstart/go:latest
```

### Step 1: Navigate to Go Web Directory
```bash
cd containers/go/sample-project/go-web
```

### Step 2: Build and Run the Application
### Make Dockerfile
```bash
# Base image
FROM cleanstart/go:latest-dev

RUN apk add --no-cache git ca-certificates wget

WORKDIR /app

COPY go.mod ./
COPY go.su[m] ./

COPY . .

RUN go mod tidy

RUN CGO_ENABLED=0 GOOS=linux go build -o go-web-app main.go

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/ || exit 1

ENTRYPOINT ["./go-web-app"]

```

### Step 3: Build the image
```bash
docker build -t go-web-app .
```

### Step 4: Run the image
```bash
docker run --rm go-web-app
```

### Step 4: Access the Web Application
```bash
docker run --rm -p 8080:8080 latest-dev:latest
```

### Docker Compose for services
```bash
docker compose build --no-cache
```
### Docker Compose for running the services
```bash
docker compose up
```

Open your browser and go to: **http://localhost:8080**

### Go Build Output
You should see output like this:
```
go: downloading github.com/gin-gonic/gin v1.9.1
go: downloading github.com/mattn/go-sqlite3 v1.14.17
Database created successfully
Table created successfully
User inserted successfully
User inserted successfully
User inserted successfully
All users:
ID: 1, Name: John Doe, Email: john@example.com
ID: 2, Name: Jane Smith, Email: jane@example.com
ID: 3, Name: Bob Johnson, Email: bob@example.com
Starting Go web server on http://localhost:8080
[GIN-debug] Listening and serving HTTP on :8080
```

### Application Access
Once started, you can access the application at: **http://localhost:8000**

### Snapshot of the application
<img width="1893" height="868" alt="image" src="https://github.com/user-attachments/assets/6706128e-95f1-4a45-902a-1a77ee88a9f4" />

## Web Interface Features

### Main Dashboard
- View all users in a responsive table
- Add new users with form validation
- Edit existing users
- Delete users with confirmation
- Modern Bootstrap UI with Font Awesome icons

### API Endpoints
- `GET /api/users` - Retrieve all users in JSON format
- `POST /api/users` - Create a new user via API

### Example API Usage
```bash
# Get all users
curl http://localhost:8080/api/users

# Create a new user
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com"}'
```

### Dependencies
- **Gin Web Framework** - HTTP web framework
- **SQLite3 Driver** - Database driver for Go
- **Bootstrap 5** - CSS framework (CDN)
- **Font Awesome** - Icon library (CDN)

## 🔍 Code Features

### Database Operations
- **Create Database**: Automatic SQLite database creation
- **Create Table**: Users table with ID, name, and email fields
- **Insert Users**: Add new users with validation
- **Query Users**: Retrieve all users or by ID
- **Update Users**: Modify existing user information
- **Delete Users**: Remove users from database

### Web Framework Features
- **Gin Router**: Fast HTTP web framework
- **HTML Templates**: Server-side rendering with Go templates
- **Form Handling**: POST form processing with validation
- **JSON API**: RESTful API endpoints
- **Error Handling**: Comprehensive error management

## 🐛 Troubleshooting

### Common Issues

#### 1. Port Already in Use
```
listen tcp :8080: bind: address already in use
```
**Solution**: Change port or kill existing process
```bash
# Kill process on port 8080
sudo lsof -ti:8080 | xargs kill -9
```

#### 2. Permission Denied
```
permission denied: go-web-app
```
**Solution**: Make executable
```bash
chmod +x go-web-app
```

## 📚 Resources

- [Verified Docker Image Publisher - CleanStart](https://cleanstart.com/)
- [Go Official Documentation](https://golang.org/doc/)
- [Gin Web Framework](https://gin-gonic.com/)
- [SQLite with Go](https://github.com/mattn/go-sqlite3)
- [Go Templates](https://golang.org/pkg/html/template/)

## 🤝 Contributing

Feel free to contribute to this project by:
- Reporting bugs
- Suggesting new features
- Submitting pull requests
- Improving documentation

## 📄 License
This project is open source and available under the [MIT License](LICENSE).