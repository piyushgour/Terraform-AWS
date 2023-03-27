provider "aws" {
  region = "us-east-1"
}
module "alb" {
  source = "../alb_module"

  security_groups = ["sg-abc",]
  subnets = ["subnet-abc","subnet-abc"]
  vpc_id = "vpc-abc"
  certificate_arn = "cert-arn:aws:"


}

# module "tg-group" {
#   source = "../lb_target_group_module"

#   load_balancer_arn = module.alb.lb_arn
#   target_id = module.alb.lb_id
# }