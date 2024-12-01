# Deploying EKS Clusters and Flask Microservices Applications with CI/CD
![Alt text From Scratch to Production: Deploying EKS Clusters and Applications with CI/CD using Jenkins and Terraform](https://github.com/ShimaaELsaadi/Microservices/blob/main/overview.jpg)
## Introduction
This repository provides a comprehensive implementation of a CI/CD pipeline for deploying Flask-based microservices written in Python. It focuses on automating the build, test, and deployment processes while leveraging Kubernetes for orchestration. Terraform is used to provision an Amazon EKS (Elastic Kubernetes Service) cluster where the application is deployed.

## Features
- Automated testing and deployment pipeline.
- Support for containerization using Docker.
- Integration with Jenkins for CI/CD orchestration.
- Deployment to Amazon EKS clusters using Kubernetes.
- Load balancing using Kubernetes Services.
- Infrastructure provisioning using Terraform.
- Modular structure for handling multiple microservices.

## Technologies Used
- *Programming Language*: Python (Flask Framework)
- *Containerization*: Docker
- *CI/CD Orchestration*: Jenkins
- *Orchestration Platform*: Kubernetes (Amazon EKS)
- *Infrastructure as Code (IaC)*: Terraform
- *Version Control*: Git
- *Other Tools*: YAML for configuration files

## Repository Structure

### CI_CD_pipeline

    ├── Dockerfile          # Containerization setup
    
    ├── Jenkinsfile         # CI/CD pipeline definition
    
    ├── kubernetes          # Kubernetes deployment manifests
    
    ├── microservices       # Flask microservices codebase
    
    ├── terraform           # Terraform configurations for EKS cluster setup
    
    └── tests               # Unit and integration tests


### Flask Microservices Details
The microservices folder contains Flask-based Python applications. Each service is designed to handle specific tasks and follows REST API best practices. 

Key files:
- *app.py*: The main entry point of the Flask application.
- *requirements.txt*: Lists the dependencies needed for the application.
- *Dockerfile*: Builds a Docker image for the microservice.

### Terraform Folder Details
The terraform folder contains configuration files to provision an EKS cluster and related resources. It includes:
- *main.tf*: Defines the primary infrastructure resources, including the EKS cluster, node groups, and networking.
- *variables.tf*: Contains input variable definitions for customization.
- *outputs.tf*: Specifies the outputs of the Terraform configuration, such as the Kubernetes configuration file.
- *terraform.tfvars*: Stores values for input variables (not included in the repository for security reasons).

These files work together to set up the EKS cluster, which serves as the deployment platform for the microservices.

### Kubernetes Folder Details
The kubernetes folder contains deployment manifests and service configurations for deploying the Flask microservices to the EKS cluster.

Key files:
- *deployment.yaml*: Defines the Deployment resource, which manages the Pods for the Flask microservices.
- *service.yaml*: Configures the LoadBalancer Service to expose the application to external traffic. The LoadBalancer automatically provides a public endpoint to access the Flask application.

## Setup Instructions
### Prerequisites
- Install [Docker](https://www.docker.com/).
- Install [Jenkins](https://www.jenkins.io/) and configure it.
- Install [Kubernetes CLI (kubectl)](https://kubernetes.io/docs/tasks/tools/).
- Install [Terraform](https://developer.hashicorp.com/terraform/).
- Ensure AWS CLI is installed and configured with appropriate permissions.

### Steps
1. Clone the repository:
    bash
    git clone https://github.com/ShimaaELsaadi/Deploying-EKS-Clusters-and-Flask-Microservices-Applications-with-CI-CD.git

    cd Deploying-EKS-Clusters-and-Flask-Microservices-Applications-with-CI-CD
   
#### Makefile
A standard GNU Make file is provided to help with running and building locally.

```txt
$ make

Build                🔨 Build container image from Dockerfile
run                  🏃‍ Run locally using flask python
push                 📤 Push container image to registry
test                 🎯 Unit tests with curl command
```
    
3. Build Docker Images:
    bash
    docker build -t microservice-app ./microservices
    
4. Configure Jenkins:
    - Add this repository to your Jenkins jobs.
    - Use the Jenkinsfile provided in the repo to automate the CI/CD process.
5. Provision EKS Cluster with Terraform:
    bash
    cd terraform
    terraform init
    terraform apply
    
    This will create an EKS cluster and associated resources, such as VPCs and subnets.
6. Configure kubectl to interact with the EKS cluster:
    bash
    aws eks update-kubeconfig --name <cluster_name>
    
7. Deploy to Kubernetes:
    bash
    kubectl apply -f kubernetes/
    
    This will deploy the Flask microservices to the EKS cluster and expose them using a LoadBalancer Service.

## Contribution Guidelines
1. Fork the repository.
2. Create a new branch for your feature or bug fix:
    bash
    git checkout -b feature-name
    
3. Commit your changes with clear messages:
    bash
    git commit -m "Add new feature"
    
4. Push your branch and create a pull request.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.

---
Feel free to open issues or pull requests if you have any suggestions or improvements!
