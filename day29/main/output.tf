# Output the public IP of the EC2 instance
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "The public IP address of the deployed EC2 instance"
  value       = module.ec2.instance_public_ip

}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.s3.bucket_arn
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.s3.bucket_name
}