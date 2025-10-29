# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "Name of the AWS key pair"
  type        = string
  default     = "devops-key"
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

# Security Group
resource "aws_security_group" "devops_sg" {
  name_prefix = "devops-sg-"
  description = "Security group for DevOps application"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-security-group"
  }
}

# Key Pair
resource "aws_key_pair" "devops_key" {
  key_name   = var.key_name
  public_key = tls_private_key.devops_key.public_key_openssh
}

resource "tls_private_key" "devops_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save private key to file
resource "local_file" "private_key" {
  content  = tls_private_key.devops_key.private_key_pem
  filename = "/terraform-key.pem"
  file_permission = "0400"
}

# Controller Instance
resource "aws_instance" "controller" {
  ami           = "ami-0c02fb55956c7d316"  # Ubuntu 20.04 LTS
  instance_type = "t2.micro"
  key_name      = aws_key_pair.devops_key.key_name
  security_groups = [aws_security_group.devops_sg.name]

  tags = {
    Name = "devops-controller"
    Type = "controller"
  }
}

# Swarm Manager Instance
resource "aws_instance" "swarm_manager" {
  ami           = "ami-0c02fb55956c7d316"  # Ubuntu 20.04 LTS
  instance_type = "t2.micro"
  key_name      = aws_key_pair.devops_key.key_name
  security_groups = [aws_security_group.devops_sg.name]

  tags = {
    Name = "devops-swarm-manager"
    Type = "swarm-manager"
  }
}

# Swarm Worker A Instance
resource "aws_instance" "swarm_worker_a" {
  ami           = "ami-0c02fb55956c7d316"  # Ubuntu 20.04 LTS
  instance_type = "t2.micro"
  key_name      = aws_key_pair.devops_key.key_name
  security_groups = [aws_security_group.devops_sg.name]

  tags = {
    Name = "devops-swarm-worker-a"
    Type = "swarm-worker"
  }
}

# Swarm Worker B Instance
resource "aws_instance" "swarm_worker_b" {
  ami           = "ami-0c02fb55956c7d316"  # Ubuntu 20.04 LTS
  instance_type = "t2.micro"
  key_name      = aws_key_pair.devops_key.key_name
  security_groups = [aws_security_group.devops_sg.name]

  tags = {
    Name = "devops-swarm-worker-b"
    Type = "swarm-worker"
  }
}

# Elastic IP for Controller
resource "aws_eip" "controller_eip" {
  instance = aws_instance.controller.id
  domain   = "vpc"

  tags = {
    Name = "devops-controller-eip"
  }
}

# Elastic IP for Swarm Manager
resource "aws_eip" "swarm_manager_eip" {
  instance = aws_instance.swarm_manager.id
  domain   = "vpc"

  tags = {
    Name = "devops-swarm-manager-eip"
  }
}

# Elastic IP for Swarm Worker A
resource "aws_eip" "swarm_worker_a_eip" {
  instance = aws_instance.swarm_worker_a.id
  domain   = "vpc"

  tags = {
    Name = "devops-swarm-worker-a-eip"
  }
}

# Elastic IP for Swarm Worker B
resource "aws_eip" "swarm_worker_b_eip" {
  instance = aws_instance.swarm_worker_b.id
  domain   = "vpc"

  tags = {
    Name = "devops-swarm-worker-b-eip"
  }
}

# Outputs
output "controller_public_ip" {
  description = "Public IP address of the controller instance"
  value       = aws_eip.controller_eip.public_ip
}

output "swarm_manager_public_ip" {
  description = "Public IP address of the swarm manager instance"
  value       = aws_eip.swarm_manager_eip.public_ip
}

output "swarm_worker_a_public_ip" {
  description = "Public IP address of the swarm worker A instance"
  value       = aws_eip.swarm_worker_a_eip.public_ip
}

output "swarm_worker_b_public_ip" {
  description = "Public IP address of the swarm worker B instance"
  value       = aws_eip.swarm_worker_b_eip.public_ip
}

output "private_key_path" {
  description = "Path to the private key file"
  value       = local_file.private_key.filename
}
