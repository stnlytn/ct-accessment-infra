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

# VPC
module "vpc" {
    source = "./modules/vpc"
    vpc_tag_name                  = "${var.project_name}-vpc"
    number_of_private_subnets     = length(var.availability_zones)
    environment                   = var.environment
    vpc_cidr_block                = var.vpc_cidr_block
    private_subnet_cidr_blocks    = var.private_subnet_cidr_blocks
    public_subnet_cidr_blocks     = var.public_subnet_cidr_blocks
    availability_zones            = var.availability_zones
}
