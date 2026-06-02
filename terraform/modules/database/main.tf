resource "aws_elasticache_subnet_group" "redis_subnets" {
  name = "redis-subnets"
  # This variable should match what you have in your tfvars/env
  subnet_ids = var.public_subnets
}
