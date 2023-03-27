variable "subnets" {
  type = list
  default = ["subnet-0ea52343","subnet-b58f7294"]
}

# variable "lb_arn" {
#     type = string
#   default = module.alb.arn
# }

# variable "tget_id" {
#     type = string
#     default = module.alb.id
# }