# Role Assgnments Module

# FE provider
terraform {
  required_providers {
    flexibleengine = {
      source = "FlexibleEngineCloud/flexibleengine"
    }
  }
}

# Provision Role Assignments resource
resource "flexibleengine_identity_role_assignment_v3" "role_assignment" {
  for_each = {
    for idx, assignment in var.role_assignments : "assignment_${idx}" => assignment
  }

  group_id   = each.value.group_id
  role_id    = each.value.role_id

  project_id = each.value.project_id != null ? each.value.project_id : null
  domain_id  = each.value.domain_id != null ? each.value.domain_id : null
}


