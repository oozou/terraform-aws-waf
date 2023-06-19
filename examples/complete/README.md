<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version           |
|---------------------------------------------------------------------------|-------------------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0          |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | >= 4.0.0, < 5.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random)          | >= 2.3.0          |

## Providers

| Name                                                                         | Version |
|------------------------------------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws)                            | 4.67.0  |
| <a name="provider_aws.virginia"></a> [aws.virginia](#provider\_aws.virginia) | 4.67.0  |

## Modules

| Name                                                                                                               | Source                                                     | Version                                  |
|--------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------|------------------------------------------|
| <a name="module_cloudfront_distribution"></a> [cloudfront\_distribution](#module\_cloudfront\_distribution)        | oozou/cloudfront/aws                                       | 1.1.0                                    |
| <a name="module_fargate_cluster"></a> [fargate\_cluster](#module\_fargate\_cluster)                                | oozou/ecs-fargate-cluster/aws                              | 1.0.8                                    |
| <a name="module_s3_alb_log_bucket"></a> [s3\_alb\_log\_bucket](#module\_s3\_alb\_log\_bucket)                      | oozou/s3/aws                                               | 1.1.5                                    |
| <a name="module_s3_cloudfront_log_bucket"></a> [s3\_cloudfront\_log\_bucket](#module\_s3\_cloudfront\_log\_bucket) | oozou/s3/aws                                               | 1.1.5                                    |
| <a name="module_vpc"></a> [vpc](#module\_vpc)                                                                      | oozou/vpc/aws                                              | 1.2.5                                    |
| <a name="module_web_service"></a> [web\_service](#module\_web\_service)                                            | git@github.com:oozou/terraform-aws-ecs-fargate-service.git | feat/support-multiple-sidecard-container |

## Resources

| Name                                                                                                                                              | Type        |
|---------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [aws_acm_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate)                           | resource    |
| [aws_acm_certificate.virginia](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate)                       | resource    |
| [aws_acm_certificate_validation.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation)     | resource    |
| [aws_acm_certificate_validation.virginia](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource    |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)                             | resource    |
| [aws_route53_record.virginia](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)                         | resource    |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                        | data source |
| [aws_iam_policy_document.alb_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)             | data source |
| [aws_iam_policy_document.cloudfront_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)      | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                          | data source |
| [aws_route53_zone.selected_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone)                     | data source |

## Inputs

| Name                                                                  | Description                                                                                                   | Type          | Default | Required |
|-----------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|---------------|---------|:--------:|
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys. | `map(string)` | `{}`    |    no    |
| <a name="input_environment"></a> [environment](#input\_environment)   | [Required] Name prefix used for resource naming in this component                                             | `string`      | n/a     |   yes    |
| <a name="input_name"></a> [name](#input\_name)                        | [Required] Name of Platfrom or application                                                                    | `string`      | n/a     |   yes    |
| <a name="input_prefix"></a> [prefix](#input\_prefix)                  | [Required] Name prefix used for resource naming in this component                                             | `string`      | n/a     |   yes    |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
