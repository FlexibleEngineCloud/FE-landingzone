module "iam_groups" {
  source = "../modules/iam/user_group"
  users = local.users
  groups = local.groups
  
  providers = {
    flexibleengine = flexibleengine.fe
  }
}