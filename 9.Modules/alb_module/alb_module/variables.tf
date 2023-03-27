
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "lb_tags" {
  description = "A map of lb_tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "create_lb" {
  description = "Controls if the Load Balancer should be created"
  type        = bool
  default     = true
}

variable "name" {
  description = "The resource name and Name tag of the load balancer."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "The resource name prefix and Name tag of the load balancer. Cannot be longer than 6 characters"
  type        = string
  default     = null
}

variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible values are application or network."
  type        = string
  default     = "application"
}

variable "internal" {
  description = "Boolean determining if the load balancer is internal or externally facing."
  type        = bool
  default     = false
}

variable "access_logs" {
  description = "Map containing access logging configuration for load balancer."
  type        = map(string)
  default     = {}
}

variable "security_groups" {
  description = "The security groups to attach to the load balancer. e.g. [\"sg-edcd9784\",\"sg-edcd9785\"]"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "A list of subnets to associate with the load balancer. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f']"
  type        = list(string)
  default     = null
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  type        = number
  default     = 60
}

variable "enable_cross_zone_load_balancing" {
  description = "Indicates whether cross zone load balancing should be enabled in application load balancers."
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Indicates whether HTTP/2 is enabled in application load balancers."
  type        = bool
  default     = true
}

variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack."
  type        = string
  default     = "ipv4"
}

variable "drop_invalid_header_fields" {
  description = "Indicates whether invalid header fields are dropped in application load balancers. Defaults to false."
  type        = bool
  default     = false
}

variable "preserve_host_header" {
  description = "Indicates whether Host header should be preserve and forward to targets without any change. Defaults to false."
  type        = bool
  default     = false
}

variable "enable_waf_fail_open" {
  description = "Indicates whether to route requests to targets if lb fails to forward the request to AWS WAF"
  type        = bool
  default     = false
}

variable "desync_mitigation_mode" {
  description = "Determines how the load balancer handles requests that might pose a security risk to an application due to HTTP desync."
  type        = string
  default     = "defensive"
}

variable "load_balancer_create_timeout" {
  description = "Timeout value when creating the ALB."
  type        = string
  default     = "10m"
}

variable "load_balancer_delete_timeout" {
  description = "Timeout value when deleting the ALB."
  type        = string
  default     = "10m"
}

variable "load_balancer_update_timeout" {
  description = "Timeout value when updating the ALB."
  type        = string
  default     = "10m"
}



# variable "tags" {
#   description = "A map of tags to add to all resources"
#   type        = map(string)
#   default     = {}
# }

variable "target_group_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "alb_arn" {
  description = "The ALB arn name."
  type        = string
  default     = ""
}

variable "alb_id" {
  description = "The ALB arn ID."
  type        = string
  default     = ""
}

variable "tg_name" {
  description = "The resource name and Name tag of the load balancer."
  type        = string
  default     = null
}


# variable "name_prefix" {
#   description = "The resource name prefix and Name tag of the load balancer. Cannot be longer than 6 characters"
#   type        = string
#   default     = null
# }
variable "extra_ssl_certs" {
  description = "A list of maps describing any extra SSL certificates to apply to the HTTPS listeners. Required key/values: certificate_arn, https_listener_index (the index of the listener within https_listeners which the cert applies toward)."
  type        = list(map(string))
  default     = []
}

variable "vpc_id" {
  description = "VPC id where the load balancer and other resources will be deployed."
  type        = string
  default     = null
}

variable "target_type" {
  description = "Target type allowed valuse for ALB is instance or ip."
  type        = string
  default     = "alb"
}

variable "load_balancing_algorithm_type" {
  description = "load_balancing_algorithm_type allowed valuse for ALB is round_robin or least_outstanding_requests."
  type        = string
  default     = "round_robin"
}

variable "protocol" {
  description = "Protocal of the load balancer and values are HTTP or HTTPS."
  type        = string
  default     = "TCP"
}

variable "health_check_path" {
  description = "health_check_path of the load balancer and values are HTTP or HTTPS."
  type        = string
  default     = "/"
}

variable "health_check_port" {
  description = "health_check_port of the load balancer and values are HTTP or HTTPS."
  type        = number
  default     = 80
}
variable "protocol_version" {
  description = "Protocal of the load balancer and values are HTTP or HTTPS."
  type        = string
  default     = "HTTP1"
}

variable "healthy_threshold" {
  description = "number of consecutive health check successes required before considering a target healthy. The range is 2-10. "
  type        = number
  default     = 5
}

variable "unhealthy_threshold" {
  description = "Number of consecutive health check failures required before considering a target unhealthy. The range is 2-10."
  type        = number
  default     = 3
}
variable "timeout" {
  description = "Amount of time, in seconds, during which no response from a target means a failed health check. The range is 2–120 seconds."
  type        = number
  default     = 3
}

variable "interval" {
  description = "Approximate amount of time, in seconds, between health checks of an individual target. The range is 5-300."
  type        = number
  default     = 5
}

variable "matcher" {
  description = "Response codes to use when checking for a healthy responses from a target. You can specify multiple values (for example, 200,202 for HTTP(s) or 0,12 for GRPC)."
  type        = number
  default     = 200 
}

variable "cookie_time" {
  description = "Only used when the type is lb_cookie. The time period, in seconds, during which requests from a client should be routed to the same target."
  type        = number
  default     = 3600
}

variable "enabled" {
  description = "Boolean to enable / disable stickiness. Default is true"
  type = bool
  default = true
}

variable "type" {
  description = "The type of sticky sessions. The only current possible values are lb_cookie, app_cookie for ALBs"
  type = string
  default = "lb_cookie"
}

variable "ssl_policy" {
  description = "Name of the SSL Policy for the listener. Required if protocol is HTTPS"
  type = string
  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "certificate_arn" {
  description = "ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS."
  type = string
  default = ""
}