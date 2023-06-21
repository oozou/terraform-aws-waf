provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

module "waf_cloudfront" {
  source = "../.."

  prefix      = var.prefix
  environment = var.environment
  name        = var.name

  scope = "CLOUDFRONT" # To work with CloudFront, you must also specify the region us-east-1 (N. Virginia) on the AWS provider.

  ip_set = {
    "admin-vpn-ipv4-set" = {
      ip_addresses       = ["127.0.0.1/32", "127.0.0.2/32", "127.0.0.3/32", "127.0.0.4/32", "127.0.0.5/32"]
      ip_address_version = "IPV4"
    },
    "admin-vpn-ipv6-set" = {
      ip_addresses       = ["1234:5678:9101:1121:3141:5161:7181:9202/128"],
      ip_address_version = "IPV6"
    }
  }
  custom_rules = [
    {
      name            = "control-access-to-cms-admin-page-rule" #
      priority        = 70                                      ##
      action          = "block"                                 # {count, allow, block}
      expression_type = "and-statements"                        ##
      statements = [                                            ##
        {
          inspect               = "single-header"
          header_name           = "host"
          positional_constraint = "CONTAINS"
          search_string         = "cms.mobilethuat.starbuckscard.in.th"
        },
        {
          inspect              = "originate-from-an-ip-addresses-in"
          is_negated_statement = true
          ip_set_key           = "admin-vpn-ipv4-set"
        },
        {
          inspect              = "originate-from-an-ip-addresses-in"
          is_negated_statement = true
          ip_set_key           = "admin-vpn-ipv6-set"
        }
      ]
    },
  ]

  providers = {
    aws = aws.virginia
  }

  tags = var.custom_tags
}


module "waf_alb" {
  source = "../.."

  prefix      = var.prefix
  environment = var.environment
  name        = var.name

  scope = "REGIONAL"

  managed_rules = [
    {
      name            = "AWSManagedRulesCommonRuleSet",
      priority        = 10
      override_action = "none"
      excluded_rules  = []
    }
  ]

  ip_set = {
    "admin-vpn-ipv4-set" = {
      ip_addresses       = ["127.0.0.1/32", "127.0.0.2/32", "127.0.0.3/32", "127.0.0.4/32", "127.0.0.5/32"]
      ip_address_version = "IPV4"
    },
    "admin-vpn-ipv6-set" = {
      ip_addresses       = ["1234:5678:9101:1121:3141:5161:7181:9202/128"],
      ip_address_version = "IPV6"
    }
  }

  custom_rules = [
    {
      name            = "control-access-to-cms-admin-page-rule" #
      priority        = 70                                      ##
      action          = "block"                                 # {count, allow, block}
      expression_type = "and-statements"                        ##
      statements = [                                            ##
        {
          inspect               = "single-header"
          header_name           = "host"
          positional_constraint = "CONTAINS"
          search_string         = "cms.mobilethuat.starbuckscard.in.th"
        },
        {
          inspect              = "originate-from-an-ip-addresses-in"
          is_negated_statement = true
          ip_set_key           = "admin-vpn-ipv4-set"
        },
        {
          inspect              = "originate-from-an-ip-addresses-in"
          is_negated_statement = true
          ip_set_key           = "admin-vpn-ipv6-set"
        }
      ]
    },
  ]

  association_resources = ["arn:aws:elasticloadbalancing:ap-southeast-1:xxxx:loadbalancer/app/xxxxx"]

  tags = var.custom_tags
}
