# Create network ACL rule
resource "flexibleengine_network_acl_rule" "rule_1" {
  name             = "rule-${random_string.id.result}"
  description      = "Allow Any"
  action           = "allow"
  protocol         = "any"
  enabled          = "true"
}
# Create network ACL
resource "flexibleengine_network_acl" "fw_acl" {
  name          = "acl-${random_string.id.result}"
  subnets       = [flexibleengine_vpc_subnet_v1.subnet_remote.id]
  inbound_rules = [flexibleengine_network_acl_rule.rule_1.id]
}