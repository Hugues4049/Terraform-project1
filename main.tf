provider "aws" {
  region  = "eu-west-3"
  profile = "default"

}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# Utilisation du module networking
module "networking" {
  source               = "./modules/networking"
  cidr_vpc             = "10.0.0.0/16"
  cidr_public_subnet_a = "10.0.128.0/20"
  cidr_public_subnet_b = "10.0.144.0/20"
  cidr_app_subnet_a    = "10.0.0.0/19"
  cidr_app_subnet_b    = "10.0.32.0/19"
  az_a                 = "eu-west-3a"
  az_b                 = "eu-west-3b"
}

# Utilisation du module Security
module "security" {
  source                 = "./modules/security"
  ssh_cidr_blocks        = ["0.0.0.0/0"]
  app_subnet_cidr_blocks = ["10.1.0.0/24"]
  vpc_id                 = module.networking.vpc_id
  public_subnet_ids      = module.networking.public_subnet_ids
  app_subnet_ids         = module.networking.app_subnet_id
  aws_network_acl_a_id   = module.security.aws_network_acl_a_id
  aws_network_acl_b_id   = module.security.aws_network_acl_b_id
}

# Utilisation du module Load Balancing
module "load_balancing" {
  source                         = "./modules/load_balancing"
  vpc_id                         = module.networking.vpc_id
  public_subnet_ids              = module.networking.public_subnet_ids
  app_subnet_ids                 = module.networking.app_subnet_id
  security_groups_application_lb = module.security.security_group_ids
}

# Utilisation du module Instances EC2
module "ec2" {
  source                   = "./modules/ec2"
  target_group_arn         = module.load_balancing.target_group_arn
  target_group_arn_B       = module.load_balancing.target_group_arn_B
  instance_subnet_ids      = module.networking.public_subnet_ids
  instance_ami_filter_name = "amzn2-ami-hvm-*-x86_64-gp2"
  instance_type            = "t2.micro"
  database_engine          = "mysql"
  database_engine_version  = "5.7"
  database_instance_class  = "db.t3.micro"
  database_multi_az        = true
  web_asg_desired_capacity = 1
  web_asg_max_size         = 2
  web_asg_min_size         = 1
  vpc_id                   = module.networking.vpc_id
  public_subnet_ids        = module.networking.public_subnet_ids
  app_subnet_ids           = module.networking.app_subnet_id
  sg_roland_id             = module.security.sg_roland_id
  #myec2key_key_name        = module.security.myec2key_key_name
  key_id = 4049
}

# Utilisation du module Instances bastion

module "bastion_a" {
  source            = "./modules/bastion"
  subnet_id         = module.networking.public_subnet_a_id
  security_group_id = module.security.sg_22_id
  key_id            = 545454
}
module "bastion_b" {
  source            = "./modules/bastion"
  subnet_id         = module.networking.public_subnet_b_id
  security_group_id = module.security.sg_22_id
  key_id            = 5445346
}

module "auto_scaling" {
  source              = "./modules/auto_scaling"
  region              = var.region
  vpc_zone_identifier = module.networking.vpc_zone_identifier
}
