variable "vpc_id" {}
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "ami_id" {}

# Add these two so the root main.tf can pass the data in:
variable "aws_region" {
  type = string
}

variable "aws_account_id" {
  type = string
}
