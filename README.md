# 2-Tier AWS Architecture with Terraform (IaC)

Automated deployment of a secure, production-style **2-Tier Architecture** on AWS using **Terraform**. This project implements Infrastructure as Code (IaC) principles to provision a custom VPC, public and private subnets, route tables, internet gateways, security group chaining, and EC2 instances configured automatically at boot via `user_data` shell scripts.

# Architecture Overview
```
Internet
                  │
                  ▼
        ┌───────────────────┐
        │ Internet Gateway  │
        └─────────┬─────────┘
                  │
 ┌────────────────┼────────────────────────────────────────────┐
 │ VPC (10.0.0.0/16)                                           │
 │                                                             │
 │   ┌─────────────────────────────────────────────────────┐   │
 │   │ Public Subnet (10.0.1.0/24)                         │   │
 │   │   - Route Table -> Internet Gateway                 │   │
 │   │                                                     │   │
 │   │   ┌─────────────────────────────────────────────┐   │   │
 │   │   │ Public EC2: Nginx Reverse Proxy             │   │   │
 │   │   │ Security Group: Allow HTTP (80) & SSH (22)  │   │   │
 │   │   └──────────────────────┬──────────────────────┘   │   │
 │   └──────────────────────────┼──────────────────────────┘   │
 │                              │ Internal Traffic (Port 8080) │
 │   ┌──────────────────────────┼──────────────────────────┐   │
 │   │ Private Subnet (10.0.2.0/24)                        │   │
 │   │   - Route Table -> Local Only (No Internet)         │   │
 │   │                                                     │   │
 │   │   ┌─────────────────────────────────────────────┐   │   │
 │   │   │ Private EC2: Application Server             │   │   │
 │   │   │ Security Group: Allow Port 8080 & SSH (22)  │   │   │
 │   │   │                 ONLY from Public EC2 SG     │   │   │
 │   │   └─────────────────────────────────────────────┘   │   │
 │   └─────────────────────────────────────────────────────┘   │
 └─────────────────────────────────────────────────────────────┘
```

# Repository Layout
```
.
├── README.md
└── terraform/
    ├── main.tf                 # VPC, Subnets, Route Tables, IGW, and Security Groups
    ├── instances.tf            # EC2 instances, AMI lookup, and key pairs
    ├── outputs.tf              # Public Proxy IP, Private App IP, and Web URL
    ├── datasources.tf          # AMI data source used for the instance creation
    ├── providers.tf.           # AWS provider configuration
    └── scripts/
        ├── user_data_private.sh# Boot script for Private App Server
        └── user_data_public.sh # Boot script template for Nginx Reverse Proxy
```

# Prerequisites

- Terraform CLI installed (v1.0.0+).
- AWS CLI configured via aws configure.
- An SSH key pair created on your AWS account (for this practice we used one called "MyEC2KeyPair")


# Step-by-Step Deployment Guide

### Step 1: Clone the Repository & Navigate to Terraform Directory
```
git clone [https://github.com/](https://github.com/)/.git
cd /terraform
```
### Step 2: Ensure Script Executable Permissions
Grant execution permissions to the user data scripts:
```
chmod +x scripts/user_data_private.sh scripts/user_data_public.sh
```
### Step 3: Initialize Terraform
Download the required AWS provider modules:
```
terraform init
```
### Step 4: Preview the Execution Plan
Review all resources Terraform intends to provision:
```
terraform plan
```
### Step 5: Apply Configuration
Deploy the architecture to AWS:
```
terraform apply -auto-approve
```
Upon completion, Terraform will output the server details:
- public_ip_ec2
- private_ip_ec2

# Verification & Testing
1. Allow 1 to 2 minutes for the EC2 `user_data` boot scripts to finish installing Nginx and initializing the Python service.

2. Verify HTTP routing via `curl`:
```
curl http://
```
3. Alternatively, open your browser and navigate to:
```
http://
```
# Automated Teardown
To avoid incurring cloud provider charges after testing, destroy all provisioned infrastructure with a single command:
```
terraform destroy -auto-approve
```
