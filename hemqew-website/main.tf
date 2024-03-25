# configure aws provider
provider "aws" {
  region = var.region
  profile = "olatunji"
}


# create vpc

module "vpc" {
  source                 = "../modules/vpc"
  region                 = var.region
  Task_name              = var.Task_name
  main_cidr              = var.main_cidr
  public1_cidr           = var.public1_cidr
  public2_cidr           = var.public2_cidr
  private1_cidr          = var.private1_cidr
  private2_cidr          = var.private2_cidr
  Environment            = var.Environment
}

# create nat-gateway

module "nat-gateway" {
  source            = "../modules/nat-gateway"
  Task_name         = module.vpc.Task_name
  public1           = module.vpc.public1
  igw               = module.vpc.igw
  main              = module.vpc.main
  private1          = module.vpc.private1
  private2          = module.vpc.private2 
} 

# create security_groups

module "security_groups" {
  source       = "../modules/security-group"
  main         = module.vpc.main
  Task_name    = module.vpc.Task_name
}