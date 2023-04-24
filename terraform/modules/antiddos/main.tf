# AntiDDOS Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

# Enable AntiDDOS on EIP
resource "flexibleengine_antiddos_v1" "antiddos" {
  count = length(var.eip_ids)

  floating_ip_id         = var.eip_ids[count.index]
  enable_l7              = true
  traffic_pos_id         = 1
  http_request_pos_id    = 3
  cleaning_access_pos_id = 2
  app_type_id            = 0
}