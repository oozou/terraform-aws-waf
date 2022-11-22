provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

module "waf_cloudfront" {
  source = "../.."
  providers = {
    aws = aws.virginia
  }
  name        = "cloudfront-waf"
  prefix      = "oozou"
  scope       = "CLOUDFRONT" //To work with CloudFront, you must also specify the region us-east-1 (N. Virginia) on the AWS provider.
  environment = "dev"
  is_enable_default_rule = false
  managed_rules = [
    {
      name            = "AWSManagedRulesCommonRuleSet",
      priority        = 10
      override_action = "none"
      excluded_rules  = []
      scope_down_statements = [
        {
          byte_match_statement = {
              field_to_match = {
                uri_path = "{}"
              }
              positional_constraint = "STARTS_WITH"
              search_string         = "/path/to/match"
              priority              = 0
              type                  = "NONE"
          }
        }
      ]

      scope_down_statements = [
      {
        not_statement = { # not statement to rate limit everything except the following path
          byte_match_statement = {
            field_to_match = {
              uri_path = "{}"
            }
            positional_constraint = "STARTS_WITH"
            search_string         = "/path/"
            priority              = 0
            type                  = "NONE"
          }
        }
      }
      ]

      # Optional scope_down_statement to refine what gets rate limited
      # scope_down_statements = [{
      #   or_statement = { # OR and AND statements require 2 or more statements to function
      #     statements = [
      #       {
      #         byte_match_statement = {
      #           field_to_match = {
      #             uri_path = "{}"
      #           }
      #           positional_constraint = "STARTS_WITH"
      #           search_string         = "/api"
      #           priority              = 0
      #           type                  = "NONE"
      #         }
      #       },
      #       {
      #         byte_match_statement = {
      #           field_to_match = {
      #             body = "{}"
      #           }
      #           positional_constraint = "CONTAINS"
      #           search_string         = "@gmail.com"
      #           priority              = 0
      #           type                  = "NONE"
      #         }
      #       },
      #       {
      #         geo_match_statement = {
      #           country_codes = ["NL", "GB", "US"]
      #         }
      #       }
      #     ]
      #   }
      # }]

    }
  ]
    

  default_action                  = "allow"

  rate_based_statement_rules = [
    {
      name                  = "request-limit"
      priority              = 20
      action                = "count"
      limit                 = 5000    
      aggregate_key_type    = "FORWARDED_IP"
      forwarded_ip_config   = {
        fallback_behavior   = "MATCH" 
        header_name         = "test"
      }
      scope_down_statements  = [{
        not_statement = { # not statement to rate limit everything except the following path
          byte_match_statement = {
            field_to_match = {
              uri_path = "{}"
            }
            positional_constraint = "STARTS_WITH"
            search_string         = "/path/"
            priority              = 0
            type                  = "NONE"
          }
        }
      }]
    }
  ]

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


# module "waf_alb" {
#   source      = "../.."
#   name        = "alb-waf"
#   prefix      = "oozou"
#   scope       = "REGIONAL"
#   environment = "dev"

#   managed_rules = [
#     {
#       name            = "AWSManagedRulesCommonRuleSet",
#       priority        = 10
#       override_action = "none"
#       excluded_rules  = []
#     }
#   ]

#   ip_sets_rule = [
#     {
#       name               = "count-ip-set"
#       priority           = 5
#       action             = "count"
#       ip_address_version = "IPV4"
#       ip_set             = ["1.2.3.4/32", "5.6.7.8/32"]
#     },
#     {
#       name               = "block-ip-set"
#       priority           = 6
#       action             = "block"
#       ip_address_version = "IPV4"
#       ip_set             = ["10.0.1.1/32"]
#     }
#   ]

#   association_resources = ["arn:aws:elasticloadbalancing:ap-southeast-1:xxxx:loadbalancer/app/xxxxx"]
#   tags = {
#     "Custom-Tag" = "1"
#   }
# }
