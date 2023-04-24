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
}
