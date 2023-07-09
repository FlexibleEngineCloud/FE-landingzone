
# Assinging Roles module
module "iam_roles" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  depends_on = [
    module.group_membership
  ]

  source = "../modules/iam/role_assignment"

  role_assignments = local.role_assignments
}