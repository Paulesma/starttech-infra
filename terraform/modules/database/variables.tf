variable "vpc_id" {
  description = "The ID of the VPC where Redis will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for the Redis cluster"
  type        = list(string)
}

