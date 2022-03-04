variable "subnet_id" {
    type = string
    default = "sub-123456"
    description = "This is Apache Webserver."
}

variable "aws_region" {
  type = string
  default = "us-west-1"
  description = "This is the region where resource are deployed."
}
variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}