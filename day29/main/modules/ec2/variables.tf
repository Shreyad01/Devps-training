variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string

}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "key_pair" {
  description = "Name of your private key pair"
  type = string
}

variable "iam_ec2_profile_name" {
  description = "iam profile name for ec2"
  type = string
}

variable "public_subnet_id" {
  description = "public subnit id for ec2"
  type = string
}

variable "security_group_id" {
  description = "security group id for ec2"
  type = string
}

variable "project_name" {
  description = "Adding Project Tag to Ec2 instance"
  type = string
}