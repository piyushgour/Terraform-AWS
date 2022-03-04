provider "aws" {
  region = "us-east-1"
}


## EC2 with minimam Attribute

resource "aws_instance" "test1" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
}


## EC2 with Hardcode Values and Tags

resource "aws_instance" "test2" {
  ami                    = "ami-0ff8a91507f77f867"
  instance_type          = "t2.micro"
  key_name               = "test2"
  subnet_id              = "sub-123456788"
  vpc_security_group_ids = ["sg-123456", "sg-987654"]
  ebs_optimized          = false
  monitoring             = false

  tags = {
    Name            = "Test-2"
    "Owner Account" = "DevOps"
    Purpose         = "Testing"
    Environment     = "dev"
  }
}

# EC2 instacne with root block device and hardcode values 
resource "aws_instance" "test3" {
  ami                    = "ami-0ff8a91507f77f867"
  instance_type          = "t2.micro"
  key_name               = "test3"
  subnet_id              = "sub-123456788"
  vpc_security_group_ids = ["sg-123456", "sg-987654"]
  ebs_optimized          = false
  monitoring             = false
  iam_instance_profile = "Profile-Name"

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
    delete_on_termination = true

  }
}

# EC2 with additional EBS volume and Encryption Enable
resource "aws_instance" "test3" {
  ami                    = "ami-0ff8a91507f77f867"
  instance_type          = "t2.micro"
  key_name               = "test3"
  subnet_id              = "sub-123456788"
  vpc_security_group_ids = ["sg-123456", "sg-987654"]
  ebs_optimized          = false
  monitoring             = false
  iam_instance_profile = "Profile-Name"

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
    encrypted = true
    delete_on_termination = true

  }

  ebs_block_device {
      device_name = "/dev/sdf"
    volume_size = 30
    volume_type = "gp2"
    encrypted = true
    delete_on_termination = false

  }  
}