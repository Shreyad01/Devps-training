terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
  backend "local" {
    path = "/home/einfochips/Desktop/learning/day30/day30-task/terraform.tfstate.d/prod"
  }
}

provider "aws" {
  region = "ap-south-1"
  profile = "${terraform.workspace}"
}

module "ec2" {
  source         = "/home/einfochips/Desktop/learning/day30/day30-task/modules/ec2"
  ami_map        = var.ami
  instance_type  = var.instance_type
  instance_name  = var.instance_name
  key_pair       = var.key_pair
  public_subnet_id = module.vpc.ec2_instance_subnet_id
  security_group_id = module.vpc.vpc_ec2_sg_id
  iam_ec2_profile_name = module.s3.iam_ec2_profile_name
  # project_name = var.project_name
}

module "s3" {
  source       = "/home/einfochips/Desktop/learning/day30/day30-task/modules/s3"
  bucket_name  = var.bucket_name
  ec2_iam_role_arn = var.ec2_iam_role_arn
}

module "vpc" {
  source = "/home/einfochips/Desktop/learning/day30/day30-task/modules/vpc"
  vpc_cidr = var.vpc_cidr_ip
  pub_subnet_cidr = var.pub_subnet_cidr_ip
}