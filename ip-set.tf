resource "aws_wafv2_ip_set" "ipset" {
  count              = length(var.ip_sets_rule)
  name               = var.ip_sets_rule[count.index].name
  scope              = var.scope
  ip_address_version = var.ip_sets_rule[count.index].ip_address_version
  addresses          = var.ip_sets_rule[count.index].ip_set
}
