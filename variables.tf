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
  description = "The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL."
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
