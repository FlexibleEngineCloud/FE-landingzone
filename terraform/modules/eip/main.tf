# EIP Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

resource "flexibleengine_vpc_eip" "eip_protected" {
  count = var.protect_eip == true ? var.eip_count : 0
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = var.eip_count > 1 ? format("%s-%d", "bandwidth-${var.eip_name}", count.index + 1) : "bandwidth-${var.eip_name}"
    size        = var.eip_bandwidth
    share_type  = "PER"
    charge_mode = "traffic"
  }
  lifecycle {
    prevent_destroy = true
  }
}

# Enable AntiDDOS on EIP
resource "flexibleengine_antiddos_v1" "antiddos" {
  floating_ip_id         = flexibleengine_vpc_eip.eip_protected[count.index].id
  enable_l7              = true
  traffic_pos_id         = 1
  http_request_pos_id    = 3
  cleaning_access_pos_id = 2
  app_type_id            = 0
}