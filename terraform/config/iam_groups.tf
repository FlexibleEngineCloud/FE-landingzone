# Provision User Groups
module "iam_groups" {
  providers = {
    flexibleengine = flexibleengine.home_fe
  }

  source = "../modules/iam/user_group"

  group_names = local.group_names
}

