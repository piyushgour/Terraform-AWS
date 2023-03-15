resource "aws_lb_target_group" "alb-tg" {
  name        = var.tg_name
  target_type = var.target_type
  port        = 80
  protocol    = upper(var.protocol)
  protocol_version = upper(var.protocol_version)
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
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.This.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy 
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.This.arn
  port              = "80"
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
  action {
    target_group_arn = aws_lb_target_group.alb-tg.arn
    type = "forward"
  }
  condition {
      path_pattern {
      values = ["/*"]
    }
  }

  listener_arn = aws_alb_listener.alb-listener.arn
  priority = 100
}


resource "aws_lb_target_group_attachment" "alb_taget_group_attachment" {
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id        = aws_lb.This.id
  port             = 80
}