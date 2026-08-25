# 🚀 AWS Infrastructure Provisioning with Terraform

This project demonstrates how to provision AWS infrastructure using **Terraform Infrastructure as Code (IaC)**.

## 🏗️ Infrastructure Created

- Custom AWS VPC
- Public Subnet
- Internet Gateway
- Route Table and Association
- Security Group
- Ubuntu EC2 Instance
- EC2 Key Pair authentication
- SSH, HTTP, and HTTPS access
- Automatic public IP assignment
- Docker installation using EC2 User Data

## 🛠️ Technologies Used

- Terraform
- AWS
- Amazon EC2
- Amazon VPC
- Ubuntu
- Docker
- Git & GitHub

## 📁 Project Structure

```text
TERRAFORM-PROVISIONING/
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── vpc.tf
├── subnet.tf
├── internet_gateway.tf
├── route_table.tf
├── security_group.tf
├── ec2.tf
├── outputs.tf
└── userdata.sh

🚀 Deployment
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply

🔗 Connect to EC2
ssh -i "path/to/terraform-key.pem" ubuntu@PUBLIC_IP

🐳 Verify Docker
docker --version

🧹 Destroy Infrastructure

To avoid unnecessary AWS charges:

👨‍💻 Author

Olutayo Oluwafemi Moses
DevOps & Cloud Engineer