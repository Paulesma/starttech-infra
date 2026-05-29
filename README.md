# StartTech Infrastructure (IaC)

This repository contains the modularized Terraform configuration for the StartTech full-stack environment. It automates the provisioning of a highly available AWS environment integrated with MongoDB Atlas.

## 🏗️ Architecture Components
- **Networking**: Custom VPC with dynamic Public Subnets for the application layer and Private Subnets for the data layer.
- **Compute**: Application Load Balancer (ALB) and Auto Scaling Group (ASG) managing containerized Golang instances.
- **Storage**: S3 Bucket for React static hosting and a CloudFront Distribution for global CDN delivery.
- **Database/Cache**: Amazon ElastiCache (Redis) cluster for session and query caching.
- **Monitoring**: Centralized CloudWatch Log Groups, Metric Alarms for health monitoring, and a CloudWatch Dashboard.

## 🚀 Deployment Instructions

### Prerequisites
- AWS CLI configured with **Administrator** permissions.
- Terraform **v1.5.0+** installed.
- **S3 Bucket** created manually for Remote State (defined in `backend.tf`).
- **DynamoDB Table** (`terraform-state-lock`) created for state locking.

### Initial Setup
1. **State Backend**: Verify the bucket name in `backend.tf` matches your manual setup.
2. **Variables**: Create a `terraform.tfvars` file based on your environment. You **must** provide your MongoDB Atlas URI here.

### Local Execution
```bash
terraform init
terraform plan
terraform apply --auto-approve
```

## 🤖 CI/CD Pipeline
The `.github/workflows/infrastructure-deploy.yml` manages the infrastructure lifecycle:
- **Plan**: Triggered on Pull Requests to preview changes.
- **Apply**: Triggered on push to `main` to synchronize the AWS environment.

## 🔐 Security & Networking Strategy
- **Network Design**: EC2 instances are placed in **Public Subnets** with `map_public_ip_on_launch` enabled. This facilitates direct outbound communication for Docker image pulls and MongoDB connectivity without NAT Gateway costs.
- **Traffic Control**: 
  - **ALB**: Accepts HTTP (80) traffic from `0.0.0.0/0`.
  - **EC2 Backend**: Strictly restricted to port `8080` inbound **only** from the ALB Security Group.
  - **Redis**: Isolated in **Private Subnets**; ingress restricted to port `6379` from the EC2 Security Group.
- **Least Privilege**: IAM Instance Profiles are scoped specifically for ECR ReadOnly and CloudWatch Logging permissions.

## 📊 Integration Outputs
After a successful `apply`, use the following outputs to configure the **starttech-application** GitHub Secrets:
- `backend_api_url` ➔ `ALB_DNS`
- `s3_bucket_name` ➔ `S3_BUCKET_NAME`
- `cloudfront_distribution_id` ➔ `CLOUDFRONT_DIST_ID`
- `redis_endpoint` ➔ `REDIS_URL`

## 👨‍💻 Author
**Eze Paul C** - Senior DevOps Engineer
