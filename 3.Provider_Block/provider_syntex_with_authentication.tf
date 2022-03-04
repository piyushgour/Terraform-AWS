# Static Credentials
# Hard-coded credentials are not recommended.
provider "aws" {
  region     = "us-west-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}


# Environment Variables
# you can run below commands in Linux. And leave provider block null/empty. 
#  export AWS_ACCESS_KEY_ID="Accesskey"
#  export AWS_SECRET_ACCESS_KEY="Secretkey"
#  export AWS_DEFAULT_REGION="us-west-2"

provider "aws" {

}

# Shared Credentials File
provider "aws" {
  region                  = "us-west-2"
  shared_credentials_file = "/home/user-name/.aws/creds"
  profile                 = "Dev"
}