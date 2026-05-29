resource "aws_elasticache_subnet_group" "redis_subnets" {
  name       = "redis-subnets"
  subnet_ids = var.private_subnets # Keep Redis private for security

  # --- ADD THIS BLOCK TO FIX THE ERROR ---
  lifecycle {
    ignore_changes = all
  }
  # ----------------------------------------
}

resource "aws_security_group" "redis_sg" {
  name        = "redis-sg"
  description = "Allow Redis traffic from backend"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
