resource "aws_wafv2_web_acl" "this" {
  name        = format("%s-%s-waf", local.prefix, var.name)
  description = "WAFv2 ACL for ${var.name}"

  scope = var.scope

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }

    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.is_enable_cloudwatch_metrics
    sampled_requests_enabled   = var.is_enable_sampled_requests
    metric_name                = "All"
  }

  dynamic "rule" {
    for_each = local.managed_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        dynamic "none" {
          for_each = rule.value.override_action == "none" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.override_action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.name
          vendor_name = "AWS"

          dynamic "excluded_rule" {
            for_each = rule.value.excluded_rules
            content {
              name = excluded_rule.value
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.is_enable_cloudwatch_metrics
        metric_name                = rule.value.name
        sampled_requests_enabled   = var.is_enable_sampled_requests
      }
    }
  }

  dynamic "rule" {
    for_each = var.ip_sets_rule
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }
      }

      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.ipset[index(var.ip_sets_rule, rule.value)].arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.is_enable_cloudwatch_metrics
        metric_name                = rule.value.name
        sampled_requests_enabled   = var.is_enable_sampled_requests
      }
    }
  }



  dynamic "rule" {
    for_each = var.ip_rate_based_rule != null ? [var.ip_rate_based_rule] : []
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }
      }

      statement {
        rate_based_statement {
          limit              = rule.value.limit
          aggregate_key_type = "IP"
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = var.is_enable_cloudwatch_metrics
        metric_name                = rule.value.name
        sampled_requests_enabled   = var.is_enable_sampled_requests
      }
    }
  }

  tags = merge(
    local.tags,
    { "Name" = format("%s-%s", local.prefix, var.name) }
  )
}

resource "aws_wafv2_web_acl_association" "this" {
  count = length(var.association_resources)

  resource_arn = var.association_resources[count.index]
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}
