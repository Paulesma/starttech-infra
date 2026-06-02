# --- Root main.tf ---

# 1. Storage Module (S3/CloudFront)
module "storage" {
  source      = "./modules/storage"
  environment = var.environment
}

# 2. Redis Module
# Uses your EXISTING VPC and Subnets
module "redis" {
  source         = "./modules/database"
  vpc_id         = var.vpc_id
  public_subnets = var.public_subnets
}

# 3. Compute Module
# FIX: Now uses var.vpc_id and var.public_subnets to match Redis
module "compute" {
  source         = "./modules/compute"
  vpc_id         = var.vpc_id         # Changed from module.networking.vpc_id
  public_subnets = var.public_subnets # Changed from module.networking.public_subnets
  ami_id         = var.ami_id
  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id
  mongo_uri      = var.mongo_uri
  redis_url      = "${module.redis.redis_endpoint}:6379"
}

# 4. Networking Bridge (Security Group Rule)
# This works now because BOTH sides are in var.vpc_id
resource "aws_security_group_rule" "allow_backend_to_redis" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = module.redis.redis_sg_id
  source_security_group_id = module.compute.backend_sg_id
}

# 5. Monitoring Module
module "monitoring" {
  source                  = "./modules/monitoring"
  asg_name                = module.compute.asg_name
  target_group_arn_suffix = module.compute.target_group_arn_suffix
  alb_arn_suffix          = module.compute.alb_arn_suffix
  aws_region              = var.aws_region
}

# 6. Networking Module (Optional)
# If you don't need a NEW VPC, you can comment this block out.
# Otherwise, it will just create a separate VPC that isn't used by your app.
module "networking" {
  source               = "./modules/networking"
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}
