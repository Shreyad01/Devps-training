ami            = "ami-0522ab6e1ddcc7055"
instance_type  = "t2.micro"
instance_name  = "Webserver-shreya"
bucket_name    = "day30-shreya"
key_pair       = "shreya-terraform"
ec2_iam_role_arn = "arn:aws:iam::590184027274:role/EC2-S3-Role"

vpc_cidr_ip = "10.1.0.0/16"
pub_subnet_cidr_ip = "10.1.1.0/24"