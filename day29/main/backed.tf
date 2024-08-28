# terraform/backend.tf
terraform {
  backend "s3" {
    bucket         = "terraformstatebucket-shreya" # same as s3 bucket name
    key            = "terraform.tfstate" # replace with the path where you want to store the state file
    region         = "ap-south-1" # samae as s3 bucket region
    dynamodb_table = "terraform_lock-shreya" #same as Dynam0db table name 
    encrypt        = true
  }
}
