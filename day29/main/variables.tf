variable "ami_Id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

# Variable for EC2 instance type
variable "instance_type" {
  description = "EC2 instance type to be used for the deployment"
  type        = string
  default     = "t2.micro"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}


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

variable "key_pair_name" {
  description = "Name of your private key pair"
  type = string
}

# EC2 IAM Role ARN
variable "ec2_iam_role_arn" {
  description = "The ARN of the IAM role attached to the EC2 instance."
  type = string
}

variable "project_name" {
  type = string
}