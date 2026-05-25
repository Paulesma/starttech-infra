# --- General Configuration ---

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

# --- Compute Variables ---

variable "ami_id" {
  description = "The AMI ID for the backend EC2 instances (Amazon Linux 2)"
  type        = string
  # This is the standard Amazon Linux 2 AMI ID for us-east-1 as of early 2024
  default     = "ami-020cba7c55df1f615" 
}

variable "instance_type" {
  description = "EC2 instance type for the backend"
  type        = string
  default     = "t2.micro"
}

# --- Module Inter-dependencies ---
# These are used to pass data between modules in your root main.tf

variable "vpc_id" {
  description = "The VPC ID (passed from networking module)"
  type        = string
  default     = ""
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = []
}
