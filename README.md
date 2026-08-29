# Terraform AWS Infrastructure

## 📌 Project Overview

This project demonstrates the deployment of a **production-style AWS infrastructure using Terraform Infrastructure as Code (IaC)**.

The infrastructure is fully provisioned and managed through Terraform, including networking, compute resources, security, load balancing, IAM, and auto scaling.

The project was built to demonstrate how cloud infrastructure can be **automated, reproducible, scalable, and version-controlled** instead of being manually configured through the AWS Management Console.

---

## 🏗️ Architecture

```text
                         Internet
                            │
                            ▼
                  ┌──────────────────┐
                  │ Application Load │
                  │     Balancer     │
                  └────────┬─────────┘
                           │
              ┌────────────┴────────────┐
              │                         │
              ▼                         ▼
       Public Subnet A           Public Subnet B
        us-east-1a                 us-east-1b
              │                         │
              └────────────┬────────────┘
                           │
                    Target Group
                           │
                           ▼
                  Auto Scaling Group
                     ┌─────┴─────┐
                     ▼           ▼
                  EC2 #1       EC2 #2
                     │           │
              Private Subnet A  Private Subnet B
                     │           │
                     └─────┬─────┘
                           │
                     NAT Gateway
                           │
                           ▼
                       Internet
```

---

## ☁️ AWS Resources

The infrastructure provisions the following AWS resources:

### Networking

* VPC
* Two public subnets
* Two private subnets
* Internet Gateway
* Public Route Table
* Private Route Table
* Route Table Associations
* NAT Gateway
* Elastic IP for NAT Gateway

### Compute

* EC2 instances
* EC2 Launch Template
* Auto Scaling Group
* Automated Docker installation

### Load Balancing

* Application Load Balancer (ALB)
* ALB Listener
* Target Group
* Health Checks
* Target Group attachment

### Security

* Application Load Balancer Security Group
* EC2 Security Group
* HTTP/HTTPS rules
* ALB-to-EC2 traffic restriction

### IAM

* IAM Role
* IAM Instance Profile
* `AmazonSSMManagedInstanceCore` policy

---

## 🛠️ Technologies Used

* **Terraform**
* **AWS**
* **Amazon EC2**
* **Amazon VPC**
* **Application Load Balancer**
* **Auto Scaling**
* **IAM**
* **NAT Gateway**
* **Internet Gateway**
* **Docker**
* **Git & GitHub**

---

## 📁 Project Structure

```text
TERRAFORM-PROVISIONING/
│
├── README.md
├── .gitignore
├── .terraform.lock.hcl
│
├── provider.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
│
├── vpc.tf
├── subnet.tf
├── route_table.tf
├── nat.tf
├── security_groups.tf
│
├── iam.tf
├── launch_template.tf
├── autoscaling.tf
├── alb.tf
│
└── userdata.sh
```

---

## ⚙️ Key Infrastructure Features

### 1. Custom VPC

A dedicated VPC is created to isolate the application infrastructure.

The VPC uses a structured CIDR range and is configured with DNS hostnames to support AWS services and internal name resolution.

### 2. Multi-AZ Public and Private Subnets

The infrastructure uses two Availability Zones:

```text
us-east-1a
us-east-1b
```

Public subnets:

```text
10.0.1.0/24
10.0.2.0/24
```

Private subnets:

```text
10.0.3.0/24
10.0.4.0/24
```

This provides better availability and creates a foundation for a highly available application architecture.

### 3. Internet Gateway

The Internet Gateway provides internet connectivity for resources located in the public subnets.

### 4. NAT Gateway

Private subnet resources use the NAT Gateway for outbound internet access without requiring public IP addresses.

An Elastic IP is associated with the NAT Gateway to provide a stable public address.

### 5. Application Load Balancer

The ALB provides a single public entry point for the application.

Traffic is received on:

```text
HTTP : 80
HTTPS : 443
```

and forwarded to the target group.

### 6. Auto Scaling Group

The application uses an Auto Scaling Group with:

```text
Minimum: 2 instances
Desired: 2 instances
Maximum: 4 instances
```

This provides redundancy and allows the infrastructure to scale as application demand increases.

### 7. Launch Template

The Launch Template defines how new EC2 instances should be created, including:

