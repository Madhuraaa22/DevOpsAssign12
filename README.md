# DevOps Assignment - Django PostgreSQL Application

This project implements a complete DevOps pipeline for a Django-PostgreSQL application deployed on AWS using Terraform, Ansible, Docker Swarm, and CI/CD automation.

## Project Overview

The project demonstrates a full-stack DevOps implementation with:
- **Infrastructure as Code** using Terraform
- **Configuration Management** using Ansible
- **Container Orchestration** using Docker Swarm
- **CI/CD Pipeline** using GitHub Actions
- **Automated Testing** using Selenium

## Architecture

### Infrastructure Components
- **Controller**: Terraform + Ansible + CI runner (t2.micro)
- **Swarm Manager**: Docker Swarm manager node (t2.micro + EIP)
- **Swarm Worker A**: Django container replicas (t2.micro + EIP)
- **Swarm Worker B**: Django container replicas (t2.micro + EIP)

### Application Stack
- **Frontend**: Django web application with login/register functionality
- **Backend**: PostgreSQL database with custom authentication
- **Orchestration**: Docker Swarm with overlay networking
- **Load Balancing**: Docker Swarm built-in load balancing

## Project Structure

`
â”œâ”€â”€ terraform/           # Terraform infrastructure code
â”œâ”€â”€ ansible/            # Ansible playbooks and configuration
â”œâ”€â”€ docker/             # Docker configuration files
â”œâ”€â”€ django_app/         # Django application source code
â”œâ”€â”€ scripts/            # Bootstrap and helper scripts
â”œâ”€â”€ ci/                 # CI/CD pipeline configuration
â”œâ”€â”€ selenium/           # Selenium test scripts
â””â”€â”€ README.md           # This file
`

## Features

### Django Application
- **Login Page**: Username (Roll No) and Password (Admission No) authentication
- **Register Page**: User registration with database storage
- **Home Page**: Personalized welcome message after successful login
- **Logout Functionality**: Secure session termination
- **Database Integration**: PostgreSQL with custom login table

### Infrastructure
- **AWS EC2 Instances**: Free-tier eligible t2.micro instances
- **Elastic IPs**: Static public IPs for all instances
- **Security Groups**: Configured for HTTP, HTTPS, SSH, and Docker Swarm ports
- **VPC Configuration**: Custom VPC with public subnet and internet gateway

### Container Orchestration
- **Docker Swarm**: Multi-node cluster with manager and workers
- **Service Replication**: Web service with 2 replicas for high availability
- **Overlay Network**: Secure communication between services
- **Volume Persistence**: PostgreSQL data persistence

### CI/CD Pipeline
- **Automated Testing**: Django unit tests and Selenium integration tests
- **Docker Image Building**: Automated image build and push to GitHub Container Registry
- **Infrastructure Deployment**: Terraform apply and Ansible configuration
- **Health Checks**: Application accessibility verification

## Prerequisites

### Local Development
- Python 3.8+
- Docker and Docker Compose
- Terraform >= 1.0
- Ansible >= 2.9
- AWS CLI configured

### AWS Requirements
- AWS Account with free-tier eligibility
- AWS CLI configured with appropriate permissions
- EC2, VPC, and IAM permissions

## Quick Start

### 1. Clone and Setup
`ash
git clone https://github.com/Madhuraaa22/DevOpsAssign12.git
cd DevOpsAssign12
`

### 2. Configure AWS Credentials
`ash
aws configure
`

### 3. Run Bootstrap Script
`ash
chmod +x scripts/bootstrap.sh
./scripts/bootstrap.sh
`

The bootstrap script will:
1. Provision AWS infrastructure with Terraform
2. Configure servers with Ansible
3. Deploy the application stack with Docker Swarm
4. Verify deployment and display access information

### 4. Access Application
After successful deployment, access the application at:
- **Web Application**: http://<swarm-manager-ip>
- **Login Page**: http://<swarm-manager-ip>/login/
- **Register Page**: http://<swarm-manager-ip>/register/

### 5. Test Credentials
- **Username**: ITA773
- **Password**: 2022PE0000

## Manual Deployment Steps

### 1. Infrastructure Provisioning
`ash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
`

### 2. Server Configuration
`ash
cd ../ansible
# Update inventory.ini with actual IPs from Terraform output
ansible-playbook -i inventory.ini site.yml
`

### 3. Application Deployment
The Ansible playbook automatically deploys the application stack to Docker Swarm.

## Testing

### Automated Testing
`ash
cd selenium
pip install -r requirements.txt
python test_app.py --url http://<swarm-manager-ip>
`

### Manual Testing
1. Navigate to the application URL
2. Register a new user
3. Login with credentials
4. Verify home page displays correct message
5. Test logout functionality

## Management Commands

### Docker Swarm Management
`ash
# SSH to manager node
ssh -i terraform/terraform-key.pem ubuntu@<manager-ip>

# Check services
docker service ls

# Check stack
docker stack services devops-app

# View logs
docker service logs devops-app_web

# Scale service
docker service scale devops-app_web=3
`

## CI/CD Pipeline

The GitHub Actions workflow (.github/workflows/ci-cd.yml) includes:
- **Test Stage**: Django unit tests and Selenium integration tests
- **Build Stage**: Docker image build and push to registry
- **Deploy Stage**: Infrastructure provisioning and application deployment
- **Cleanup Stage**: Resource cleanup for pull requests

### Required Secrets
Configure the following secrets in GitHub repository:
- AWS_ACCESS_KEY_ID: AWS access key
- AWS_SECRET_ACCESS_KEY: AWS secret key
- GITHUB_TOKEN: GitHub token for container registry

## Cleanup

### Destroy Infrastructure
`ash
cd terraform
terraform destroy -auto-approve
`

### Remove Docker Stack
`ash
ssh -i terraform/terraform-key.pem ubuntu@<manager-ip>
docker stack rm devops-app
`

## Security Considerations

- **Database**: PostgreSQL runs in isolated container with custom authentication
- **Network**: Docker Swarm overlay network provides secure service communication
- **Access**: SSH key-based authentication for all instances
- **Secrets**: Environment variables for sensitive configuration

## Performance Optimization

- **Load Balancing**: Docker Swarm provides built-in load balancing
- **Service Replication**: Web service runs with 2 replicas
- **Resource Limits**: Configured for free-tier instances
- **Caching**: Django static files served efficiently

---

**Note**: This project is designed for educational purposes and uses free-tier AWS resources. Ensure proper cleanup to avoid charges.


<!-- Deployment triggered on 10/27/2025 00:57:38 -->
