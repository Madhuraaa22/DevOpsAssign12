# DevOps Assignment - Django PostgreSQL Application

## ðŸŽ¯ Project Overview

This project implements a complete DevOps pipeline for a Django-PostgreSQL web application with:
- **AWS Infrastructure**: Provisioned using Terraform
- **Server Configuration**: Automated using Ansible
- **Container Orchestration**: Docker Swarm with Docker Compose
- **CI/CD Pipeline**: GitHub Actions with automated testing
- **Monitoring**: Selenium-based automated testing

## ðŸ—ï¸ Architecture

### Infrastructure Components
- **Controller** (t2.micro): Terraform + Ansible + CI runner
- **Swarm Manager** (t2.micro + EIP): Docker Swarm manager node
- **Swarm Worker A** (t2.micro + EIP): Django container replicas
- **Swarm Worker B** (t2.micro + EIP): PostgreSQL container replicas

### Application Features
- Django login/register system with PostgreSQL backend
- Beautiful, responsive UI with modern design
- User authentication against custom login table
- Personalized welcome messages
- Secure session management

## ðŸ“ Project Structure

`
â”œâ”€â”€ terraform/              # Terraform configuration files
â”‚   â””â”€â”€ main.tf            # AWS infrastructure definition
â”œâ”€â”€ ansible/               # Ansible playbooks and inventory
â”‚   â”œâ”€â”€ inventory.ini      # Server inventory
â”‚   â”œâ”€â”€ install_docker.yml # Docker installation playbook
â”‚   â”œâ”€â”€ setup_swarm.yml    # Docker Swarm setup playbook
â”‚   â””â”€â”€ deploy_stack.yml   # Application deployment playbook
â”œâ”€â”€ docker/                # Docker configuration
â”‚   â”œâ”€â”€ Dockerfile         # Django application container
â”‚   â””â”€â”€ docker-compose.yml # Docker Swarm stack definition
â”œâ”€â”€ django_app/            # Django application source code
â”‚   â”œâ”€â”€ devops_app/        # Django project settings
â”‚   â”œâ”€â”€ auth_app/          # Authentication app
â”‚   â”œâ”€â”€ templates/         # HTML templates
â”‚   â””â”€â”€ requirements.txt   # Python dependencies
â”œâ”€â”€ scripts/               # Automation scripts
â”‚   â”œâ”€â”€ bootstrap.sh       # Main deployment script (Linux/Mac)
â”‚   â”œâ”€â”€ bootstrap.ps1      # Main deployment script (Windows)
â”‚   â”œâ”€â”€ cleanup.sh         # Infrastructure cleanup script
â”‚   â””â”€â”€ health_check.ps1   # Health monitoring script
â”œâ”€â”€ ci/                    # CI/CD pipeline configurations
â”‚   â””â”€â”€ .github/workflows/ # GitHub Actions workflows
â”œâ”€â”€ selenium/              # Automated testing
â”‚   â””â”€â”€ test_app.py        # Selenium test suite
â””â”€â”€ README.md              # This file
`

## ðŸš€ Quick Start

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform installed (v1.5.0+)
- Ansible installed (v2.9+)
- Docker installed (for local development)
- Python 3.8+ (for local development)

### Automated Deployment

#### Linux/Mac
`ash
# Clone the repository
git clone https://github.com/suyog1329/DevOpsAssign12.git
cd DevOpsAssign12

# Make scripts executable
chmod +x scripts/*.sh

# Run the bootstrap script
./scripts/bootstrap.sh
`

#### Windows
`powershell
# Clone the repository
git clone https://github.com/suyog1329/DevOpsAssign12.git
cd DevOpsAssign12

# Run the bootstrap script
.\scripts\bootstrap.ps1
`

### Manual Deployment

1. **Deploy Infrastructure**
   `ash
   cd terraform
   terraform init
   terraform plan
   terraform apply -auto-approve
   `

2. **Configure Servers**
   `ash
   cd ansible
   # Update inventory.ini with actual IPs
   ansible-playbook -i inventory.ini install_docker.yml
   ansible-playbook -i inventory.ini setup_swarm.yml
   ansible-playbook -i inventory.ini deploy_stack.yml
   `

3. **Test Application**
   `ash
   cd selenium
   python test_app.py --url http://MANAGER_IP:8000
   `

## ðŸŒ Application URLs

After successful deployment, access the application at:
- **Main Application**: http://MANAGER_IP:8000
- **Login Page**: http://MANAGER_IP:8000/login/
- **Register Page**: http://MANAGER_IP:8000/register/

### Test Credentials
- **Username**: ITA733 (Roll Number)
- **Password**: 2022PE0000 (Admission Number)

## ðŸ”§ Management Commands

