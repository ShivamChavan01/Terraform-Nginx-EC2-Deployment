# Terraform Nginx EC2 Deployment

## Overview
This Terraform configuration sets up an AWS environment using LocalStack and deploys an EC2 instance running Nginx. The setup includes:
- **VPC** with public and private subnets.
- **Internet Gateway** and **Route Table** for external access.
- **Security Group** to allow HTTP traffic.
- **EC2 Instance** with user data to install and start Nginx.
- **Terraform Outputs** for instance public IP and Nginx access URL.

## Prerequisites
- Terraform installed ([Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli))
- LocalStack installed ([Install LocalStack](https://docs.localstack.cloud/getting-started/installation/))
- AWS CLI installed ([Install AWS CLI](https://aws.amazon.com/cli/))

## Terraform Configuration

### 1. Provider Configuration
The AWS provider is set up to use LocalStack, which simulates AWS services locally.
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}

provider "aws" {
  access_key                  = "LKIAQAAAAAAAIOFPSI36"  # Dummy values for LocalStack
  secret_key                  = "p4VoUAkjIKZKyTAQco/KtX5fRIZjDye/DuxJvo+C"
  region                      = "eu-north-1"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    s3    = "http://localhost:4566"
    ec2   = "http://localhost:4566"
    iam   = "http://localhost:4566"
    sts   = "http://localhost:4566"
    rds   = "http://localhost:4566"
    lambda = "http://localhost:4566"
  }
}
```

### 2. VPC Configuration
Creates a VPC with a CIDR block of `10.0.0.0/16`.
```hcl
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "my-vpc" }
}
```

### 3. Subnets
Two subnets are created within the VPC:
```hcl
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"
  tags = { Name = "Private_subnet" }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.2.0/24"
  tags = { Name = "Public_Subnet" }
}
```

### 4. Internet Gateway
Required to allow the EC2 instance to access the internet.
```hcl
resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = { Name = "my-igw" }
}
```

### 5. Route Table & Association
Associates the route table with the public subnet for internet access.
```hcl
resource "aws_route_table" "my-rt" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = { Name = "My Routing Table" }
}

resource "aws_route_table_association" "public_sub" {
  route_table_id = aws_route_table.my-rt.id
  subnet_id      = aws_subnet.public_subnet.id
}
```

### 6. Security Group
Allows inbound traffic on port **80 (HTTP)** and all outbound traffic.
```hcl
resource "aws_security_group" "nginx-sp" {
  vpc_id = aws_vpc.my-vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "Nginx-sp" }
}
```

### 7. EC2 Instance with Nginx Installation
Deploys an EC2 instance and installs Nginx via `user_data`.
```hcl
resource "aws_instance" "my-nginx-server" {
  ami                    = "ami-0df4d205d505c6f42"  # Update with valid AMI ID
  instance_type          = "t3.nano"
  subnet_id             = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.nginx-sp.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    sudo yum install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
  EOF

  tags = { Name = "Nginx-Ec2-Server" }
}
```

### 8. Outputs
After deployment, these outputs provide access details.
```hcl
output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.my-nginx-server.public_ip
}

output "instance_url" {
  description = "Nginx Server URL"
  value       = "http://${aws_instance.my-nginx-server.public_ip}"
}
```

## Deployment Steps

### **1. Start LocalStack**
```bash
localstack start -d
```

### **2. Initialize Terraform**
```bash
terraform init
```

### **3. Apply Terraform Configuration**
```bash
terraform apply -auto-approve
```

### **4. Verify Nginx Server**
- Copy the public IP from the Terraform output.
- Open the browser and visit: `http://<PUBLIC_IP>`.

### **5. SSH into the Instance (If Needed)**
```bash
ssh -i your-key.pem ec2-user@<PUBLIC_IP>
```
```bash
sudo systemctl status nginx
```

## Notes
- LocalStack **does not fully support EC2**, so this configuration works only on real AWS.
- Always check for the latest AMI ID before deploying.
- Restrict security groups in production for better security.

## Conclusion
This Terraform configuration automates the deployment of an AWS EC2 instance with Nginx using LocalStack (for supported resources). If you want real EC2 functionality, you must deploy it on actual AWS.

---
**Author: Shivam Chavan**

