terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.30.0"
    }
  }

  required_version = ">= 0.14.9"

  backend "s3" {
    bucket         = "ct-terraform-state-202312"
    key            = "terraform.tfstate"
    region         = "ap-east-1"
    dynamodb_table = "terraform_state"
  }
}

provider "aws" {
  region = var.region
}

# module "vpc" {
#   source                     = "./modules/vpc"
#   project_name               = var.project_name
#   number_of_private_subnets  = length(var.availability_zones)
#   environment                = var.environment
#   vpc_cidr_block             = var.vpc_cidr_block
#   private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
#   public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
#   availability_zones         = var.availability_zones
# }

module "instance_profile" {
  source = "./modules/instance_profile"
}

# module "asg" {
#   source                = "./modules/asg"
#   vpc_id                = module.vpc.vpc_id
#   private_subnet_ids    = module.vpc.private_subnet_ids
#   public_subnet_ids     = module.vpc.public_subnet_ids
#   vpc_cidr_block        = module.vpc.vpc_cidr_block
#   project_name          = var.project_name
#   image_id              = var.image_id
#   instance_type         = var.instance_type
#   instance_profile_name = module.instance_profile.instance_profile_name
# }

module "dynamodb" {
  source = "./modules/dynamodb"
}
