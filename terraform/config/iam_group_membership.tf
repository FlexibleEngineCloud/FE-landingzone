module "group_membership" {
  source = "../modules/iam/group_membership"
  providers = {
    flexibleengine = flexibleengine.fe
  }

  groups_ids = local.group_ids
  groups     = local.groups

  depends_on = [
    data.external.get_group_ids
  ]

}
