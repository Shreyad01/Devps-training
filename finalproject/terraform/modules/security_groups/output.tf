# output of ec2 security group id
output "controller_sg_id" {
  value = aws_security_group.controller_sg.id
}

# output of rds security group id
output "worker_sg_id" {
    value = aws_security_group.worker_sg.id  
}