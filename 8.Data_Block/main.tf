## Find the latest available AMI that is tagged with Component = Linux 
data "aws_ami" "example" {
  most_recent = true

  owners = ["self"]
  tags = {
    Name   = "linux"
    Tested = "true"
  }
}

## Find the latest AMI is from Official Ubuntu Server.
## 999999999999 is Ubuntu's account ID. 
data "aws_ami_ids" "ubuntu" {
  owners = ["999999999999"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/ubuntu-*-*-amd64-server-*"]
  }
}



## Getting Own VPC properties. 
data "aws_vpc" "my_vpc" {
  value = "vpc-0101010101"
}
resource "aws_subnet" "subnet" {
  vpc_id                  = data.aws_vpc.my_vpc.id    # refrence of VPC ID
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true" 
  availability_zone       = "us-east-1a"
    tags = {
        Name = "Test VPC Subnet"
    }
}
