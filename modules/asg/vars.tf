variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "public_subnet_ids" {
  description = "public subnet ids"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "private subnet ids"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "image_id" {
  description = "image id for launch template"
  type        = string
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
}

variable "instance_profile_name" {
  description = "instance profile name for launch template"
  type        = string
}
