# Project IDs as output
output "project_ids" {
  value = local.project_ids
}

# Group IDs as output
output "groups_ids" {
  value = data.external.get_group_ids.result
}

# Group memberships as output
output "group_membership" {
  value = local.group_membership
}

# Role Assignments as output
output "role_assignments" {
  value = local.role_assignments
}

