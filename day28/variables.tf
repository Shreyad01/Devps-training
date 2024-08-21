# AWS Region
variable "region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"  
}

# EC2 Instance Variables
variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  default     = "ami-04a81a99f5ec58529"
}

variable "instance_type" {
  description = "The EC2 instance type"
  default     = "t2.micro"
}

# RDS Variables
variable "db_name" {
  description = "The name of the RDS MySQL database"
  default     = "mydb"
}

variable "db_username" {
  description = "The master username for the RDS MySQL instance"
  default     = "admin"
}

variable "db_password" {
  description = "The master password for the RDS MySQL instance"
  default     = "password123"
  sensitive   = true  # Marks the variable as sensitive, so it won't be logged or displayed in output
}

# S3 Bucket Variables
variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name"
  default     = "shreya-static-assets-bucket"

  validation {
    condition     = length(var.bucket_prefix) > 2 && length(var.bucket_prefix) < 64
    error_message = "The bucket prefix must be between 3 and 63 characters long."
  }
}

# VPC Configuration
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr1" {
  description = "The CIDR block for the subnet"
  default     = "10.0.2.0/24"
}

variable "subnet_cidr2" {
  description = "The CIDR block for the subnet"
  default     = "10.0.3.0/24"
}


# Security Group Configuration
variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the EC2 instance"
  default     = "0.0.0.0/0"
}

variable "allowed_http_cidr" {
  description = "CIDR block allowed to access HTTP on the EC2 instance"
  default     = "0.0.0.0/0"
}

variable "allowed_mysql_cidr" {
  description = "CIDR block allowed to access MySQL on the RDS instance"
  default     = "10.0.6.0/24"  # EC2 subnet CIDR
}
