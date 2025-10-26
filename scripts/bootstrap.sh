#!/bin/bash

# DevOps Assignment Bootstrap Script
set -e

echo "Starting DevOps Assignment Bootstrap Script..."

# Check prerequisites
echo "Checking prerequisites..."
if ! command -v terraform &> /dev/null; then
    echo "Error: Terraform is not installed"
    exit 1
fi

if ! command -v ansible &> /dev/null; then
    echo "Error: Ansible is not installed"
    exit 1
fi

if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed"
    exit 1
fi

echo "âœ“ All prerequisites are met!"

# Run Terraform
echo "Running Terraform..."
cd terraform
terraform init
terraform plan
terraform apply -auto-approve

# Get outputs
SWARM_MANAGER_IP=
echo "Swarm Manager IP: "

cd ..

# Update Ansible inventory
echo "Updating Ansible inventory..."
sed -i "s/SWARM_MANAGER_IP//g" ansible/inventory.ini

# Wait for instances
echo "Waiting for instances to be ready..."
sleep 120

# Run Ansible
echo "Running Ansible..."
cd ansible
ansible-playbook -i inventory.ini site.yml

echo "âœ“ Deployment completed successfully!"
echo "Access the application at: http://"
