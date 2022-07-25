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


module "waf_alb" {
  source      = "../.."
  name        = "alb-waf"
  prefix      = "oozou"
  scope       = "REGIONAL"
  environment = "dev"

  managed_rules = [
    {
      name            = "AWSManagedRulesCommonRuleSet",
      priority        = 10
      override_action = "none"
      excluded_rules  = []
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

  association_resources = ["arn:aws:elasticloadbalancing:ap-southeast-1:xxxx:loadbalancer/app/xxxxx"]
  tags = {
    "Custom-Tag" = "1"
  }
}
