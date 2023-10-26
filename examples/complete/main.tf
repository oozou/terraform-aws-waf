provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
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

  custom_response_body = [
    {
      key          = "custom-response"
      content      = <<EOL
      {
        "data": {
            "code": "OUT_OF_THAILAND"
        }
      }
      EOL
      content_type = "APPLICATION_JSON"
    }
  ]

  ip_set = {
    "allow-ipv4-set" = {
      ip_addresses       = ["127.0.0.1/32", "127.0.0.2/32", "127.0.0.3/32", "127.0.0.4/32", "127.0.0.5/32"]
      ip_address_version = "IPV4"
    },
    "allow-ipv6-set" = {
      ip_addresses       = ["1234:5678:9101:1121:3141:5161:7181:9202/128"],
      ip_address_version = "IPV6"
    }
  }

  custom_rules = [
    {
      name            = "allow-access-to-public-path" #
      priority        = 70                            ##
      action          = "allow"                       # {count, allow, block}
      expression_type = "or-statements"               ##
      statements = [                                  ##
        {
          inspect               = "uri-path"
          positional_constraint = "STARTS_WITH"
          search_string         = "/uploads"
        },
        {
          inspect               = "uri-path"
          positional_constraint = "STARTS_WITH"
          search_string         = "/images"
        },
      ]
    },
    {
      name            = "allow-access-from-vpn" #
      priority        = 80                      ##
      action          = "allow"                 # {count, allow, block}
      expression_type = "or-statements"         ##
      statements = [                            ##
        {
          inspect              = "originate-from-an-ip-addresses-in"
          is_negated_statement = true
          ip_set_key           = "allow-ipv4-set"
        },
        {
          inspect              = "originate-from-an-ip-addresses-in"
          is_negated_statement = true
          ip_set_key           = "allow-ipv6-set"
        },
      ]
    },
    {
      name            = "allow-access-from-3rd" #
      priority        = 90                      ##
      action          = "allow"                 # {count, allow, block}
      expression_type = "or-statements"         ##
      statements = [                            ##
        # If 3rd only use, api uri we can add it to statement
        {
          inspect              = "originate-from-an-ip-addresses-in"
          is_negated_statement = true
          ip_set_key           = "allow-ipv4-set"
          # ip_set_key           = "allow-3rd-ipv4-set"
        },
        {
          inspect              = "originate-from-an-ip-addresses-in"
          is_negated_statement = true
          ip_set_key           = "allow-ipv6-set"
          # ip_set_key           = "allow-3rd-ipv6-set"
        },
      ]
    },
    {
      name            = "control-access-to-cms-admin-page" #
      priority        = 100                                ##
      action          = "block"                            # {count, allow, block}
      expression_type = "and-statements"                   ##
      statements = [                                       ##
        {
          inspect               = "single-header"
          header_name           = "host"
          positional_constraint = "CONTAINS"
          search_string         = "xxx.com"
        },
        {
          inspect              = "originate-from-an-ip-addresses-in"
          is_negated_statement = true
          ip_set_key           = "allow-ipv4-set"
        },
        {
          inspect              = "originate-from-an-ip-addresses-in"
          is_negated_statement = true
          ip_set_key           = "allow-ipv6-set"
        }
      ]
    },
    {
      name            = "control-access-to-api-from-geo" #
      priority        = 110                              ##
      action          = "block"                          # {count, allow, block}
      expression_type = "and-statements"                 ##
      statements = [                                     ##
        {
          inspect               = "single-header"
          header_name           = "host"
          positional_constraint = "CONTAINS"
          search_string         = "xxx.com"
        },
        {
          inspect              = "originate-from-a-country-in"
          is_negated_statement = true
          country_codes        = ["TH"]
        }
      ]
    }
  ]

  association_resources = ["arn:aws:elasticloadbalancing:ap-southeast-1:xxx:loadbalancer/app/xxx"]

  tags = var.custom_tags
}
