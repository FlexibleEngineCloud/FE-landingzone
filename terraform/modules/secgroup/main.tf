# Security Group Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

resource "flexibleengine_networking_secgroup_v2" "secgroup" {
  name                 = "sg-${var.name}"
  description          = var.description
  delete_default_rules = var.delete_default_egress_rules
}

resource "flexibleengine_networking_secgroup_rule_v2" "ingress_with_source_cidr" {
  count = length(var.ingress_with_source_cidr)

  security_group_id = flexibleengine_networking_secgroup_v2.secgroup.id
  direction         = "ingress"
  ethertype         = var.ingress_with_source_cidr[count.index]["ethertype"]

  protocol         = var.ingress_with_source_cidr[count.index]["protocol"]
  port_range_min   = var.ingress_with_source_cidr[count.index]["from_port"]
  port_range_max   = var.ingress_with_source_cidr[count.index]["to_port"]
  remote_ip_prefix = var.ingress_with_source_cidr[count.index]["source_cidr"]
}