* AMI
* Instance type
* SSH key pair
* Security group
* IAM instance profile
* User data
* Instance tags

### 8. Automated Docker Installation

EC2 instances automatically install Docker through Terraform user data.

The initialization script performs:

```bash
apt update
apt install docker.io
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu
```

This means newly launched instances can automatically prepare the environment without manual installation.

### 9. IAM

EC2 instances are assigned an IAM role and instance profile.

The role includes:

```text
AmazonSSMManagedInstanceCore
```

This provides the required permissions for AWS Systems Manager functionality.

---

## 🔐 Security Design

The infrastructure separates public-facing and application resources.

The ALB is exposed to the internet while EC2 instances are intended to receive application traffic through the ALB.

The EC2 security group allows HTTP traffic from the ALB security group rather than exposing the application directly to the entire internet.

This creates a more secure traffic flow:

```text
Internet
   ↓
ALB
   ↓
EC2
```

instead of:

```text
Internet
   ↓
EC2
```

---

## 🔧 Terraform Variables

Infrastructure configuration is managed using Terraform variables rather than hardcoding environment-specific values.

Example:

```hcl
aws_region    = "us-east-1"
ami_id        = "YOUR_AMI_ID"
instance_type = "t3.micro"
instance_name = "terraform-web-server"
key_name      = "YOUR_KEY_PAIR_NAME"
```

Sensitive or environment-specific configuration should be stored locally in:

```text
terraform.tfvars
```

and should **not** be committed to GitHub.

A template is provided as:

```text
terraform.tfvars.example
```

---

## 🚀 Deployment

### Prerequisites

Install and configure:

* Terraform
* AWS CLI
* Git
* An AWS account

Verify Terraform:

```bash
terraform version
```

Verify AWS authentication:

```bash
aws sts get-caller-identity
```

---

### Initialize Terraform

```bash
terraform init
```

### Format Configuration

```bash
terraform fmt
```

### Validate Configuration

```bash
terraform validate
```

### Preview Infrastructure Changes

```bash
terraform plan
```

### Deploy Infrastructure

```bash
terraform apply
```

Confirm the deployment by entering:

```text
yes
```

---

## 📤 Terraform Outputs

After deployment, retrieve infrastructure outputs with:

```bash
terraform output
```

The project provides outputs such as:

* EC2 instance ID
* EC2 public IP
* Application Load Balancer DNS name

The ALB DNS name can be used to access the application.

---

## 🧹 Destroy Infrastructure

When the infrastructure is no longer required:

```bash
terraform destroy
```

Confirm with:

```text
yes
```

This is especially important when using chargeable AWS resources such as the NAT Gateway and Application Load Balancer.

---

## 🔒 Git & Security

The following files and directories should **not** be committed:

```text
.terraform/
terraform.tfstate
terraform.tfstate.*
terraform.tfvars
*.tfplan
*.pem
```

The Terraform lock file should remain tracked:

```text
.terraform.lock.hcl
```

This project previously encountered the Terraform AWS provider binary being included in Git. The `.terraform/` directory is therefore excluded from version control.

---

## 📚 What I Learned

Through this project, I gained practical experience with:

* Infrastructure as Code
* Terraform configuration and state
* Terraform variables and outputs
* AWS provider configuration
* VPC architecture
* Public and private subnet design
* Route tables
* Internet Gateway
* NAT Gateway
* Security Groups
* EC2 provisioning
* SSH access
* Automated instance configuration
* Docker installation through user data
* IAM roles and instance profiles
* Application Load Balancers
* Target Groups
* Health checks
* Launch Templates
* Auto Scaling Groups
* Multi-AZ infrastructure
* Git and GitHub version control

---

## 🔮 Future Improvements

Planned improvements for this infrastructure include:

* CloudWatch monitoring and alarms
* CPU-based Auto Scaling policies
* HTTPS with ACM
* Route 53 DNS
* Terraform remote state using S3
* State locking
* Terraform modules
* Separate development and production environments
* Jenkins CI/CD integration
* Automated infrastructure deployment
* Infrastructure security scanning
* Container deployment through the provisioned infrastructure

---

## 👨‍💻 Author

**Olutayo Oluwafemi Moses**
DevOps & Cloud Engineer