# AWS WAF Terraform Module

Terraform module with create vpc and subnet resources on AWS.

## Usage

```terraform
module "waf" {
  source = "git::ssh://git@github.com:oozou/terraform-aws-waf.git"
  name   = "test-waf"
  prefix = "oozou"
  scope  = "CLOUDFRONT"
  environment = "dev"
  ip_sets_rule = [
    {
      name               = "count-ip-set"
      priority           = 5
      action             = "count"
      ip_address_version = "IPV4"
      ip_set             = ["1.2.3.4/32", "5.6.7.8/32"]
    },
    {
      name               = "block-ip-set"
      priority           = 6
      action             = "block"
      ip_address_version = "IPV4"
      ip_set             = ["10.0.1.1/32"]
    }
  ]
  tags = {
    "Custom-Tag" = "1"
  }
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_wafv2_ip_set.ipset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_association_resources"></a> [association\_resources](#input\_association\_resources) | ARN of the ALB, CloudFront, Etc to be associated with the WAFv2 ACL. | `list(string)` | `[]` | no |
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | The action to perform if none of the rules contained in the WebACL match. | `string` | `"allow"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Variable used as a prefix | `string` | n/a | yes |
| <a name="input_ip_sets_rule"></a> [ip\_sets\_rule](#input\_ip\_sets\_rule) | A rule to detect web requests coming from particular IP addresses or address ranges. | <pre>list(object({<br>    name               = string<br>    priority           = number<br>    ip_set             = list(string)<br>    action             = string<br>    ip_address_version = string<br>  }))</pre> | `[]` | no |
| <a name="input_managed_rules"></a> [managed\_rules](#input\_managed\_rules) | List of Managed WAF rules. | <pre>list(object({<br>    name            = string<br>    priority        = number<br>    override_action = string<br>    excluded_rules  = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesCommonRuleSet",<br>    "override_action": "none",<br>    "priority": 10<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesAmazonIpReputationList",<br>    "override_action": "none",<br>    "priority": 20<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesKnownBadInputsRuleSet",<br>    "override_action": "none",<br>    "priority": 30<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesSQLiRuleSet",<br>    "override_action": "none",<br>    "priority": 40<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesLinuxRuleSet",<br>    "override_action": "none",<br>    "priority": 50<br>  },<br>  {<br>    "excluded_rules": [],<br>    "name": "AWSManagedRulesUnixRuleSet",<br>    "override_action": "none",<br>    "priority": 60<br>  }<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | A friendly name of the WebACL. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix name of customer to be displayed in AWS console and resource | `string` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the WAFv2 ACL. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_web_acl_id"></a> [web\_acl\_id](#output\_web\_acl\_id) | The ARN of the WAF WebACL. |
