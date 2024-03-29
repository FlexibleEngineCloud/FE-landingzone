# Random string unique identifier for landing zone resources
resource "random_string" "id" {
  length  = 4
  special = false
  upper   = false
}

locals {
  # Load groups JSON file
  groups = jsondecode(file("${path.module}/groups.json"))

  # Load policies JSON file
  policies = jsondecode(file("../../policies.json"))

  # TMS Tags for FE Resources
  tags = jsondecode(file("${path.module}/tms-tags.json"))

  # Load Group IDs
  group_ids = module.iam_groups.group_ids

  # Load Project IDs
  project_ids = jsondecode(file("${path.module}/projects.json"))

  # Mapping Group IDs with their associated User IDs
  group_membership = {
    for group in local.groups : group.name => {
      group_id = local.group_ids[group.name]
      user_ids = [for user in group.users : user.id]
    }
  }

  # Load Group memeberships
  group_membership_ids = module.group_membership.group_memberships


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
              role == "Tenant_Admin" ? ["c0783d60df5440a7acc4b1eb5b2a1913"] : role == "Guest" ? ["bb5e60bd4ce14f54863138e11ae7750b"] :  local.policy_ids[role]
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
