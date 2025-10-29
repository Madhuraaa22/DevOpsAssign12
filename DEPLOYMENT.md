# Deployment Guide - DevOps Assignment

## ðŸš€ Quick Deployment Steps

### Prerequisites Setup

1. **Install Required Tools**
   `ash
   # Install AWS CLI
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install

   # Install Terraform
   wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
   unzip terraform_1.5.0_linux_amd64.zip
   sudo mv terraform /usr/local/bin/

   # Install Ansible
   sudo apt update
   sudo apt install ansible -y

   # Install Docker
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   sudo usermod -aG docker 
   `

2. **Configure AWS Credentials**
   `ash
   aws configure
   # Enter your AWS Access Key ID
   # Enter your AWS Secret Access Key
   # Enter your default region (e.g., us-east-1)
   # Enter default output format (json)
   `

### Automated Deployment

1. **Clone Repository**
   `ash
   git clone https://github.com/suyog1329/DevOpsAssign12.git
   cd DevOpsAssign12
   `

2. **Run Bootstrap Script**
   `ash
   # For Linux/Mac
   chmod +x scripts/*.sh
   ./scripts/bootstrap.sh

   # For Windows PowerShell
   .\scripts\bootstrap.ps1
   `

3. **Wait for Deployment**
   - The script will take approximately 10-15 minutes
   - Monitor the output for any errors
   - Note down the IP addresses displayed at the end

### Manual Deployment (Step by Step)

1. **Deploy Infrastructure**
   `ash
   cd terraform
   terraform init
   terraform plan
   terraform apply -auto-approve
   `

2. **Get IP Addresses**
   `ash
   terraform output
   # Note down all the IP addresses
   `

3. **Update Ansible Inventory**
   `ash
   cd ../ansible
   # Edit inventory.ini and replace placeholder IPs with actual IPs
   nano inventory.ini
   `

4. **Configure Servers**
   `ash
   # Install Docker
   ansible-playbook -i inventory.ini install_docker.yml

   # Setup Swarm
   ansible-playbook -i inventory.ini setup_swarm.yml

   # Deploy Application
   ansible-playbook -i inventory.ini deploy_stack.yml
   `

5. **Test Application**
   `ash
   cd ../selenium
   pip install -r requirements.txt
   python test_app.py --url http://MANAGER_IP:8000
   `

## ðŸ” Verification Steps

1. **Check Infrastructure**
   `ash
   cd terraform
   terraform show
   `

2. **Check Docker Swarm**
   `ash
   ssh -i terraform/terraform-key.pem ubuntu@MANAGER_IP
   docker node ls
   docker service ls
   `

3. **Test Application**
   - Open browser: http://MANAGER_IP:8000
   - Register a new user
   - Login with credentials
   - Verify personalized message

## ðŸ› ï¸ Troubleshooting

### Common Issues

1. **Terraform Apply Fails**
   - Check AWS credentials: ws sts get-caller-identity
   - Verify region settings
   - Check for resource limits in AWS console

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

# View application logs
ssh -i terraform/terraform-key.pem ubuntu@MANAGER_IP "docker service logs devops_app_web"
`

## ðŸ§¹ Cleanup

To destroy all AWS resources:
`ash
# Using script
./scripts/cleanup.sh

# Manual cleanup
cd terraform
terraform destroy -auto-approve
`

## ðŸ“Š Monitoring

### Health Check
`ash
# Run health check
./scripts/health_check.sh

# Or manually check
curl http://MANAGER_IP:8000/login/
curl http://MANAGER_IP:8000/register/
`

### Scaling
`ash
# Scale web service
ssh -i terraform/terraform-key.pem ubuntu@MANAGER_IP "docker service scale devops_app_web=3"
`

## ðŸ“ Notes

- All instances are t2.micro (free tier eligible)
- Elastic IPs are attached to all instances
- Security groups allow necessary ports
- Database data persists in Docker volumes
- Application supports horizontal scaling

## ðŸ†˜ Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review the logs for error messages
3. Verify all prerequisites are installed
4. Ensure AWS credentials are properly configured
5. Check AWS service limits and quotas