### Docker Swarm Management
`ash
# SSH to manager node
ssh -i terraform/terraform-key.pem ubuntu@MANAGER_IP

# View running services
docker service ls

# Scale web service
docker service scale devops_app_web=3

# View service logs
docker service logs devops_app_web

# Update service
docker service update --image new-image devops_app_web
`

### Health Monitoring
`ash
# Run health check
./scripts/health_check.sh

# Or on Windows
.\scripts\health_check.ps1
`

## ðŸ§ª Testing

### Automated Testing
The project includes comprehensive Selenium-based testing:
- Login page accessibility
- Registration functionality
- User authentication
- Home page display
- Logout functionality

### Manual Testing
1. Navigate to the login page
2. Click "Register here" to create a new account
3. Use the registered credentials to login
4. Verify the personalized welcome message
5. Test logout functionality

## ðŸ”„ CI/CD Pipeline

The GitHub Actions pipeline includes:
1. **Code Quality**: Linting and syntax checking
2. **Testing**: Automated test execution
3. **Infrastructure**: Terraform deployment
4. **Configuration**: Ansible server setup
5. **Deployment**: Docker Swarm stack deployment
6. **Validation**: Selenium test execution

### Pipeline Triggers
- Push to main branch: Runs tests only
- Push to ITA733 branch: Full deployment pipeline
- Pull requests: Runs tests and validation

## ðŸ§¹ Cleanup

To destroy all AWS resources:
`ash
# Linux/Mac
./scripts/cleanup.sh

# Windows
cd terraform
terraform destroy -auto-approve
`

## ðŸ“Š Monitoring and Logging

### Application Logs
`ash
# View Django application logs
ssh -i terraform/terraform-key.pem ubuntu@MANAGER_IP "docker service logs devops_app_web"

# View database logs
ssh -i terraform/terraform-key.pem ubuntu@MANAGER_IP "docker service logs devops_app_db"
`

### System Monitoring
`ash
# Check system resources
ssh -i terraform/terraform-key.pem ubuntu@MANAGER_IP "docker system df"

# View node status
ssh -i terraform/terraform-key.pem ubuntu@MANAGER_IP "docker node ls"
`

## ðŸ› ï¸ Troubleshooting

### Common Issues

1. **Terraform Apply Fails**
   - Check AWS credentials: ws sts get-caller-identity
   - Verify region settings
   - Check for resource limits

2. **Ansible Connection Issues**
   - Verify security group allows SSH (port 22)
   - Check instance status in AWS console
   - Ensure private key permissions: chmod 400 terraform-key.pem

3. **Docker Swarm Issues**
   - Check if all nodes are joined: docker node ls
   - Verify network connectivity between nodes
   - Check service status: docker service ls

4. **Application Not Accessible**
   - Verify security group allows HTTP (port 80)
   - Check if services are running: docker service ps devops_app_web
   - Verify load balancer configuration

### Debug Commands
`ash
# Check Terraform state
cd terraform && terraform show

# Test Ansible connectivity
cd ansible && ansible all -i inventory.ini -m ping

# Check Docker Swarm status
ssh -i terraform/terraform-key.pem ubuntu@MANAGER_IP "docker system info"
`

## ðŸ“ˆ Scaling

### Horizontal Scaling
`ash
# Scale web service to 5 replicas
docker service scale devops_app_web=5

# Scale database service (if needed)
docker service scale devops_app_db=2
`

### Vertical Scaling
Modify the docker-compose.yml file to adjust resource limits:
`yaml
deploy:
  resources:
    limits:
      memory: 1G
      cpus: '0.5'
`

## ðŸ”’ Security Considerations

- All instances use security groups with minimal required ports
- Private keys are generated automatically and stored securely
- Database credentials are managed through environment variables
- HTTPS can be enabled by adding SSL certificates

## ðŸ“ Assignment Requirements Fulfilled

âœ… **Django Application**: Complete login/register system with PostgreSQL
âœ… **AWS Infrastructure**: Terraform-managed EC2 instances with Elastic IPs
âœ… **Server Configuration**: Ansible playbooks for automated setup
âœ… **Container Orchestration**: Docker Swarm with Docker Compose
âœ… **CI/CD Pipeline**: GitHub Actions with automated testing
âœ… **Monitoring**: Selenium-based test automation
âœ… **Documentation**: Comprehensive README and inline documentation

## ðŸ¤ Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## ðŸ“„ License

This project is created for educational purposes as part of a DevOps assignment.

## ðŸ‘¥ Authors

- **Student**: ITA733
- **Assignment**: DevOps Assignment 1 & 2
- **Institution**: [Your Institution Name]

---

**Note**: This project is designed for educational purposes and should not be used in production without proper security hardening and configuration.
