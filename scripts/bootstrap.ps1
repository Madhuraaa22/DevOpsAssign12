# DevOps Assignment Bootstrap Script (PowerShell)
# This script automates the entire deployment process

param(
    [switch] = False
)

# Colors for output
 = "Red"
 = "Green"
 = "Yellow"

# Function to print colored output
function Write-Status {
    param([string])
    Write-Host "[INFO] " -ForegroundColor 
}

function Write-Warning {
    param([string])
    Write-Host "[WARNING] " -ForegroundColor 
}

function Write-Error {
    param([string])
    Write-Host "[ERROR] " -ForegroundColor 
}

# Check prerequisites
function Test-Prerequisites {
    Write-Status "Checking prerequisites..."
    
    # Check if AWS CLI is installed
    if (-not (Get-Command aws -ErrorAction SilentlyContinue)) {
        Write-Error "AWS CLI is not installed. Please install it first."
        exit 1
    }
    
    # Check if Terraform is installed
    if (-not (Get-Command terraform -ErrorAction SilentlyContinue)) {
        Write-Error "Terraform is not installed. Please install it first."
        exit 1
    }
    
    # Check if Ansible is installed
    if (-not (Get-Command ansible -ErrorAction SilentlyContinue)) {
        Write-Error "Ansible is not installed. Please install it first."
        exit 1
    }
    
    # Check AWS credentials
    try {
        aws sts get-caller-identity | Out-Null
    }
    catch {
        Write-Error "AWS credentials not configured. Please run 'aws configure' first."
        exit 1
    }
    
    Write-Status "All prerequisites met!"
}

# Deploy infrastructure with Terraform
function Deploy-Infrastructure {
    Write-Status "Deploying AWS infrastructure with Terraform..."
    
    Set-Location terraform
    
    # Initialize Terraform
    Write-Status "Initializing Terraform..."
    terraform init
    
    # Plan deployment
    Write-Status "Planning Terraform deployment..."
    terraform plan
    
    # Apply deployment
    Write-Status "Applying Terraform configuration..."
    terraform apply -auto-approve
    
    # Get outputs
    Write-Status "Getting Terraform outputs..."
     = terraform output -raw controller_public_ip
     = terraform output -raw swarm_manager_public_ip
     = terraform output -raw swarm_worker_a_public_ip
     = terraform output -raw swarm_worker_b_public_ip
    
    Write-Status "Infrastructure deployed successfully!"
    Write-Status "Controller IP: "
    Write-Status "Swarm Manager IP: "
    Write-Status "Swarm Worker A IP: "
    Write-Status "Swarm Worker B IP: "
    
    Set-Location ..
}

# Update Ansible inventory
function Update-Inventory {
    Write-Status "Updating Ansible inventory with actual IPs..."
    
    Set-Location ansible
    
    # Replace placeholder IPs with actual IPs
    (Get-Content inventory.ini) -replace "SWARM_MANAGER_IP",  | Set-Content inventory.ini
    (Get-Content inventory.ini) -replace "SWARM_WORKER_A_IP",  | Set-Content inventory.ini
    (Get-Content inventory.ini) -replace "SWARM_WORKER_B_IP",  | Set-Content inventory.ini
    
    Write-Status "Inventory updated successfully!"
    Set-Location ..
}

# Wait for instances to be ready
function Wait-ForInstances {
    Write-Status "Waiting for EC2 instances to be ready..."
    Write-Warning "This may take 2-3 minutes..."
    Start-Sleep -Seconds 120
    Write-Status "Instances should be ready now!"
}

# Configure servers with Ansible
function Configure-Servers {
    Write-Status "Configuring servers with Ansible..."
    
    Set-Location ansible
    
    # Install Docker on all nodes
    Write-Status "Installing Docker on all nodes..."
    ansible-playbook -i inventory.ini install_docker.yml --ssh-common-args="-o StrictHostKeyChecking=no"
    
    # Setup Docker Swarm
    Write-Status "Setting up Docker Swarm cluster..."
    ansible-playbook -i inventory.ini setup_swarm.yml --ssh-common-args="-o StrictHostKeyChecking=no"
    
    # Deploy application stack
    Write-Status "Deploying application stack..."
    ansible-playbook -i inventory.ini deploy_stack.yml --ssh-common-args="-o StrictHostKeyChecking=no"
    
    Write-Status "Server configuration completed!"
    Set-Location ..
}

# Run tests
function Invoke-Tests {
    if () {
        Write-Warning "Skipping tests as requested."
        return
    }
    
    Write-Status "Running Selenium tests..."
    
    Set-Location selenium
    
    # Install Selenium if not already installed
    pip install selenium
    
    # Run tests
    python test_app.py --url "http://"
    
    Write-Status "Tests completed successfully!"
    Set-Location ..
}

# Display final information
function Show-FinalInfo {
    Write-Status "ðŸŽ‰ Deployment completed successfully!"
    Write-Host ""
    Write-Host "ðŸ“‹ Deployment Summary:" -ForegroundColor 
    Write-Host "=====================" -ForegroundColor 
    Write-Host "Controller IP: "
    Write-Host "Swarm Manager IP: "
    Write-Host "Swarm Worker A IP: "
    Write-Host "Swarm Worker B IP: "
    Write-Host ""
    Write-Host "ðŸŒ Application URLs:" -ForegroundColor 
    Write-Host "===================" -ForegroundColor 
    Write-Host "Django App: http://"
    Write-Host "Login: http:///login/"
    Write-Host "Register: http:///register/"
    Write-Host ""
    Write-Host "ðŸ”§ Management Commands:" -ForegroundColor 
    Write-Host "======================" -ForegroundColor 
    Write-Host "SSH to Manager: ssh -i terraform/terraform-key.pem ubuntu@"
    Write-Host "View Services: ssh -i terraform/terraform-key.pem ubuntu@ 'docker service ls'"
    Write-Host "Scale Web Service: ssh -i terraform/terraform-key.pem ubuntu@ 'docker service scale devops_app_web=3'"
    Write-Host ""
    Write-Host "ðŸ§¹ Cleanup:" -ForegroundColor 
    Write-Host "===========" -ForegroundColor 
    Write-Host "To destroy infrastructure: cd terraform && terraform destroy -auto-approve"
}

# Main execution
function Main {
    Write-Status "Starting DevOps Assignment Bootstrap Process..."
    
    Test-Prerequisites
    Deploy-Infrastructure
    Update-Inventory
    Wait-ForInstances
    Configure-Servers
    Invoke-Tests
    Show-FinalInfo
}

# Run main function
Main
