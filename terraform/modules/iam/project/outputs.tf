
output "project_ids" {
  description = "maps containing the name and ID of the created projects"
  value = {
    for project in flexibleengine_identity_project_v3.project :
      project.name => project.id
  }
}