locals {
  prefix = format("%s-%s", var.prefix, var.environment)
  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.tags
  )
}
