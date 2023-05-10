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
  count = length(var.eips)

  floating_ip_id         = var.eips[count.index].floating_ip_id
  enable_l7              = var.eips[count.index].enable_l7
  traffic_pos_id         = var.eips[count.index].traffic_pos_id
  http_request_pos_id    = var.eips[count.index].http_request_pos_id
  cleaning_access_pos_id = var.eips[count.index].cleaning_access_pos_id
  app_type_id            = var.eips[count.index].app_type_id
}