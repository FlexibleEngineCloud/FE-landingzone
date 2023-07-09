output "id" {
  description = "The ID of the created role"
  value = [for role in flexibleengine_identity_role_v3.role : role.id]
}