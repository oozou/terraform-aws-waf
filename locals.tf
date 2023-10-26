locals {
  name = format("%s-%s-%s", var.prefix, var.environment, var.name)
  tags = merge(
    {
      "Terraform"   = "true"
      "Environment" = var.environment,
      "Module"      = "terraform-aws-waf"
    },
    var.tags
  )
  default_rules = [
    {
      name            = "AWSManagedRulesCommonRuleSet",
      priority        = 10
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesAmazonIpReputationList",
      priority        = 20
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesKnownBadInputsRuleSet",
      priority        = 30
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesSQLiRuleSet",
      priority        = 40
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesLinuxRuleSet",
      priority        = 50
      override_action = "none"
      excluded_rules  = []
    },
    {
      name            = "AWSManagedRulesUnixRuleSet",
      priority        = 60
      override_action = "none"
      excluded_rules  = []
    }
  ]
  managed_rules = concat(var.is_enable_default_rule ? local.default_rules : [], var.managed_rules)

  /* ------------------------------ Custom Rules ------------------------------ */
  # unique_dynamic_blocks
  originate_from_a_country_in       = "originate-from-a-country-in"
  originate_from_an_ip_addresses_in = "originate-from-an-ip-addresses-in"
  has_a_label                       = "has-a-label"
  # byte_match_dynamic_blocks
  single_header = "single-header"
  # all_headers            = "all-headers" ## Not support by this module now
  # cookies                = "cookies" ## Not support by this module now
  single_query_parameter = "single-query-parameter"
  all_query_parameters   = "all-query-parameters"
  uri_path               = "uri-path"
  query_string           = "query-string"
  # body                   = "body" ## Not support by this module now
  # json_body              = "json-body" ## Not support by this module now
  http_method = "http-method"
  # header_order = "header_order" ## Not support by this module now
  request_component_dynamic_blocks = [
    local.single_header,
    # local.all_headers,
    # local.cookies,
    local.single_query_parameter,
    local.all_query_parameters,
    local.uri_path,
    local.query_string,
    # local.body,
    # local.json_body,
    local.http_method,
    # local.header_order
  ]
}
