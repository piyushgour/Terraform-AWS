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
  ami = var.image               # calling Input variable from "Variable" block (within this file) 
  instance_type = local.type    # calling local variable from "local" block 
  subnet_id = var.subnet_id     # calling variable from variables.tf file
  # some other code ... 
 
}


provider "aws" {
  region = var.aws_region           # variable value (us-west-1) is come from variables.tf file
  access_key = var.aws_access_key   # variable value (xxxxx) came from terraform.tfvars file 
  secret_key = var.aws_secret_key   # variable value (yyyyy) came from terraform.tfvars file
}


output "Instance_id" {
  value = aws_instance.web-server.id
}

output "webserver_public_ip" {
  value = aws_instance.web-server.public_ip
}