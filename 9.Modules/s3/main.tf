provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "test-bucket" {
  bucket = "my-test-bucket-1414"

  tags = {
    Name        = "my-test-bucket-1414"
    Environment = "Dev-Test"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.test-bucket.id
  acl    = "private"
}