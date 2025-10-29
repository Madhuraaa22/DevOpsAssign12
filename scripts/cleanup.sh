#!/bin/bash

# Cleanup script for DevOps Assignment
# This script destroys all AWS resources created by Terraform

set -e

echo "ðŸ§¹ Starting cleanup process..."

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

# Confirm cleanup
read -p "Are you sure you want to destroy all AWS resources? (yes/no): " confirm
if [ "" != "yes" ]; then
    print_warning "Cleanup cancelled."
    exit 0
fi

# Destroy infrastructure
print_status "Destroying AWS infrastructure..."
cd terraform
terraform destroy -auto-approve
cd ..

print_status "Cleanup completed successfully!"
