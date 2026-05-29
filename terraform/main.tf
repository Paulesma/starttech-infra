module "networking" {
  source               = "./modules/networking"
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

module "storage" {
  source      = "./modules/storage"
  environment = var.environment
}

# 1. Start with Redis (Dependency loop broken)
module "redis" {
  source          = "./modules/database"
  vpc_id          = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
}

# 2. Run Compute (Uses Redis Endpoint)
module "compute" {
  source         = "./modules/compute"
  vpc_id         = module.networking.vpc_id
  public_subnets = module.networking.public_subnets
  ami_id         = var.ami_id
  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id
  mongo_uri      = var.mongo_uri

  # redis_url connects correctly here
  redis_url = "${module.redis.redis_endpoint}:6379"
}

# 3. Link them with the Bridge Rule
resource "aws_security_group_rule" "allow_backend_to_redis" {
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  security_group_id        = module.redis.redis_sg_id
  source_security_group_id = module.compute.backend_sg_id
}
# 4. Deploy Monitoring (Requirement: Phase 1 & 3)
module "monitoring" {
  source                  = "./modules/monitoring"
  asg_name                = module.compute.asg_name
  target_group_arn_suffix = module.compute.target_group_arn_suffix
  alb_arn_suffix          = module.compute.alb_arn_suffix
  aws_region              = var.aws_region
}