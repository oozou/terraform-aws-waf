# Change Log

All notable changes to this module will be documented in this file.

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
