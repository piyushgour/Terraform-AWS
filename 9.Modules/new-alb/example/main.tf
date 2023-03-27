module "alb" {
  source  = "../module"

  name = "my-alb"

  load_balancer_type = "application"

  vpc_id             = "vpc-d6d2d1ac"
  subnets            = ["subnet-0ea52343","subnet-b58f7294"]
  security_groups    = ["sg-2dd8a803",]

#   access_logs = {
#     bucket = "my-alb-logs"
#   }

  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        my_target = {
          target_id = "i-027d6079d7ae74241"
          port = 80
        }
        # my_other_target = {
        #   target_id = "i-024ab5722e9d189d0"
        #   port = 8080
        # }
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:acm:us-east-1:463423328685:certificate/b93a6772-95f2-44a0-b37e-f1d8438ffbd0"
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Test"
  }
}