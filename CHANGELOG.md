# Change Log

All notable changes to this module will be documented in this file.
## [v1.3.0] - 2025-03-31

### Removed 

- Remove exclude_rule block
- Remove single_query_argument block in aws_wafv2_web_acl_logging_configuration
- Change AWS provider version to >= 5.0.0


## [v1.2.0] - 2024-03-27

### Added 

- Add request size constraint statement
  - Resource: `aws_wafv2_web_acl.this`

## [v1.1.1] - 2023-10-26

### Added 

- Add custom response from waf and support or statements
  - Resource: `aws_wafv2_web_acl.this`
  - Variable: `custom_response_body`

### Changed

- Add tagging with module name in `local.tags`

## [v1.1.0] - 2023-06-21

### Changed

- Update default type of `var.is_create_logging_configuration`
- The order of attributes in resource `aws_wafv2_web_acl.this` and it's naming format

### Added 

- New complete example, custom_rules usage
- Add local var `name`,`originate_from_a_country_in`,`originate_from_an_ip_addresses_in`,`has_a_label`,`single_header`,`single_query_parameter`,`all_query_parameters`,`uri_path`,`query_string`,`http_method`,`request_component_dynamic_blocks`,
- Variables var.ip_set and var.custom_rules
- Constraint version to terraform `>= 1.0.0`
- New resource aws_wafv2_ip_set.this. We didn't remove the previous ip_set rule feature; we add new one
- The dynamic `rule` block to support custom_rules in resource `aws_wafv2_web_acl.this`

### Removed

- Variables `local.prefix` and use `local.name` instead

## [v1.0.3] - 2022-10-25

### Changed

- Update `provider/aws` version to `>= 4.0.0`
- Update `.README.md`

## [v1.0.2] - 2022-07-22

### Added

- support logging kms, log retension
- variables
  - `cloudwatch_log_retention_in_days`
  - `cloudwatch_log_kms_key_id`

## [v1.0.1] - 2022-07-20

### Added

- support monitoring

- variables
  - `is_enable_default_rule`
  - `is_enable_cloudwatch_metrics`
  - `is_enable_sampled_requests`
  - `ip_rate_based_rule`
  - `is_create_logging_configuration`
  - `redacted_fields`
  - `logging_filter`

### Changed

- move default rule from variables to locals.tf

## [v1.0.0] - 2022-05-31

### Added

- init terraform-aws-waf module
