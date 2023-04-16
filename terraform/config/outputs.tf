# Group IDs as output
output "groups_ids" {
  value = data.external.get_group_ids.result
}

# Project IDs as output
output "project_ids" {
  value = local.project_ids
}

# Role Assignments as output
output "role_assignments" {
  value = local.role_assignments
}