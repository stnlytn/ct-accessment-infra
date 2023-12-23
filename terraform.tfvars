project_name               = "ct-accessment"
region                     = "ap-east-1"
vpc_cidr_block             = "10.0.0.0/16"
environment                = "dev"
private_subnet_cidr_blocks = ["10.0.0.0/24", "10.0.4.0/24", "10.0.8.0/24"]
availability_zones         = ["ap-east-1a", "ap-east-1b", "ap-east-1c"]
public_subnet_cidr_blocks  = ["10.0.12.0/24", "10.0.16.0/24", "10.0.20.0/24"]
image_id                   = "ami-0e0478d36758d0fb9"
