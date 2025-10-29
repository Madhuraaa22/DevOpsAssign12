# Health check script for DevOps Assignment (PowerShell)
# This script checks the health of all deployed services

param(
    [string] = ""
)

Write-Host "ðŸ¥ Running health checks..." -ForegroundColor Green

# Colors for output
 = "Red"
 = "Green"
 = "Yellow"

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

# Get manager IP from Terraform output if not provided
if (-not ) {
    Set-Location terraform
     = terraform output -raw swarm_manager_public_ip
    Set-Location ..
}

Write-Status "Checking Docker Swarm services..."

# Check if services are running
ssh -i terraform/terraform-key.pem -o StrictHostKeyChecking=no ubuntu@ "docker service ls"

Write-Status "Checking application health..."

# Test application endpoints
try {
    Invoke-WebRequest -Uri "http:///login/" -UseBasicParsing | Out-Null
    Write-Status "âœ“ Login page accessible"
}
catch {
    Write-Error "âœ— Login page not accessible"
}

try {
    Invoke-WebRequest -Uri "http:///register/" -UseBasicParsing | Out-Null
    Write-Status "âœ“ Register page accessible"
}
catch {
    Write-Error "âœ— Register page not accessible"
}

Write-Status "Health check completed!"
