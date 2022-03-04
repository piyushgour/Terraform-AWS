resource "aws_security_group" "web_server_sg" {
    name        = "allow_https"
    description = "Allow HTTPS inbound traffic only"
    vpc_id      = "vpc-12345"

    ingress = [
    {
      description      = "Allow HTTPS to All"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]

  tags = {
    Name = "Allow_HTTPS"
  }

}