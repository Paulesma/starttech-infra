# --- General Configuration ---
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "The AWS Account ID for ECR registry"
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

# --- Networking Configuration ---
variable "vpc_id" {
  description = "The ID of the existing VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for the ALB and EC2 instances"
  type        = list(string)
}

# --- Compute Variables ---
variable "ami_id" {
  description = "The AMI ID for the backend EC2 instances (Ubuntu 24.04)"
  type        = string
  default     = "ami-04b70fa74e45c3917"
}

variable "instance_type" {
  description = "EC2 instance type for the backend"
  type        = string
  default     = "t2.micro"
}

# --- Data Layer Secrets ---
variable "mongo_uri" {
  description = "Connection string for MongoDB Atlas"
  type        = string
  sensitive   = true
}

