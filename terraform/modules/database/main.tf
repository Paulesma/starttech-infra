resource "aws_elasticache_subnet_group" "redis_subnets" {
  name       = "redis-subnets"
  subnet_ids = var.private_subnets
}

resource "aws_security_group" "redis_sg" {
  name   = "redis-sg"
  vpc_id = var.vpc_id

  # Only allow the Backend EC2 instances to talk to Redis
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.backend_sg_id]
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "starttech-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnets.name
  security_group_ids   = [aws_security_group.redis_sg.id]
}
