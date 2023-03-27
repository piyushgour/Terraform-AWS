locals {
  create_lb = var.create_lb
}
resource "aws_lb" "this" {
  count = local.create_lb ? 1 : 0

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



resource "aws_lb_target_group" "alb-tg" {
  name        = var.tg_name
  target_type = var.target_type
  port        = 443
  protocol    = upper(var.protocol)
  #protocol_version = upper(var.protocol_version)
  vpc_id      = var.vpc_id

  load_balancing_algorithm_type = var.load_balancing_algorithm_type

  health_check {
    path = var.health_check_path
    port = var.health_check_port
    healthy_threshold = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout = var.timeout
    interval = var.interval
    matcher = var.matcher # has to be HTTP 200 or fails
  }

  stickiness {
    cookie_duration = var.cookie_time #(3600) 1 hour
    enabled = var.enabled
    type = var.type
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
# resource "aws_lb_listener" "https_listener" {
#   load_balancer_arn =  aws_lb.this[0].arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = var.ssl_policy 
#   certificate_arn   = var.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.alb-tg.arn
#   }
# }


resource "aws_lb_listener" "http_listener" {
  depends_on = [
    aws_lb.this
  ]
  load_balancer_arn = aws_lb.this[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}



# Create Listener Rules
resource "aws_alb_listener_rule" "rule-1" {
  depends_on = [aws_lb_listener.http_listener]
  action {
    target_group_arn = aws_lb_target_group.alb-tg.arn
    type = "forward"
  }
  condition {
      path_pattern {
      values = ["/*"]
    }
  }

  listener_arn = aws_lb_listener.http_listener.arn 
  priority = 100
}


resource "aws_lb_target_group_attachment" "alb_taget_group_attachment" {
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id        = aws_lb.this[0].arn #"i-09d1a29ec5315e719" #aws_lb.this[0].arn
  port             = 80
}