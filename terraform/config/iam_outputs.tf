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

# Output for "OBS_bucket_manager_role_assignment" module
output "OBS_bucket_manager_role_assignments" {
  value = module.OBS_bucket_viewer_role_assignment.role_assignments
}

# Output for "fullaccess_role_assignment" module
output "fullaccess_role_assignments" {
  value = module.fullaccess_role_assignment.role_assignments
}

# Output for "global_role_assignment_security" module
output "global_role_assignment_security_assignments" {
  value = module.global_role_assignment_security.role_assignments
}

# Output for "global_role_assignment_domain" module
output "global_role_assignment_domain_assignments" {
  value = module.global_role_assignment_domain.role_assignments
}

# Output for "global_role_assignment_network" module
output "global_role_assignment_network_assignments" {
  value = module.global_role_assignment_network.role_assignments
}

# Output for "global_role_assignment_dev" module
output "global_role_assignment_dev_assignments" {
  value = module.global_role_assignment_dev.role_assignments
}

# Output for "global_role_assignment_preprod" module
output "global_role_assignment_preprod_assignments" {
  value = module.global_role_assignment_preprod.role_assignments
}

# Output for "global_role_assignment_prod" module
output "global_role_assignment_prod_assignments" {
  value = module.global_role_assignment_prod.role_assignments
}
