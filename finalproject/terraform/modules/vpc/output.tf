# output of public subnet id
output "pub_subnet_id" {
  value = aws_subnet.public_subnet.id
}

# output of vpc id
output "shreya_vpc_id" {
  value = aws_vpc.shreya_vpc.id
}