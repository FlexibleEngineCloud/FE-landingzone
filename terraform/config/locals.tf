locals {
  # Load groups JSON file
  groups = jsondecode(file("${path.module}/groups.json"))

  # Load policies JSON file
  policies = jsondecode(file("../../policies.json"))

  # Load Group IDs
  group_ids = data.external.get_group_ids.result

  /*
  # Extract User IDs
  user_ids = flatten([
    for group in local.groups :
    [for user in group.users :
    {
      name = user.name
      id   = user.id
    }]
  ])
  */

  # Extract Group names
  group_names = flatten([
    for group in local.groups : group.name
  ])

  # Extract project names
  project_names = flatten([
    for group in local.groups :
    [for project in group.projects : project.name]
  ])

  # Extract policy IDs
  policy_ids = {
    for key, value in local.policies : key => [
      for obj in value :
      obj.id
    ]
  }

  # Extract project IDs
  project_ids = data.external.get_project_ids.result

  # Combining Group IDs, Project IDs, and Policy IDs
  groups_roles = [
    for group in local.groups :
    {
      name = group.name
      id   = local.group_ids[group.name]
      projects = [
        for project in group.projects :
        {
          name = project.name
          id   = local.project_ids[project.name]
          roles = flatten([
            for role in project.permissions :
            local.policy_ids[role]
          ])
        }
      ]
    }
  ]

  # Extract Role Assingments
  role_assignments = flatten([
    for group in local.groups_roles :
    [for project in group.projects :
      [for role in project.roles :
        {
          group_id   = group.id
          project_id = project.id
          role_id    = role
  }]]])
}
