provider "aws" {
  region = "us-east-1"
}
# resource "aws_lb_target_group" "alb-example" {
#   name        = "tf-example-lb-alb-tg"
#   target_type = "ip"
#   port        = 80
#   protocol    = "HTTP"
#   vpc_id      = "vpc-d6d2d1ac"
# }

# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.test.arn
#   port              = "80"
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb-example.arn
#   }
# }

# resource "aws_lb_target_group_attachment" "test" {
#   target_group_arn = aws_lb_target_group.alb-example.arn
#   target_id        = "172.31.1.0"
#   port             = 80
# }
# resource "aws_lb" "test" {
#   name               = "test-lb-tf"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = ["sg-0e315973aa76f0a87"]
#   subnets            = ["subnet-0ea52343","subnet-b58f7294"]

#   enable_deletion_protection = false
#   # access_logs {
#   #   bucket  = aws_s3_bucket.lb_logs.id
#   #   prefix  = "test-lb"
#   #   enabled = true
#   # }

#   tags = {
#     Environment = "terraform-test"
#   }
# }



####################################
###     New Module
####################################

locals {
  create_lb = var.create_lb
}
resource "aws_lb" "this" {
  #count = local.create_lb ? 1 : 0

  name        = var.name

  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  security_groups    = var.security_groups
  subnets            = var.subnets

  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  enable_http2                     = var.enable_http2
  ip_address_type                  = var.ip_address_type
  drop_invalid_header_fields       = var.drop_invalid_header_fields
  preserve_host_header             = var.preserve_host_header
  enable_waf_fail_open             = var.enable_waf_fail_open
  desync_mitigation_mode           = var.desync_mitigation_mode

  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = merge(
    {
      Name = (var.name != null) ? var.name : var.name_prefix
    },
    var.tags,
    var.lb_tags,
  )
  timeouts {
    create = var.load_balancer_create_timeout
    update = var.load_balancer_update_timeout
    delete = var.load_balancer_delete_timeout
  }
}


resource "aws_lb_target_group" "alb-example" {
  name        = "tf-example-lb-alb-tg"
  target_type = var.target_type
  port        = 80
  protocol    = upper(var.protocol)
  protocol_version = upper(var.protocol_version)
  vpc_id      = var.vpc_id

  load_balancing_algorithm_type = var.load_balancing_algorithm_type

  health_check {
    path = var.health_check_path
    port = var.health_check_port
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"  # has to be HTTP 200 or fails
  }

  stickiness {
    cookie_duration = 3600
    enabled = true
    type = "lb_cookie"
  }

    tags = merge(
    var.tags,
    var.target_group_tags,
  )

  lifecycle {
    create_before_destroy = true
  }


}

# Create a Listener 
resource "aws_alb_listener" "my-alb-listener" {
  depends_on = [aws_lb_target_group.alb-example]
  #count = local.create_lb ? length(var.https_listeners) : 0
  default_action {
    target_group_arn =  aws_lb_target_group.alb-example.arn
    type = "forward"
  }
  load_balancer_arn = aws_lb.this.arn
  port = 80
  protocol = "HTTP"
}


# Create Listener Rules
resource "aws_alb_listener_rule" "rule-1" {
  depends_on = [
    aws_lb_target_group.alb-example
  ]
  action {
    target_group_arn =  aws_lb_target_group.alb-example.arn
    type = "forward"
  }
  condition {
      path_pattern {
      values = ["/*"]
    }
  }

  listener_arn = aws_alb_listener.my-alb-listener.arn
  priority = 100
}


# resource "aws_lb_target_group_attachment" "alb_taget_group_attachment" {
#   target_group_arn = aws_lb_target_group.alb-example
#   target_id        = aws_lb.this.id
#   port             = 80
# }

