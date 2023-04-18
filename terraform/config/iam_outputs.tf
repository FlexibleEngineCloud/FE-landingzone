# Project IDs as output
output "project_ids" {
  value = local.project_ids
}

# Group IDs as output
output "groups_ids" {
  value = local.group_ids
}

# Group memberships as output
output "group_membership" {
  value = local.group_membership_ids
}

# Role Assignments as output
output "role_assignments" {
  value = local.role_assignments
}