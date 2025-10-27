# DevOps Assignment - Django Authentication System

A comprehensive Django-based authentication system with login, registration, and home page functionality, deployed using DevOps practices including Docker, Terraform, Ansible, and CI/CD pipelines.

---

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Architecture](#architecture)
- [Screenshots](#screenshots)
- [Prerequisites](#prerequisites)
- [Installation & Setup](#installation--setup)
- [Running Locally](#running-locally)
- [DevOps Pipeline](#devops-pipeline)
- [Testing](#testing)
- [Deployment](#deployment)
- [Project Structure](#project-structure)
- [Technologies Used](#technologies-used)
- [Troubleshooting](#troubleshooting)
- [Cleanup](#cleanup)
- [Contributing](#contributing)

---

## 🎯 Project Overview

This project implements a complete DevOps pipeline for a Django-PostgreSQL application with user authentication features. It demonstrates:

- **Infrastructure as Code** using Terraform
- **Configuration Management** using Ansible
- **Container Orchestration** using Docker Swarm
- **CI/CD Pipeline** using GitHub Actions
- **Automated Testing** using Selenium
- **Database Integration** with PostgreSQL

---

## ✨ Features

### Application Features

- **User Registration**: New users can register with username and password
- **User Login**: Secure authentication using Django's authentication system
- **Protected Home Page**: Personalized welcome message after successful login
- **Logout Functionality**: Secure session termination
- **Database Integration**: PostgreSQL with custom authentication table
- **Modern UI**: Responsive design with gradient backgrounds

### DevOps Features

- AWS EC2 deployment with Terraform
- Ansible-based configuration management
- Docker Swarm orchestration with multi-node cluster
- Service replication for high availability
- Automated CI/CD pipeline with GitHub Actions
- Selenium integration tests

---

## 🏗️ Architecture

### Infrastructure Components

| Component | Description | Instance Type |
|-----------|-------------|---------------|
| **Controller** | Terraform + Ansible + CI runner | t2.micro |
| **Swarm Manager** | Docker Swarm manager node | t2.micro + EIP |
| **Swarm Worker A** | Django container replicas | t2.micro + EIP |
| **Swarm Worker B** | Django container replicas | t2.micro + EIP |

### Application Stack

```
┌─────────────────────────────────────┐
│         Load Balancer               │
│     (Docker Swarm Built-in)         │
└──────────────┬──────────────────────┘
               │
        ┌──────┴───────┐
        │              │
┌───────▼──────┐  ┌────▼──────────┐
│   Django     │  │   Django      │
│  Container   │  │  Container    │
│  (Replica 1) │  │  (Replica 2)  │
└──────┬───────┘  └────┬──────────┘
       │               │
       └───────┬───────┘
               │
        ┌──────▼────────┐
        │  PostgreSQL   │
        │   Database    │
        └───────────────┘
```

---

## 📸 Screenshots

### 1. Login Page
<img width="1919" height="989" alt="Screenshot 2025-10-27 204803" src="https://github.com/user-attachments/assets/5a8dbddf-bd1a-46c1-aa12-65514cbcfbac" />

*User login page with username (Roll No) and password (Admission No) authentication*

**Local URL**: `http://127.0.0.1:8000/login/`

---

### 2. Register Page
<img width="1916" height="976" alt="Screenshot 2025-10-27 204732" src="https://github.com/user-attachments/assets/9ba68373-6ddc-403d-86eb-4fd72b55527c" />

*User registration page for creating new accounts*

**Local URL**: `http://127.0.0.1:8000/register/`

---

### 3. Home Page
<img width="1919" height="988" alt="Screenshot 2025-10-27 204827" src="https://github.com/user-attachments/assets/f24ed13f-157f-4cba-bdc4-f126d87df6d5" />

*Protected home page displaying personalized welcome message after successful login*

**Local URL**: `http://127.0.0.1:8000/home/`

---

**Local URL**: `http://127.0.0.1:8000/`

---

## 📦 Prerequisites

### Local Development

- Python 3.8 or higher
- pip (Python package manager)
- Git
- Code editor (VS Code recommended)

### DevOps Deployment

- Docker and Docker Compose
- Terraform >= 1.0
- Ansible >= 2.9
- AWS CLI configured
- AWS Account with appropriate permissions

---

## 🚀 Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Madhuraaa22/DevOpsAssign12.git
cd DevOpsAssign12
```

### 2. Create Virtual Environment (Recommended)

```bash
# Windows
python -m venv venv
venv\Scripts\activate

# Linux/Mac
python3 -m venv venv
source venv/bin/activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

---

## 💻 Running Locally

### Step 1: Navigate to Django App

```bash
cd django_app
```

### Step 2: Run Database Migrations

```bash
python manage.py makemigrations
python manage.py migrate
```

### Step 3: Create Superuser (Optional)

```bash
python manage.py createsuperuser
```

### Step 4: Start Development Server

```bash
python manage.py runserver
```

### Step 5: Access the Application

Open your browser and navigate to:

- **Login Page**: http://127.0.0.1:8000/login/
- **Register Page**: http://127.0.0.1:8000/register/
- **Home Page**: http://127.0.0.1:8000/home/ (after login)

### Test Credentials

For testing, you can use:
- **Username**: ITA773
- **Password**: 2022PE0000

---

## 🔄 DevOps Pipeline

### Quick Start with Bootstrap Script

```bash
# Configure AWS credentials
aws configure

# Run bootstrap script
chmod +x scripts/bootstrap.sh
./scripts/bootstrap.sh
```

The bootstrap script automatically:
1. Provisions AWS infrastructure with Terraform
2. Configures servers with Ansible
3. Deploys application stack with Docker Swarm
4. Verifies deployment and displays access information

### Manual Deployment Steps

#### 1. Infrastructure Provisioning

```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

#### 2. Server Configuration

```bash
cd ../ansible
# Update inventory.ini with actual IPs from Terraform output
ansible-playbook -i inventory.ini site.yml
```

#### 3. Application Deployment

The Ansible playbook automatically deploys the application stack to Docker Swarm.

### CI/CD Pipeline

GitHub Actions workflow includes:

- **Test Stage**: Django unit tests and Selenium integration tests
- **Build Stage**: Docker image build and push to GitHub Container Registry
- **Deploy Stage**: Infrastructure provisioning and application deployment
- **Cleanup Stage**: Resource cleanup for pull requests

#### Required GitHub Secrets

Configure these secrets in your GitHub repository settings:

- `AWS_ACCESS_KEY_ID`: Your AWS access key
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret key
- `GITHUB_TOKEN`: GitHub token for container registry

---

## 🧪 Testing

### Automated Testing

```bash
cd selenium
pip install -r requirements.txt
python test_app.py --url http://<swarm-manager-ip>
```

### Manual Testing Checklist

- [ ] Navigate to the application URL
- [ ] Register a new user on `/register/`
- [ ] Login with created credentials on `/login/`
- [ ] Verify home page displays correct welcome message
- [ ] Test logout functionality
- [ ] Verify redirect after logout

---

## 🌐 Deployment

### Docker Swarm Management

#### SSH to Manager Node

```bash
ssh -i terraform/terraform-key.pem ubuntu@<manager-ip>
```

#### Check Services

```bash
docker service ls
docker stack services devops-app
```

#### View Logs

```bash
docker service logs devops-app_web
```

#### Scale Service

```bash
docker service scale devops-app_web=3
```

### Access Deployed Application

After successful deployment:

- **Web Application**: `http://<swarm-manager-ip>`
- **Login Page**: `http://<swarm-manager-ip>/login/`
- **Register Page**: `http://<swarm-manager-ip>/register/`

---

## 📁 Project Structure

```
DevOpsAssign12/
├── terraform/              # Terraform infrastructure code
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── ansible/                # Ansible playbooks and configuration
│   ├── inventory.ini
│   ├── site.yml
│   └── roles/
├── docker/                 # Docker configuration files
│   ├── Dockerfile
│   └── docker-compose.yml
├── django_app/             # Django application source code
│   ├── auth_app/          # Authentication app
│   ├── devops_assignment/ # Project settings
│   ├── templates/         # HTML templates
│   └── manage.py
├── scripts/                # Bootstrap and helper scripts
│   └── bootstrap.sh
├── ci/                     # CI/CD pipeline configuration
│   └── .github/workflows/
├── selenium/               # Selenium test scripts
│   └── test_app.py
├── screenshots/            # Application screenshots
├── requirements.txt        # Python dependencies
├── .gitignore             # Git ignore file
└── README.md              # This file
```

---

## 🛠️ Technologies Used

### Backend
- **Python 3.12**: Programming language
- **Django 4.2**: Web framework
- **PostgreSQL**: Database

### Frontend
- **HTML5**: Markup
- **CSS3**: Styling (with gradients and modern design)
- **JavaScript**: Client-side interactivity

### DevOps
- **Docker**: Containerization
- **Docker Swarm**: Orchestration
- **Terraform**: Infrastructure as Code
- **Ansible**: Configuration Management
- **GitHub Actions**: CI/CD Pipeline
- **AWS EC2**: Cloud hosting
- **Selenium**: Automated testing

---

## 🔧 Troubleshooting

### Database Issues

```bash
# Reset database
python manage.py flush

# Create new migrations
python manage.py makemigrations
python manage.py migrate
```

### Port Already in Use

```bash
# Windows - Find process using port 8000
netstat -ano | findstr :8000
taskkill /PID <PID> /F

# Linux/Mac
lsof -ti:8000 | xargs kill -9
```

### Static Files Not Loading

```bash
python manage.py collectstatic
```

### Docker Swarm Issues

```bash
# Reinitialize swarm
docker swarm leave --force
docker swarm init

# Remove and redeploy stack
docker stack rm devops-app
docker stack deploy -c docker-compose.yml devops-app
```

---

## 🧹 Cleanup

### Destroy AWS Infrastructure

```bash
cd terraform
terraform destroy -auto-approve
```

### Remove Docker Stack

```bash
ssh -i terraform/terraform-key.pem ubuntu@<manager-ip>
docker stack rm devops-app
```

### Deactivate Virtual Environment

```bash
deactivate
```

---

## 🔒 Security Considerations

- **Database**: PostgreSQL with custom authentication table
- **Network**: Docker Swarm overlay network for secure communication
- **Access**: SSH key-based authentication for all instances
- **Secrets**: Environment variables for sensitive configuration
- **Session Management**: Django's secure session handling

---

## 🚀 Performance Optimization

- **Load Balancing**: Docker Swarm built-in load balancing
- **Service Replication**: Web service with 2 replicas for high availability
- **Resource Limits**: Optimized for free-tier AWS instances
- **Caching**: Django static file caching enabled

---

## 📝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed for educational purposes.

---

## 👤 Author

**Madhura**
- GitHub: [@Madhuraaa22](https://github.com/Madhuraaa22)
- Repository: [DevOpsAssign12](https://github.com/Madhuraaa22/DevOpsAssign12)

---

