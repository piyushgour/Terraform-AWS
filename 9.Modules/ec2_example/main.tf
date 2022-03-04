provider "aws" {
  region = "us-east-1"
}


module "web_instance" {
  source = "../ec2"

  login_key = var.pam_key
}