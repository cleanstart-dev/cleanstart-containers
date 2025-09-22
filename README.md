# CleanStart
CleanStart is dedicated to reshaping the landscape of software supply chain security. With seamless integration, combined with continuous monitoring and vulnerability intelligence, CleanStart provides a platform that secures every step from development to delivery.

Our main goal is to make security easy for users while taking on the hard work of finding and fixing security issues. Here's how we do it:

Developer Harmony: We try to make security fit seamlessly into developers' work so they can keep moving fast without sacrificing safety.

Security Empowerment: With our tools, security teams can set up strong security rules and make sure they're followed, keeping the whole supply chain safe.

We are committed to enabling faster detection and response to threats, increasing trust, and empowering organizations to develop software with confidence by minimizing developer disruption and empowering security teams.

## CleanStart Container Images
CleanStart have built community edition of Docker container images available at [Docker Hub](https://hub.docker.com/u/cleanstart). CleanStart Community team is continuously building sample applications, how-to guides for running CleanStart images and making them available on [GitHub Repo](https://github.com/clnstrt/cleanstart-containers). The aim of such sample projects is learning containerization, web development, and DevOps practices. Each container includes practical examples, setup scripts, and detailed documentation to help you learn and implement containerized solutions.


## 🚀 Quick Start

### Prerequisites
- Docker installed and running
- Basic command line knowledge

### 1. Clone the GitHub Repository 
```bash
git clone https://github.com/your-username/cleanstart-containers.git
cd cleanstart-containers
```

### 2. Pull a CleanStart Container Image
```bash
# Example: Pull the Go container
docker pull cleanstart/go:latest
```

### 3. Run a Container
```bash
# Example: Run Go container interactively
docker run -it --rm cleanstart/go:latest
```

### 4. Try Sample Projects
```bash
# Navigate to sample projects
cd containers/go/sample-project

# Run hello world example
cd hello-world
docker build -t go-hello-world .
docker run --rm go-hello-world
```

## 📁 Project Structure for the cleanstart-containers repo
```
cleanstart-containers/
├── LICENSE                          
├── README.md                        # This file
└── containers/                      # All container sample projects
    ├── go/
    │   ├── README.md
    │   └── sample-project/
    |   │   └── hell-world/
    |   │   |    └── README.md
    |   │   |    └── Dockerfile
    |   │   |    └── project files
    |   │   └── go-web/
    |   │   |    └── README.md
    |   │   |    └── Dockerfile
    |   │   |    └── project files
    ├── nginx/                      
    ├── python/                     
    ├── node/                       
    └── [more containers...]
```

## 🛠️ Development

### Building Images
```bash
# Build a specific container
cd containers/go
docker build -t cleanstart/go:latest .
```

### Running Sample Projects
```bash
# Navigate to any sample project
cd containers/go/sample-project/go-web

# Build and run
docker build -t go-web-app .
docker run -p 8080:8080 go-web-app
```

### Using Docker Compose
```bash
# Navigate to any sample project
cd containers/[container-name]/sample-project

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## 🧪 Testing Your Setup

### Health Checks
```bash
# Check if services are running
docker-compose ps

# Test web endpoints
curl http://localhost:8080/health

# View service logs
docker-compose logs -f [service-name]
```

### Common Test Commands
```bash
# Test Docker installation
docker --version
docker-compose --version

# Test container functionality
docker run --rm cleanstart/[container-name] --version
```


## 📚 Documentation

Each sample project includes:
- **Detailed README** - Complete setup and usage instructions
- **Setup Scripts** - Automated environment setup
- **Docker Compose** - Multi-container orchestration
- **Example Code** - Working code examples
- **Test Scripts** - Validation and testing tools

## 🤝 Contributing

We welcome contributions to improve these sample projects. Please fork the repository, make your sample projects, or changes. Commit, push and send PR request. CleanStart community team will review the your changes and once approved, your changes will be merged. 

## 🆘 Support

If you encounter issues or need help:

1. **Check the troubleshooting section above**
2. **Review the individual project READMEs**
3. **Check the project logs for specific errors**
4. **Open an issue on GitHub with detailed information**

---

**Happy Containerizing! 🐳**
