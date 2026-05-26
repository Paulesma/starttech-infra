# StartTech Infrastructure (IaC)

This repository contains the Terraform configuration for the StartTech full-stack environment. It follows a modular design to ensure scalability and maintainability.

## 🏗️ Architecture Components
- **Networking**: VPC with Public and Private subnets across 2 Availability Zones.
- **Compute**: Application Load Balancer (ALB) and Auto Scaling Group (ASG) for the Backend API.
- **Storage**: S3 Bucket and CloudFront Distribution for Frontend hosting.
- **Database/Cache**: ElastiCache Redis cluster for session caching.
- **Monitoring**: CloudWatch Log Groups for centralized logging.

## 🚀 Deployment Instructions

### Prerequisites
- AWS CLI configured with Administrator permissions.
- Terraform v1.5.0+ installed.
- An S3 bucket created manually for the Terraform Remote State.

### Manual Setup
1. **State Backend**: Ensure the bucket name in `terraform/backend.tf` matches your manually created state bucket.
2. **Variables**: Copy `terraform.tfvars.example` to `terraform.tfvars` and provide your specific values (Region, AMI, etc.).

### Local Execution
```bash
cd terraform
terraform init
terraform plan
terraform apply --auto-approve
```

## 🤖 CI/CD Pipeline
The `.github/workflows/infrastructure-deploy.yml` automatically manages the infrastructure:
- **On Pull Request**: Runs `terraform plan` to preview changes.
- **On Push to Main**: Runs `terraform apply` to update the AWS environment.

## 🔐 Security & Compliance
- **Least Privilege**: IAM roles are scoped specifically for EC2, ECR, and CloudWatch access.
- **Network Isolation**: Redis and EC2 instances are placed in private subnets.
- **Traffic Control**: Security groups restrict ingress to port 80 (ALB) and 8080 (App).

## 📊 Outputs
Upon successful deployment, Terraform provides:
- `backend_api_url`: The endpoint for the Go API.
- `frontend_url`: The CloudFront URL for the React app.
- `redis_endpoint`: The internal DNS for the cache cluster.
