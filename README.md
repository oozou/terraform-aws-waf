# AWS WAF Terraform Module

Terraform module with create vpc and subnet resources on AWS.

## Usage

```terraform
module "waf" {
  source = "git::ssh://git@github.com:oozou/terraform-aws-waf.git"
  name   = "test-waf"
  prefix = "oozou"
  is_enable_default_rule = true
  is_enable_sampled_requests = false
  is_enable_cloudwatch_metrics = false
  is_create_logging_configuration = true
  scope  = "CLOUDFRONT"
  environment = "dev"
  managed_rules = [
    {
      name            = "AWSManagedRulesAdminProtectionRuleSet",
      priority        = 60
      override_action = "none"
      excluded_rules  = []
    }
  ]
  ip_sets_rule = [
    {
      name               = "block-ip-set"
      priority           = 6
      action             = "block"
      ip_address_version = "IPV4"
      ip_set             = ["10.0.1.1/32"]
    }
  ]
  ip_rate_based_rule = {
    name : "ip-rate-limit",
    priority : 7,
    action : "block",
    limit : 100
  }
  redacted_fields = [
    {
      single_header = {
        name = "user-agent"
      }
    }
  ]

  logging_filter = {
    default_behavior = "DROP"
    filter = [
      {
        behavior    = "KEEP"
        requirement = "MEETS_ANY"
        condition = [
          {
            action_condition = {
              action = "ALLOW"
            }
          },
        ]
      }
    ]
  }
  association_resources = "arn:xxxxx"
  tags = {
    "Custom-Tag" = "1"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/4.8.0/docs/resources/cloudwatch_log_group) | resource |
| [aws_wafv2_ip_set.ipset](https://registry.terraform.io/providers/hashicorp/aws/4.8.0/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.this](https://registry.terraform.io/providers/hashicorp/aws/4.8.0/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.this](https://registry.terraform.io/providers/hashicorp/aws/4.8.0/docs/resources/wafv2_web_acl_association) | resource |
| [aws_wafv2_web_acl_logging_configuration.main](https://registry.terraform.io/providers/hashicorp/aws/4.8.0/docs/resources/wafv2_web_acl_logging_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_association_resources"></a> [association\_resources](#input\_association\_resources) | ARN of the ALB, CloudFront, Etc to be associated with the WAFv2 ACL. | `list(string)` | `[]` | no |
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | The action to perform if none of the rules contained in the WebACL match. | `string` | `"block"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Variable used as a prefix | `string` | n/a | yes |
| <a name="input_ip_rate_based_rule"></a> [ip\_rate\_based\_rule](#input\_ip\_rate\_based\_rule) | A rate-based rule tracks the rate of requests for each originating IP address, and triggers the rule action when the rate exceeds a limit that you specify on the number of requests in any 5-minute time span | <pre>object({<br>    name     = string<br>    priority = number<br>    action   = string<br>    limit    = number<br>  })</pre> | `null` | no |
| <a name="input_ip_sets_rule"></a> [ip\_sets\_rule](#input\_ip\_sets\_rule) | A rule to detect web requests coming from particular IP addresses or address ranges. | <pre>list(object({<br>    name               = string<br>    priority           = number<br>    ip_set             = list(string)<br>    action             = string<br>    ip_address_version = string<br>  }))</pre> | `[]` | no |
| <a name="input_is_create_logging_configuration"></a> [is\_create\_logging\_configuration](#input\_is\_create\_logging\_configuration) | Whether to create logging configuration in order start logging from a WAFv2 Web ACL to CloudWatch | `bool` | `true` | no |
| <a name="input_is_enable_cloudwatch_metrics"></a> [is\_enable\_cloudwatch\_metrics](#input\_is\_enable\_cloudwatch\_metrics) | The action to perform if none of the rules contained in the WebACL match. | `bool` | `true` | no |
| <a name="input_is_enable_default_rule"></a> [is\_enable\_default\_rule](#input\_is\_enable\_default\_rule) | If true with enable default rule (detail in locals.tf) | `bool` | `true` | no |
| <a name="input_is_enable_sampled_requests"></a> [is\_enable\_sampled\_requests](#input\_is\_enable\_sampled\_requests) | Whether AWS WAF should store a sampling of the web requests that match the rules. You can view the sampled requests through the AWS WAF console. | `bool` | `true` | no |
| <a name="input_logging_filter"></a> [logging\_filter](#input\_logging\_filter) | A configuration block that specifies which web requests are kept in the logs and which are dropped. You can filter on the rule action and on the web request labels that were applied by matching rules during web ACL evaluation. | `any` | `{}` | no |
| <a name="input_managed_rules"></a> [managed\_rules](#input\_managed\_rules) | List of Managed WAF rules. | <pre>list(object({<br>    name            = string<br>    priority        = number<br>    override_action = string<br>    excluded_rules  = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | A friendly name of the WebACL. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix name of customer to be displayed in AWS console and resource | `string` | n/a | yes |
| <a name="input_redacted_fields"></a> [redacted\_fields](#input\_redacted\_fields) | The parts of the request that you want to keep out of the logs. Up to 100 `redacted_fields` blocks are supported. | `any` | `[]` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the WAFv2 ACL. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_web_acl_id"></a> [web\_acl\_id](#output\_web\_acl\_id) | The ARN of the WAF WebACL. |
<!-- END_TF_DOCS -->
