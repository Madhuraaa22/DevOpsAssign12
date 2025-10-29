#!/bin/bash

# DevOps Assignment Bootstrap Script
# This script automates the entire deployment process

set -e

echo "ðŸš€ Starting DevOps Assignment Bootstrap Process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "[INFO] "
}

print_warning() {
    echo -e "[WARNING] "
}

print_error() {
    echo -e "[ERROR] "
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if AWS CLI is installed
    if ! command -v aws &> /dev/null; then
        print_error "AWS CLI is not installed. Please install it first."
        exit 1
    fi
    
    # Check if Terraform is installed
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform is not installed. Please install it first."
        exit 1
    fi
    
    # Check if Ansible is installed
    if ! command -v ansible &> /dev/null; then
        print_error "Ansible is not installed. Please install it first."
        exit 1
    fi
    
    # Check AWS credentials
    if ! aws sts get-caller-identity &> /dev/null; then
        print_error "AWS credentials not configured. Please run 'aws configure' first."
        exit 1
    fi
    
    print_status "All prerequisites met!"
}

# Deploy infrastructure with Terraform
deploy_infrastructure() {
    print_status "Deploying AWS infrastructure with Terraform..."
    
    cd terraform
    
    # Initialize Terraform
    print_status "Initializing Terraform..."
    terraform init
    
    # Plan deployment
    print_status "Planning Terraform deployment..."
    terraform plan
    
    # Apply deployment
    print_status "Applying Terraform configuration..."
    terraform apply -auto-approve
    
    # Get outputs
    print_status "Getting Terraform outputs..."
    CONTROLLER_IP=
    MANAGER_IP=
    WORKER_A_IP=
    WORKER_B_IP=
    
    print_status "Infrastructure deployed successfully!"
    print_status "Controller IP: "
    print_status "Swarm Manager IP: "
    print_status "Swarm Worker A IP: "
    print_status "Swarm Worker B IP: "
    
    cd ..
}

# Update Ansible inventory
update_inventory() {
    print_status "Updating Ansible inventory with actual IPs..."
    
    cd ansible
    
    # Replace placeholder IPs with actual IPs
    sed -i "s/SWARM_MANAGER_IP//g" inventory.ini
    sed -i "s/SWARM_WORKER_A_IP//g" inventory.ini
    sed -i "s/SWARM_WORKER_B_IP//g" inventory.ini
    
    print_status "Inventory updated successfully!"
    cd ..
}

# Wait for instances to be ready
wait_for_instances() {
    print_status "Waiting for EC2 instances to be ready..."
    print_warning "This may take 2-3 minutes..."
    sleep 120
    print_status "Instances should be ready now!"
}

# Configure servers with Ansible
configure_servers() {
    print_status "Configuring servers with Ansible..."
    
    cd ansible
    
    # Install Docker on all nodes
    print_status "Installing Docker on all nodes..."
    ansible-playbook -i inventory.ini install_docker.yml --ssh-common-args="-o StrictHostKeyChecking=no"
    
    # Setup Docker Swarm
    print_status "Setting up Docker Swarm cluster..."
    ansible-playbook -i inventory.ini setup_swarm.yml --ssh-common-args="-o StrictHostKeyChecking=no"
    
    # Deploy application stack
    print_status "Deploying application stack..."
    ansible-playbook -i inventory.ini deploy_stack.yml --ssh-common-args="-o StrictHostKeyChecking=no"
    
    print_status "Server configuration completed!"
    cd ..
}

# Run tests
run_tests() {
    print_status "Running Selenium tests..."
    
    cd selenium
    
    # Install Selenium if not already installed
    pip install selenium
    
    # Run tests
    python test_app.py --url http://
    
    print_status "Tests completed successfully!"
    cd ..
}

# Display final information
display_final_info() {
    print_status "ðŸŽ‰ Deployment completed successfully!"
    echo ""
    echo "ðŸ“‹ Deployment Summary:"
    echo "====================="
    echo "Controller IP: "
    echo "Swarm Manager IP: "
    echo "Swarm Worker A IP: "
    echo "Swarm Worker B IP: "
    echo ""
    echo "ðŸŒ Application URLs:"
    echo "==================="
    echo "Django App: http://"
    echo "Login: http:///login/"
    echo "Register: http:///register/"
    echo ""
    echo "ðŸ”§ Management Commands:"
    echo "======================"
    echo "SSH to Manager: ssh -i terraform/terraform-key.pem ubuntu@"
    echo "View Services: ssh -i terraform/terraform-key.pem ubuntu@ 'docker service ls'"
    echo "Scale Web Service: ssh -i terraform/terraform-key.pem ubuntu@ 'docker service scale devops_app_web=3'"
    echo ""
    echo "ðŸ§¹ Cleanup:"
    echo "==========="
    echo "To destroy infrastructure: cd terraform && terraform destroy -auto-approve"
}

# Main execution
main() {
    print_status "Starting DevOps Assignment Bootstrap Process..."
    
    check_prerequisites
    deploy_infrastructure
    update_inventory
    wait_for_instances
    configure_servers
    run_tests
    display_final_info
}

# Run main function
main "$@"
