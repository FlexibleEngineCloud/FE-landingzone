output "role_assignments" {
  description = "Role assignments"
  value = [for role_assignment in flexibleengine_identity_role_assignment_v3.role_assignment : role_assignment]
}