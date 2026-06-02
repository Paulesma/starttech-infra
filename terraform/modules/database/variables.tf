variable "vpc_id" {
  description = "The ID of the VPC where Redis will be deployed"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for the Redis cluster"
  type        = list(string)
}
