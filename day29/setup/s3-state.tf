provider "aws" {
  region = var.region
}

# terraform/s3-state.tf
resource "aws_s3_bucket" "terraform_states" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "TerraformStateBucket-shreya"
  }
}

# s3 bucket versioning
resource "aws_s3_bucket_versioning" "s3-version"{
  bucket = aws_s3_bucket.terraform_states.id
  versioning_configuration {
    status = "Enabled"
  }
}  

# terraform/dynamodb-lock.tf
resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform_lock-shreya"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "dynamodbLock-shreya"
  }
}

# Output the S3 bucket name used for Terraform remote state
output "terraform_state_bucket_name" {
  description = "The name of the S3 bucket used to store the Terraform remote state"
  value       = aws_s3_bucket.terraform_states.bucket
}

