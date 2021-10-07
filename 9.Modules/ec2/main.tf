resource "aws_instance" "test" {
  ami           = var.ami_id
  instance_type = var.ec2_type
  key_name      = var.login_key
  subnet_id     = var.subnet_id
  ebs_optimized = var.ebs_optimized
  monitoring    = var.ec2_monitoring

  tags {
    Name       = "Terraform"
    department = "Devops"
    team       = "Infra"
    app        = "resources"
    env        = "Dev"
  }
}
