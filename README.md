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
├── CONTRIBUTING.md     # Index file for how-to-guide coverage across CleanStart Images
├── Security-Scanner-Integration.md  # Sharing the interest with progress of CleanStart's efforts to be recognized in popular vulnerability tools
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
