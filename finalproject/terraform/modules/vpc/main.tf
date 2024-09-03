# Create the VPC
resource "aws_vpc" "shreya_vpc" {
  cidr_block = var.vpc_cidr_ip

  tags = {
    Name = "MyVPC-shreya"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.shreya_vpc.id

  tags = {
    Name = "MyIGW-shreya"
  }
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.shreya_vpc.id
  cidr_block              = var.pub_subnet_cidr_ip
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "pub-sub-shreya"
  }
}


# Create a route table for the public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.shreya_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "Pub-RT-shreya"
  }
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}