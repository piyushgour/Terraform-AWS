resource "aws_vpc" "web_vpc" {
  cidr_block = var.cidr_range_for_web_vpc
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  tags = {
    Name               = "Web_VPC"
    Environment        = "Dev"
    Application        = "Front End"
  }
}


resource "aws_subnet" "web_vpc_subnet" {
    vpc_id = aws_vpc.web_vpc.id
    count = length(var.public_subnet_for_web)
    cidr_block = var.public_subnet_for_web[count.index]
    tags = {
    Name               = "Web_VPC_Subnet"
    Environment        = "Dev"
    Application        = "Front End"
  }

}