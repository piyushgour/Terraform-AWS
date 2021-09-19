# Terraform 0.13 and later

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


# Terraform 0.12 and earlier:
provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
}


# The default provider configuration; resources that begin with `aws_` will use
# it as the default, and it can be referenced as `aws`.
provider "aws" {
  region = "us-east-1"
}


# Additional provider configuration for west coast region; resources can
# reference this as `aws.west`.
provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

# Terraform needs the name of a provider configuration, it expects a reference of the form <PROVIDER NAME>.<ALIAS>. 
# In the example below, aws.west would refer to the provider with the us-west-2 region.
resource "aws_instance" "web-server" {
  provider = aws.west

  # ...
}