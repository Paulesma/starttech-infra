output "redis_endpoint" {
  description = "The DNS name of the Redis cluster"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}
