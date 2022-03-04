variable "ami_id" {
  type = string
  default = "ami-0ff8a91507f77f867"
  description = "This is the region where resource are deployed."
}

variable "ec2_type" {
  type = string
  default = "t2.micro"
  description = "AWS Instance type."
}

variable "login_key" {
  type = string
  description = "PEM key name for using SSH/Login"
}

variable "subnet_id" {
    type = string
    default = "sub-123456788"
    description = "Subnet ID "
}

variable "ebs_optimized" {
  type = bool
  default = false
  description = "EBS volume encryption true/false. Enables true if you need high I/O."
}

variable "ec2_monitoring" {
  type = bool
  default = false 
  description = "set true if you need detailed matrix."
}

