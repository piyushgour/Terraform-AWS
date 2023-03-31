# AWS Application Load Balancer (ALB) Terraform module

Terraform module which creates Application Load Balancer resources on AWS.

## Usage

### Application Load Balancer

HTTP and HTTPS listeners with default actions:

```hcl
module "alb" {
  source  = "../module"
  name = "my-alb"
  load_balancer_type = "application"
  vpc_id             = "vpc-abcde"
  subnets            = ["subnet-abcd", "subnet-bcde"]
  security_groups    = ["sg-edcd", "sg-edcd9"]
  access_logs = {
    bucket = "my-alb-logs"
  }
  target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        my_target = {
          target_id = "i-012345678"
          port = 80
        }
        my_other_target = {
          target_id = "i-a1b2c3d4e"
          port = 8080
        }
      }
    }
  ]
  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
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
```

## Assumptions

It's recommended you use this module with [terraform-aws-vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws), [terraform-aws-security-group](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws), and [terraform-aws-autoscaling](https://registry.terraform.io/modules/terraform-aws-modules/autoscaling/aws/).

## Notes

1. Terraform AWS provider version v2.39.0 and  related to "Provider produced inconsistent final plan". It means that S3 bucket has to be created before referencing it as an argument inside `access_logs = { bucket = "my-already-created-bucket-for-logs" }`, so this won't work: `access_logs = { bucket = module.log_bucket.s3_bucket_id }`.

## Conditional creation

Sometimes you need to have a way to create ALB resources conditionally but Terraform does not allow to use `count` inside `module` block, so the solution is to specify argument `create_lb`.

```hcl
# This LB will not be created
module "lb" {
 source = "../module"

 create_lb = false
 # ... omitted
}
```




## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.59 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.59 |



## Resources

