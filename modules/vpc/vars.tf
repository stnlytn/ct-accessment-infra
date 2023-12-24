variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block range for vpc"
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Application environment"
  type        = string
}

variable "number_of_private_subnets" {
  type        = number
  default     = 2
  description = "The number of private subnets in a VPC."
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "CIDR block range for the private subnets"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "CIDR block range for the private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones for the selected region"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "region_identifiers" {
  type        = list(string)
  default     = ["a", "b", "c", "d", "e", "f"]
  description = "Extensions for names of elements"
}
