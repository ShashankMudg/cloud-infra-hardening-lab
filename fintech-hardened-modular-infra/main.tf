# --- Root main.tf ---

module "vpc" {
  source = "./modules/vpc"
}

module "storage" {
  source = "./modules/storage"
}

module "security" {
  source = "./modules/security"
}

# Corrected Compute Module Call
module "compute" {
  source          = "./modules/compute"
  private_subnets = module.vpc.private_subnets
  lambda_sg_id    = module.vpc.lambda_sg_id 
  db_table_arn    = module.storage.db_arn
}

module "gateway" {
  source      = "./modules/gateway"
  lambda_arn  = module.compute.lambda_arn
  lambda_name = module.compute.lambda_name
  waf_arn     = module.security.waf_arn
}