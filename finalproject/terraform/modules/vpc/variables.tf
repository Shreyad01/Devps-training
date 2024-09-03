variable "vpc_cidr_ip" {
    description = "var for vpc cidr and ip"
    type = string
}

# variable for public subnet cidr ip
variable "pub_subnet_cidr_ip" {
    description = "var for public subnet cidr and ip"
    type = string
}

variable "region" {
  type = string
}
# variable "pub_subnet_id" {
#   description = "public subnet id"
#   type = string  
# }