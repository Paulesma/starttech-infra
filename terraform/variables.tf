# --- General Configuration ---
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "The AWS Account ID for ECR registry"
  type        = string
  default     = "266545926099"
}

variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
  default     = "prod"
}

# --- Networking Configuration ---
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# --- Compute Variables ---
variable "ami_id" {
  description = "The AMI ID for the backend EC2 instances (AL2023)"
  type        = string
  default     = "ami-020cba7c55df1f615" # Corrected to your AL2023 ID
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
  sensitive   = true # Hides password from logs
}
variable "vpc_id" {
  description = "The ID of the existing VPC"
  type        = string
}

variable "redis_url" {
  description = "The connection endpoint for Redis"
  type        = string
}
