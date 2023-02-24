# Security group of the firewall.
resource "flexibleengine_networking_secgroup_v2" "secgroup_1" {
  name        = "secgroup-${random_string.id.result}"
  description = "security group of Firewall"
}
resource "flexibleengine_networking_secgroup_rule_v2" "secgroup_rule_1" {
  direction         = "ingress" 
  ethertype         = "IPv4"
  remote_ip_prefix  = var.cidr_vpc
  security_group_id = flexibleengine_networking_secgroup_v2.secgroup_1.id
}