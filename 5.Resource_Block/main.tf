# Resource block with Required arguement 

resource "aws_instance" "web_server" {
  ami           = "ami-abc1234"
  instance_type = "t2.micro"
}


# Resource Block with more arguments

resource "aws_instance" "web_server" {
  ami           = "ami-abc1234"
  instance_type = "t2.micro"
  key_name = "test-key"
  subnet_id = "sub-12345xyz"
  security_groups = [ "sg-12345","sg-98765" ]

  # Some other arguments ...
}


# Resource with  Meta Arguments

resource "aws_key_pair" "test-key" {
    key_name   = "test-key"
    public_key = "ssh-rsa ---Your---Public---Key---vOSs="
}

resource "aws_instance" "web_server" {
    count = 4                       # Count create 4 similer configration instance
    ami           = "ami-abc1234"
    instance_type = "t2.micro"
    key_name = aws_key_pair.test-key
    # Some other code ...

    ## depends_on meta-argument to handle hidden resource 
    ## or module dependencies that Terraform can't automatically infer.
    depends_on = [
        aws_key_pair.test-key,
    ]
}