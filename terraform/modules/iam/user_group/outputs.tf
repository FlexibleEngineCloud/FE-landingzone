output "group_ids" {
  description = "maps containing the name and ID of the created groups"
  value = {
    for group in flexibleengine_identity_group_v3.group :
      group.name => group.id
  }
}