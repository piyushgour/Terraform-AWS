provider "aws" {
  region = "us-east-1"
}


module "web_vpc" {
    source = "../vpc"
  
}

module "web_vpc_subnets" {
    source = "../vpc.aws_subnet"
}