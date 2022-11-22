locals {
  prefix = format("%s-%s", var.prefix, var.environment)
  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.tags
  )
  default_rules = [
    {
      name            = "AWSManagedRulesCommonRuleSet",
      priority        = 10
      override_action = "none"
      excluded_rules  = []
      scope_down_statements = []
    },
    {
      name            = "AWSManagedRulesAmazonIpReputationList",
      priority        = 20
      override_action = "none"
      excluded_rules  = []
      scope_down_statements = []
    },
    {
      name            = "AWSManagedRulesKnownBadInputsRuleSet",
      priority        = 30
      override_action = "none"
      excluded_rules  = []
      scope_down_statements = []
    },
    {
      name            = "AWSManagedRulesSQLiRuleSet",
      priority        = 40
      override_action = "none"
      excluded_rules  = []
      scope_down_statements = []
    },
    {
      name            = "AWSManagedRulesLinuxRuleSet",
      priority        = 50
      override_action = "none"
      excluded_rules  = []
      scope_down_statements = []
    },
    {
      name            = "AWSManagedRulesUnixRuleSet",
      priority        = 60
      override_action = "none"
      excluded_rules  = []
      scope_down_statements = []
    }
  ]
  managed_rules = concat(var.is_enable_default_rule ? local.default_rules : [], var.managed_rules)
}
