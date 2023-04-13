output "groups_ids" {
  value = data.external.get_group_ids.result
}
output "groups" {
  value = local.groups
}
output "projects" {
  value = local.projects
}
output "users" {
  value = local.users
}