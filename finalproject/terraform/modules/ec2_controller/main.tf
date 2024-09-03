# Create EC2 instance
resource "aws_instance" "webserver" {
  ami                         = var.ami
  instance_type               = var.instance_type
  # iam_instance_profile        = var.ec2_instance_profile_name
  associate_public_ip_address = true
  subnet_id                   = var.pub_subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = "finaltask-shreya"
  root_block_device {
    volume_size = 20
  }
  tags = {
    Name = "Controller-${var.instance_name}"
    Node = "Master"
  }
  # connection {
  #   type        = "ssh"
  #   user        = "ubuntu"
  #   private_key = file("/home/einfochips/Downloads/Ansible/Assessment/Final_Assessment/final-task-shreya-ap-south.pem")
  #   host        = self.public_ip
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt-get update",
  #     "sudo apt-get install -y nginx",
  #     "sudo systemctl start nginx",
  #     "sudo systemctl enable nginx",
  #     "sudo apt update && sudo apt install ansible -y",
  #     "ansible --version"
  #   ]
  # }
  # provisioner "local-exec" {
  #   command = "echo 'Nginx installation initiated on ${aws_instance.webserver.public_ip}'"
  # }
 
}

# Create the Elastic IP
# resource "aws_eip" "my_eip" {
#   domain = "vpc"
#   # instance = aws_instance.webserver.id
#   tags = {
#     Name = "eip-shreya"
#   }
# }

# # # Associate the Elastic IP with the EC2 instance
# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.webserver.id
#   allocation_id = aws_eip.my_eip.id
# }