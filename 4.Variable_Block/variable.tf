# Input Variable 

variable "image" {
  type = string
  default = "ami-123456789"
  description = "The id of the machine image (AMI) to use for the server."

}

# Local Variable
# This variable is only work's with in the file.
locals {
  type = "t2.micro"  

}

resource "aws_instance" "web-server" {
  ami = var.image
  instance_type = local.type
  # some other code ... 

}