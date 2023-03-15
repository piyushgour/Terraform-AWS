locals {
  create_lb = var.create_lb && var.putin_khuylo
}

resource "aws_lb" "this" {
  count = local.create_lb ? 1 : 0

  name        = var.name
  name_prefix = var.name_prefix

  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  security_groups    = var.create_security_group && var.load_balancer_type == "application" ? concat([aws_security_group.this[0].id], var.security_groups) : var.security_groups
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

  dynamic "access_logs" {
    for_each = length(var.access_logs) > 0 ? [var.access_logs] : []

    content {
      enabled = try(access_logs.value.enabled, try(access_logs.value.bucket, null) != null)
      bucket  = try(access_logs.value.bucket, null)
      prefix  = try(access_logs.value.prefix, null)
    }
  }

  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping

    content {
      subnet_id            = subnet_mapping.value.subnet_id
      allocation_id        = lookup(subnet_mapping.value, "allocation_id", null)
      private_ipv4_address = lookup(subnet_mapping.value, "private_ipv4_address", null)
      ipv6_address         = lookup(subnet_mapping.value, "ipv6_address", null)
    }
  }

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

resource "aws_lb_target_group" "main" {
  count = local.create_lb ? length(var.target_groups) : 0

  name        = lookup(var.target_groups[count.index], "name", null)
  name_prefix = lookup(var.target_groups[count.index], "name_prefix", null)

  vpc_id           = var.vpc_id
  port             = try(var.target_groups[count.index].backend_port, null)
  protocol         = try(upper(var.target_groups[count.index].backend_protocol), null)
  protocol_version = try(upper(var.target_groups[count.index].protocol_version), null)
  target_type      = try(var.target_groups[count.index].target_type, null)

  connection_termination             = try(var.target_groups[count.index].connection_termination, null)
  deregistration_delay               = try(var.target_groups[count.index].deregistration_delay, null)
  slow_start                         = try(var.target_groups[count.index].slow_start, null)
  proxy_protocol_v2                  = try(var.target_groups[count.index].proxy_protocol_v2, false)
  lambda_multi_value_headers_enabled = try(var.target_groups[count.index].lambda_multi_value_headers_enabled, false)
  load_balancing_algorithm_type      = try(var.target_groups[count.index].load_balancing_algorithm_type, null)
  preserve_client_ip                 = try(var.target_groups[count.index].preserve_client_ip, null)
  ip_address_type                    = try(var.target_groups[count.index].ip_address_type, null)

  dynamic "health_check" {
    for_each = try([var.target_groups[count.index].health_check], [])

    content {
      enabled             = try(health_check.value.enabled, null)
      interval            = try(health_check.value.interval, null)
      path                = try(health_check.value.path, null)
      port                = try(health_check.value.port, null)
      healthy_threshold   = try(health_check.value.healthy_threshold, null)
      unhealthy_threshold = try(health_check.value.unhealthy_threshold, null)
      timeout             = try(health_check.value.timeout, null)
      protocol            = try(health_check.value.protocol, null)
      matcher             = try(health_check.value.matcher, null)
    }
  }

  dynamic "stickiness" {
    for_each = try([var.target_groups[count.index].stickiness], [])

    content {
      enabled         = try(stickiness.value.enabled, null)
      cookie_duration = try(stickiness.value.cookie_duration, null)
      type            = try(stickiness.value.type, null)
      cookie_name     = try(stickiness.value.cookie_name, null)
    }
  }

  tags = merge(
    var.tags,
    var.target_group_tags,
    lookup(var.target_groups[count.index], "tags", {}),
    {
      "Name" = try(var.target_groups[count.index].name, var.target_groups[count.index].name_prefix, "")
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  # Merge the target group index into a product map of the targets so we
  # can figure out what target group we should attach each target to.
  # Target indexes can be dynamically defined, but need to match
  # the function argument reference. This means any additional arguments
  # can be added later and only need to be updated in the attachment resource below.
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment#argument-reference
  target_group_attachments = merge(flatten([
    for index, group in var.target_groups : [
      for k, targets in group : {
        for target_key, target in targets : join(".", [index, target_key]) => merge({ tg_index = index }, target)
      }
      if k == "targets"
    ]
  ])...)

  # Filter out the attachments for lambda functions. The ALB target group needs permission to forward a request on to
  # the specified lambda function. This filtered list is used to create those permission resources
  target_group_attachments_lambda = {
    for k, v in local.target_group_attachments :
    (k) => merge(v, { lambda_function_name = split(":", v.target_id)[6] })
    if try(v.attach_lambda_permission, false)
  }
}



resource "aws_lb_target_group_attachment" "this" {
  for_each = { for k, v in local.target_group_attachments : k => v if local.create_lb }

  target_group_arn  = aws_lb_target_group.main[each.value.tg_index].arn
  target_id         = each.value.target_id
  port              = lookup(each.value, "port", null)
  availability_zone = lookup(each.value, "availability_zone", null)

  depends_on = [aws_lambda_permission.lb]
}

resource "aws_lb_listener_rule" "https_listener_rule" {
  count = local.create_lb ? length(var.https_listener_rules) : 0

  listener_arn = aws_lb_listener.frontend_https[lookup(var.https_listener_rules[count.index], "https_listener_index", count.index)].arn
  priority     = lookup(var.https_listener_rules[count.index], "priority", null)

  # forward actions
  dynamic "action" {
    for_each = [
      for action_rule in var.https_listener_rules[count.index].actions :
      action_rule
      if action_rule.type == "forward"
    ]

    content {
      type             = action.value["type"]
      target_group_arn = aws_lb_target_group.main[lookup(action.value, "target_group_index", count.index)].id
    }
  }


  tags = merge(
    var.tags,
    var.https_listener_rules_tags,
    lookup(var.https_listener_rules[count.index], "tags", {}),
  )
}

resource "aws_lb_listener_rule" "http_tcp_listener_rule" {
  count = local.create_lb ? length(var.http_tcp_listener_rules) : 0

  listener_arn = aws_lb_listener.frontend_http_tcp[lookup(var.http_tcp_listener_rules[count.index], "http_tcp_listener_index", count.index)].arn
  priority     = lookup(var.http_tcp_listener_rules[count.index], "priority", null)


  # forward actions
  dynamic "action" {
    for_each = [
      for action_rule in var.http_tcp_listener_rules[count.index].actions :
      action_rule
      if action_rule.type == "forward"
    ]

    content {
      type             = action.value["type"]
      target_group_arn = aws_lb_target_group.main[lookup(action.value, "target_group_index", count.index)].id
    }
  }

  tags = merge(
    var.tags,
    var.http_tcp_listener_rules_tags,
    lookup(var.http_tcp_listener_rules[count.index], "tags", {}),
  )
}

resource "aws_lb_listener" "frontend_http_tcp" {
  count = local.create_lb ? length(var.http_tcp_listeners) : 0

  load_balancer_arn = aws_lb.this[0].arn

  port     = var.http_tcp_listeners[count.index]["port"]
  protocol = var.http_tcp_listeners[count.index]["protocol"]

  dynamic "default_action" {
    for_each = length(keys(var.http_tcp_listeners[count.index])) == 0 ? [] : [var.http_tcp_listeners[count.index]]

    # Defaults to forward action if action_type not specified
    content {
      type             = lookup(default_action.value, "action_type", "forward")
      target_group_arn = contains([null, ""], lookup(default_action.value, "action_type", "")) ? aws_lb_target_group.main[lookup(default_action.value, "target_group_index", count.index)].id : null

      dynamic "redirect" {
        for_each = length(keys(lookup(default_action.value, "redirect", {}))) == 0 ? [] : [lookup(default_action.value, "redirect", {})]

        content {
          path        = lookup(redirect.value, "path", null)
          host        = lookup(redirect.value, "host", null)
          port        = lookup(redirect.value, "port", null)
          protocol    = lookup(redirect.value, "protocol", null)
          query       = lookup(redirect.value, "query", null)
          status_code = redirect.value["status_code"]
        }
      }

      dynamic "forward" {
        for_each = length(keys(lookup(default_action.value, "forward", {}))) == 0 ? [] : [lookup(default_action.value, "forward", {})]

        content {
          dynamic "target_group" {
            for_each = forward.value["target_groups"]

            content {
              arn    = aws_lb_target_group.main[target_group.value["target_group_index"]].id
              weight = lookup(target_group.value, "weight", null)
            }
          }

          dynamic "stickiness" {
            for_each = length(keys(lookup(forward.value, "stickiness", {}))) == 0 ? [] : [lookup(forward.value, "stickiness", {})]

            content {
              enabled  = lookup(stickiness.value, "enabled", false)
              duration = lookup(stickiness.value, "duration", 60)
            }
          }
        }
      }
    }
  }

  tags = merge(
    var.tags,
    var.http_tcp_listeners_tags,
    lookup(var.http_tcp_listeners[count.index], "tags", {}),
  )
}

resource "aws_lb_listener" "frontend_https" {
  count = local.create_lb ? length(var.https_listeners) : 0

  load_balancer_arn = aws_lb.this[0].arn

  port            = var.https_listeners[count.index]["port"]
  protocol        = lookup(var.https_listeners[count.index], "protocol", "HTTPS")
  certificate_arn = var.https_listeners[count.index]["certificate_arn"]
  ssl_policy      = lookup(var.https_listeners[count.index], "ssl_policy", var.listener_ssl_policy_default)
  alpn_policy     = lookup(var.https_listeners[count.index], "alpn_policy", null)

  dynamic "default_action" {
    for_each = length(keys(var.https_listeners[count.index])) == 0 ? [] : [var.https_listeners[count.index]]
  }

  dynamic "default_action" {
    for_each = contains(["authenticate-oidc", "authenticate-cognito"], lookup(var.https_listeners[count.index], "action_type", {})) ? [var.https_listeners[count.index]] : []
    content {
      type             = "forward"
      target_group_arn = aws_lb_target_group.main[lookup(default_action.value, "target_group_index", count.index)].id
    }
  }

  tags = merge(
    var.tags,
    var.https_listeners_tags,
    lookup(var.https_listeners[count.index], "tags", {}),
  )
}

resource "aws_lb_listener_certificate" "https_listener" {
  count = local.create_lb ? length(var.extra_ssl_certs) : 0

  listener_arn    = aws_lb_listener.frontend_https[var.extra_ssl_certs[count.index]["https_listener_index"]].arn
  certificate_arn = var.extra_ssl_certs[count.index]["certificate_arn"]
}

################################################################################
# Security Group
################################################################################

locals {
  create_security_group = local.create_lb && var.create_security_group && var.load_balancer_type == "application"
  security_group_name   = try(coalesce(var.security_group_name, var.name, var.name_prefix), "")
}

resource "aws_security_group" "this" {
  count = local.create_security_group ? 1 : 0

  name        = var.security_group_use_name_prefix ? null : local.security_group_name
  name_prefix = var.security_group_use_name_prefix ? "${local.security_group_name}-" : null
  description = var.security_group_description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    var.security_group_tags,
    { "Name" = local.security_group_name },
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "this" {
  for_each = { for k, v in var.security_group_rules : k => v if local.create_security_group }

  # Required
  security_group_id = aws_security_group.this[0].id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = each.value.type

  # Optional
  description              = lookup(each.value, "description", null)
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}