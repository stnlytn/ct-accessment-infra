variable "region" {
  description = "aws region to deploy to"
  type        = string
  default     = "ap-east-1"
}

variable "backend_bucket_name" {
  description = "aws backend bucket name"
  type        = string
  default     = "ct-terraform-state-202312"
}
