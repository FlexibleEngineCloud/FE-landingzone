# Virtual IP Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

# Create Virtual IP
resource "flexibleengine_networking_vip_v2" "vip" {
  name = var.vip_name
  network_id = var.subnet_id
  ip_version = var.ip_version
  ip_address = var.ip_address
}

# Attach VIP to instance
resource "flexibleengine_networking_vip_associate_v2" "vip_associate" {
  vip_id = flexibleengine_networking_vip_v2.vip.id
  port_ids = var.port_ids
}