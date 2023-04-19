# Provision Group Memberships
module "group_membership" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  depends_on = [
    module.iam_groups
  ]

  source = "../modules/iam/group_membership"

  group_membership = local.group_membership
}
