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

#create application load balancer

module "application_load_balancer" {
  source                  = "../modules/alb"
  Task_name               = module.vpc.Task_name
  alb_security_grp_id     = module.security_groups.alb_security_grp_id
  public1                 = module.vpc.public1
  public2                 = module.vpc.public2
  main                    = module.vpc.main
  web_private_instance_id = module.ec2-instance.web_private_instance_id
  domain                  = "*.myproject1.net"
}

# create ec2-instance

module "ec2-instance" {
  source                  = "../modules/ec2-instance"
  public1                 = module.vpc.public1
  az1                     = module.vpc.az1
  bastion_security_grp_id = module.security_groups.bastion_security_grp_id
  web_app_security_grp_id = module.security_groups.web_app_security_grp_id
  private1                = module.vpc.private1 
}