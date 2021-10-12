variable "cidr_range_for_web_vpc" {
  type = string
  default = "20.20.0.0/16"
}

variable "public_subnet_for_web" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["20.20.1.0/24","20.20.2.0/24",]
}