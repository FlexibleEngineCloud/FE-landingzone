# Provision projects
module "iam_projects" {
  providers = {
    flexibleengine = flexibleengine.fe
  }

  source = "../modules/iam/project"

  project_names = local.project_names
  region = var.region
}

# Get project IDs via API call.
data "external" "get_project_ids" {
  depends_on = [
    module.iam_projects
  ]

  program = ["../../scripts/venv/bin/python3", "../../scripts/get_project_ids.py"]
}