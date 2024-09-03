variable "shreya_vpc_id" {
    type = string
}

variable "controller_ingress_rules" {
  type = list(object({
    from_port  = number
    to_port    = number
  }))

  default = [ {
    from_port   = 6443
    to_port     = 6443
  },
  {
    from_port   = 2379
    to_port     = 2380
  },
  {
    from_port   = 10250
    to_port     = 10250
  },
  {
    from_port   = 10257
    to_port     = 10257
  },
  {
    from_port   = 10259
    to_port     = 10259
  },
  {
    from_port   = 8080
    to_port     = 8080
  },
  {
    from_port   = 22
    to_port     = 22
  },
  {
    from_port   = 443
    to_port     = 443
  },
  {
    from_port   = 80
    to_port     = 80
  } ]
}

variable "worker_ingress_rules" {
  type = list(object({
    from_port = number
    to_port   = number
  }))
  default = [ {
    from_port   = 10250
    to_port     = 10250
  },
  {
    from_port   = 30000
    to_port     = 32767
  },
  {
    from_port   = 22
    to_port     = 22
  },
  {
    from_port   = 443
    to_port     = 443
  },
  {
    from_port   = 80
    to_port     = 80
  } ]
}