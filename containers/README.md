## CleanStart Containers Samples Projects
The aim is to create sample projects for all CleanStart community images. 

## Index images, Use Cases and their sample projects

| Sr No | Image Name        | Use Case                        | Dockerfile-Based Projects | Kubernetes-Based Projects | Helm-Based Projects |
|-------|-------------------|---------------------------------|---------------------------|---------------------------|----------------------|
| 1     | argocd            | Continuous Deployment (CD)      | Yes                       | No                        | No                   |
| 2     | argo-workflow      | Workflow Automation             | Yes                       | No                       | No                 |
| 3     | busybox           | Lightweight Utility             | Yes                       | No                       | No                  |
| 4     | curl              | Data Transfer                   | Yes                       | No                       | No                 |
| 5     | jre               | Java Runtime                    | Yes                       | No                        | No                 |
| 6     | jdk               | Java Development Kit            | Yes                       | No                       | No                 |
| 7     | go                | Web Applications & Microservices| Yes                       | Yes                       | No                 |
| 8     | python            | Data Science & Web Apps         | Yes                       | Yes                       | Yes                 |
| 9     | nginx             | Web Server & Reverse Proxy      | Yes                       | No                        | No                 |
| 10    | node              | JavaScript Runtime              | Yes                       | No                        | No                 |
| 11    | postgres          | Relational Database             | Yes                       | No                        | No                 |
| 12    | prometheus        | Monitoring & Alerting           | Yes                       | No                        | No                 |
| 13    | step-cli          | PKI & Certificates              | Yes                       | No                        | No                 |


## BEST PRACTICE BEFORE RUNNING ANY PROJECT

 Find the Process ID (PID) using a specific port (e.g., 8080)
 For Linux/macOS:
 ```bash
lsof -i :8080
```

# For Windows (PowerShell):
Get-Process -Id (Get-NetTCPConnection -LocalPort 8080).OwningProcess

 Kill the process using its PID
 For Linux/macOS:
 ```bash
kill -9 <PID>
```

# For Windows:
```bash
Stop-Process -Id <PID>
```



