# ECS Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

resource "flexibleengine_kms_key_v1" "kms" {
  key_alias       = var.key_alias
  pending_days    = var.pending_days
  key_description = var.key_description
  realm           = var.realm
  is_enabled      = var.is_enabled
  rotation_enabled = var.rotation_enabled
  rotation_interval = var.rotation_interval
}