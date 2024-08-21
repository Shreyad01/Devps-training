# Provider Configuration
provider "aws" {
  region = var.region
}

#VPC Configuration
resource "aws_vpc" "shreya_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "shreya_VPC"
  }
}

# Subnet Configuration
# public subnet
resource "aws_subnet" "shreya_publicsubnet" {
  vpc_id            = aws_vpc.shreya_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "shreya_publicSubnet"
  }
}

# private subnet
resource "aws_subnet" "shreya_privateSubnet_az1" {
  vpc_id            = aws_vpc.shreya_vpc.id
  cidr_block        = var.subnet_cidr1
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "shreya_privateSubnet_az1"
  }
}

resource "aws_subnet" "shreya_privateSubnet_az2" {
  vpc_id            = aws_vpc.shreya_vpc.id
  cidr_block        = var.subnet_cidr2
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = false

  tags = {
    Name = "shreya_privateSubnet_az2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "shreya_igw" {
  vpc_id = aws_vpc.shreya_vpc.id

  tags = {
    Name = "shreya_IGW"
  }
}

# Route Table
resource "aws_route_table" "shreya_route_table" {
  vpc_id = aws_vpc.shreya_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.shreya_igw.id
  }

  tags = {
    Name = "shreya_RouteTable"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "shreya_route_table_assoc" {
  subnet_id      = aws_subnet.shreya_publicsubnet.id
  route_table_id = aws_route_table.shreya_route_table.id
}

# Security Group for EC2
resource "aws_security_group" "shreya-ec2_sg" {
  vpc_id = aws_vpc.shreya_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_http_cidr]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "shreya-EC2SecurityGroup"
  } 
}


# Security Group for RDS
resource "aws_security_group" "shreya-rds_sg" {
  vpc_id = aws_vpc.shreya_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.allowed_mysql_cidr]
  }

   ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }

   ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }
   
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "shreya-RDSSecurityGroup"
  }
}

# EC2 Instance
resource "aws_instance" "shreya_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.shreya_publicsubnet.id
  security_groups = [aws_security_group.shreya-ec2_sg.id]
  key_name      =  "ansible-new.pem"
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name

  associate_public_ip_address = true

  depends_on = [aws_security_group.shreya-ec2_sg]

  tags = {
    Name = "shreya_ec2"
    Environment = "new"
  }
}

# RDS MySQL Instance
resource "aws_db_instance" "shreya-mysql_db" {
  allocated_storage    = 20
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  publicly_accessible  = false
  vpc_security_group_ids = [aws_security_group.shreya-rds_sg.id]

  db_subnet_group_name = aws_db_subnet_group.shreya_db_subnet_group.name

  tags = {
    Name = "shreya-RDSInstance"
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "shreya_db_subnet_group" {
  name       = "shreya-db-subnet-group"
  subnet_ids = [aws_subnet.shreya_privateSubnet_az1.id, aws_subnet.shreya_privateSubnet_az2.id]

  tags = {
    Name = "shreya-DBSubnetGroup"
  }
}

# S3 Bucket
resource "aws_s3_bucket" "shreya-static_bucket" {
  bucket = "${var.bucket_prefix}-${random_id.bucket_suffix.hex}"

  tags = {
    Name = "shreya-static_bucket"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 6
}

# IAM Role for EC2 to Access S3
resource "aws_iam_role" "ec2_role" {
  name = "EC2S3AccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# IAM Policy for S3 Access
resource "aws_iam_policy" "s3_access_policy" {
  name        = "EC2S3AccessPolicy"
  description = "Policy to allow EC2 instance to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action   = ["s3:ListBucket", "s3:GetObject", "s3:PutObject"],
      Effect   = "Allow",
      Resource = [
        aws_s3_bucket.shreya-static_bucket.arn,
        "${aws_s3_bucket.shreya-static_bucket.arn}/*"
      ]
    }]
  })
}

# Attach Policy to EC2 Role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Instance Profile for EC2 to Assume the Role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_role.name
}


# Outputs
output "ec2_public_ip" {
  value = aws_instance.shreya_ec2.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.shreya-mysql_db.endpoint
}

output "s3_bucket_name" {
  value = aws_s3_bucket.shreya-static_bucket.bucket
}
