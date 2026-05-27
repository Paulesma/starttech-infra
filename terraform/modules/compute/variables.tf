# --- Networking (Passed from networking module) ---
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet IDs for the EC2 instances"
  type        = list(string)
}

# --- Compute Configuration ---
variable "ami_id" {
  description = "The AMI ID for the EC2 instances"
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID for ECR registry"
  type        = string
}

# --- Application Secrets/Endpoints (Phase 2 Requirement) ---
variable "mongo_uri" {
  description = "The connection string for MongoDB Atlas"
  type        = string
}

variable "redis_url" {
  description = "The endpoint for the ElastiCache Redis cluster"
  type        = string
}
