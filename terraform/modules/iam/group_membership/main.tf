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
  for_each = { for group in var.groups :
    group.name => {
      group_id = var.groups_ids[group.name]
      user_ids = [for user in group.users : user.id]
    }
  }

  group = each.value.group_id
  users = each.value.user_ids

  # any other attributes you need to set for each membership
}
