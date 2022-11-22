variable "prefix" {
  description = "The prefix name of customer to be displayed in AWS console and resource"
  type        = string
}

variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
}

variable "name" {
  type        = string
  description = "A friendly name of the WebACL."
}

variable "scope" {
  type        = string
  description = <<-DOC
    Specifies whether this is for an AWS CloudFront distribution or for a regional application.
    Possible values are `CLOUDFRONT` or `REGIONAL`.
    To work with CloudFront, you must also specify the region us-east-1 (N. Virginia) on the AWS provider.
  DOC
  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "Allowed values: `CLOUDFRONT`, `REGIONAL`."
  }
}

variable "is_enable_default_rule" {
  type        = bool
  description = "If true with enable default rule (detail in locals.tf)"
  default     = true
}

# https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html
variable "managed_rules" {
  type = list(object({
    name            = string
    priority        = number
    override_action = string
    excluded_rules  = list(string)
    scope_down_statements = any
  }))
  description = "List of Managed WAF rules."
  default     = []
}

variable "ip_sets_rule" {
  type = list(object({
    name               = string
    priority           = number
    ip_set             = list(string)
    action             = string
    ip_address_version = string
  }))
  description = "A rule to detect web requests coming from particular IP addresses or address ranges."
  default     = []
}

variable "rate_based_statement_rules" {
  type = list(object({
    name                  = string
    priority              = number
    action                = string
    limit                 = number    // between 100 and 20,000,000
    aggregate_key_type    = string    // FORWARDED_IP or IP
    forwarded_ip_config   = any       // If aggregate_key_type is set to FORWARDED_IP, this block is required
    scope_down_statements  = any
  }))
  description = "A rate-based rule tracks the rate of requests for each originating IP address, and triggers the rule action on IPs with rates that go over a limit."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the WAFv2 ACL."
  default     = {}
}

variable "association_resources" {
  type        = list(string)
  description = "ARN of the ALB, CloudFront, Etc to be associated with the WAFv2 ACL."
  default     = []
}

variable "default_action" {
  type        = string
  description = "The action to perform if none of the rules contained in the WebACL match."
  default     = "block"
}

variable "is_enable_cloudwatch_metrics" {
  type        = bool
  description = "The action to perform if none of the rules contained in the WebACL match."
  default     = true
}

variable "is_enable_sampled_requests" {
  type        = bool
  description = "Whether AWS WAF should store a sampling of the web requests that match the rules. You can view the sampled requests through the AWS WAF console."
  default     = true
}

variable "ip_rate_based_rule" {
  type = object({
    name     = string
    priority = number
    action   = string
    limit    = number
  })
  description = "A rate-based rule tracks the rate of requests for each originating IP address, and triggers the rule action when the rate exceeds a limit that you specify on the number of requests in any 5-minute time span"
  default     = null
}

variable "is_create_logging_configuration" {
  description = "Whether to create logging configuration in order start logging from a WAFv2 Web ACL to CloudWatch"
  default     = true
}

variable "cloudwatch_log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire"
  type        = number
  default     = 90
}

variable "cloudwatch_log_kms_key_id" {
  description = "The ARN for the KMS encryption key."
  type        = string
  default     = null
}

variable "redacted_fields" {
  description = "The parts of the request that you want to keep out of the logs. Up to 100 `redacted_fields` blocks are supported."
  type        = any
  default     = []
}

variable "logging_filter" {
  type        = any
  description = "A configuration block that specifies which web requests are kept in the logs and which are dropped. You can filter on the rule action and on the web request labels that were applied by matching rules during web ACL evaluation."
  default     = {}
}
