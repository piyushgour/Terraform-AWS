provider "aws" {
  region = "us-east-1"
}
module "alb" {
  source = "../alb_module"

  security_groups = ["sg-2dd8a803",]
  subnets = ["subnet-0ea52343","subnet-b58f7294"]
  vpc_id = "vpc-d6d2d1ac"
  certificate_arn = "arn:aws:acm:us-east-1:463423328685:certificate/b93a6772-95f2-44a0-b37e-f1d8438ffbd0"


}

# module "tg-group" {
#   source = "../lb_target_group_module"

#   load_balancer_arn = module.alb.lb_arn
#   target_id = module.alb.lb_id
# }