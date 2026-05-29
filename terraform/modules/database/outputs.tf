output "redis_endpoint" {
  description = "The DNS name of the Redis cluster"
  # Senior Fix: Access the first node in the list
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "redis_port" {
  description = "The port on which the Redis cluster accepts connections"
  value       = aws_elasticache_cluster.redis.port
}

output "redis_sg_id" {
  description = "The ID of the Redis security group"
  value       = aws_security_group.redis_sg.id
}
