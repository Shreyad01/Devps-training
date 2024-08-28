provider "aws" {
  region = "us-east-1"
  profile = "dev"
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "example" {
  key_name   = "terraform-shreya-key"
  public_key = tls_private_key.example.public_key_openssh
}

output "private_key_pem" {
  value       = tls_private_key.example.private_key_pem
  description = "Private key in PEM format"
  sensitive = true
}