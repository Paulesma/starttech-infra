variable "vpc_id" {
  description = "The ID of the VPC where resources will be deployed"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for the ALB and EC2 instances"
  type        = list(string)
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instances (Amazon Linux 2023 recommended)"
  type        = string
}

variable "aws_region" {
  description = "AWS region for ECR login and resource placement"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS Account ID for ECR image referencing"
  type        = string
}

variable "mongo_uri" {
  description = "The connection string for MongoDB Atlas"
  type        = string
  sensitive   = true # Hides the value in CLI output for security
}

variable "redis_url" {
  description = "The endpoint for the ElastiCache Redis cluster"
  type        = string
}
