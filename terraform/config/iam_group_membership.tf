# Provision Group Memberships
module "group_membership" {
  providers = {
    flexibleengine = flexibleengine.fe
  }

  depends_on = [
    data.external.get_group_ids
  ]

  source = "../modules/iam/group_membership"

  groups_ids = local.group_ids
  groups     = local.groups
}
