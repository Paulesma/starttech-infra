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
}
module "redis" {
  source          = "./modules/database"
  vpc_id          = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
  backend_sg_id   = module.compute.backend_sg_id # Link them for security
}