| Name | Type |
|------|------|
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.frontend_http_tcp](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.frontend_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.http_tcp_listener_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_listener_rule.https_listener_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs"></a> [access\_logs](#input\_access\_logs) | Map containing access logging configuration for load balancer. | `map(string)` | `{}` | no |
| <a name="input_create_lb"></a> [create\_lb](#input\_create\_lb) | Controls if the Load Balancer should be created | `bool` | `true` | no |
| <a name="input_desync_mitigation_mode"></a> [desync\_mitigation\_mode](#input\_desync\_mitigation\_mode) | Determines how the load balancer handles requests that might pose a security risk to an application due to HTTP desync. | `string` | `"defensive"` | no |
| <a name="input_drop_invalid_header_fields"></a> [drop\_invalid\_header\_fields](#input\_drop\_invalid\_header\_fields) | Indicates whether invalid header fields are dropped in application load balancers. Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | Indicates whether cross zone load balancing should be enabled in application load balancers. | `bool` | `false` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_http2"></a> [enable\_http2](#input\_enable\_http2) | Indicates whether HTTP/2 is enabled in application load balancers. | `bool` | `true` | no |
| <a name="input_enable_tls_version_and_cipher_suite_headers"></a> [enable\_tls\_version\_and\_cipher\_suite\_headers](#input\_enable\_tls\_version\_and\_cipher\_suite\_headers) | Indicates whether the two headers (x-amzn-tls-version and x-amzn-tls-cipher-suite), which contain information about the negotiated TLS version and cipher suite, are added to the client request before sending it to the target. | `bool` | `false` | no |
| <a name="input_enable_waf_fail_open"></a> [enable\_waf\_fail\_open](#input\_enable\_waf\_fail\_open) | Indicates whether to route requests to targets if lb fails to forward the request to AWS WAF | `bool` | `false` | no |
| <a name="input_enable_xff_client_port"></a> [enable\_xff\_client\_port](#input\_enable\_xff\_client\_port) | Indicates whether the X-Forwarded-For header should preserve the source port that the client used to connect to the load balancer in application load balancers. | `bool` | `true` | no |
| <a name="input_extra_ssl_certs"></a> [extra\_ssl\_certs](#input\_extra\_ssl\_certs) | A list of maps describing any extra SSL certificates to apply to the HTTPS listeners. Required key/values: certificate\_arn, https\_listener\_index (the index of the listener within https\_listeners which the cert applies toward). | `list(map(string))` | `[]` | no |
| <a name="input_http_tcp_listener_rules"></a> [http\_tcp\_listener\_rules](#input\_http\_tcp\_listener\_rules) | A list of maps describing the Listener Rules for this ALB. Required key/values: actions, conditions. Optional key/values: priority, http\_tcp\_listener\_index (default to http\_tcp\_listeners[count.index]) | `any` | `[]` | no |
| <a name="input_http_tcp_listener_rules_tags"></a> [http\_tcp\_listener\_rules\_tags](#input\_http\_tcp\_listener\_rules\_tags) | A map of tags to add to all http listener rules | `map(string)` | `{}` | no |
| <a name="input_http_tcp_listeners"></a> [http\_tcp\_listeners](#input\_http\_tcp\_listeners) | A list of maps describing the HTTP listeners or TCP ports for this ALB. Required key/values: port, protocol. Optional key/values: target\_group\_index (defaults to http\_tcp\_listeners[count.index]) | `any` | `[]` | no |
| <a name="input_http_tcp_listeners_tags"></a> [http\_tcp\_listeners\_tags](#input\_http\_tcp\_listeners\_tags) | A map of tags to add to all http listeners | `map(string)` | `{}` | no |
| <a name="input_https_listener_rules"></a> [https\_listener\_rules](#input\_https\_listener\_rules) | A list of maps describing the Listener Rules for this ALB. Required key/values: actions, conditions. Optional key/values: priority, https\_listener\_index (default to https\_listeners[count.index]) | `any` | `[]` | no |
| <a name="input_https_listener_rules_tags"></a> [https\_listener\_rules\_tags](#input\_https\_listener\_rules\_tags) | A map of tags to add to all https listener rules | `map(string)` | `{}` | no |
| <a name="input_https_listeners"></a> [https\_listeners](#input\_https\_listeners) | A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate\_arn. Optional key/values: ssl\_policy (defaults to ELBSecurityPolicy-2016-08), target\_group\_index (defaults to https\_listeners[count.index]) | `any` | `[]` | no |
| <a name="input_https_listeners_tags"></a> [https\_listeners\_tags](#input\_https\_listeners\_tags) | A map of tags to add to all https listeners | `map(string)` | `{}` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | The time in seconds that the connection is allowed to be idle. | `number` | `60` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Boolean determining if the load balancer is internal or externally facing. | `bool` | `false` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack. | `string` | `"ipv4"` | no |
| <a name="input_lb_tags"></a> [lb\_tags](#input\_lb\_tags) | A map of tags to add to load balancer | `map(string)` | `{}` | no |
| <a name="input_listener_ssl_policy_default"></a> [listener\_ssl\_policy\_default](#input\_listener\_ssl\_policy\_default) | The security policy if using HTTPS externally on the load balancer. [See](https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html). | `string` | `"ELBSecurityPolicy-2016-08"` | no |
| <a name="input_load_balancer_create_timeout"></a> [load\_balancer\_create\_timeout](#input\_load\_balancer\_create\_timeout) | Timeout value when creating the ALB. | `string` | `"10m"` | no |
| <a name="input_load_balancer_delete_timeout"></a> [load\_balancer\_delete\_timeout](#input\_load\_balancer\_delete\_timeout) | Timeout value when deleting the ALB. | `string` | `"10m"` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | The type of load balancer to create. Possible values are application or network. | `string` | `"application"` | no |
| <a name="input_load_balancer_update_timeout"></a> [load\_balancer\_update\_timeout](#input\_load\_balancer\_update\_timeout) | Timeout value when updating the ALB. | `string` | `"10m"` | no |
| <a name="input_name"></a> [name](#input\_name) | The resource name and Name tag of the load balancer. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The resource name prefix and Name tag of the load balancer. Cannot be longer than 6 characters | `string` | `null` | no |
| <a name="input_preserve_host_header"></a> [preserve\_host\_header](#input\_preserve\_host\_header) | Indicates whether Host header should be preserve and forward to targets without any change. Defaults to false. | `bool` | `false` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | The security groups to attach to the load balancer. e.g. ["sg-edcd9784","sg-edcd9785"] | `list(string)` | `[]` | no |
| <a name="input_subnet_mapping"></a> [subnet\_mapping](#input\_subnet\_mapping) | A list of subnet mapping blocks describing subnets to attach to network load balancer | `list(map(string))` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | A list of subnets to associate with the load balancer. e.g. ['subnet-1a2b3c4d','subnet-1a2b3c4e','subnet-1a2b3c4f'] | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_target_group_tags"></a> [target\_group\_tags](#input\_target\_group\_tags) | A map of tags to add to all target groups | `map(string)` | `{}` | no |
| <a name="input_target_groups"></a> [target\_groups](#input\_target\_groups) | A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend\_protocol, backend\_port | `any` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id where the load balancer and other resources will be deployed. | `string` | `null` | no |

