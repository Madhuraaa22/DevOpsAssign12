#!/bin/bash

# Health check script for DevOps Assignment
# This script checks the health of all deployed services

set -e

echo "ðŸ¥ Running health checks..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "[INFO] "
}

print_warning() {
    echo -e "[WARNING] "
}

print_error() {
    echo -e "[ERROR] "
}

# Get manager IP from Terraform output
cd terraform
MANAGER_IP=
cd ..

print_status "Checking Docker Swarm services..."

# Check if services are running
ssh -i terraform/terraform-key.pem -o StrictHostKeyChecking=no ubuntu@ "docker service ls"

print_status "Checking application health..."

# Test application endpoints
curl -f http:///login/ > /dev/null && print_status "âœ“ Login page accessible" || print_error "âœ— Login page not accessible"
curl -f http:///register/ > /dev/null && print_status "âœ“ Register page accessible" || print_error "âœ— Register page not accessible"

print_status "Health check completed!"
