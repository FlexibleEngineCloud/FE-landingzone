# User Groups Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

# Provision User Groups resource
resource "flexibleengine_identity_group_v3" "group" {
  for_each = toset(var.group_names)

  name        = each.value
  description = "${each.value} group"

  # any other attributes you need to set for each group
}


