# Group Memberships Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

# Provision Group Memberships resource
resource "flexibleengine_identity_group_membership_v3" "membership" {
  for_each = var.group_membership

  group = each.value.group_id
  users = each.value.user_ids

  # any other attributes you need to set for each membership
}
