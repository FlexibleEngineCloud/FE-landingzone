# Provision User Groups
module "iam_groups" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/user_group"

  group_names = local.group_names
}

# Provision Group Memberships
module "group_membership" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/group_membership"

  group_membership = local.group_membership

  depends_on = [
    module.iam_groups
  ]
}

# Assinging Roles module
module "iam_roles" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/role_assignment"

  role_assignments = local.role_assignments

  depends_on = [
    module.group_membership
  ]
}