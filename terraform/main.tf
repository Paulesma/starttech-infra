provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "./modules/networking"
}

module "storage" {
  source      = "./modules/storage"
  environment = var.environment
}

module "compute" {
  source          = "./modules/compute"
  vpc_id          = module.networking.vpc_id
  public_subnets  = module.networking.public_subnets
  private_subnets = module.networking.private_subnets
  ami_id          = var.ami_id
  aws_region      = var.aws_region
  aws_account_id  = var.aws_account_id

  # NEW: Pass these from your root variables/tfvars to the container
  mongo_uri = var.mongo_uri
  redis_url = "${module.redis.redis_endpoint}:6379"
}

module "redis" {
  source          = "./modules/database" # Ensure this path matches your folder
  vpc_id          = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
  # Ensure your compute module has an output named "backend_sg_id"
  backend_sg_id = module.compute.backend_sg_id
}
