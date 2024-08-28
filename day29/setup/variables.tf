# Variable for AWS region
variable "region" {
  description = "AWS region where the resources will be deployed"
  type        = string
  default     = "ap-south-1"
}

#Variable for S3 bucket name used for application data
variable "bucket_name" {
  description = "Name of the S3 bucket for application data"
  type        = string
}
