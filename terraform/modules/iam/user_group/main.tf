# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}


resource "flexibleengine_identity_group_v3" "group" {
  for_each = var.groups

  name        = each.key
  description = "${each.key} group"
}

resource "flexibleengine_identity_group_membership_v3" "membership" {
  for_each = var.groups
  
  group = flexibleengine_identity_group_v3.group[each.key].id
  users = [
      for user in var.groups[each.key]:
      var.users[user]
  ]
}