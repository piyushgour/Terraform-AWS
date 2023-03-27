module "alb" {
  source  = "../module"

  name = "my-alb"

  load_balancer_type = "application"

  vpc_id             = "vpc-abc"
  subnets            = ["subnet-abc","subnet-abcd"]
  security_groups    = ["sg-abc",]

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
          target_id = "i-abc"
          port = 80
        }
        # my_other_target = {
        #   target_id = "i-abcd"
        #   port = 8080
        # }
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "CERT-ARN"
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