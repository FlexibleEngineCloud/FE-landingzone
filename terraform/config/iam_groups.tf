# Provision User Groups
module "iam_groups" {
  providers = {
    flexibleengine = flexibleengine.fe
  }

  source = "../modules/iam/user_group"

  group_names = local.group_names
}

# Get Group IDs via API call.
data "external" "get_group_ids" {
  depends_on = [module.iam_groups]

  program = ["../../scripts/venv/bin/python3", "../../scripts/get_group_ids.py"]
}

