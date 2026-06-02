
output "redis_endpoint" {
  # Add the [0] index because cache_nodes is a list
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "redis_sg_id" {
  value = aws_security_group.redis_sg.id
}
